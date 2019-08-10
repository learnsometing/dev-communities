$(function () {
    /* This script governs the autocomplete tag search form used in users#edit_skill_tags */
    /* The script is executed when a user selects a tag from the autocomplete dropdown. */
    /* First, a tag is created (if it does not already exist) with a button that allows it to be removed  */
    /* from the list. Then, a hidden field on a form for the user's skill list is created with the name of the skill */
    /* if it does not exist. */

    var $tagSearch = $("#tag-search");
    var $tagsDiv = $("#tags");
    var $skillsForm = $("#skills-form");

    function createTag(name) {
        /* returns a new tag with the given name */
        let tag = document.createElement('div');
        tag.classList.add('tag');
        tag.innerText = name;
        return tag;
    };

    function createRemoveTagButton() {
        /* returns a new button that is used to remove the tag it is placed on */
        let removeTagBtn = document.createElement('button');
        removeTagBtn.classList.add('remove-tag-button');
        removeTagBtn.innerText = '\u2715';
        return removeTagBtn;
    };

    function createHiddenTag(name) {
        /* returns a hidden field that contains the name of the skill that was tagged */
        let hiddenField = document.createElement('input');
        hiddenField.type = 'hidden';
        hiddenField.name = 'user[skill_list][]';
        hiddenField.value = name;
        return hiddenField;
    };

    function nodeInNodelist(name, nodes) {
        /* Iterates over a nodelist for a node that contains the given name as text or as its value */
        /* Returns the node if found */
        for (let node of nodes) {
            if (node.innerText == name + "\n\u2715" || node.value == name) {
                return node;
            }
        };

        return false;
    };

    function appendTagButtonToDiv(name) {
        /* Make a div that represents the tag for the user to see and add it to the tags div */
        /* Prevents multiples from being created by checking for the tag in the tags div first */
        let children = $tagsDiv.children();

        if (nodeInNodelist(name, children)) {
            return;
        };

        let tag = createTag(name);
        let removeTagBtn = createRemoveTagButton();
        tag.append(removeTagBtn);

        removeTagBtn.addEventListener('click', function () {
            tag.remove();
            let field = nodeInNodelist(name, $skillsForm.children());
            if (field) {
                field.remove();
            };

        });
        $tagsDiv.append(tag);
    }

    function appendSkillNameToForm(name) {
        /* Add the name of the skill to the form for the user's skill list */
        /* Checks the form for the name of the skill before appending it */
        let children = $skillsForm.children()

        if (nodeInNodelist(name, children)) {
            return;
        }

        let hiddenField = createHiddenTag(name);
        $skillsForm.append(hiddenField);
    }

    $tagSearch.bind('railsAutocomplete.select', function (event, data) {
        let tagName = data.item.value;
        appendSkillNameToForm(tagName);
        appendTagButtonToDiv(tagName);
        $(this).val('');
        return false;
    });
});