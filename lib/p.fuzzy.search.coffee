class Trigram
  constructor: (tg, id, score) ->
    @tg    = tg
    @id    = id
    @score = score


class PseudoFuzzy
  constructor: (input, data) ->
    @input    = input.toLowerCase()
    @data     = data
    @trigrams = this.gen_trigrams_for_data(@data)

  gen_trigrams: (input) ->
    input_trigrams = []
    range = [0..(input.length-3)]
    for sub_index in range
      tg = input[sub_index...(3 + sub_index)]
      input_trigrams.push tg.toLowerCase()

    input_trigrams

  gen_trigrams_for_data: (data_sample) ->
    trigrams = []

    for obj, id in data_sample
      word = " #{obj.name}"
      range = [0..(word.length-3)]
      for sub_index in range
        tg = word[sub_index...(3 + sub_index)].toLowerCase()
        trigrams.push new Trigram(tg, id, 1)

    trigrams

  search: (input) ->
    input = " #{@input}"

    input_trigrams = this.gen_trigrams(input)

    score = []
    ids = [0..@trigrams.length]
    for id in ids
      sub_trigrams = @trigrams.filter (t) -> t.id == id

      sub_score = sub_trigrams.map (trigram) ->
        if (input_trigrams.filter (tg) -> tg == trigram.tg).length > 0 then 1 else 0

      if sub_score.length > 0
        score.push
         score: sub_score.reduce (x,y) -> x + y
         id: id

    sorted = score.sort (a, b) -> b.score - a.score

    this.get_results(@data, sorted)

  get_results: (data, sorted) =>
    sorted.map (sorted_item) ->
      i = data.filter (data_item, id) -> id == sorted_item.id
      i[0]

# Testing
fuzzy = new PseudoFuzzy('mar', data_sample)
console.log fuzzy.search()

