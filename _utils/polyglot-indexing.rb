require('yaml')
$index_file_path = './_data/polyglot-index.yml'
$file_regex = '\w*(?:\.md|\.html)' # Must link with file_regex
$frontmatter_regex = '^-+$(?:[\s\S]+?)^-+$'
$lang_regex = '(?:lang:\s?)([\S]+$)'
$permalink_regex = '(?:permalink:\s?)([\S]+$)'
$extract_post_filename_regex = '(?:\d{4}-\d{2}-\d{2}-)(\S+)(?:.md|.html)' # Link with file_regex
$extract_nonpost_filename_regex = '(\S+)(?:.md|.html)' # Link with file_regex
$exclude_regex = '\.git|assets'
$max_depth = 2
$lang_from_path = (ARGV[0] == '--lang_from_path')? true : false
root = File.expand_path('.') + '/'
puts 'Running at ' + root
$strip_length = root.length
config_file = YAML::load_file('./_config.yml')
$languages = config_file['languages']
puts 'configured languages: ' + $languages.join(',')
$default_language = config_file['default_lang']
$files = nil

def recursive (path, depth)
    puts '  ' * depth + 'navigating: ' + path
    Dir.foreach(path) do |filename|
        next if filename == '.' or filename == '..'
        fullname = path + '/' + filename
        puts '  ' * depth + 'checking: ' + filename
        if $exclude_regex != '' and fullname.match($exclude_regex)
            puts '  ' * depth + '-- excluded. '
            next
        end

        if File.directory?(fullname) and depth < $max_depth
            recursive(fullname, depth+1)
        elsif File.file?(fullname) and fullname.match($file_regex)
            process_target_file(fullname, depth)
        end
    end
end

def process_target_file (file, depth)
    puts '  ' * depth + '+processing file: ' + file
    f = File.open(file)
    content = f.read
    f.close
    frontmatter = content.match($frontmatter_regex)
    if frontmatter == nil
        puts '  ' * depth + '-file without front matter.'
        return
    end
    
    file = file [2..-1] # strip "./"
    # puts '  ' * depth + ' stripped path: ' + file
    segments = file.split('/')

    _, lang = frontmatter[0].match($lang_regex)
    if segments != nil && lang == nil && $lang_from_path
        if file[0] == '_' and segments.length > 2 and $languages.include? segments[1]
            lang = segments[1]
        elsif segments.length > 1 and $languages.include? segments[0]
            lang = segments[0]
        end
    end


    if lang == nil
        lang = $default_language
    end

    _, permalink = frontmatter[0].match($permalink_regex)
    if permalink == nil
        permalink = segments[-1].match($extract_post_filename_regex)
        if permalink == nil
            permalink = segments[-1].match($extract_nonpost_filename_regex)
        end
        permalink = permalink[1]
    end

    if $hash[permalink] == nil
        $hash[permalink] = []
    end
    $hash[permalink].push(lang)
end


def load_existing_index_file ()
    puts 'loading index file: ' + $index_file_path
    f = File.open($index_file_path, 'r')
    if f != nil
        hash = YAML::parse(f)
    end
    f.close
end

def save_index_file ()
    f = File.open($index_file_path, 'w') { |file| file.write($hash.to_yaml) }
    puts 'saved index file: ' + $index_file_path
end

if ARGV.length > 1
    load_existing_index_file
    $files = ARGV[1].split(',')
else
    $hash = {}
end

if $files != nil
    $files.each do |f|
        process_target_file(f)
    end
else
    recursive('.', 0)
end
save_index_file