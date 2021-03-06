require_relative "item_manager"
require_relative "ownable"

class Cart
  include ItemManager
  include Ownable

  def initialize(owner)
    self.owner = owner
    @items = []
  end

  def items
    # Cartにとってのitemsは自身の@itemsとしたいため、ItemManagerのitemsメソッドをオーバーライドします。
    # CartインスタンスがItemインスタンスを持つときは、オーナー権限の移譲をさせることなく、自身の@itemsに格納(Cart#add)するだけだからです。
    @items
  end

  def add(item)
    @items << item
  end

  def total_amount
    @items.sum(&:price)
  end

  def check_out
    return if owner.wallet.balance < total_amount
    self.owner.wallet -= customer.cart.total_amount
    item.owner.wallet += customer.cart.total_amount
    self.owner << customer.cart.items
    customer.cart.items_list = []
  # ## 要件
  #   - カートの中身Cart#itemsのすべてのアイテムの購入金額が、カートのオーナーのウォレットself.owner.walletからアイテムのオーナーのウォレットitem.owner.walletに移されること。
  #   - カートの中身Cart#itemsのすべてのアイテムのオーナー権限が、カートのオーナーに移されること。
  #   - カートの中身Cart#itemsが空になること。

  # ## ヒント
  #   - カートのオーナーのウォレット ==> self.owner.wallet
  #   - アイテムのオーナーのウォレット ==> item.owner.wallet
  #   - お金が移されるということ ==> (？)のウォレットからその分を引き出して、(？)のウォレットにその分を入金するということ
  #   - アイテムのオーナー権限がカートのオーナーに移されること ==> オーナーの書き換え(item.owner = ?)
  end

end
