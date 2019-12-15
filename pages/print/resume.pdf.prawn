require "prawn"
require "prawn/table"
require "yaml"

Prawn::Document.generate("pages/print/resume.pdf") do
  font_families.update("TimesNewRoman" => {
    :normal => "assets/fonts/pdf/times-new-roman.ttf",
    :italic => "assets/fonts/pdf/times-new-roman-italique.ttf",
    :bold => "assets/fonts/pdf/times-new-roman-gras.ttf",
    :bold_italic => "assets/fonts/pdf/times-new-roman-gras-italique.ttf"
  })
  font "TimesNewRoman"

  data =  YAML::load(File.open("pages/data/index.yaml"))

  text data['name'], align: :center, style: :bold
  text data['position'], align: :center
  move_down 10

  contacts_config = {
    "site" => "Сайт: ",
    "telegram" => "Telegram: ",
    "gmail" => "Gmail: ",
    "mail" => "Email: " ,
    "github" => "GitHub: "
  }

  default_me = "assets/img/default_me.jpeg"
  contacts = contacts_config.map { |key, title| [title, data['contacts'][key]].join }.join("\n")
  table [[{image: default_me, fit: [150, 150]}, content: contacts]], column_widths: [200, 200], cell_style: { border_width: 0 }

  config = {
    "skils" => "Навыки:",
    "education" => "Образование:",
    "experience" => "Опыт работы:",
    "projects" => "Интересные проекты в которых я принимал участие:",
    "languages" => "Знание иностранных языков:",
    "personal_qualities" => "Личные качества:"
  }

  config.each do |key, title|
    move_down 5
    text title, style: :bold
    move_down 5
    data[key].each do |e|
      if e.is_a?(String)
        text "- " + e.to_s, indent_paragraphs: 10
      else
        case key
        when "education"
          text "#{e['year_ending']}: #{e['name']}", indent_paragraphs: 10
        when "experience"
          text %(<link href="#{e['url']}"><u>#{e['name']}</u></link>: #{e['work_dates']}, #{e['position']}), inline_format: true, indent_paragraphs: 10
        when "projects"
          text %(<link href="#{e['url']}"><u>#{e['name']}</u></link>: #{e['short_information']}), inline_format: true, indent_paragraphs: 10
        when "languages"
          text "#{e['name']}: #{e['level']}, #{e['description']}", indent_paragraphs: 10
        end
      end
    end
  end
end
