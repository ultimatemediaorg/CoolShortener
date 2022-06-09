require 'octokit'

module Short
    class BlankPage < Jekyll::Page
        def read_yaml(*)
            @data ||= {}
        end
    end

    class Short < Jekyll::Generator
        def generate(site)
            @client = Octokit::Client.new()
            @site = site
            hash_length = @site.config["id_length"]
            @client.list_issues(@site.config["repo"]).map do |issue|
                id = Digest::SHA1.hexdigest(issue.number.to_s)[0, 6]
                @site.pages << file(id, issue.title)
            end
        end

        def file(id, url)
            page = BlankPage.new(@site, '/', '', id + '.html')
            page.data["layout"] = "redirect"
            page.data["redirect_to"] = url
            page
        end
    end
end