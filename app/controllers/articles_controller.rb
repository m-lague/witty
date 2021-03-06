class ArticlesController < ApplicationController
  before_action :set_article, only: [:edit, :update, :destroy, :featured]

  def index
    @sorted_articles = policy_scope(Article)
    @featured_articles = Article.where(
      featured_at: (Date.today - 30.day)..Date.today)
  end

  def new
    @article = Article.new
    authorize @article
  end

  def create
    @article = current_user.articles.build(article_params)
    authorize @article

    if @article.save
      flash[:notice] = "Votre article a bien été ajouté"
      redirect_to articles_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @article.update(article_params)
      flash[:notice] = "Votre article a bien été modifié"
      redirect_to articles_path
    else
      render :edit
    end
  end

  def destroy
    @article.destroy
    flash[:notice] = "Votre article a bien été supprimé"
    redirect_to articles_path
  end

  def featured
    authorize @article
    if @article.featured_at?
      @article.featured_at = nil
    else
      @article.featured_at = Date.today
    end
    @article.save
    redirect_to articles_path
  end

  private

  def set_article
    @article = Article.find(params[:id])
    authorize @article
  end

  def article_params
    params.require(:article).permit(:title, :description, :url, tag_ids: [])
  end
end
