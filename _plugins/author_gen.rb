module Jekyll
  class AuthorIndex < Page
    def initialize(site, base, dir, author)
      @site = site
      @base = base
      @dir = dir
      @name = 'index.html'
      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), 'author_index.html')
      self.data['author'] = author
      author_title_prefix = site.config['tag_title_prefix'] || 'Posts by '
      author_title_suffix = site.config['tag_title_suffix'] || ''
      author_title = Jekyll.configuration({})['authors'][author]['display_name']
      self.data['title'] = "#{author_title_prefix}#{author_title}#{author_title_suffix}"
    end
  end

  class AuthorGenerator < Generator
    safe true
    
    def generate(site)
      if site.layouts.key? 'author_index'
        dir = site.config['author_dir'] || 'author'
        site.posts.each do |post|
          post_author = post.data['author']
          post_author.each do |author|
            write_author_index(site, File.join(dir, author), author)
          end
        end
      end
    end

    def write_author_index(site, dir, author)
      index = AuthorIndex.new(site, site.source, dir, author)
      index.render(site.layouts, site.site_payload)
      index.write(site.dest)
      site.pages << index
    end
  end
end