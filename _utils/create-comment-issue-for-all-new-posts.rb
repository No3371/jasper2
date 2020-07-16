$repo = 'https://api.github.com/repos/No3371/blog-comments/issues?state=all'
$access_token = 'THEd13GITHUBfb87TOKENa4FROM5eSETTINGS'
$exclude_regex = '\.git|assets'
$file_regex = '\w*(?:\.md|\.html)'
$frontmatter_regex = '^-+$(?:[\s\S]+?)^-+$' # should not ever need to modify this
$github_comments_issueid_regex = '(?:github_comments_issueid:\s?)([\S]+$)'        # should not ever need to modify this with Polyglot

def process (path)
    if path.match($exclude_regex)
        return
    end
    puts '+checking file: ' + file
    content = File.open(file, 'r+')
    frontmatter = content.match($frontmatter_regex)[0]
    if frontmatter == nil
        return
    end
    issue_id = frontmatter.match($github_comments_issueid_regex)
    if issue_id == nil
        return
    end
    issue_id = issue_id[1]
    if issue_id == 'NONE'
        return
    end



def request_create (postname, token)
    require 'net/http'
    require 'uri'

    uri = URI.parse($repo
    request = Net::HTTP::Post.new(uri)
    request.content_type = "text/plain; charset=utf-8"
    request["Cookie"] = "logged_in=no"
    request["Authorization"] = "token " + token
    request.body = "${
    \"title\": \"" + postname + "\",
    \"body\": \"A comment created with API to serve as comments deposit for blog post" + postname + "\",
    \"assignees\": [
    ],
    \"labels\": [
        \"comments\"
    ]
    }"

    req_options = {
    use_ssl: uri.scheme == "https",
    }

    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
        http.request(request)
    end

    return response
end

if ARGV.length == 0
    return
end

puts 'create-comment called with:'
ARGV.foreach do |argv|
    puts '- ' + argv
end