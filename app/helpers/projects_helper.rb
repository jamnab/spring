module ProjectsHelper
  def count_opinion(opinionable)
    opinionable.opinions.like.count - opinionable.opinions.dislike.count
  end
end
