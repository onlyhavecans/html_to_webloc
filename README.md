# HTML to Webloc

This tool is designed to take an export from [Pocket](https://getpocket.com/) and break them out into webloc files.

I did this to move from Pocket to DevonThink.

## Requirements

- Ruby

## Usage

1. Clone or download this repository to a folder
1. Go to [Pocket's Export page](https://getpocket.com/export) and click 'Export HTML File'
1. Save this file to this folder
1. `bundle` to pull deps for ruby
1. `bundle exec ruby make_weblocs.rb` to write everything to output

## Notes

This was not tested on windows but was designed to work on it.

Broken links will be discareded and not made to webloc files!

Not all files have their title looked up.
