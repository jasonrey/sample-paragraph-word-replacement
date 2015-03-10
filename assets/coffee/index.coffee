$ ->
    String.prototype.repeat = (n) ->
        return new Array(n + 1).join(@)

    qParagraph = $ "p.question"

    text = qParagraph.text()

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

    qParagraph.html transformed.join " "

    aParagraph = $ "p.answer"

    aParagraph.html transformed.join " "

    qNodes = qParagraph.find "> span"
    aNodes = aParagraph.find "> span"

    qNodes.on "click", ->
        qNode = $ @
        index = qNode.index()

        # Check for mode
        selecting = not qNode.hasClass "selected"

        # Search for selected nodes
        selectedQNodes = qNodes.filter ".selected"

        # Only allow consecutive selection
        if selectedQNodes.length > 0
            # Get min max index
            min = $(selectedQNodes[0]).index()
            max = $(selectedQNodes[selectedQNodes.length - 1]).index()

            if selecting
                return if index isnt min - 1 and index isnt max + 1
            else #not selecting
                return if min < index < max

        qNode.toggleClass "selected"

        aNode = aNodes.eq index

        target = aNode.find "span"

        target.text if qNode.hasClass("selected") then "_".repeat qNode.text().length else qNode.text()