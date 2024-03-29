module Jekyll
  class TagGenerator < Generator
    safe true

    def generate(site)
      if site.layouts.key? 'tag_index'
        site.tags.keys.each do |tag|
          paginate(site, tag)
        end
      end
    end

    def paginate(site, tag)
      tag_posts = site.posts.find_all {|post| post.tags.include?(tag)}.sort_by {|post| -post.date.to_f}
      num_pages = TagPager.calculate_pages(tag_posts, site.config['paginate'].to_i)

      (1..num_pages).each do |page|
        pager = TagPager.new(site.config, page, tag_posts, tag, num_pages)
        dir = File.join('tag', tag, page > 1 ? "#{page}" : '')
        page = TagPage.new(site, site.source, dir, tag)
        page.pager = pager
        site.pages << page
      end
    end
  end

  class TagPage < Page
    def initialize(site, base, dir, tag)
      @site = site
      @base = base
      @dir = dir
      @name = 'index.html'

      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), 'tag_index.html')
      self.data['tag'] = tag
      tag_title_prefix = site.config['tag_title_prefix'] || 'Posts Tagged &ldquo;'
      tag_title_suffix = site.config['tag_title_suffix'] || '&rdquo;'
      self.data['title'] = "#{tag_title_prefix}#{tag}#{tag_title_suffix}"
    end
  end

  class TagPager < Pager
    attr_reader :tag

    def initialize(config, page, all_posts, tag, num_pages = nil)
      @tag = tag
      super config, page, all_posts, num_pages
    end

    alias_method :original_to_liquid, :to_liquid

    def to_liquid
      liquid = original_to_liquid
      liquid['tag'] = @tag
      liquid
    end
  end
end
