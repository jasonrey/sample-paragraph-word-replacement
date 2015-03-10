$ ->
    String.prototype.repeat = (n) ->
        return new Array(n + 1).join(@)

    qParagraph = $ "p.question"
    aParagraph = $ "p.answer"

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
            word = "<span class='punc'><span>" + word[0] + "</span></span><span><span>" + word.substr(1)
        else
            word = "<span><span>" + word

        if word[word.length - 1] in tokens
            word = word.slice(0, -1) + "</span></span><span class='punc'><span>" + word[word.length - 1] + "</span></span>"
        else
            word = word + "</span></span>"

        transformed.push word

    transformedParagraph = transformed.join ""

    qParagraph.html transformedParagraph
    aParagraph.html transformedParagraph

    qNodes = qParagraph.find "> span"
    aNodes = aParagraph.find "> span"

    isConsecutiveSelect = (node) ->
        paragraph = $ "p.question"
        nodes = paragraph.find "> span"
        index = node.index()

        # Don't allow punctuation
        if node.hasClass "punc"
            return

        # Check for mode
        selecting = not node.hasClass "selected"

        # Search for selected nodes
        selectedQNodes = nodes.filter ".selected"

        # Only allow consecutive selection
        if selectedQNodes.length > 0
            # Get min max index
            min = $(selectedQNodes[0]).index()
            max = $(selectedQNodes[selectedQNodes.length - 1]).index()

            if selecting
                return if index isnt min - 1 and index isnt max + 1
            else #not selecting
                return if min < index < max

        return true


    qNodes.on "mouseover", ->
        qNode = $ @

        if !isConsecutiveSelect qNode
            return

        qNode.addClass "hover"

    qNodes.on "mouseout", ->
        qNode = $ @

        qNode.removeClass "hover"

    qNodes.on "click", ->
        qNode = $ @

        if !isConsecutiveSelect qNode
            return

        qNode.toggleClass "selected"

        # Restructure from all the nodes
        wordCounter = 0
        answer = []
        input = null

        # Find if there are initial input and value
        initialInput = aParagraph.find "input"
        initialValue = initialInput.val()

        for node in qNodes
            node = $ node

            if node.hasClass "selected"
                if wordCounter is 0
                    input = $ "<input type='text' />"

                    input.attr "data-chars", 0

                    if initialValue?
                        input.val initialValue

                    answer.push input

                length = parseInt input.attr "data-chars"

                input.attr "data-chars", length + node.text().length

                wordCounter++
            else
                wordCounter = 0
                answer.push node.clone()

        aParagraph.html answer

        # Set the width based on chars length
        if input?
            length = parseInt input.attr "data-chars"
            input.css "width", length * 10