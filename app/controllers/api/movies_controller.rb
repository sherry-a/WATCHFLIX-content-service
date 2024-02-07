require 'aws-sdk-s3'
class Api::MoviesController < ApplicationController
  before_action :set_movie, only: %i[ show update destroy ]
  def index
    @movies = Movie.all
    render json: @movies
  end

  def upload
    file = params[:file]
    file_name=file.original_filename
    key = generate_s3_key(file_name)
    s3 = ActiveStorage::Blob.service.client
    bucket = s3.bucket(Rails.application.credentials.dig(:aws, :s3, :bucket))
    s3_bucket_object = bucket.object(key)
    s3_bucket_object.upload_file(file.path)
    render json: {key: key}
  end

  def get_video_url
  key = "#{params[:key]}.mp4"
  s3_credentials = Rails.application.credentials.dig(:aws, :s3)
  s3_service = Aws::S3::Resource.new(
    region: s3_credentials[:region],
    access_key_id: s3_credentials[:access_key_id],
    secret_access_key: s3_credentials[:secret_access_key]
  )
  s3_bucket = s3_service.bucket(s3_credentials[:bucket])
  s3_bucket_obj = s3_bucket.object(key)
  presigned_url = s3_bucket_obj.presigned_url(:get, expires_in: 3600)
  render json: { video_url: presigned_url }
  rescue Aws::S3::Errors::NoSuchKey
  render json: { error: 'Video not found' }, status: :not_found
  end

  def show
    render json: @movie
  end

  def create
    @movie = Movie.new(movie_params)
    if @movie.save
      render json: @movie, status: :created , location: api_movie_url(@movie)
    else
      render json: {error: @movie.errors.full_messages[0]}, status: :unprocessable_entity
    end
  end

  def update
    if @movie.update(movie_params)
      render json: @movie
    else
      render json: {error: @movie.errors.full_messages[0]}, status: :unprocessable_entity
    end
  end

  def destroy
    @movie.destroy
  end

  private

    def generate_s3_key(filename)
      timestamp = Time.now.to_i
      return "#{timestamp}-#{filename}"  
    end
    
    def set_movie
      @movie = Movie.find(params[:id])
    end

    def movie_params
      params.require(:movie).permit(:title,:release_year,:description,:thumbnail,:key)
    end
end
