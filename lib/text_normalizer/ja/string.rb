# -*- coding: utf-8 -*-
require 'text_normalizer/ja/normalizer'
require 'nkf'

class TextNormalizer::Ja::String
  include TextNormalizer::Ja::Normalizer

  define :narrow do |s|
    NKF.nkf('-wWZ1', s)
  end

  define :downcase, &:downcase

  define :remove_commas do |s|
    s.gsub(/(\d),(?=\d\d\d)/, '\\1')
  end

  define :expand_katakana do |s|
    NKF.nkf('-wWx', s)
  end

  define :unify_space_repeats do |s|
    s.gsub(/ {2,}/, ' ')
  end

  define :unify_long_repeats do |s|
    s.gsub(/ー{2,}/, 'ー')
  end
end
