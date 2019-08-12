$(document).on('turbolinks:load', function () {
    /* This script governs the autocomplete tag search form used in users#edit_skill_tags 
       The script is executed when a user selects a tag from the autocomplete dropdown. 
       First, a tag is created (if it does not already exist) with a button that allows it to be removed  
       from the list. Then, a hidden field on a form for the user's skill list is created with the name of the skill 
       if it does not exist. */

    var $tagSearchField = $('#tag-search-field');
    var tagsDiv = document.getElementById('tags');
    var skillFields = document.getElementById('skill-fields');
    var submitButton = document.getElementById('submit-skills');
    var unicodeX = '\u2715';

    function RemoveButton() {
        // skill tag removal button constructor 
        this.text = unicodeX;
    };
    RemoveButton.prototype.create = function (tag) {
        // Appends a new skill tag removal button to the given tag div
        let removeBtn = document.createElement('button');
        removeBtn.className = 'remove-tag-button';
        removeBtn.innerText = this.text;
        let text = tag.innerText
        removeBtn.addEventListener('click', function () {
            let field = nodeWithTextOrValue(text, skillFields.children);
            if (field) {
                field.remove();
            };
            tag.remove();
            console.log(skillFields.children.length)
            if (skillFields.children.length == 0) {
                submitButton.disabled = true;
            }
        });
        tag.appendChild(removeBtn);
    }

    function SkillTag(name) {
        // skill tag constructor
        this.name = name;
    };
    SkillTag.prototype.create = function () {
        // appends a new tag to the DOM
        let tag = document.createElement('div');
        tag.className = 'tag';
        tag.innerText = this.name
        let removeTagBtn = new RemoveButton();
        removeTagBtn.create(tag);
        tagsDiv.appendChild(tag);
        if (submitButton.disabled) {
            submitButton.disabled = false;
        }
    }

    function HiddenField(value) {
        // hidden field constructor for the skill list form
        this.value = value;
    };
    HiddenField.prototype.create = function () {
        /* appends a new hidden field containing the name of the skill to the 
        skill list form */
        let hiddenField = document.createElement('input');
        hiddenField.type = 'hidden';
        hiddenField.name = 'user[skill_list][]';
        hiddenField.value = this.value;
        skillFields.appendChild(hiddenField);
    }

    function nodeWithTextOrValue(name, nodes) {
        /* Iterates over a nodelist for a node that contains the given name as 
           text or as its value. Returns the node if found */
        for (let node of nodes) {
            if (!node.innerText && !node.value) {
                continue
            }

            if ((node.innerText && node.innerText == `${name}\n${unicodeX}`) || (node.value && node.value == name)) {
                return node;
            }
        };

        return false;
    };

    function addSkillTagToDOM(name) {
        /* Make a div that represents the tag for the user to see and add it to 
           the tags div. Prevents multiples from being created by checking for 
           the tag in the tags div first */
        let children = tagsDiv.children;

        if (nodeWithTextOrValue(name, children)) {
            return;
        };

        let tag = new SkillTag(name);
        tag.create()
    }

    function addSkillNameToForm(value) {
        /* Add the name of the skill to the form for the user's skill list
           Checks the form for the name of the skill before appending it */
        let children = skillFields.children

        if (nodeWithTextOrValue(value, children)) {
            return;
        }
        let hiddenField = new HiddenField(value);
        hiddenField.create();
    }

    $tagSearchField.bind('railsAutocomplete.select', function (event, data) {
        let tagName = data.item.value;
        addSkillNameToForm(tagName);
        addSkillTagToDOM(tagName);
        $(this).val('');
        return false;
    });

    if (tagsDiv) {
        let existingTags = tagsDiv.children

        for (let tag of existingTags) {
            let hiddenField = new HiddenField(tag.innerText);
            hiddenField.create();
            let removeBtn = new RemoveButton();
            removeBtn.create(tag);
        }

        if (skillFields.children.length == 0) {
            submitButton.disabled = true;
        }
    }
});