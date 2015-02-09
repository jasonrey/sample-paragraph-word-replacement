$ ->
    p = $ "p.question"
    doc = $ document

    text = p.text()

    words = text.split " "

    # Empty this array if token splitting is not needed
    tokens = [
        "\""
        "."
        ","
        "!"
    ]

    transformed = []

    for word in words
        if word[0] in tokens
            word = word[0] + "<span><span>" + word.substr(1)
        else
            word = "<span><span>" + word

        if word[word.length - 1] in tokens
            word = word.slice(0, -1) + "</span></span>" + word[word.length - 1]
        else
            word = word + "</span></span>"

        transformed.push word

    p.html transformed.join " "

    nodes = p.find "> span"

    nodes.on "click", ->
        node = $ @

        node.toggleClass "selected"

        selectedNodes = p.find "> span.selected"
        chosen = $ ".chosen"
        chosenContent = chosen.find "> span"

        chosen.css "display", "none"
        chosenContent.empty()

        chosenContent.append $(selectedNode).clone() for selectedNode in selectedNodes

        chosen.css "display", "inline-block" if chosenContent.find("span").length > 0
