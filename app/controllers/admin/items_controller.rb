class Admin::ItemsController < Admin::BoardController
  #Callbacks
  before_action :authenticate_user!
  before_action :is_admin?

  def index
    @items = Item.all
  end

  def new
    @item = Item.new
    @categories = Category.all
  end

  def create
    @item = Item.new(item_params)
    item_categories()
    if @item.save
      flash[:success] = "L'item a été créé avec succès 😎"
      redirect_to(item_path(@item))
    else
      flash.now[:warning] = @item.errors.full_messages
      render :new
    end
  end

  def show
    @item = Item.find(params[:id])
  end

  def edit
    @item = Item.find(params[:id])
  end

  def update
    @item = Item.find(params[:id])

    if @item.update(item_params)
      flash[:success] = "L'item a été modifié avec succès 👌"
      redirect_to items_path
    else
      flash.now[:warning] = @item.errors.full_messages
      render :edit
    end
  end

  def destroy
    @item = Item.find(params[:id])
    @item.destroy
    flash[:success] = "L'item a été supprimé avec succès 👌"
    redirect_to items_path
  end

  def mask
    Item.find(params[:item]).update(sellable: params[:unmask])
    redirect_to items_path
  end

  private

  def item_params
    puts 
    params.require(:item).permit(:title, :description, :price, :image_url, :item_picture)
  end
  def item_categories 
    array_of_categories = params.require(:item).permit(categories:[])[:categories]
    unless array_of_categories.nil?
      array_of_categories.reject(&:empty?).each do |category_id|
        test = JoinTableItemCategory.create(item: @item,category: Category.find(category_id))
        puts "-"*60
        puts test
        puts "-"*60
      end
    end
  end
end
