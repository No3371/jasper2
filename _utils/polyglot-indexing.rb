include Regexp

index_file_path = './_data/polyglot-index.yml'
file_regex = '\w*(?:\.md|\.html)'
frontmatter_regex = '^-+$(?:[\s\S]+?)^-+$'
lang_regex = '(?:lang:\s?)([\S]+$)'
permalink_regex = '(?:permalink:\s?)([\S]+$)'
exclude_regex = ''
max_depth = 2
lang_from_path = (ARGV[0] == '--lang_from_path')? true : false
files = nil
if ARGV.length > 1
    load_existing_index_file
    files = ARGV[1].split(',')
else
    hash = {}
end

depth = 0
if files != nil
    files.each do |f|
        process_target_file(f)
else
    recursive('.', depth)
end

def recursive (path, depth)
    next if filename == '.' or filename == '..' or path.match(exclude_regex)

    if File.directory?(path) && depth < max_depth
        depth++
        recursive(path, depth)
    else if File.file?(path) && file_regex.match(path)
        process_target_file(path)
    end
end

def process_target_file (file)
    f = File.open(file)
    content = f.read
    f.close
    front = frontmatter_regex.match(content)
    _, lang = lang_regex.match(front)
    _, permalink = permalink_regex.match(front)
    if permalink == nil
        if lang_from_path
        end
    else
        if hash[permalink] == nil
            hash[permalink] = []
        end
        hash[permalink].push(lang)
    end
end

def load_existing_index_file ()
    f = File.open(index_file_path)
    if f != nil
        hash = YAML::parse(f)
    end
    f.close
end
    

def derive_lang_from_path(doc)
if !@lang_from_path
    return nil
end
segments = doc.relative_path.split('/')
if doc.relative_path[0] == '_' \
    and segments.length > 2 \
    and segments[1] =~ /^[a-z]{2,3}(:?[_-](:?[A-Za-z]{2}){1,2}){0,2}$/
    return segments[1]
elsif segments.length > 1 \
    and segments[0] =~ /^[a-z]{2,3}(:?[_-](:?[A-Za-z]{2}){1,2}){0,2}$/
    return segments[0]
else
    return nil
end
end

# assigns natural permalinks to documents and prioritizes documents with
# active_lang languages over others.  If lang is not set in front matter,
# then this tries to derive from the path, if the lang_from_path is set.
# otherwise it will assign the document to the default_lang
def coordinate_documents(docs)
regex = document_url_regex
approved = {}
docs.each do |doc|
    lang = doc.data['lang'] || derive_lang_from_path(doc) || @default_lang
    url = doc.url.gsub(regex, '/')
    doc.data['permalink'] = url
    next if @file_langs[url] == @active_lang
    next if @file_langs[url] == @default_lang && lang != @active_lang
    approved[url] = doc
    @file_langs[url] = lang
end
approved.values
end