# Recommendify.redis = Redis.new(:host => "localhost", :port => 6379)
#
# class MachineRecomender < Recommendify::Base
#
#   max_neighbors 50
#
#   input_matrix :show_detail,
#     :native => true,
#     :similarity_func => :jaccard,
#     :weight => 10.0
#
#   input_matrix :contact,
#     :native => true,
#     :similarity_func => :jaccard,
#     :weight => 50.0
# end
