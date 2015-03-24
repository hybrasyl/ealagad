//
// This code is part of Project Hybrasyl.
//
// Modifications (C) 2012 Justin Baugh <baughj@audeocloud.com>
// Original code (C) 2011 Chris Wood <chris@flipbit.co.uk>
//

/* 

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, version 2 of the License.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

*/

/// <reference path="jquery-1.2.6-vsdoc.js" />
(function($) {

    $.fn.annotateImage = function(options) {
        ///	<summary>
        ///		Creates annotations on the given image.
        ///     Images are loaded from the "getUrl" propety passed into the options.
        ///	</summary>
        var opts = $.extend({}, $.fn.annotateImage.defaults, options);
        var image = this;

        this.image = this;
        this.mode = 'view';

        // Assign defaults
        this.getUrl = opts.getUrl;
        this.saveUrl = opts.saveUrl;
        this.deleteUrl = opts.deleteUrl;
        this.editable = opts.editable;
        this.useAjax = opts.useAjax;
        this.notes = opts.notes;
	      this.worldmapId = opts.worldmapId;

        // Add the canvas
        this.canvas = $('<div class="image-annotate-canvas"><div class="image-annotate-view"></div><div class="image-annotate-edit"><div class="image-annotate-edit-area"></div></div></div>');
        this.canvas.children('.image-annotate-edit').hide();
        this.canvas.children('.image-annotate-view').hide();
        this.image.after(this.canvas);

        // Give the canvas and the container their size and background
        this.canvas.height(this.height());
        this.canvas.width(this.width());
        this.canvas.css('background-image', 'url("' + this.attr('src') + '")');
        this.canvas.children('.image-annotate-view, .image-annotate-edit').height(this.height());
        this.canvas.children('.image-annotate-view, .image-annotate-edit').width(this.width());

        // Add the behavior: hide/show the notes when hovering the picture
        this.canvas.hover(function() {
            if ($(this).children('.image-annotate-edit').css('display') == 'none') {
                $(this).children('.image-annotate-view').show();
            }
        }, function() {
            //$(this).children('.image-annotate-view').hide();
        });

        this.canvas.children('.image-annotate-view').hover(function() {
            $(this).show();
        }, function() {
            //$(this).hide();
        });

        // load the notes
        if (this.useAjax) {
            $.fn.annotateImage.ajaxLoad(this);
        } else {
            $.fn.annotateImage.load(this);
        }

        // Add the "Add a note" button
        if (this.editable) {
            this.button = $('<a class="image-annotate-add" id="image-annotate-add" href="#">Add Map Point</a>');
            this.button.click(function() {
                $.fn.annotateImage.add(image);
            });
            this.canvas.after(this.button);
	          this.button2 = $('<a class="image-annotate-add" id="image-annotate-done" href="#" onClick="window.close();">Done</a>');
	    this.button.after(this.button2);
        }

        // Hide the original
        this.hide();

        return this;
    };

    /**
    * Plugin Defaults
    **/
    $.fn.annotateImage.defaults = {
        getUrl: '/admin/worldmaps',
        saveUrl: '/admin/worldmap_points/save_point.json',
        deleteUrl: '/admin/worldmap_points',
        editable: true,
        useAjax: true,
        notes: new Array()
    };

    $.fn.annotateImage.clear = function(image) {
        ///	<summary>
        ///		Clears all existing annotations from the image.
        ///	</summary>    
        for (var i = 0; i < image.notes.length; i++) {
            image.notes[image.notes[i]].destroy();
        }
        image.notes = new Array();
    };

    $.fn.annotateImage.ajaxLoad = function(image) {
        ///	<summary>
        ///		Loads the annotations from the "getUrl" property passed in on the
        ///     options object.
        ///	</summary>
            $.ajax({
                url: image.getUrl + '/' + image.worldmapId + '/get_points.json',
                type: 'GET',
                dataType: 'json',
                beforeSend: function(xhr) {
                    xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
                },
                success: function(data) {
                    image.notes = data;
                    $.fn.annotateImage.load(image);
                }
            });
    }

    $.fn.annotateImage.load = function(image) {
        ///	<summary>
        ///		Loads the annotations from the notes property passed in on the
        ///     options object.
        ///	</summary>
        for (var i = 0; i < image.notes.length; i++) {
            image.notes[image.notes[i]] = new $.fn.annotateView(image, image.notes[i]);
        }
    };

    $.fn.annotateImage.getTicks = function() {
        ///	<summary>
        ///		Gets a count og the ticks for the current date.
        ///     This is used to ensure that URLs are always unique and not cached by the browser.
        ///	</summary>        
        var now = new Date();
        return now.getTime();
    };

    $.fn.annotateImage.add = function(image) {
        ///	<summary>
        ///		Adds a note to the image.
        ///	</summary>        
        if (image.mode == 'view') {
            image.mode = 'edit';
            // Create/prepare the editable note elements
            var editable = new $.fn.annotateEdit(image);
            $.fn.annotateImage.createSaveButton(editable, image);
            $.fn.annotateImage.createCancelButton(editable, image);
        }
    };

    $.fn.annotateImage.createSaveButton = function(editable, image, note) {
        ///	<summary>
        ///		Creates a Save button on the editable note.
        ///	</summary>
        var ok = $('<a class="image-annotate-edit-ok">OK</a>');

        ok.click(function() {
          var form = $('#image-annotate-edit-form form');
          //var text = $('#image-annotate-text').val();
	        var targetMap = $('#targetMap').val();
	        var pointDestX = $('#pointDestX').val();
	        var pointDestY = $('#pointDestY').val();
	        var pointName = $('#pointName').val();
	        var pointConditional = $('#pointConditional').val();
	        var worldmapId = $('#worldmapId').val();

          $.fn.annotateImage.appendPosition(form, editable);
          image.mode = 'view';

            // Save via AJAX
            if (image.useAjax) {
                $.ajax({
                    type: "POST",
                    url: image.saveUrl,
                    beforeSend: function(xhr) {
                        xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
                    },
                    data: form.serializeArray(),
                    error: function(e) { alert("An error occured saving the map point. Was it valid?") },
                    success: function(data) {
				                if (data.annotation_id != undefined) {
					                  editable.note.id = data.annotation_id;
				                }
		                },
                    dataType: "json"
                });
            }

            // Add to canvas
            if (note) {
                console.log("worldmapId is " + worldmapId);
                note.resetPosition(editable, targetMap, pointDestX, pointDestY, pointName, pointConditional, worldmapId);
            } else {
                editable.note.editable = true;
                note = new $.fn.annotateView(image, editable.note)
                console.log("worldmapId is " + worldmapId);
                note.resetPosition(editable, targetMap, pointDestX, pointDestY, pointName, pointConditional, worldmapId);
                image.notes.push(editable.note);
            }
            editable.destroy();
        });
        editable.form.append(ok);
    };

    $.fn.annotateImage.createCancelButton = function(editable, image) {
        ///	<summary>
        ///		Creates a Cancel button on the editable note.
        ///	</summary>
        var cancel = $('<a class="image-annotate-edit-close">Cancel</a>');
        cancel.click(function() {
            editable.destroy();
            image.mode = 'view';
        });
        editable.form.append(cancel);
    };

    $.fn.annotateImage.saveAsHtml = function(image, target) {
        var element = $(target);
        var html = "";
        for (var i = 0; i < image.notes.length; i++) {
            html += $.fn.annotateImage.createHiddenField("pointName_" + i, image.notes[i].pointName);
            html += $.fn.annotateImage.createHiddenField("targetMap_" + i, image.notes[i].targetMap);
            html += $.fn.annotateImage.createHiddenField("pointDestX_" + i, image.notes[i].pointDestX);
            html += $.fn.annotateImage.createHiddenField("pointDestY_" + i, image.notes[i].pointDestY);
            html += $.fn.annotateImage.createHiddenField("pointConditional_" + i, image.notes[i].pointConditional);
            html += $.fn.annotateImage.createHiddenField("top_" + i, image.notes[i].top);
            html += $.fn.annotateImage.createHiddenField("left_" + i, image.notes[i].left);
            html += $.fn.annotateImage.createHiddenField("height_" + i, image.notes[i].height);
            html += $.fn.annotateImage.createHiddenField("width_" + i, image.notes[i].width);
        }
        element.html(html);
    };

    $.fn.annotateImage.createHiddenField = function(name, value) {
        return '&lt;input type="hidden" name="' + name + '" value="' + value + '" /&gt;<br />';
    };

    $.fn.annotateEdit = function(image, note) {
        ///	<summary>
        ///		Defines an editable annotation area.
        ///	</summary>
        this.image = image;

        if (note) {
            this.note = note;
        } else {
            var newNote = new Object();
            //newNote.id = "";
            newNote.top = 30;
            newNote.left = 30;
            newNote.width = 8;
            newNote.height = 8;
            newNote.targetmap = "";
	          newNote.dest_x = 0;
	          newNote.dest_y = 0;
	          newNote.pointName = "";
	          newNote.conditional = "";
            this.note = newNote;
        }

        // Set area
        var area = image.canvas.children('.image-annotate-edit').children('.image-annotate-edit-area');
        this.area = area;
        this.area.css('height', this.note.height + 'px');
        this.area.css('width', this.note.width + 'px');
        this.area.css('left', this.note.left + 'px');
        this.area.css('top', this.note.top + 'px');

        // Show the edition canvas and hide the view canvas
        image.canvas.children('.image-annotate-view').hide();
        image.canvas.children('.image-annotate-edit').show();

        // Add the note (which we'll load with the form afterwards)

        var form = $('<div id="image-annotate-edit-form"><form id="pointAnnotation"></form></div>');

        this.form = form;
        $('body').append(this.form);
        $('#pointAnnotation').append('<div class="pointformfield"> <label class="label editpointformlabel">Target Map</label> <select class="editformselect" name="targetMap" id="targetMap"></select></div>');
        $('#pointAnnotation').append('<div class="pointformfield"> <label class="label editpointformlabel">X</label> <input name="pointDestX" id="pointDestX" type="text" class="annotate-sm"/><label class="label editpointformlabel">Y</label> <input name="pointDestY" id="pointDestY" type="text" class="annotate-sm"/></div>');
        $('#pointAnnotation').append('<div class="pointformfield"> <label class="label editpointformlabel">Point Name</label> <input name="pointName" id="pointName" type="text" class="annotate-lg"> </div>');
        $('#pointAnnotation').append('<input type="hidden" id="worldmapId" name="worldmapId"/>');
        $('#pointDestX').val(this.note.pointDestX);
        $('#pointDestY').val(this.note.pointDestY);
        $('#pointName').val(this.note.pointName);
        $('#pointConditional').val(this.note.pointConditional);
        $('#worldmapId').val(image.worldmapId);

	      var $selected = this.note.targetMap;

        var mapzones = $.ajax({
            url: '/admin/maps/get_zones',
            processData: false,
            cache: false,
            beforeSend: function(xhr) {
                xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
            },
        }).done(function(html){
	          var x = $selected;
	          $("#targetMap").append(html);
	          $("#targetMap").val(x);
        });

        //	$('#mapnames').val(this.note.targetMap);
        mapzones.fail(function(jqXHR, textStatus) {
            alert("Request failed: " + textStatus);
        });


        this.form.css('left', this.area.offset().left + 'px');
        this.form.css('top', (parseInt(this.area.offset().top) + parseInt(this.area.height()) + 7) + 'px');

        // Set the area as a draggable/resizable element contained in the image canvas.
        // Would be better to use the containment option for resizable but buggy
        area.draggable({
            containment: image.canvas,
            drag: function(e, ui) {
                form.css('left', area.offset().left + 'px');
                form.css('top', (parseInt(area.offset().top) + parseInt(area.height()) + 2) + 'px');
            },
            stop: function(e, ui) {
                form.css('left', area.offset().left + 'px');
                form.css('top', (parseInt(area.offset().top) + parseInt(area.height()) + 2) + 'px');
            }
        });
        return this;
    };

    $.fn.annotateEdit.prototype.destroy = function() {
        ///	<summary>
        ///		Destroys an editable annotation area.
        ///	</summary>        
        this.image.canvas.children('.image-annotate-edit').hide();
        this.area.resizable('destroy');
        this.area.draggable('destroy');
        this.area.css('height', '');
        this.area.css('width', '');
        this.area.css('left', '');
        this.area.css('top', '');
        this.form.remove();
    }

    $.fn.annotateView = function(image, note) {
        ///	<summary>
        ///		Defines a annotation area.
        ///	</summary>
        this.image = image;

        this.note = note;

        this.editable = (note.editable && image.editable);

        // Add the area
        this.area = $('<div class="image-annotate-area' + (this.editable ? ' image-annotate-area-editable' : '') + '"><div></div></div>');
        image.canvas.children('.image-annotate-view').prepend(this.area);

        // Add the note

        this.form = $('<div class="image-annotate-note">' + note.pointName + ' (' + note.pointDestX + ',' + note.pointDestY + ')' + '</div>');
        this.form.hide();
        image.canvas.children('.image-annotate-view').append(this.form);
        this.form.children('span.actions').hide();

        // Set the position and size of the note
        this.setPosition();

        // Add the behavior: hide/display the note when hovering the area
        var annotation = this;
        this.area.hover(function() {
            annotation.show();
        }, function() {
            annotation.hide();
        });

        // Edit a note feature
        if (this.editable) {
            var form = this;
            this.area.click(function() {
                form.edit();
            });
        }
    };

    $.fn.annotateView.prototype.setPosition = function() {
        ///	<summary>
        ///		Sets the position of an annotation.
        ///	</summary>
        this.area.children('div').height((parseInt(this.note.height) - 2) + 'px');
        this.area.children('div').width((parseInt(this.note.width) - 2) + 'px');
        this.area.css('left', (this.note.left) + 'px');
        this.area.css('top', (this.note.top) + 'px');
        this.form.css('left', (this.note.left) + 'px');
        this.form.css('top', (parseInt(this.note.top) + parseInt(this.note.height) + 7) + 'px');
    };

    $.fn.annotateView.prototype.show = function() {
        ///	<summary>
        ///		Highlights the annotation
        ///	</summary>
        this.form.fadeIn(250);
        if (!this.editable) {
            this.area.addClass('image-annotate-area-hover');
        } else {
            this.area.addClass('image-annotate-area-editable-hover');
        }
    };

    $.fn.annotateView.prototype.hide = function() {
        ///	<summary>
        ///		Removes the highlight from the annotation.
        ///	</summary>      
        this.form.fadeOut(250);
        this.area.removeClass('image-annotate-area-hover');
        this.area.removeClass('image-annotate-area-editable-hover');
    };

    $.fn.annotateView.prototype.destroy = function() {
        ///	<summary>
        ///		Destroys the annotation.
        ///	</summary>      
        this.area.remove();
        this.form.remove();
    }

    $.fn.annotateView.prototype.edit = function() {
        ///	<summary>
        ///		Edits the annotation.
        ///	</summary>      
        if (this.image.mode == 'view') {
            this.image.mode = 'edit';
            var annotation = this;

            // Create/prepare the editable note elements
            var editable = new $.fn.annotateEdit(this.image, this.note);

            $.fn.annotateImage.createSaveButton(editable, this.image, annotation);

            // Add the delete button
            var del = $('<a class="image-annotate-edit-delete">Delete</a>');
            del.click(function() {
                var form = $('#image-annotate-edit-form form');

                $.fn.annotateImage.appendPosition(form, editable)
                var url = annotation.image.deleteUrl + '/' + annotation.note.id;

                if (annotation.image.useAjax) {
                    console.log("url should be " + url);
                    $.ajax({
                        url: url,
                        type: 'DELETE',
                        beforeSend: function(xhr) {
                            xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
                        },
                        //data: form.serialize(),
                        error: function(e) { alert("An error occured deleting that note.") }
                    });
                }

                annotation.image.mode = 'view';
                editable.destroy();
                annotation.destroy();
            });
            editable.form.append(del);

            $.fn.annotateImage.createCancelButton(editable, this.image);
        }
    };

    $.fn.annotateImage.appendPosition = function(form, editable) {
        ///	<summary>
        ///		Appends the annotations coordinates to the given form that is posted to the server.
        ///	</summary>

        var worldmapId = $('#worldmapId').val()
        if (editable.note.id) {
            var areaFields = $('<input type="hidden" value="' + editable.area.height() + '" name="height"/>' +
                               '<input type="hidden" value="' + editable.area.width() + '" name="width"/>' +
                               '<input type="hidden" value="' + editable.area.position().top + '" name="top"/>' +
                               '<input type="hidden" value="' + editable.area.position().left + '" name="left"/>' + 
                               '<input type="hidden" value="' + editable.note.id + '" name="id"/>' +
                               '<input type="hidden" value="' + worldmapId + '" name="worldmapId"/>' );
            form.append(areaFields);
        }
        else {
            var areaFields = $('<input type="hidden" value="' + editable.area.height() + '" name="height"/>' +
                               '<input type="hidden" value="' + editable.area.width() + '" name="width"/>' +
                               '<input type="hidden" value="' + editable.area.position().top + '" name="top"/>' +
                               '<input type="hidden" value="' + editable.area.position().left + '" name="left"/>' + 
                               '<input type="hidden" value="' + worldmapId + '" name="worldmapId"/>');
            form.append(areaFields);
        }
    }

    $.fn.annotateView.prototype.resetPosition = function(editable, targetMap, pointDestX, pointDestY, pointName, pointConditional, worldmapId) {
        ///	<summary>
        ///		Sets the position of an annotation.
        ///	</summary>
        this.form.html(pointName);
        this.form.hide();

        // Resize
        this.area.children('div').height(editable.area.height() + 'px');
        this.area.children('div').width((editable.area.width() - 2) + 'px');
        this.area.css('left', (editable.area.position().left) + 'px');
        this.area.css('top', (editable.area.position().top) + 'px');
        this.form.css('left', (editable.area.position().left) + 'px');
        this.form.css('top', (parseInt(editable.area.position().top) + parseInt(editable.area.height()) + 7) + 'px');

        // Save new position to note
        this.note.top = editable.area.position().top;
        this.note.left = editable.area.position().left;
        this.note.height = editable.area.height();
        this.note.width = editable.area.width();

	      // Save our actual map point information
        this.note.pointName = pointName;
	      this.note.targetMap = targetMap;
	      this.note.pointDestX = pointDestX;
	      this.note.pointDestY = pointDestY;
	      this.note.pointConditional = pointConditional;
	      this.note.worldmapId = worldmapId;
        this.note.id = editable.note.id;
        this.editable = true;
    };

})(jQuery);
