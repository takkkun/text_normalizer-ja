def sample_normalizer
  Class.new { include TextNormalizer::Ja::Normalizer }
end

def f(&proc)
  proc.extend(TextNormalizer::Ja::Normalizer::Composable)
end
