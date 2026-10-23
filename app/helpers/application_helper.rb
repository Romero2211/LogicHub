module ApplicationHelper
  CATEGORY_LABELS = {
    "movies" => "🎬 Фильмы",
    "series" => "📺 Сериалы",
    "games" => "🎮 Игры",
    "ai" => "🤖 ИИ"
  }.freeze

  def category_label(category)
    CATEGORY_LABELS.fetch(category.to_s, category.to_s)
  end

  def category_badge_classes(category)
    {
      "movies" => "bg-orange-500/20 text-orange-400",
      "series" => "bg-blue-500/20 text-blue-400",
      "games" => "bg-green-500/20 text-green-400",
      "ai" => "bg-violet-500/20 text-violet-300"
    }.fetch(category.to_s, "bg-zinc-700 text-zinc-300")
  end

  def field_classes
    "w-full rounded-lg border border-[#2a2a32] bg-[#0f0f12] px-3 py-2.5 text-white placeholder:text-[#64748b] focus:border-[#7c3aed] focus:outline-none"
  end

  def label_classes
    "mb-1.5 block text-sm text-[#94a3b8]"
  end

  def primary_button_classes
    "inline-flex items-center justify-center rounded-lg bg-[#7c3aed] px-4 py-2.5 font-medium text-white hover:bg-[#6d28d9]"
  end

  def liked?(record)
    logged_in? && current_user.likes.exists?(likeable: record)
  end

  def like_path_for(record)
    record.is_a?(Comment) ? comment_like_path(record) : post_like_path(record)
  end

  def secondary_button_classes
    "inline-flex items-center justify-center rounded-lg border border-[#2a2a32] bg-[#1a1a1f] px-4 py-2.5 text-[#94a3b8] hover:text-white"
  end
end
