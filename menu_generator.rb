module Jekyll
    class Page
        def menu
            self.data['menu'] ||= {}
        end
        
        def menu_parent
            menu['parent']
        end
        
        def menu_name
            menu['name'] ||= self.data['title']
        end
        
        def subpages
            menu['subpages'] ||= []
        end
    end
    
    class MenuGenerator < Generator
        safe true
        
        def menu_name(hash)
            hash['menu']['name'] || hash['title']
        end

        def setup_config(site)
            site.config['menu_generator'] ||= {}
            site.config['menu_generator']['parent_match_hash'] ||= 'path'
            site.config['menu_generator']['menu_root'] ||= '__root'
            site.config['menu_generator']['delete_content_hash'] ||= false
            site.config['menu_generator']['hash_name_in_site_object'] ||= "menu"

            site.config['menu_generator']['css'] ||= {}
            site.config['menu_generator']['css']['current'] ||= 'current'
            site.config['menu_generator']['css']['current_parent'] ||= 'current-parent'

            @parent_match_hash      = site.config['menu_generator']['parent_match_hash']
            @menu_root              = site.config['menu_generator']['menu_root']
            @delete_content_hash    = site.config['menu_generator']['delete_content_hash']
            @hash_name_in_site_object    = site.config['menu_generator']['hash_name_in_site_object']
        end

        def generate(site)
            @pages = site.pages.dup

            setup_config(site)

            @main_menu = []
            @lookup = { @menu_root => @main_menu }

            build_tree
            sort_pages
            generate_suburls
            
            pp @main_menu

            site.config[@hash_name_in_site_object] = @main_menu
        end
        
        def build_tree
            # build the subpage tree
            loop do 
                prev_size = @pages.size
                
                @pages.reject! do |page|
                    parent = @lookup[page.menu_parent]
                    unless parent.nil?
                        # Initilize the name
                        page.menu_name
                        @lookup[page[@parent_match_hash]] = page.subpages
                        liq_hash = page.to_liquid

                        if @delete_content_hash
                            liq_hash.delete('content')
                        end
                        parent << liq_hash
                        true
                    else
                        false
                    end
                end
                
                break if @pages.size == prev_size
            end
        end
        
        def sort_pages
            # lookup contains every page's subpage array,
            # so we only need to sort every value in lookup
            @lookup.each do |key, val|
                val.sort! do |a, b|
                    compare_pages(a, b)  
                end
            end
        end
        
        def compare_pages(a, b)
            if a['menu']['position'].nil? and b['menu']['position'].nil? or a['menu']['position'] == b['menu']['position']
                # neither has a position, sort by name
                menu_name(a) <=> menu_name(b)
            elsif a['menu']['position'].nil?
                # if a has no position, it goes after b
                +1
            elsif b['menu']['position'].nil?
                # if b has no position, it goes after a
                -1
            else
                # both have a position, compare them
                a['menu']['position'] <=> b['menu']['position']
            end  
        end
        
        def generate_suburls
            # generate the suburl lists.
            # #set_suburls recurses, so we only call this
            # on the pages in the main menu
            @main_menu.each do |page|
                set_suburls(page)
            end
        end
        
        def set_suburls(page)
            page['menu']['subpages'].each do |subpage|
                set_suburls(subpage)
            end
            page['menu']['suburls'] = suburls(page)
        end
        
        def suburls(page_hash, add_self=false)
            subsub = page_hash['menu']['subpages'].map do |subpage|
                suburls(subpage, true)
            end
            subsub.flatten!
            if add_self
                subsub << page_hash['url']
            else
                subsub
            end
        end
    end 
end
