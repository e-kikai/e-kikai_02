SimpleCaptcha.setup do |sc|
  # 画像のサイズ default: 100x28
  # sc.image_size = '120x40'

  # 文字列の長さ default: 5
  sc.length = 6

  # 画像のスタイル 固定よりランダムが良い
  sc.image_style = 'random'

  # 画像のグニャグニャ感のレベル（上下の揺れ） default: low
  # possible values: 'low', 'medium', 'high', 'random'
  sc.distortion = 'high'

  # 画像のグニャグニャ感のレベル（立体感のある揺れ？）default: medium
  # possible values: 'none', 'low', 'medium', 'high'
  sc.implode = 'medium'
end
