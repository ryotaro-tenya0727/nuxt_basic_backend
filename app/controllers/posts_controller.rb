class PostsController < ApplicationController
  before_action :set_post, only: %i[ show update destroy ]

  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.all.eager_load(:user)
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(post_params)
    if @post.save
      attach_image
      render :show, status: :created
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    if @post.update(post_params)
      render :show, status: :ok
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post.destroy!
  end

  private
  def attach_image
    return if params[:image].blank?
    base64_data = params[:image].split(',').last
    mime_type = params[:image].split(',').first.split(';').first.split(':').last
    extension = Rack::Mime::MIME_TYPES.invert[mime_type]
    filename = [SecureRandom.uuid, extension].join

    @post.image.attach(
      io: StringIO.new(base64_data),
      filename: filename,
      content_type: mime_type
    )
  end
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def post_params
      params.permit(:title, :body).merge(user: current_user)
    end
end
