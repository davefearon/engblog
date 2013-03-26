module Jekyll
  class AuthorGenerator < Generator
    safe true

    def generate(site)
      if site.layouts.key? 'author_index'

        site.posts.each do |post|
          post_author = post.data['author']
          post_author.each do |author|
            paginate(site, author)
          end
        end
      end
    end

    def paginate(site, author)
      author_posts = site.posts.find_all {|post| post.data['author'].include?(author)}.sort_by {|post| -post.date.to_f}
      num_pages = AuthorPager.calculate_pages(author_posts, site.config['paginate'].to_i)

      (1..num_pages).each do |page|
        pager = AuthorPager.new(site.config, page, author_posts, author, num_pages)
        dir = File.join('author', author, page > 1 ? "#{page}" : '')
        page = AuthorPage.new(site, site.source, dir, author)
        page.pager = pager
        site.pages << page
      end
    end
  end

  class AuthorPage < Page
    def initialize(site, base, dir, author)
      @site = site
      @base = base
      @dir = dir
      @name = 'index.html'

      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), 'author_index.html')
      self.data['author'] = author
      author_title_prefix = site.config['author_title_prefix'] || 'Posts by '
      author_title_suffix = site.config['author_title_suffix'] || ''
      author_title = Jekyll.configuration({})['authors'][author]['display_name']
      self.data['title'] = "#{author_title_prefix}#{author_title}#{author_title_suffix}"
    end
  end

  class AuthorPager < Pager
    attr_reader :author

    def initialize(config, page, all_posts, author, num_pages = nil)
      @author = author
      super config, page, all_posts, num_pages
    end

    alias_method :original_to_liquid, :to_liquid

    def to_liquid
      liquid = original_to_liquid
      liquid['author'] = @author
      liquid
    end
  end
end
