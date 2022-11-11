/*
██╗░░░██╗████████╗██╗██╗░░░░░░██████╗
██║░░░██║╚══██╔══╝██║██║░░░░░██╔════╝
██║░░░██║░░░██║░░░██║██║░░░░░╚█████╗░
██║░░░██║░░░██║░░░██║██║░░░░░░╚═══██╗
╚██████╔╝░░░██║░░░██║███████╗██████╔╝
░╚═════╝░░░░╚═╝░░░╚═╝╚══════╝╚═════╝░
*/
const resName = GetParentResourceName();

const allJobsStatisticsDiv = document.getElementById('all-jobs-statistics').getContext('2d');
const jobStatisticsDiv = document.getElementById('job-statistics-chart').getContext('2d');

let TRANSLATIONS = {};
let MARKERS_INFOS = {};

function translateEverything() {
	$("body").find(".translatable").each(function() {
		let translationId = $(this).data("translationId")

		$(this).prop("innerHTML", TRANSLATIONS[translationId]);
	})

	MARKERS_INFOS = {
		["stash"]: { 
			label: getLocalizedText("menu:dynamic:marker_info:stash"),
			settingsName: getLocalizedText("menu:dynamic:marker_info:stash_settings"),
			isJobMarker: true,
			isPublicMarker: true,
			requiresDataUpdate: false
		},
		["armory"]: { 
			label: getLocalizedText("menu:dynamic:marker_info:armory"),
			settingsName: getLocalizedText("menu:dynamic:marker_info:armory_settings"),
			isJobMarker: true,
			isPublicMarker: true,
			requiresDataUpdate: true,
			framework: "ESX"
		},
		["safe"]: { 
			label: getLocalizedText("menu:dynamic:marker_info:safe"),
			settingsName: null,
			isJobMarker: true,
			isPublicMarker: true,
			requiresDataUpdate: false,
			framework: "ESX"
		},
		["garage"]: { 
			label: getLocalizedText("menu:dynamic:marker_info:temporary_garage"),
			settingsName: getLocalizedText("menu:dynamic:marker_info:temporary_garage_settings"),
			isJobMarker: true,
			isPublicMarker: true,
			requiresDataUpdate: true
		},
		["garage_buyable"]: { 
			label: getLocalizedText("menu:dynamic:marker_info:garage_buyable"),
			settingsName: getLocalizedText("menu:dynamic:marker_info:garage_buyable_settings"),
			isJobMarker: true,
			isPublicMarker: true,
			requiresDataUpdate: true
		},
		["garage_owned"]: { 
			label: getLocalizedText("menu:dynamic:marker_info:garage_owned"),
			settingsName: getLocalizedText("menu:dynamic:marker_info:garage_owned_settings"),
			isJobMarker: true,
			isPublicMarker: true,
			requiresDataUpdate: true
		},
		["boss"]: { 
			label: getLocalizedText("menu:dynamic:marker_info:boss"),
			settingsName: getLocalizedText("menu:dynamic:marker_info:boss_settings"),
			isJobMarker: true,
			isPublicMarker: false,
			requiresDataUpdate: true
		},
		["wardrobe"]: { 
			label: getLocalizedText("menu:dynamic:marker_info:wardrobe"),
			settingsName: null,
			isJobMarker: true,
			isPublicMarker: true,
			requiresDataUpdate: true
		},
		["job_outfit"]: { 
			label: getLocalizedText("menu:dynamic:marker_info:job_outfit"),
			settingsName: getLocalizedText("menu:dynamic:marker_info:job_outfit_settings"),
			isJobMarker: true,
			isPublicMarker: true,
			requiresDataUpdate: true
		},
		["shop"]: { 
			label: getLocalizedText("menu:dynamic:marker_info:shop"),
			settingsName: getLocalizedText("menu:dynamic:marker_info:shop_settings"),
			isJobMarker: true,
			isPublicMarker: true,
			requiresDataUpdate: true
		},
		["market"]: { 
			label: getLocalizedText("menu:dynamic:marker_info:market"),
			settingsName: getLocalizedText("menu:dynamic:marker_info:market_settings"),
			isJobMarker: true,
			isPublicMarker: true,
			requiresDataUpdate: true
		},
		["harvest"]: { 
			label: getLocalizedText("menu:dynamic:marker_info:harvest"),
			settingsName: getLocalizedText("menu:dynamic:marker_info:harvest_settings"),
			isJobMarker: true,
			isPublicMarker: true,
			requiresDataUpdate: true
		},
		["process"]: { 
			label: getLocalizedText("menu:dynamic:marker_info:process"),
			settingsName: getLocalizedText("menu:dynamic:marker_info:process_settings"),
			isJobMarker: true,
			isPublicMarker: true,
			requiresDataUpdate: true
		},
		["crafting_table"]: { 
			label: getLocalizedText("menu:dynamic:marker_info:crafting_table"),
			settingsName: getLocalizedText("menu:dynamic:marker_info:crafting_table_settings"),
			isJobMarker: true,
			isPublicMarker: true,
			requiresDataUpdate: true
		},
		["teleport"]: { 
			label: getLocalizedText("menu:dynamic:marker_info:teleport"),
			settingsName: getLocalizedText("menu:dynamic:marker_info:teleport_settings"),
			isJobMarker: true,
			isPublicMarker: true,
			requiresDataUpdate: true
		},
		["weapon_upgrader"]: { 
			label: getLocalizedText("menu:dynamic:marker_info:weapon_upgrader"),
			settingsName: getLocalizedText("menu:dynamic:marker_info:weapon_upgrader_settings"),
			isJobMarker: true,
			isPublicMarker: true,
			requiresDataUpdate: true
		},
		["duty"]: { 
			label: getLocalizedText("menu:dynamic:marker_info:duty"),
			settingName: null,
			isJobMarker: true,
			isPublicMarker: false,
			requiresDataUpdate: true
		},
		["job_shop"]: { 
			label: getLocalizedText("menu:dynamic:marker_info:job_shop"),
			settingsName: getLocalizedText("menu:dynamic:marker_info:job_shop_settings"),
			isJobMarker: false,
			isPublicMarker: true,
			requiresDataUpdate: true
		},
	}
} 

function refreshTranslations(locale) {
	$.ajax({
		url: `menu_translations/${locale}.json`,
		success: function (translationsJSON) {
			TRANSLATIONS = JSON.parse(translationsJSON);

			translateEverything();
		}
	});
}

function loadTranslations() {
	$.ajax({
		url: `https://${resName}/getLocale`,
		success: function (locale) {
			refreshTranslations(locale);
		}
	});
} loadTranslations();

function getLocalizedText(text) {
	return TRANSLATIONS[text];
}

function getFramework() {
	return new Promise((resolve) => {
		$.post(`https://${resName}/getFramework`, {}, (framework) => {
			resolve(framework)
		})
	}) 
}

const allJobsStatisticsChart = new Chart(allJobsStatisticsDiv, {
	type: 'bar',

	data: {
		labels: "Jobs",
		datasets: []
	},

	options: {
		scales: {
			y: {
				beginAtZero: true
			}
		},
	}
});

const jobStatisticsChart = new Chart(jobStatisticsDiv, {
	type: 'bar',

	data: {
		labels: "Ranks",
		datasets: []
	},

	options: {
		scales: {
			y: {
				beginAtZero: true
			}
		},
	}
});

// Fetch all the forms we want to apply custom Bootstrap validation styles to
var forms = document.querySelectorAll('.needs-validation')

// Loop over them and prevent submission
Array.prototype.slice.call(forms)
.forEach(function (form) {
	form.addEventListener('submit', function (event) {

	event.preventDefault();

	form.classList.add('was-validated')
	}, false)
})

$(".max-two-decimals").change(function() {
	if(isNaN(this.value)) {
		return
	}

	let number = parseFloat(this.value);

	if(number) {
		this.value = number.toFixed(2);
	}
})

function getValidId(text) {
	text = text.toLowerCase();
	text = text.replace(/[^a-zA-Z0-9]/g,'_');

	return text
}

$(".id").on("input", function() {
	let text = $(this).val();
	

	$(this).val( getValidId(text) );
})

function componentToHex(c) {
	var hex = c.toString(16);

	return hex.length == 1 ? "0" + hex : hex;
  }
  
function rgbToHex(r, g, b) {
	return "#" + componentToHex(r) + componentToHex(g) + componentToHex(b);
}  

function hexToRgb(hex) {
	var result = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec(hex);

	return result ? {
	  r: parseInt(result[1], 16),
	  g: parseInt(result[2], 16),
	  b: parseInt(result[3], 16)
	} : null;
}

function getVehicleLabel(vehicleModel, cb) {
	$.post(`https://${resName}/get-vehicle-label`, JSON.stringify({vehicleModel: vehicleModel}), cb)
}

// Disables enter
$(document).on("keypress", 'form', function (e) {
    var code = e.keyCode || e.which;
    if (code == 13) {
        e.preventDefault();
        return false;
    }
});

/* Dialogs */
function inputDialog(title, data, yesCallback) {
	$("#input-text-dialog-title").text(title);

	var inputModal = $("#input-text-dialog-modal");

	// Removes old data
	inputModal.find(".modal-body form").empty();

	data.forEach(currentData => {
		var id = currentData.id;
		var label = currentData.label;
		var defaultValue = currentData.default !== undefined ? currentData.default : "";

		var type = currentData.type || "text";

		if (type === "button") {
			var button = $(`<button type="button" class="mt-3 btn ${currentData.buttonType}">${label}</button>`);

			button.click(function () {
				currentData.buttonCallback(inputModal);
			});

			inputModal.find(".modal-body form").append(button);
		} else if (type === "select") {

			var select = $(`<select class="form-select" data-id="${id}" aria-label="Select"></select>`)
			var options = currentData.options

			options.forEach(option => {
				var optionElement = $(`<option value="${option.value}">${option.label}</option>`)
				select.append(optionElement);
			})

			inputModal.find(".modal-body form").append(select);
		} else if (type === "switch") {

			var switchInput = $(`
			<div class="form-check form-switch mt-3">
				<label class="form-check-label" for="modal-${id}">${label}</label>
				<input class="form-check-input" type="checkbox" id="modal-${id}" data-id="${id}">
			</div>`);

			inputModal.find(".modal-body form").append(switchInput);

			$(`#modal-${id}`).prop("checked", defaultValue)
		} else {
			let isAnId = currentData.isId || false
			var formGroup = $(
				`<div class="form-group">
					<label for="modal-${id}" class="col-form-label">${label}</label>
					<input id="modal-${id}" type="${type}" class="form-control" data-id="${id}" value="${defaultValue}">
					<div class="invalid-feedback">Can't be empty</div>
				</div>`
			)

			inputModal.find(".modal-body form").append(formGroup)

			let inputDiv = $(`#modal-${id}`);

			inputDiv.unbind('input');

			if(isAnId) {
				inputDiv.on('input', function() {
					let text = inputDiv.val();
					text = text.toLowerCase();
					text = text.replace(/[^a-zA-Z0-9]/g,'_');

					inputDiv.val(text);
				});
			}
		}
	})

	inputModal.modal("show");

	$("#input-text-dialog-confirm").off('click');
	$("#input-text-dialog-confirm").click(function () {
		var areInputsValid = true;

		var inputs = inputModal.find(".form-control, .form-select, :checkbox");
		var length = inputs.length;

		var data = {};

		inputs.each(function (index, element) {
			var text = $(element).val();
			if (text || $(element).is(":checkbox")) {
				$(element).removeClass("is-invalid");
				var id = $(element).data("id");

				if ($(element).is(":checkbox")) {
					data[id] = $(element).is(':checked');
				} else {
					data[id] = text;
				}
			} else {
				$(element).addClass("is-invalid");
				areInputsValid = false;
			}
		});

		inputModal.modal("hide");
		yesCallback(data);
	})
}

function deleteDialog(title, message, yesCallback) {
	var deleteModal = $('#delete-dialog-modal')
	deleteModal.find('.modal-title').text(title);
	deleteModal.find('.modal-body').text(message);

	deleteModal.modal("show")

	$("#delete-dialog-confirm").off('click');
	$("#delete-dialog-confirm").click(function () {
		deleteModal.modal("hide");
		yesCallback()
	})
}

function showError(msg){
	$("#notification-message").text(msg);
	$("#notification-modal").modal("show");
}

function itemsDialog(cb) {
	let inputItemsModal = $("#input-items-dialog-modal")
	inputItemsModal.modal("show");

	$("#input-item-search").val("");
	
	$.post(`https://${resName}/get-all-items`, JSON.stringify({}), function (items) {
		let itemListDiv = $("#items-list");

		itemListDiv.empty();

		for(const[itemName, itemData] of Object.entries(items)) {
			let itemDiv = $(`
				<li class="list-group-item list-group-item-action" value=${itemName}>${itemData.label}</li>
			`);

			itemDiv.click(function() {
				inputItemsModal.modal("hide");
				cb(itemName);
			});

			itemListDiv.append(itemDiv);
		}
	});
}

$("#input-item-search").on("keyup", function() {
	let text = $(this).val().toLowerCase();

	$("#items-list li").filter(function() {
      $(this).toggle($(this).text().toLowerCase().indexOf(text) > -1)
    });
})

function weaponsDialog(cb) {
	let inputWeaponsModal = $("#input-weapons-dialog-modal")
	inputWeaponsModal.modal("show");

	$("#input-weapon-search").val();

	$.post(`https://${resName}/get-all-weapons`, JSON.stringify({}), function (weapons) {
		let weaponListDiv = $("#weapons-list");

		weaponListDiv.empty();

		weapons.forEach(weaponData => {
			let weaponDiv = $(`
				<li class="list-group-item list-group-item-action" value=${weaponData.name}>${weaponData.label}</li>
			`);

			weaponDiv.click(function() {
				inputWeaponsModal.modal("hide");
				cb(weaponData.name);
			});

			weaponListDiv.append(weaponDiv);
		})
	});
}

$("#input-weapon-search").on("keyup", function() {
	let text = $(this).val().toLowerCase();

	$("#weapons-list li").filter(function() {
      $(this).toggle($(this).text().toLowerCase().indexOf(text) > -1)
    });
})

function accountsDialog(cb) {
	let accountsModal = $("#input-accounts-dialog-modal");
	let accountsList = $("#accounts-list");

	$.post(`https://${resName}/getAllAccounts`, {}, function (accounts) {
		accountsList.empty();

		for(const[accountName, accountLabel] of Object.entries(accounts)) {
			let accountDiv = $(`
				<li class="list-group-item list-group-item-action" value=${accountName}>${accountLabel}</li>
			`);

			accountDiv.click(function() {
				accountsModal.modal("hide");
				cb(accountName);
			});

			accountsList.append(accountDiv);
		}

		accountsModal.modal("show");
	})
}

/*
██████╗░░█████╗░███╗░░██╗██╗░░██╗░██████╗
██╔══██╗██╔══██╗████╗░██║██║░██╔╝██╔════╝
██████╔╝███████║██╔██╗██║█████═╝░╚█████╗░
██╔══██╗██╔══██║██║╚████║██╔═██╗░░╚═══██╗
██║░░██║██║░░██║██║░╚███║██║░╚██╗██████╔╝
╚═╝░░╚═╝╚═╝░░╚═╝╚═╝░░╚══╝╚═╝░░╚═╝╚═════╝░
*/
let ranksDataTable = $("#ranks-container").DataTable( {
	"lengthMenu": [10, 15, 20],
	"createdRow": function ( row, data, index ) {
		$(row).addClass("clickable");

		$(row).click(function() {
			let editRankModal = $("#edit-rank");

			let rankId = data[0];
			let rankLabel = data[1];
			let rankName = data[2];
			let rankGrade = data[3];
			let rankSalary = data[4];

			$("#edit-rank-label").val(rankLabel);
			$("#edit-rank-name").val(rankName);
			$("#edit-rank-grade").val(rankGrade);
			$("#edit-rank-salary").val(rankSalary);

			editRankModal.data("rankId", rankId);

			editRankModal.modal("show");
		})
	},
} );

function deleteRank(jobName, rankId) {
	deleteDialog("Delete rank", `Are you sure you want to delete this rank?`, function () {
		$.post(`https://${resName}/delete-rank`, JSON.stringify({ rankId: rankId }), function (data) {
			// Removes deleted row
			if (data.isSuccessful) {
				refreshJobRanks(jobName)
			} else {
				showError(data.message)
			}
		}), "json";
	})
}

function fillJobRanks(ranks) {
	ranksDataTable.clear();

	for(const[_, gradeData] of Object.entries(ranks)) {
		ranksDataTable.row.add( [gradeData.id, gradeData.label, gradeData.name, gradeData.grade, gradeData.salary] );
	}

	ranksDataTable.draw();
}

$("#edit-rank-form").submit(function(event) {
	if (!this.checkValidity()) {
		event.preventDefault();
		event.stopPropagation();

		return;
	} else {
		$(this).removeClass("was-validated");
		$("#create-rank").modal("hide");
	}
	
	let data = {
		rankLabel: $("#edit-rank-label").val(),
		rankName: $("#edit-rank-name").val(),
		rankGrade: parseInt( $("#edit-rank-grade").val() ),
		rankSalary: parseInt( $("#edit-rank-salary").val() ),
		rankId: $("#edit-rank").data("rankId")
	}

	$.post(`https://${resName}/updateRank`, JSON.stringify(data), function (resultData) {
		// Updates old row field with new values
		if (resultData.isSuccessful) {
			refreshJobRanks( $("#edit-job").data("jobName") );
		} else {
			showError(resultData.message)
		}
	});

	$("#edit-rank").modal("hide");
})

$("#edit-rank-delete-btn").click(function() {
	let jobName = $("#edit-job").data("jobName");
	let rankId = $("#edit-rank").data("rankId");

	deleteRank(jobName, rankId);
})

$("#create-rank-btn").click(function() {
	// Reset previous inputs
	$("#create-rank-label").val("");
	$("#create-rank-name").val("");
	$("#create-rank-grade").val("");
	$("#create-rank-salary").val("");

	$("#create-rank").modal("show");
});

// Automatically fills the id from the label
$("#create-rank-label").on("input", function(){
	let label = $(this).val();

	let id = getValidId(label);

	$("#create-rank-name").val(id);
})

// Automatically fills the id from the label
$("#edit-rank-label").on("input", function(){
	let label = $(this).val();

	let id = getValidId(label);

	$("#edit-rank-name").val(id);
})

$("#create-rank-form").submit(function(event) {
	if (!this.checkValidity()) {
		event.stopPropagation();
		event.preventDefault();

		return;
	} else {
		$(this).removeClass("was-validated");

		$("#create-rank").modal("hide");
	}

	let jobName = $("#edit-job").data("jobName");

	let data = {
		rankLabel: $("#create-rank-label").val(),
		rankName: $("#create-rank-name").val(),
		rankGrade: parseInt( $("#create-rank-grade").val() ),
		rankSalary: parseInt( $("#create-rank-salary").val() ),
		jobName: jobName
	}

	$.post(`https://${resName}/create-new-rank`, JSON.stringify(data), function (data) {
		if (data.isSuccessful) {
			refreshJobRanks(jobName)
		} else {
			showError(data.message)
		}
	});
})

function refreshJobRanks(jobName) {
	$.post(`https://${resName}/retrieveJobRanks`, JSON.stringify({ jobName: jobName }), function (ranks) {
		if (ranks) {
			fillJobRanks(ranks)
		}
	});
}
/*
░░░░░██╗░█████╗░██████╗░░██████╗
░░░░░██║██╔══██╗██╔══██╗██╔════╝
░░░░░██║██║░░██║██████╦╝╚█████╗░
██╗░░██║██║░░██║██╔══██╗░╚═══██╗
╚█████╔╝╚█████╔╝██████╦╝██████╔╝
░╚════╝░░╚════╝░╚═════╝░╚═════╝░
*/
var allJobs = {};

function refresh() {
	fillPublicMarkers();

	return new Promise((resolve, reject) => {
		$.post(`https://${resName}/getJobsData`, JSON.stringify({}), function (jobs) {
			allJobs = jobs;
			
			fillJobs(jobs);

			resolve();
		}), "json";
	});
}

$("#create-job-btn").click(function () {
	inputDialog(getLocalizedText("menu:create_new_job"), [
		{ id: "jobLabel", label: getLocalizedText("menu:dynamic:new_job_label") },
		{ id: "jobName", label: getLocalizedText("menu:dynamic:new_job_name"), isId: true },
	], function (data) {
		$.post(`https://${resName}/create-new-job`, JSON.stringify({ jobLabel: data.jobLabel, jobName: data.jobName }), function (data) {
			if (data.isSuccessful) {
				refresh()
			} else {
				showError(data.message)
			}
		});
	});
})

function exitFromEditJob(){
	// Resets current active tab (ranks is the default one)
	$("#edit-job").find(".nav-link, .tab-pane").each(function() {
		if($(this).data("isDefault") == "1") {
			$(this).addClass(["active", "show"])
		} else {
			$(this).removeClass(["active", "show"])
		}
	})

	refresh();

	$("#edit-job").hide();
	$("#job-creator").show();
}

function deleteJob(jobName) {
	deleteDialog(getLocalizedText("menu:dynamic:delete_job"), getLocalizedText("menu:dynamic:delete_job_confirm"), function () {
		$.post(`https://${resName}/delete-job`, JSON.stringify({ jobName: jobName }), function (data) {
			if (data.isSuccessful) {
				exitFromEditJob()
			} else {
				showError(data.message)
			}
		});
	})
}

$("#delete-job-btn").click(function() {
	let jobName = $("#edit-job").data("jobName");
	deleteJob(jobName);
})

$("#edit-job-label").on("input", function(){
	let label = $(this).val();

	let id = getValidId(label);

	$("#edit-job-name").val(id);
})

function editJob(jobData) {
	let editJobDiv = $("#edit-job");

	editJobDiv.data("jobName", jobData.name);

	// Chart with ranks 
	loadRanksDistrubutions();

	// Job settings
	$("#edit-job-label").val(jobData.label);
	$("#edit-job-name").val(jobData.name);

	// Fills actions in settings
	if(jobData.actions) {
		for(const[actionName, isEnabled] of Object.entries(jobData.actions)) {
			$("#job-settings-actions").find(`[data-action-name=${actionName}]`).prop("checked", isEnabled)
		}
	}


	$("#edit-job-text").text(jobData.label);

	fillJobRanks(jobData.ranks);
	fillJobMarkers();

	$("#job-creator").hide();
	editJobDiv.show();
}

$("#edit-job-close-btn").click(function() {
	exitFromEditJob();
})

$("#job-settings").submit(function(event) {
	if (!this.checkValidity()) {
		event.stopPropagation();
		event.preventDefault();
		return;
	} else {
		$(this).removeClass("was-validated");
	}

	let actions = {};

	$("#job-settings-actions").find(".job-action").each(function() {
		let actionName = $(this).data("actionName");

		actions[actionName] = $(this).prop("checked");
	})

	let oldJobName = $("#edit-job").data("jobName");
	let jobName = $("#edit-job-name").val();
	let jobLabel = $("#edit-job-label").val();

	let data = {
		oldJobName: oldJobName,
		jobName: jobName,
		jobLabel: jobLabel,
		actions: actions
	}

	$.post(`https://${resName}/update-job`, JSON.stringify(data), function (resultData) {
		// Updates old job with new values
		if (resultData.isSuccessful) {
			exitFromEditJob();
		} else {
			showError(resultData.message)
		}
	});
})

let jobsDataTable = $("#jobs-container").DataTable( {
	"lengthMenu": [10, 15, 20],
	"createdRow": function ( row, data, index ) {
		$(row).addClass("clickable");

		$(row).click(function() {
			let jobName = data[1];

			editJob(allJobs[jobName])
		})
	},
} );

function fillJobs(jobs) {
	jobsDataTable.clear();

	for (const [_, job] of Object.entries(jobs)) {
		jobsDataTable.row.add( [job.label, job.name, Object.entries(job.ranks).length] );
	}

	jobsDataTable.draw();
}

/*
███╗░░░███╗░█████╗░██████╗░██╗░░██╗███████╗██████╗░░██████╗
████╗░████║██╔══██╗██╔══██╗██║░██╔╝██╔════╝██╔══██╗██╔════╝
██╔████╔██║███████║██████╔╝█████═╝░█████╗░░██████╔╝╚█████╗░
██║╚██╔╝██║██╔══██║██╔══██╗██╔═██╗░██╔══╝░░██╔══██╗░╚═══██╗
██║░╚═╝░██║██║░░██║██║░░██║██║░╚██╗███████╗██║░░██║██████╔╝
╚═╝░░░░░╚═╝╚═╝░░╚═╝╚═╝░░╚═╝╚═╝░░╚═╝╚══════╝╚═╝░░╚═╝╚═════╝░
*/
let allMarkers = {};

let jobMarkersDataTable = $("#job-markers-container").DataTable( {
	"lengthMenu": [10, 15, 20],
	"createdRow": function ( row, data, index ) {
		$(row).addClass("clickable");

		$(row).click(function() {
			let markerId = data[0];

			editMarker(markerId);
		})
	},
} );

let publicMarkersDataTable = $("#public-markers-container").DataTable( {
	"lengthMenu": [10, 15, 20],
	"createdRow": function ( row, data, index ) {
		$(row).addClass("clickable");

		$(row).click(function() {
			let markerId = data[0];

			editMarker(markerId);
		})
	},
} );

function fillJobMarkers(markerToEdit) {
	let jobName = $("#edit-job").data("jobName");

	$.post(`https://${resName}/retrieve-job-markers`, JSON.stringify({ jobName: jobName }), function (markers) {
		allMarkers = {};

		// Manually insert each marker to avoid wrong conversion between lua table first index (1) and javascript object first index (0)
		for(const[k, markerData] of Object.entries(markers)) {
			allMarkers[markerData.id] = markerData;
		}

		jobMarkersDataTable.clear();

		for(const[_, markerData] of Object.entries(markers)) {
			let typeLabel = MARKERS_INFOS[markerData.type].label;
			
			jobMarkersDataTable.row.add( [markerData.id, markerData.label, typeLabel, markerData.coords.x, markerData.coords.y, markerData.coords.z, markerData.minGrade] );
		}
	
		jobMarkersDataTable.draw();

		if(markerToEdit) {
			editMarker(markerToEdit);
		}
	})
}

function fillPublicMarkers(markerToEdit) {
	$.post(`https://${resName}/retrieve-job-markers`, JSON.stringify({ jobName: "public_marker" }), function (markers) {
		allMarkers = {};

		// Manually insert each marker to avoid wrong conversion between lua table first index (1) and javascript object first index (0)
		for(const[k, markerData] of Object.entries(markers)) {
			allMarkers[markerData.id] = markerData;
		}
		
		publicMarkersDataTable.clear();

		for(const[_, markerData] of Object.entries(markers)) {
			let typeLabel = MARKERS_INFOS[markerData.type].label;
			
			publicMarkersDataTable.row.add( [markerData.id, markerData.label, typeLabel, markerData.coords.x, markerData.coords.y, markerData.coords.z, markerData.minGrade] );
		}
	
		publicMarkersDataTable.draw();

		if(markerToEdit) {
			editMarker(markerToEdit);
		}
	})
}

async function createJobMarker(jobName) {
	let allowedMarkers = [];

	for(const[markerType, markerInfo] of Object.entries(MARKERS_INFOS)) {
		if(markerInfo.framework == undefined || markerInfo.framework == await getFramework()) {
			if(markerInfo.isJobMarker) {
				allowedMarkers.push({
					value: markerType,
					label: markerInfo.label
				})
			}
		}
	}

	inputDialog(getLocalizedText("menu:dynamic:job_markers:create_marker"), [
		{ id: "markerType", label: "Marker Type:", type: "select", options: allowedMarkers },
		{ id: "label", label: getLocalizedText("menu:dynamic:job_markers:label"), type: "text", default: getLocalizedText("menu:dynamic:default") },
		{ id: "markerCoordsX", label: getLocalizedText("menu:dynamic:job_markers:coord_x"), type: "number" },
		{ id: "markerCoordsY", label: getLocalizedText("menu:dynamic:job_markers:coord_y"), type: "number" },
		{ id: "markerCoordsZ", label: getLocalizedText("menu:dynamic:job_markers:coord_z"), type: "number" },
		{
			id: "currentCoordsBtn", label: getLocalizedText("menu:dynamic:job_markers:current_coords"), type: "button", buttonType: "btn-success",
			buttonCallback: function (modal) {
				$.post(`https://${resName}/get-current-coords`, {}, function (data) {
					var coords = data.coords;

					if (coords) {
						$(`#modal-markerCoordsX`).val(coords.x)
						$(`#modal-markerCoordsY`).val(coords.y)
						$(`#modal-markerCoordsZ`).val(coords.z)
					}
				})
			}
		},
		{ id: "markerMinGrade", label: getLocalizedText("menu:dynamic:job_markers:min_grade"), type: "number", default: 0 },
	], function (data) {
		data.jobName = jobName

		$.post(`https://${resName}/create-marker`, JSON.stringify(data), function (data) {
			if (data.isSuccessful) {
				fillJobMarkers(data.markerId);
			} else {
				showError(data.message)
			}
		});
	})
}
$("#create-job-marker-btn").click(function() {
	let jobName = $("#edit-job").data("jobName");

	createJobMarker(jobName);
})

async function createPublicMarker() {
	let allowedMarkers = [];

	for(const[markerType, markerInfo] of Object.entries(MARKERS_INFOS)) {
		if(markerInfo.framework == undefined || markerInfo.framework == await getFramework()) {
			if(markerInfo.isPublicMarker) {
				allowedMarkers.push({
					value: markerType,
					label: markerInfo.label
				})
			}
		}
	}

	inputDialog(getLocalizedText("menu:dynamic:public_markers:create_public_marker"), [
		{ id: "markerType", label: "Marker Type:", type: "select", options: allowedMarkers },
		{ id: "label", label: getLocalizedText("menu:dynamic:public_markers:label"), type: "text", default: getLocalizedText("menu:dynamic:default") },
		{ id: "markerCoordsX", label: getLocalizedText("menu:dynamic:public_markers:coord_x"), type: "number" },
		{ id: "markerCoordsY", label: getLocalizedText("menu:dynamic:public_markers:coord_y"), type: "number" },
		{ id: "markerCoordsZ", label: getLocalizedText("menu:dynamic:public_markers:coord_z"), type: "number" },
		{
			id: "currentCoordsBtn", label: getLocalizedText("menu:dynamic:public_markers:current_coords"), type: "button", buttonType: "btn-success",
			buttonCallback: function (modal) {
				$.post(`https://${resName}/get-current-coords`, {}, function (data) {
					var coords = data.coords;

					if (coords) {
						$(`#modal-markerCoordsX`).val(coords.x)
						$(`#modal-markerCoordsY`).val(coords.y)
						$(`#modal-markerCoordsZ`).val(coords.z)
					}
				})
			}
		},
	], function (data) {
		$.post(`https://${resName}/create-public-marker`, JSON.stringify(data), function (data) {
			if (data.isSuccessful) {
				fillPublicMarkers(data.markerId);
			} else {
				showError(data.message)
			}
		});
	})
}
$("#create-public-marker-btn").click(createPublicMarker);

function hideAllMarkerSettings() {
	$("#edit-marker-form").find(".edit-marker-settings").each(function() {
		$(this).find(".form-control").each(function(index, element) {
			if($(element).prop("required")) {
				$(element).prop("required", false);
				$(element).data("isActuallyRequired", true);
			}
		});

		$(this).hide();
	})
}

function showMarkerSettings(markerType) {
	hideAllMarkerSettings();

	$("#edit-marker-form").find(`.edit-marker-settings`).each(function() {
		if($(this).data("markerType") == markerType) {
			$(this).find(".form-control").each(function(index, element) {
				if( $(element).data("isActuallyRequired") ) {
					$(element).prop("required", true);
				}
			});

			$(this).show();

			return;
		}
	})
}

function editMarker(markerId) {
	$("#edit-marker-form").removeClass("was-validated");

	let markerData = allMarkers[markerId];

	if(!markerData) {
		console.log("Couldn't find marker " + markerId);
		
		console.log(`Existing markers for job '${ $("#edit-job").data("jobName") }': `)

		for(const[key, value] of Object.entries(allMarkers)) {
			console.log(`	Marker ID '${key}'`);
		}

		
		return
	}

	let isMarkerPublic = markerData.jobName == "public_marker";
	
	$("#edit-marker-form").data("isPublic", isMarkerPublic);

	$("#edit-marker-label").val(markerData.label);
	$("#edit-marker-type").val(markerData.markerType);

	changeMarkerGradeType(markerData.gradesType);

	if(markerData.gradesType === "specificGrades") {
		setSpecificGrades(markerData.specificGrades);
	} else if(markerData.gradesType === "minimumGrade") {
		$("#edit-marker-min-grade").val(markerData.minGrade);
	}

	$("#edit-marker-scale-x").val(markerData.scale.x);
	$("#edit-marker-scale-y").val(markerData.scale.y);
	$("#edit-marker-scale-z").val(markerData.scale.z);
	
	$("#edit-marker-coord-x").val(markerData.coords.x);
	$("#edit-marker-coord-y").val(markerData.coords.y);
	$("#edit-marker-coord-z").val(markerData.coords.z);
	
	$("#edit-marker-color").val(rgbToHex(markerData.color.r, markerData.color.g, markerData.color.b));
	$("#edit-marker-alpha").val(markerData.color.alpha);
	
	// Map blip
	$("#edit-marker-sprite-id").val(markerData.blip?.spriteId);
	$("#edit-marker-blip-color").val(markerData.blip?.color);
	$("#edit-marker-blip-scale").val(markerData.blip?.scale);
	toggleBlipInputs(markerData.blip?.spriteId ? true : false);

	// NPC
	$("#edit-marker-npc-model").val(markerData.ped?.model);
	$("#edit-marker-npc-heading").val(markerData.ped?.heading);
	toggleNpcInputs(markerData.ped?.model ? true : false);
	
	// Object
	$("#edit-marker-object-model").val(markerData.object?.model);
	$("#edit-marker-object-rotation-pitch").val(markerData.object?.pitch);
	$("#edit-marker-object-rotation-roll").val(markerData.object?.roll);
	$("#edit-marker-object-rotation-yaw").val(markerData.object?.yaw);
	toggleObjectInputs(markerData.object?.model ? true : false);

	// Minimum grade / specific grade inputs
	$("#edit-marker-min-grade").prop("disabled", isMarkerPublic);
	$("input[name=markerGradeType]").prop("disabled", isMarkerPublic);
	$("#edit-marker-min-grade").val(markerData.minGrade || 0);

	let settingsLabel = MARKERS_INFOS[markerData.type].settingsName;

	if(settingsLabel) {
		$("#specific-marker-settings").show();
		$("#specific-marker-settings-label").text(settingsLabel);
		
		showMarkerSettings(markerData.type);
	} else {
		$("#specific-marker-settings").hide();
		hideAllMarkerSettings();
	}

	setCurrentMarkerData(markerData.type, markerData.data);

	let editMarkerModal = $("#edit-marker-dialog-modal");

	editMarkerModal.modal("show");
	editMarkerModal.data("markerId", markerId);
}

function changeMarkerGradeType(type) {
	$(`input[type=radio][name="markerGradeType"][value="${type}"]`).prop("checked", true);

	switch(type) {
		case "minimumGrade": {
			$("#edit-marker-min-grade").prop("required", true);

			$("#edit-marker-min-grade-form").show();
			$("#edit-marker-specific-grades-form").hide();
			break;
		}

		case "specificGrades": {
			$("#edit-marker-min-grade").prop("required", false);

			$("#edit-marker-min-grade-form").hide();
			$("#edit-marker-specific-grades-form").show();
			break;
		}
	}
}

$("input[type=radio][name=markerGradeType").change(function() {
	let gradesType = $(this).val();

	changeMarkerGradeType(gradesType);
})

function addVehicleToTemporaryGarage(vehicleModel, vehicleData) {
	vehicleData = vehicleData || {}

	let vehiclesTable = $("#garage-data-model-tbody")
	
	let vehiclePrimaryColor = vehicleData.primaryColor || "#111111"
	let vehicleSecondaryColor = vehicleData.secondaryColor || "#111111"

	let customPlate = vehicleData.plate || "";

	let deleteVehicleBtn = $(`<button class="btn btn-outline-danger" type="button">${getLocalizedText("menu:dynamic:marker:temporary_garage:delete")}</button>`)

	let vehicleTableRow = $(`
		<tr class="vehicle">
			<th scope="row">
				<p class="text-center vehicle-model">${vehicleModel}</p>
			</th>
			<td>
				<p class="text-center vehicle-label">${vehicleModel}</p>
			</td>
			<td>
				<input type="color" class="form-control form-control-color vehicle-primary-color" value="${vehiclePrimaryColor}" title="Primary Color">
			</td>
			<td>
				<input type="color" class="form-control form-control-color vehicle-secondary-color" value="${vehicleSecondaryColor}" title="Secondary Color">
			</td>
			<td>
				<input type="text" class="form-control vehicle-custom-plate" value="${customPlate}" placeholder="${getLocalizedText("menu:dynamic:marker:temporary_garage:random_plate")}" title="Custom plate">
			</td>
			<td class="delete-vehicle-btn"/>
		</tr>
	`)

	getVehicleLabel(vehicleModel, (vehicleLabel) => {
		vehicleTableRow.find(".vehicle-label").text(vehicleLabel)
	})

	vehiclesTable.append(vehicleTableRow);

	vehicleTableRow.find(".delete-vehicle-btn").append(deleteVehicleBtn)

	$(deleteVehicleBtn).click(function () {
		$(this).parents(".vehicle").remove();
	});
}

$("#garage-owned-current-coords").click(function() {
	$.post(`https://${resName}/get-current-coords`, {}, function (data) {
		var coords = data.coords;
		var heading = data.heading;

		if (coords) {
			$("#garage-owned-spawnpoint-x").val(coords.x)
			$("#garage-owned-spawnpoint-y").val(coords.y)
			$("#garage-owned-spawnpoint-z").val(coords.z)
		}

		if (heading) {
			$("#garage-owned-heading").val(heading)
		}
	})
});

function toggleBlipInputs(isEnabled) {
	$("#edit-marker-map-blip").prop("checked", isEnabled);

	$("#edit-marker-map-blip-inputs").find(".form-control").each(function() {
		$(this).prop("disabled", !isEnabled);
		$(this).prop("required", isEnabled);
	})
}

function toggleNpcInputs(isEnabled) {
	$("#edit-marker-npc").prop("checked", isEnabled);

	$("#edit-marker-npc-inputs").find(".form-control").each(function() {
		$(this).prop("disabled", !isEnabled);
		$(this).prop("required", isEnabled);
		$("#edit-marker-npc-current-heading-btn").prop("disabled", !isEnabled);
	})
}

function toggleObjectInputs(isEnabled) {
	$("#edit-marker-object").prop("checked", isEnabled);

	$("#edit-marker-object-inputs").find(".form-control").each(function() {
		$(this).prop("disabled", !isEnabled);
		$(this).prop("required", isEnabled);
	})
}

// Boss marker settings
function toggleBossWashMoneyOptions(isEnabled) {
	$("#boss-data-washmoney-percentage").prop("required", isEnabled);
	$("#boss-data-washmoney-percentage").prop("disabled", !isEnabled);
	$("#boss-data-washmoney-to-society-account").prop("disabled", !isEnabled);
}

$("#boss-data-washmoney").change(function() {
	toggleBossWashMoneyOptions( $(this).prop("checked") );
})


// Harvestable items settings
function toggleRequiresTool(isEnabled) {
	$("#harvest-item-requires-tool").prop("checked", isEnabled);
		
	$("#harvest-item-tool").prop("required", isEnabled);
	$("#harvest-item-tool").prop("disabled", !isEnabled);

	$("#harvest-item-tool-lose-on-use").prop("disabled", !isEnabled);

	if(!isEnabled) {
		toggleLoseToolOnUse(false);
	}
}

function toggleLoseToolOnUse(isEnabled) {
	$("#harvest-item-tool-lose-on-use").prop("checked", isEnabled);

	$("#harvest-item-tool-lose-quantity").prop("required", isEnabled);
	$("#harvest-item-tool-lose-quantity").prop("disabled", !isEnabled);

	$("#harvest-item-tool-lose-probability").prop("required", isEnabled);
	$("#harvest-item-tool-lose-probability").prop("disabled", !isEnabled);
}

function toggleDisappearsAfterUse(isEnabled) {
	$("#harvest-disappear-after-use").prop("checked", isEnabled);

	$("#harvest-disappear-seconds").prop("required", isEnabled);
	$("#harvest-disappear-seconds").prop("disabled", !isEnabled);
}

$("#harvest-requires-minimum-account-money").change(function() {
	let isEnabled = $(this).prop("checked");

	$("#harvest-minimum-account-name-div").find("input, button").prop("disabled", !isEnabled);
	$("#harvest-minimum-account-name-div").find("input, button").prop("required", isEnabled);
});

// Marker generic settings
$("#edit-marker-map-blip").change(function(){
	let isEnabled = $(this).prop("checked");

	toggleBlipInputs(isEnabled);
})

$("#edit-marker-npc").change(function(){
	let isEnabled = $(this).prop("checked");

	toggleNpcInputs(isEnabled);
})

$("#edit-marker-object").change(function(){
	let isEnabled = $(this).prop("checked");

	toggleObjectInputs(isEnabled);
})

$("#edit-marker-current-coords-btn").click(function(){
	$.post(`https://${resName}/get-current-coords`, {}, function (data) {
		let coords = data.coords;

		if (coords) {
			$(`#edit-marker-coord-x`).val(coords.x)
			$(`#edit-marker-coord-y`).val(coords.y)
			$(`#edit-marker-coord-z`).val(coords.z)
		}
	})
})

$("#delete-marker-btn").click(function(){
	let editMarkerModal = $("#edit-marker-dialog-modal");
	let markerId = editMarkerModal.data("markerId");

	editMarkerModal.modal("hide");

	if(markerId) {
		deleteDialog("Delete marker", "Are you sure you want to delete this marker?", function () {
			$.post(`https://${resName}/delete-marker`, JSON.stringify({ markerId: markerId }), function (data) {
				if (data.isSuccessful) {

					if( $("#edit-marker-form").data("isPublic") ) {
						fillPublicMarkers();
					} else {
						fillJobMarkers();
					}
					
				} else {
					showError(data.message);
				}
			})
		})
	}
})

function setCurrentMarkerData(markerType, markerData) {
	// Resets animations from old opened marker
	$("#edit-marker-dialog-modal").data("animations", []);
	
	markerData = markerData || {};
	
	switch(markerType) {
		case "garage": {
			let coords = markerData.spawnCoords

			if (coords) {
				$("#marker-temporary-garage-spawnpoint-x").val(coords.x)
				$("#marker-temporary-garage-spawnpoint-y").val(coords.y)
				$("#marker-temporary-garage-spawnpoint-z").val(coords.z)
			}

			if (markerData.heading) {
				$("#marker-temporary-garage-heading").val(markerData.heading)
			}

			$("#garage-data-model-tbody").empty();

			if (markerData.vehicles) {
				for (const [vehicleModel, vehicleData] of Object.entries(markerData.vehicles)) {
					addVehicleToTemporaryGarage(vehicleModel, vehicleData)
				}
			}

			break;
		}

		case "garage_buyable": {
			if(markerData.spawnCoords) {
				$("#garage-buyable-spawnpoint-x").val(markerData.spawnCoords.x);
				$("#garage-buyable-spawnpoint-y").val(markerData.spawnCoords.y);
				$("#garage-buyable-spawnpoint-z").val(markerData.spawnCoords.z);
			}
			
			$("#garage-buyable-heading").val(markerData.heading);

			$("#garage-buyable-vehicles").empty();

			if(markerData.vehicles) {
				for (const [vehicleName, price] of Object.entries(markerData.vehicles)) {
					var vehicleInputGroup = $(`<div class="input-group mt-1 vehicle"></div>`)

					var vehicleInput = $(`<input type="text" class="form-control vehicle-model" placeholder="Vehicle model" disabled value="${vehicleName}">`);
					var moneySpan = $(`<span class="input-group-text">$</span>`)
					var vehiclePrice = $(`<input type="text" class="form-control vehicle-price" placeholder="Vehicle price" disabled value="${price}">`);
					var deleteVehicle = $(`<button class="btn btn-outline-danger" type="button">Delete</button>`);

					vehicleInputGroup.append(vehicleInput, moneySpan, vehiclePrice, deleteVehicle);

					$(deleteVehicle).click(function () {
						$(this).parent().remove();
					})

					$("#garage-buyable-vehicles").append(vehicleInputGroup)
				}
			}
			
			$("#garage-buyable-vehicle-model").val("");
			$("#garage-buyable-vehicle-price").val("");
			
			break;
		}

		case "garage_owned": {
			if(markerData.spawnCoords) {
				$("#garage-owned-spawnpoint-x").val(markerData.spawnCoords.x);
				$("#garage-owned-spawnpoint-y").val(markerData.spawnCoords.y);
				$("#garage-owned-spawnpoint-z").val(markerData.spawnCoords.z);
			}

			$("#garage-owned-heading").val(markerData.heading);

			break;
		}
		
		case "boss": {
			let canWashMoney = markerData.canWashMoney;
			let canWithdraw = markerData.canWithdraw;
			let canDeposit = markerData.canDeposit;
			let canEmployees = markerData.canEmployees;
			let canGrades = markerData.canGrades;

			toggleBossWashMoneyOptions(canWashMoney);

			if(canWashMoney) {
				$("#boss-data-washmoney-percentage").val(markerData.washMoneyReturnPercentage);
				$("#boss-data-washmoney-to-society-account").prop("checked", markerData.washMoneyGoesToSocietyAccount);
			}

			$("#boss-data-washmoney").prop('checked', canWashMoney);
			$("#boss-data-withdraw").prop('checked', canWithdraw);
			$("#boss-data-deposit").prop('checked', canDeposit);
			$("#boss-data-employees").prop('checked', canEmployees);
			$("#boss-data-grades").prop('checked', canGrades);
			
			$("#boss-data-max-salary").val(markerData.maxSalary);

			break;
		}

		case "shop": {
			$("#shop-data-item-id").val("")
			$("#shop-data-item-price").val("")

			$('#shop-data-items-container').empty();

			if (markerData.itemsOnSale) {
				for (const [itemName, itemData] of Object.entries(markerData.itemsOnSale)) {
					addItemToShop(itemName, itemData)
				}
			}
			
			break;
		}

		case "market": {
			$("#market-modal-items-tbody").empty();

			if(markerData.items) {
				for (const [itemName, itemData] of Object.entries(markerData.items)) {
					addItemToMarket(itemName, itemData.minPrice, itemData.maxPrice, itemData.blackMoney, itemData.sellTime);
				}
			}

			$("#market-modal-society-percentage").val(markerData.percentageForSociety);

			break;
		}

		case "crafting_table": {
			let craftablesDiv = $("#craftables");

			craftablesDiv.empty();

			if(markerData.craftablesItems) {
				for (const [resultItemName, craftingData] of Object.entries(markerData.craftablesItems)) {
					addNewCraftableToCraftables(resultItemName, craftingData)
				}
			}
			
			break;
		}

		case "armory": {
			$("#armory-is-shared").prop("checked", markerData.isShared);
			$("#armory-refill-on-take").prop("checked", markerData.refillOnTake);

			break;
		}

		case "job_outfit": {
			$("#job-outfit-outfits").empty();

			if(markerData.outfits) {
				(markerData.outfits).forEach(outfit => {
					createNewOutfit(outfit)
				})	
			}

			break;
		}

		case "teleport": {
			if(markerData.teleportCoords) {
				$("#teleport-x").val(markerData.teleportCoords.x);
				$("#teleport-y").val(markerData.teleportCoords.y);
				$("#teleport-z").val(markerData.teleportCoords.z);
			}
			
			break;
		}

		case "harvest": {
			$("#harvest-modal-items").empty();
			
			if(markerData.harvestableItems) {
				markerData.harvestableItems.forEach(item => {
					addItemToHarvestable(item.name, item.minQuantity, item.maxQuantity, item.time, item.chances);
				});
			}
			
			if(markerData.animations) {
				$("#edit-marker-dialog-modal").data("animations", markerData.animations)
			}

			toggleRequiresTool(markerData.itemTool);
			$("#harvest-item-tool").val(markerData.itemTool);

			toggleLoseToolOnUse(markerData.itemToolLoseQuantity);
			$("#harvest-item-tool-lose-quantity").val(markerData.itemToolLoseQuantity);
			$("#harvest-item-tool-lose-probability").val(markerData.itemToolLoseProbability);
			
			toggleDisappearsAfterUse(markerData.disappearAfterUse);
			$("#harvest-disappear-seconds").val(markerData.disappearSeconds);

			$("#harvest-requires-minimum-account-money").prop("checked", markerData.requiresMinimumAccountMoney || false).change();
			$("#harvest-minimum-account-name").val(markerData.minimumAccountName);
			$("#harvest-minimum-account-amount").val(markerData.minimumAccountAmount);

			break;
		}

		case "process": {

			if(markerData.itemToRemoveName)
				$("#item-to-remove-name").val(markerData.itemToRemoveName)

			if(markerData.itemToRemoveQuantity) 
				$("#item-to-remove-quantity").val(markerData.itemToRemoveQuantity)

			if(markerData.itemToAddName)
				$("#item-to-add-name").val(markerData.itemToAddName)

			if(markerData.itemToAddQuantity)
				$("#item-to-add-quantity").val(markerData.itemToAddQuantity)

			if(markerData.timeToProcess)
				$("#process-time").val(markerData.timeToProcess)

			if(markerData.animations)
				$("#edit-marker-dialog-modal").data("animations", markerData.animations)

			$("#process-requires-minimum-account-money").prop("checked", markerData.requiresMinimumAccountMoney || false).change();
			$("#process-minimum-account-name").val(markerData.minimumAccountName);
			$("#process-minimum-account-amount").val(markerData.minimumAccountAmount);

			break;
		}

		case "weapon_upgrader": {
			if(markerData.componentsPrices) {
				// set empty all, so disabled components will remain disabled
				$("#weapon-upgrader-components").find(".form-control").each(function() {
					$(this).val("");
				})
				
				for(const [componentName, componentPrice] of Object.entries(markerData.componentsPrices)) {
					$("#weapon-upgrader-components").find(`[data-componentname=${componentName}]`).val(componentPrice);
				}
			}

			if(markerData.tintsPrices) {
				// set empty all, so disabled tints will remain disabled
				$("#weapon-upgrader-tints").find(".form-control").each(function() {
					$(this).val("");
				})

				for(const [tintId, tintPrice] of Object.entries(markerData.tintsPrices)) {
					$("#weapon-upgrader-tints").find(`[data-tintid=${tintId}]`).val(tintPrice);
				}
			}
			
			break;
		}

		case "job_shop": {
			let allJobsSelect = $("#job-shop-all-jobs");
			
			allJobsSelect.find(".job-shop-job").remove();

			$.post(`https://${resName}/getJobsData`, JSON.stringify({}), function (jobs) {
				let jobsRanks = {}

				for(const [_, jobData] of Object.entries(jobs)) {
					if(jobData.name) {
						let jobDiv = $(`<option class="job-shop-job" value="${jobData.name}">${jobData.label}</option>`);
	
						jobsRanks[jobData.name] = jobData.ranks
						allJobsSelect.append(jobDiv);
					}
				}

				allJobsSelect.data("ranks", jobsRanks);
			}), "json";
			
			break;
		}
	}
}

function getCurrentMarkerData(markerType) {
	let markerData = {};

	switch(markerType) {
		case "garage": {
			let coords = {
				x: parseFloat( $("#marker-temporary-garage-spawnpoint-x").val() ),
				y: parseFloat( $("#marker-temporary-garage-spawnpoint-y").val() ),
				z: parseFloat( $("#marker-temporary-garage-spawnpoint-z").val() )
			};
		
			let heading = parseFloat( $("#marker-temporary-garage-heading").val() );
		
			let vehicles = {};
			
			let vehiclesObject = $("#garage-data-model-tbody").children(".vehicle");
		
			vehiclesObject.each(function (index, element) {
				let vehicleModel = $(element).find(".vehicle-model").text();
				let vehiclePrimaryColor = $(element).find(".vehicle-primary-color").val();
				let vehicleSecondaryColor = $(element).find(".vehicle-secondary-color").val();
				let vehiclePlate = $(element).find(".vehicle-custom-plate").val();
		
				vehicles[vehicleModel] = {
					primaryColor: vehiclePrimaryColor,
					secondaryColor: vehicleSecondaryColor,
					plate: vehiclePlate || null
				}
			})
			
			markerData = {
				vehicles: vehicles,
				spawnCoords: coords,
				heading: heading
			}

			break;
		}

		case "garage_buyable": {
			let coords = {
				x: parseFloat( $("#garage-buyable-spawnpoint-x").val() ),
				y: parseFloat( $("#garage-buyable-spawnpoint-y").val() ),
				z: parseFloat( $("#garage-buyable-spawnpoint-z").val() )
			};

			let heading = parseFloat( $("#garage-buyable-heading").val() );
		
			let vehicles = {};
			let vehiclesObject = $("#garage-buyable-vehicles").find(".vehicle");
	
			vehiclesObject.each(function (index, element) {
				let model = $(element).find(".vehicle-model").val();
				let price = parseInt( $(element).find(".vehicle-price").val() );
	
				vehicles[model] = price;
			});

			markerData = {
				spawnCoords: coords,
				heading: heading,
				vehicles: vehicles
			}

			break;
		}

		case "garage_owned": {
			markerData = {
				spawnCoords: {
					x: parseFloat( $("#garage-owned-spawnpoint-x").val() ),
					y: parseFloat( $("#garage-owned-spawnpoint-y").val() ),
					z: parseFloat( $("#garage-owned-spawnpoint-z").val() ),
				},
		
				heading: parseFloat( $("#garage-owned-heading").val() )
			}

			break;
		}

		case "boss": {
			let canWashMoney = $("#boss-data-washmoney").prop('checked')
			let canWithdraw = $("#boss-data-withdraw").prop('checked')
			let canDeposit = $("#boss-data-deposit").prop('checked')
			let canEmployees = $("#boss-data-employees").prop('checked')
			let canGrades = $("#boss-data-grades").prop('checked')
		
			if(canWashMoney) {
				var washMoneyReturnPercentage = parseInt($("#boss-data-washmoney-percentage").val());
				var washMoneyGoesToSocietyAccount = $("#boss-data-washmoney-to-society-account").prop("checked");
			}
		
			markerData = {
				canWashMoney: canWashMoney,
				washMoneyReturnPercentage: washMoneyReturnPercentage,
				washMoneyGoesToSocietyAccount: washMoneyGoesToSocietyAccount,
				canWithdraw: canWithdraw,
				canDeposit: canDeposit,
				canEmployees: canEmployees,
				canGrades: canGrades,
				maxSalary: parseInt( $("#boss-data-max-salary").val() ),
			}

			break;
		}

		case "shop": {
			let itemsOnSale = {};

			let itemsContainer = $("#shop-data-items-container")
		
			itemsContainer.children().each(function (index, element) {
				let itemName = $(element).data("item-name");
				let itemPrice = $(element).data("item-price");
				let blackMoney = $(element).find(".item-blackmoney").prop("checked");
	
				if (itemName && itemPrice) {
					itemsOnSale[itemName] = {
						price: itemPrice,
						blackMoney: blackMoney
					};
				}
			})

			markerData = {
				itemsOnSale: itemsOnSale
			}
			
			break;
		}

		case "market": {
			let items = {}

			let marketBodyDiv = $("#market-modal-items-tbody")

			let itemsDivs = marketBodyDiv.children(".item")

			itemsDivs.each(function(index, element) {
				let itemDiv = $(element)

				let itemName = itemDiv.find(".item-name").text();
				let itemMinPrice = parseInt(itemDiv.find(".item-min-price").text());
				let itemMaxPrice = parseInt(itemDiv.find(".item-max-price").text());
				let blackMoney = itemDiv.find(".item-blackmoney").prop("checked")
				let sellTime = parseInt(itemDiv.find(".item-selltime").val());

				items[itemName] = {
					minPrice: itemMinPrice,
					maxPrice: itemMaxPrice,
					blackMoney: blackMoney,
					sellTime: sellTime
				}
			});

			markerData = { 
				items: items,
				percentageForSociety: parseInt( $("#market-modal-society-percentage").val() )
			}

			break;
		}

		case "crafting_table": {
			let craftablesItems = {};
		
			let craftables = $("#craftables").children();
		
			craftables.each(function(craftableIndex, craftableElement) {
				let craftable = $(craftableElement);
		
				let resultItemName = craftable.find('.result-item').val();
				let resultItemQuantity = parseInt( craftable.find('.result-item-quantity').val() );
				let resultItemCraftingTime = parseInt( craftable.find('.result-item-crafting-time').val() );
		
				craftablesItems[resultItemName] = {
					recipes: {},
					animations: craftable.data("animations"),
					quantity: resultItemQuantity || 1,
					craftingTime: resultItemCraftingTime || 8
				}
		
				let ingredientsItemsDiv = craftable.find('.craft-ingredients').children();
		
				ingredientsItemsDiv.each(function(ingredientIndex, ingredientElement){
					var ingredientDiv = $(ingredientElement)
		
					var ingredientName = ingredientDiv.data("item-name");
					var ingredientQuantity = ingredientDiv.data("item-quantity");
					var loseOnUse = ingredientDiv.find(".lose-on-use-checkbox").prop("checked")
					
					craftablesItems[resultItemName].recipes[ingredientName] = {
						quantity: ingredientQuantity,
						loseOnUse: loseOnUse
					}
				})
			})
		
			markerData = {
				craftablesItems: craftablesItems
			}
		
			break;
		}

		case "armory": {
			markerData = {
				isShared: $("#armory-is-shared").prop("checked"),
				refillOnTake: $("#armory-refill-on-take").prop("checked")
			}

			break;
		}

		case "job_outfit": {
			let jobOutfitsDiv = $("#job-outfit-outfits");
			let outfitsDiv = jobOutfitsDiv.children();
		
			let outfits = [];

			outfitsDiv.each(function(index, outfitDivRaw){
				let outfitDiv = $(outfitDivRaw);
	
				let outfit = getOutfitFromOutfitDiv(outfitDiv);
	
				outfits.push(outfit);
			})
	
			markerData = {
				outfits: outfits
			}

			break;
		}

		case "teleport": {
			markerData = {
				teleportCoords: {
					x: parseFloat( $(`#teleport-x`).val() ),
					y: parseFloat( $(`#teleport-y`).val() ),
					z: parseFloat( $(`#teleport-z`).val() ),
				}
			}

			break;
		}

		case "harvest": {
			let harvestableItems = [];

			$("#harvest-modal-items").find(".harvestable-item").each(function(index, element) {
				let harvestableItem = {
					name: $(this).find(".harvest-item-name").val(),
					minQuantity: parseInt( $(this).find(".harvest-item-min-quantity").val() ),
					maxQuantity: parseInt( $(this).find(".harvest-item-max-quantity").val() ),
					time: parseInt( $(this).find(".harvest-item-time").val() ),
					chances: parseInt( $(this).find(".harvest-item-chance").val()),
				};

				harvestableItems.push(harvestableItem);
			})

			if($("#harvest-item-requires-tool").prop("checked")) {
				var itemTool = $("#harvest-item-tool").val();
			}

			if($("#harvest-item-tool-lose-on-use").prop("checked")) {
				var itemToolLoseQuantity = parseInt($("#harvest-item-tool-lose-quantity").val());
				var itemToolLoseProbability = parseInt( $("#harvest-item-tool-lose-probability").val() );
			}

			markerData = {
				harvestableItems: harvestableItems,
				animations: $("#edit-marker-dialog-modal").data("animations"),

				itemTool: itemTool,
				itemToolLoseQuantity: itemToolLoseQuantity,
				itemToolLoseProbability: itemToolLoseProbability,

				disappearAfterUse: $("#harvest-disappear-after-use").prop("checked"),
				disappearSeconds: parseInt( $("#harvest-disappear-seconds").val() ),

				requiresMinimumAccountMoney: $("#harvest-requires-minimum-account-money").prop("checked"),
				minimumAccountName: $("#harvest-minimum-account-name").val(),
				minimumAccountAmount: parseInt( $("#harvest-minimum-account-amount").val() ),
			}

			break;
		}

		case "process": {
			markerData = {
				itemToRemoveName: $("#item-to-remove-name").val(),
				itemToRemoveQuantity: parseInt($("#item-to-remove-quantity").val()),
				itemToAddName: $("#item-to-add-name").val(),
				itemToAddQuantity: parseInt($("#item-to-add-quantity").val()),
				timeToProcess: parseInt($("#process-time").val()),
				animations: $("#edit-marker-dialog-modal").data("animations"),

				requiresMinimumAccountMoney: $("#process-requires-minimum-account-money").prop("checked"),
				minimumAccountName: $("#process-minimum-account-name").val(),
				minimumAccountAmount: parseInt( $("#process-minimum-account-amount").val() )
			}

			break;
		}

		case "weapon_upgrader": {
			let weaponsComponentsDiv = $("#weapon-upgrader-components");
			let weaponsTintsDiv = $("#weapon-upgrader-tints");
			
			let componentsPrices = {};
			let tintsPrices = {};

			weaponsComponentsDiv.find(".form-control").each(function(index, element) {
				let componentDiv = $(element)

				let componentName = componentDiv.data("componentname")
				let componentPrice = componentDiv.val()

				if(componentPrice) {
					componentsPrices[componentName] = componentPrice
				}
			})

			weaponsTintsDiv.find(".form-control").each(function(index, element) {
				let tintDiv = $(element)

				let tintId = parseInt(tintDiv.data("tintid"))
				let tintPrice = parseInt(tintDiv.val())

				if(tintPrice) {
					tintsPrices[tintId] = tintPrice
				}
			})

			markerData = {
				componentsPrices: componentsPrices,
				tintsPrices: tintsPrices
			}
			
			break;
		}

		case "job_shop": {
			let jobName = $("#job-shop-all-jobs").val();

			if(!jobName) return;

			let rankGrade = parseInt($("#job-shop-all-ranks").val());
			
			if(jobName && !isNaN(rankGrade)) {
				markerData = {
					allowedJob: jobName,
					minimumRank: rankGrade
				}
			}
			
			break;
		}
	}

	return markerData;
}

$("#edit-marker-form").submit(function(event){
	if (!this.checkValidity()) {
		event.stopPropagation();
		event.preventDefault();
		return;
	}

	let editMarkerModal = $("#edit-marker-dialog-modal");
	let markerId = editMarkerModal.data("markerId");

	let isPublicMarker = $("#edit-marker-form").data("isPublic");

	let enableMarkerBlip = $("#edit-marker-map-blip").prop("checked");

	if(enableMarkerBlip) {
		var blipSpriteId = 	parseInt( $("#edit-marker-sprite-id").val() );
		var blipColor = 	parseInt( $("#edit-marker-blip-color").val() );
		var blipScale = 	parseFloat( $("#edit-marker-blip-scale").val() );
	}

	let color = hexToRgb( $("#edit-marker-color").val() );

	let enableNPC = $("#edit-marker-npc").prop("checked");

	if(enableNPC) {
		var npcModel = $("#edit-marker-npc-model").val();
		var npcHeading = parseFloat( $("#edit-marker-npc-heading").val() );
	}

	let enableObject = $("#edit-marker-object").prop("checked");

	if(enableObject) {
		var objectModel = $("#edit-marker-object-model").val();
		var objectPitch = $("#edit-marker-object-rotation-pitch").val();
		var objectRoll = $("#edit-marker-object-rotation-roll").val();
		var objectYaw = $("#edit-marker-object-rotation-yaw").val();
	}

	let gradesType = $("input[type=radio][name=markerGradeType]:checked").val();

	if(gradesType === "minimumGrade") {
		var minGrade = parseInt( $("#edit-marker-min-grade").val() );
	} else if(gradesType === "specificGrades") {
		var specificGrades = $("#edit-marker-specific-grades").data("grades") || {};
	}

	let data = {
		markerId: markerId,

		label: $("#edit-marker-label").val(),

		gradesType: gradesType,

		minGrade: minGrade,
		specificGrades: specificGrades,

		coords: {
			x: parseFloat( $("#edit-marker-coord-x").val() ),
			y: parseFloat( $("#edit-marker-coord-y").val() ),
			z: parseFloat( $("#edit-marker-coord-z").val() ),
		},

		blip: {
			spriteId: blipSpriteId,
			color: blipColor,
			scale: blipScale,
		},
		
		markerType: parseInt( $("#edit-marker-type").val() ),

		scale: {
			x: parseFloat( $("#edit-marker-scale-x").val() ),
			y: parseFloat( $("#edit-marker-scale-y").val() ),
			z: parseFloat( $("#edit-marker-scale-z").val() )
		},
		
		color: {
			r: color.r,
			g: color.g,
			b: color.b,
			alpha: parseInt( $("#edit-marker-alpha").val() )
		},

		ped: {
			model: npcModel,
			heading: npcHeading
		},

		object: {
			model: objectModel,
			pitch: objectPitch,
			roll: objectRoll,
			yaw: objectYaw
		}
	}

	let markerData = getCurrentMarkerData(allMarkers[markerId].type);

	$.post(`https://${resName}/update-marker`, JSON.stringify(data), function (data) {
		if (data.isSuccessful) {

			let markerType = allMarkers[markerId].type

			if(MARKERS_INFOS[markerType].requiresDataUpdate) {
				$.post(`https://${resName}/update-marker-data`, JSON.stringify({ markerId: markerId, markerData: markerData }), function (data) {
					if (data.isSuccessful) {
						editMarkerModal.modal("hide");
					} else {
						showError(data.message)
					}
	
					if(isPublicMarker) {
						fillPublicMarkers();
					} else {
						fillJobMarkers();
					}
				});
			} else {
				editMarkerModal.modal("hide");

				if(isPublicMarker) {
					fillPublicMarkers();
				} else {
					fillJobMarkers();
				}
			}
		} else {
			showError(data.message)
		}
	})
})

function gradesDialog(enabledGrades) {
	return new Promise(resolve => {
		let gradesModal = $("#input-grades-dialog-modal")
		let gradesList = $("#grades-list");
		gradesList.empty();
	
		let jobName = $("#edit-job").data("jobName");
	
		$.post(`https://${resName}/getJobGrades`, JSON.stringify({jobName: jobName}), function(jobGrades) {
			for( const[_, gradeData] of Object.entries(jobGrades) ) {
				let gradeDiv = $(`
					<div class="form-check fs-3">
						<input class="form-check-input grade" type="checkbox" value="${gradeData.grade}" ${enabledGrades[gradeData.grade] && "checked" || null}>
						<label class="form-check-label">
							${gradeData.grade} - ${gradeData.label}
						</label>
					</div>
				`);
	
				gradesList.append(gradeDiv);
			}
	
			gradesModal.modal("show");
		})

		
	
		let confirmButton = $("#input-grades-dialog-confirm");
		
		confirmButton.unbind("click");
		confirmButton.click(function() {
			let grades = {};
			$(".grade:checked").each(function() {
				grades[ parseInt($(this).val()) ] = true;
			})
	
			gradesModal.modal("hide");
	
			resolve(grades);		
		})
	});
}

function setSpecificGrades(grades) {
	let specificGradesDiv = $("#edit-marker-specific-grades");
	
	specificGradesDiv.data("grades", grades);
	specificGradesDiv.val( Object.keys(grades).join(","));
}

$("#edit-marker-specific-grades-choose-btn").click(async function() {
	let enabledGrades = $("#edit-marker-specific-grades").data("grades") || {};

	let grades = await gradesDialog(enabledGrades);

	setSpecificGrades(grades);
})

$("#edit-marker-npc-current-heading-btn").click(function(){
	$.post(`https://${resName}/get-current-coords`, {}, function (data) {
		let heading = data.heading;

		if (heading) {
			$(`#edit-marker-npc-heading`).val(heading);
		}
	})
})

$("#marker-data-add-vehicle").click(function () {
	var modelDiv = $("#marker-data-vehicle-model");
	var model = modelDiv.val();

	// Clears input
	modelDiv.val("");

	if (model) {
		modelDiv.removeClass("is-invalid");

		addVehicleToTemporaryGarage(model)
	} else {
		modelDiv.addClass("is-invalid");
	}
})

$("#markers-data-current-coords").hover(function(){
	$("#markers-data-current-coords").tooltip("show")
}, function(){
	$("#markers-data-current-coords").tooltip("hide")
})

$("#markers-data-current-coords").click(function () {
	$.post(`https://${resName}/get-current-coords`, {}, function (data) {
		var coords = data.coords;
		var heading = data.heading;

		if (coords) {
			$("#marker-temporary-garage-spawnpoint-x").val(coords.x)
			$("#marker-temporary-garage-spawnpoint-y").val(coords.y)
			$("#marker-temporary-garage-spawnpoint-z").val(coords.z)
		}

		if (heading) {
			$("#marker-temporary-garage-heading").val(heading)
		}
	})
})

function addItemToShop(itemName, itemData) {
	var newItem = $(`
		<tr class="border">
			<td class="col">
				<p class="text-center">${itemName}</p>
			</td>
			
			<td class="col">
				<p class="text-center">$${itemData.price}</p>
			</td>

			<td class="col">
				<div class="form-check form-switch col-md-4 offset-md-4">
					<input class="form-check-input item-blackmoney" type="checkbox"}>
				</div>
			</td>
			
			<td class="col">
				<button type="button" class="btn btn-outline-danger col-12">Remove</button>
			</td>
		</tr>
	`)

	newItem.data("item-name", itemName);
	newItem.data("item-price", parseInt(itemData.price));

	newItem.find(".item-blackmoney").prop("checked", itemData.blackMoney);

	newItem.find(".btn").click(function () {
		newItem.remove();
	})

	$('#shop-data-items-container').append(newItem)
}

$("#shop-data-add-btn").click(function () {
	var isEverythingValid = true

	var itemNameDiv = $("#shop-data-item-id")
	var itemPriceDiv = $("#shop-data-item-price")
	var itemName = itemNameDiv.val();
	var itemPrice = itemPriceDiv.val();

	let itemData = {
		price: itemPrice
	}

	if (!itemName) {
		itemNameDiv.addClass("is-invalid")
		isEverythingValid = false
	} else {
		itemNameDiv.removeClass("is-invalid")
	}

	if (!itemPrice) {
		itemPriceDiv.addClass("is-invalid")
		isEverythingValid = false
	} else {
		itemPriceDiv.removeClass("is-invalid")
	}

	if (isEverythingValid) {
		addItemToShop(itemName, itemData)
	}
})

$("#shop-data-choose-item-btn").click(function () {
	itemsDialog(function(itemName) {
		$("#shop-data-item-id").val(itemName);
	})
});

$("#shop-data-choose-weapon-btn").click(function () {
	weaponsDialog(function(weaponName) {
		$("#shop-data-item-id").val(weaponName);
	})
});

$("#garage-buyable-add-vehicle").click(function () {
	var isEverythingValid = true;
	
	var modelDiv = $("#garage-buyable-vehicle-model");
	var model = modelDiv.val();
	var priceDiv = $("#garage-buyable-vehicle-price");
	var price = parseInt(priceDiv.val());

	// Clears input
	modelDiv.val("");
	priceDiv.val("");

	if (model) {
		modelDiv.removeClass("is-invalid");
	} else {
		modelDiv.addClass("is-invalid");
		isEverythingValid = false
	}

	if(price) {
		priceDiv.removeClass("is-invalid")
	} else {
		priceDiv.addClass("is-invalid")
		isEverythingValid = false
	}

	if(isEverythingValid) {
		var vehicleInputGroup = $(`<div class="input-group mt-1 vehicle"></div>`)

		var vehicleInput = $(`<input type="text" class="form-control vehicle-model" placeholder="Vehicle model" disabled value="${model}">`);
		var moneySpan = $(`<span class="input-group-text">$</span>`)
		var vehiclePrice = $(`<input type="text" class="form-control vehicle-price" placeholder="Vehicle price" disabled value="${price}">`);
		var deleteVehicle = $(`<button class="btn btn-outline-danger" type="button">Delete</button>`);

		vehicleInputGroup.append(vehicleInput, moneySpan, vehiclePrice, deleteVehicle);

		$(deleteVehicle).click(function () {
			$(this).parent().remove();
		})

		$("#garage-buyable-vehicles").append(vehicleInputGroup)
	}
})

$("#garage-buyable-current-coords").click(function() {
	$.post(`https://${resName}/get-current-coords`, {}, function (data) {
		var coords = data.coords;
		var heading = data.heading;

		if (coords) {
			$("#garage-buyable-spawnpoint-x").val(coords.x)
			$("#garage-buyable-spawnpoint-y").val(coords.y)
			$("#garage-buyable-spawnpoint-z").val(coords.z)
		}

		if (heading) {
			$("#garage-buyable-heading").val(heading)
		}
	})
})

function addNewCraftableToCraftables(resultItemName, craftingData) {
	var craftablesDiv = $("#craftables")

	var newCraftable = $(`
		<div class="container border mt-3">

			<div class="input-group mb-3 mt-2">
				<span class="input-group-text">${getLocalizedText("menu:dynamic:marker:crafting_table:time_to_craft")}</span>
				<input type="number" class="form-control result-item-crafting-time" placeholder="Seconds" value="${craftingData && craftingData.craftingTime || 8}" required>
			</div>

			<div class="input-group my-2">
				<span class="input-group-text">${getLocalizedText("menu:dynamic:marker:crafting_table:result_item")}</span>
				<input type="text" class="form-control result-item" placeholder="Item/Weapon id" value="${resultItemName || ""}" required>
				<button type="button" class="btn btn-secondary translatable choose-item-btn" data-translation-id="menu:dialog:choose_item">Choose item</button>
				<button type="button" class="btn btn-secondary translatable choose-weapon-btn" data-translation-id="menu:dialog:choose_weapon">Choose weapon</button>
				<span class="input-group-text ms-2">${getLocalizedText("menu:dynamic:marker:crafting_table:quantity")}</span>
				<input type="number" class="form-control result-item-quantity" placeholder="Item quantity" value="${craftingData && craftingData.quantity || 1}" required>
			</div>

			<table class="table">
				<thead>
					<tr>
						<th scope="col">${getLocalizedText("menu:dynamic:marker:crafting_table:item_id")}</th>
						<th scope="col">${getLocalizedText("menu:dynamic:marker:crafting_table:item_quantity")}</th>
						<th scope="col">${getLocalizedText("menu:dynamic:marker:crafting_table:lose_on_use")}</th>
						<th scope="col">${getLocalizedText("menu:dynamic:marker:crafting_table:remove")}</th>
					</tr>
				</thead>
				<tbody class="craft-ingredients">

				</tbody>
			</table>

			<div class="input-group mb-2">
				<span class="input-group-text">${getLocalizedText("menu:dynamic:marker:crafting_table:item_id")}</span>
				<input type="text" class="form-control crafting-table-item-id">
				<button type="button" class="btn btn-secondary translatable choose-ingredient-item-btn" data-translation-id="menu:dialog:choose_item">Choose item</button>
				<span class="input-group-text ms-2">${getLocalizedText("menu:dynamic:marker:crafting_table:item_quantity")}</span>
				<input type="number" class="form-control crafting-table-item-quantity">
				<button type="button" class="btn btn-success ms-2 add-to-craft-btn">${getLocalizedText("menu:dynamic:marker:crafting_table:add_to_craft")}</button>
			</div>

			<button type="button" class="btn btn-danger mt-5 mb-2 remove-craft-btn">${getLocalizedText("menu:dynamic:marker:crafting_table:remove_craft")}</button>
			<button type="button" class="btn btn-secondary mt-5 mb-2 animations-craft-btn float-end">${getLocalizedText("menu:dynamic:marker:crafting_table:animations")}</button>
		</div>
	`)

	newCraftable.find(".remove-craft-btn").click(function() {
		newCraftable.remove();
	})

	newCraftable.find(".animations-craft-btn").click(function() {
		inputAnimations(newCraftable.data("animations"), function(animations) {
			newCraftable.data("animations", animations)
		});
	})

	// Choose result item
	newCraftable.find(".choose-item-btn").click(function() {
		itemsDialog(function(itemName) {
			newCraftable.find(".result-item").val(itemName);
		})
	})

	// Choose result weapon
	newCraftable.find(".choose-weapon-btn").click(function() {
		weaponsDialog(function(weaponName) {
			newCraftable.find(".result-item").val(weaponName);
		})
	})

	// Choose recipe item
	newCraftable.find(".choose-ingredient-item-btn").click(function() {
		itemsDialog(function(itemName) {
			newCraftable.find(".crafting-table-item-id").val(itemName);
		})
	})

	var addToCraftBtn = newCraftable.find(".add-to-craft-btn")
	addToCraftBtn.click(function() {
		var itemIdDiv = newCraftable.find(".crafting-table-item-id");
		var itemQuantityDiv = newCraftable.find(".crafting-table-item-quantity");

		var itemName = itemIdDiv.val();
		var itemQuantity = parseInt(itemQuantityDiv.val());

		var isEverythingValid = true

		if(itemName) {
			itemIdDiv.removeClass("is-invalid");
		} else {
			itemIdDiv.addClass("is-invalid");
			isEverythingValid = false;
		}

		if(itemQuantity && itemQuantity > 0) {
			itemQuantityDiv.removeClass("is-invalid");
		} else {
			itemQuantityDiv.addClass("is-invalid");
			isEverythingValid = false;
		}

		if(isEverythingValid) {
			var craftIngredientsDiv = newCraftable.find(".craft-ingredients");

			let newCraftItem = $(`
				<tr data-item-name=${itemName} data-item-quantity=${itemQuantity}>
					<th scope="row">${itemName}</td>
					<td>${itemQuantity}</td>
					<td>
						<div class="form-check form-switch fs-4">
							<input class="form-check-input lose-on-use-checkbox" type="checkbox" checked>
						</div>
					</td>
					<td><button type="button" class="btn btn-outline-warning remove-ingredient-btn">Remove</button></td>
				</tr>
			`)

			newCraftItem.find('.remove-ingredient-btn').click(function() {
				newCraftItem.remove()
			})

			craftIngredientsDiv.append(newCraftItem)

			itemIdDiv.val("");
			itemQuantityDiv.val("");
		}
	})

	if(craftingData && craftingData.recipes) {
		let craftIngredientsDiv = newCraftable.find('.craft-ingredients');
		
		for (const [ingredientName, ingredientData] of Object.entries(craftingData.recipes)) {
			let newCraftItem = $(`
				<tr data-item-name=${ingredientName} data-item-quantity=${ingredientData.quantity}>
					<th scope="row">${ingredientName}</td>
					<td>${ingredientData.quantity}</td>
					<td>
						<div class="form-check form-switch fs-4">
							<input class="form-check-input lose-on-use-checkbox" type="checkbox">
						</div>
					</td>
					<td><button type="button" class="btn btn-outline-warning remove-ingredient-btn">Remove</button></td>
				</tr>
			`)

			let loseOnUse = ingredientData.loseOnUse
			newCraftItem.find(".lose-on-use-checkbox").prop("checked", loseOnUse)

			newCraftItem.find('.remove-ingredient-btn').click(function() {
				newCraftItem.remove()
			})

			craftIngredientsDiv.append(newCraftItem)
		}
	}

	if(craftingData && craftingData.animations) {
		newCraftable.data("animations", craftingData.animations)
	}

	craftablesDiv.append(newCraftable);
}

$("#crafting-table-new-craft-btn").click(function() {
	addNewCraftableToCraftables()
})

$("#delete-armory-content").click(function(){
	let armoryModal = $("#armory-data-modal");
	
	let markerId = armoryModal.data("markerId")
	
	armoryModal.modal("hide");

	deleteDialog("Armory inventory", "Do you want to delete this armory's content?", function () {
		$.post(`https://${resName}/delete-armory-inventory`, JSON.stringify({ markerId: markerId }), function (data) {
			if(!data.isSuccessful) {
				showError(data.message)
			}
		})
	})
})

$("#delete-stash-inventory").click(function() {
	let editMarkerModal = $("#edit-marker-dialog-modal");
	let markerId = editMarkerModal.data("markerId");

	deleteDialog("Stash inventory", "Do you want to delete this stash content?", function () {
		$.post(`https://${resName}/delete-stash-inventory`, JSON.stringify({ markerId: markerId }), function (data) {
			if(!data.isSuccessful) {
				showError(data.message)
			}
		})
	})
})

function createNewOutfit(outfit){
	outfit = outfit || {};

	outfit.tshirt_1 = outfit.tshirt_1 || 0;
	outfit.tshirt_2 = outfit.tshirt_2 || 0;

	outfit.torso_1 = outfit.torso_1 || 0;
	outfit.torso_2 = outfit.torso_2 || 0;

	outfit.decals_1 = outfit.decals_1 || 0;
	outfit.decals_2 = outfit.decals_2 || 0;

	outfit.arms = outfit.arms || 0;
	outfit.arms_2 = outfit.arms_2 || 0;

	outfit.pants_1 = outfit.pants_1 || 0;
	outfit.pants_2 = outfit.pants_2 || 0;

	outfit.shoes_1 = outfit.shoes_1 || 0;
	outfit.shoes_2 = outfit.shoes_2 || 0;

	outfit.mask_1 = outfit.mask_1 || 0;
	outfit.mask_2 = outfit.mask_2 || 0;

	outfit.bproof_1 = outfit.bproof_1 || 0;
	outfit.bproof_2 = outfit.bproof_2 || 0;

	outfit.chain_1 = outfit.chain_1 || 0;
	outfit.chain_2 = outfit.chain_2 || 0;

	outfit.helmet_1 = outfit.helmet_1 || -1;
	outfit.helmet_2 = outfit.helmet_2 || 0;

	outfit.glasses_1 = outfit.glasses_1 || 0;
	outfit.glasses_2 = outfit.glasses_2 || 0;

	outfit.bags_1 = outfit.bags_1 || 0;
	outfit.bags_2 = outfit.bags_2 || 0;

	let outfitsDiv = $("#job-outfit-outfits")
	let outfitId = $("#job-outfit-outfits").children().length + 1;
	
	let outfitDiv = $(`
		<div class="accordion accordion-flush mt-1" id="job-outfit-id-${outfitId}" data-label="${outfit.label}">
			<div class="accordion-item">
				<h2 class="accordion-header">
					<button class="accordion-button collapsed" type="button" data-bs-toggle="collapse"
						data-bs-target="#job-outfit-content-id-${outfitId}" aria-expanded="false">
						${outfit.label}
					</button>
				</h2>
				<div id="job-outfit-content-id-${outfitId}" class="accordion-collapse collapse" data-bs-parent="#job-outfit-id-${outfitId}">
					<div class="accordion-body container">
						<div class="outfit">
							<div class="input-group mb-3 col">
								<span class="input-group-text col">T-Shirt</span>
								<input type="number" class="form-control float-end col outfit-tshirt" value=${outfit.tshirt_1}>
								<span class="input-group-text col">Color</span>
								<input type="number" class="form-control float-end col outfit-tshirt-color" value=${outfit.tshirt_2}>
							</div>
							<div class="input-group mb-3 col">
								<span class="input-group-text col">Torso</span>
								<input type="number" class="form-control float-end col outfit-torso" value=${outfit.torso_1}>
								<span class="input-group-text col">Color</span>
								<input type="number" class="form-control float-end col outfit-torso-color" value=${outfit.torso_2}>
							</div>
							<div class="input-group mb-3 col">
								<span class="input-group-text col">Decals</span>
								<input type="number" class="form-control float-end col outfit-decals" value=${outfit.decals_1}>
								<span class="input-group-text col">Color</span>
								<input type="number" class="form-control float-end col outfit-decals-color" value=${outfit.decals_2}>
							</div>
							<div class="input-group mb-3 col">
								<span class="input-group-text col">Arms</span>
								<input type="number" class="form-control float-end col outfit-arms" value=${outfit.arms}>
								<span class="input-group-text col">Color</span>
								<input type="number" class="form-control float-end col outfit-arms-color" value=${outfit.arms_2}>
							</div>
							<div class="input-group mb-3 col">
								<span class="input-group-text col">Pants</span>
								<input type="number" class="form-control float-end col outfit-pants" value=${outfit.pants_1}>
								<span class="input-group-text col">Color</span>
								<input type="number" class="form-control float-end col outfit-pants-color" value=${outfit.pants_2}>
							</div>
							<div class="input-group mb-3 col">
								<span class="input-group-text col">Shoes</span>
								<input type="number" class="form-control float-end col outfit-shoes" value=${outfit.shoes_1}>
								<span class="input-group-text col">Color</span>
								<input type="number" class="form-control float-end col outfit-shoes-color" value=${outfit.shoes_2}>
							</div>
							<div class="input-group mb-3 col">
								<span class="input-group-text col">Mask</span>
								<input type="number" class="form-control float-end col outfit-mask" value=${outfit.mask_1}>
								<span class="input-group-text col">Color</span>
								<input type="number" class="form-control float-end col outfit-mask-color" value=${outfit.mask_2}>
							</div>
							<div class="input-group mb-3 col">
								<span class="input-group-text col">Bulletproof</span>
								<input type="number" class="form-control float-end col outfit-bulletproof" value=${outfit.bproof_1}>
								<span class="input-group-text col">Color</span>
								<input type="number" class="form-control float-end col outfit-bulletproof-color" value=${outfit.bproof_2}>
							</div>
							<div class="input-group mb-3 col">
								<span class="input-group-text col">Chain</span>
								<input type="number" class="form-control float-end col outfit-chain" value=${outfit.chain_1}>
								<span class="input-group-text col">Color</span>
								<input type="number" class="form-control float-end col outfit-chain-color" value=${outfit.chain_2}>
							</div>
							<div class="input-group mb-3 col">
								<span class="input-group-text col">Helmet/Hat</span>
								<input type="number" class="form-control float-end col outfit-helmet" value=${outfit.helmet_1}>
								<span class="input-group-text col">Color</span>
								<input type="number" class="form-control float-end col outfit-helmet-color" value=${outfit.helmet_2}>
							</div>
							<div class="input-group mb-3 col">
								<span class="input-group-text col">Glasses</span>
								<input type="number" class="form-control float-end col outfit-glasses" value=${outfit.glasses_1}>
								<span class="input-group-text col">Color</span>
								<input type="number" class="form-control float-end col outfit-glasses-color" value=${outfit.glasses_2}>
							</div>
							<div class="input-group mb-3 col">
								<span class="input-group-text col">Bag</span>
								<input type="number" class="form-control float-end col outfit-bag" value=${outfit.bags_1}>
								<span class="input-group-text col">Color</span>
								<input type="number" class="form-control float-end col outfit-bag-color" value=${outfit.bags_2}>
							</div>
						</div>

						<button type="button" class="btn btn-success mt-1 current-outfit-btn">Current outfit</button>

						<button type="button" class="btn btn-danger mt-1 delete-outfit-btn">Delete outfit</button>
					</div>
				</div>
			</div>
		</div>
	`)

	outfitDiv.find(".current-outfit-btn").click(function(){
		$.post(`https://${resName}/get-current-outfit`, JSON.stringify({}), function (data) {
			outfitDiv.find(".outfit-tshirt").val(data.tshirt_1)
			outfitDiv.find(".outfit-tshirt-color").val(data.tshirt_2)

			outfitDiv.find(".outfit-torso").val(data.torso_1)
			outfitDiv.find(".outfit-torso-color").val(data.torso_2)

			outfitDiv.find(".outfit-decals").val(data.decals_1)
			outfitDiv.find(".outfit-decals-color").val(data.decals_2)

			outfitDiv.find(".outfit-arms").val(data.arms)
			outfitDiv.find(".outfit-arms-color").val(data.arms_2)

			outfitDiv.find(".outfit-pants").val(data.pants_1)
			outfitDiv.find(".outfit-pants-color").val(data.pants_2)

			outfitDiv.find(".outfit-shoes").val(data.shoes_1)
			outfitDiv.find(".outfit-shoes-color").val(data.shoes_2)

			outfitDiv.find(".outfit-mask").val(data.mask_1)
			outfitDiv.find(".outfit-mask-color").val(data.mask_2)

			outfitDiv.find(".outfit-bulletproof").val(data.bproof_1)
			outfitDiv.find(".outfit-bulletproof-color").val(data.bproof_2)

			outfitDiv.find(".outfit-chain").val(data.chain_1)
			outfitDiv.find(".outfit-chain-color").val(data.chain_2)

			outfitDiv.find(".outfit-helmet").val(data.helmet_1)
			outfitDiv.find(".outfit-helmet-color").val(data.helmet_2)

			outfitDiv.find(".outfit-glasses").val(data.glasses_1)
			outfitDiv.find(".outfit-glasses-color").val(data.glasses_2)

			outfitDiv.find(".outfit-bag").val(data.bags_1)
			outfitDiv.find(".outfit-bag-color").val(data.bags_2)
		});
	})

	outfitDiv.find(".delete-outfit-btn").click(function(){
		deleteDialog("Delete Outfit", "Are you sure to delete this outfit?", function(){
			outfitDiv.remove();
		})
	})

	$(outfitsDiv).append(outfitDiv)
}

function getOutfitFromOutfitDiv(outfitDiv) {
	let outfit = {}

	outfit.label = outfitDiv.data("label")

	outfit.tshirt_1 = parseInt(outfitDiv.find(".outfit-tshirt").val()) || 0;
	outfit.tshirt_2 = parseInt(outfitDiv.find(".outfit-tshirt-color").val()) || 0;

	outfit.torso_1 = parseInt(outfitDiv.find(".outfit-torso").val()) || 0;
	outfit.torso_2 = parseInt(outfitDiv.find(".outfit-torso-color").val()) || 0;

	outfit.decals_1 = parseInt(outfitDiv.find(".outfit-decals").val()) || 0;
	outfit.decals_2 = parseInt(outfitDiv.find(".outfit-decals-color").val()) || 0;

	outfit.arms = parseInt(outfitDiv.find(".outfit-arms").val()) || 0;
	outfit.arms_2 = parseInt(outfitDiv.find(".outfit-arms-color").val()) || 0;

	outfit.pants_1 = parseInt(outfitDiv.find(".outfit-pants").val()) || 0;
	outfit.pants_2 = parseInt(outfitDiv.find(".outfit-pants-color").val()) || 0;

	outfit.shoes_1 = parseInt(outfitDiv.find(".outfit-shoes").val()) || 0;
	outfit.shoes_2 = parseInt(outfitDiv.find(".outfit-shoes-color").val()) || 0;

	outfit.mask_1 = parseInt(outfitDiv.find(".outfit-mask").val()) || 0;
	outfit.mask_2 = parseInt(outfitDiv.find(".outfit-mask-color").val()) || 0;

	outfit.bproof_1 = parseInt(outfitDiv.find(".outfit-bulletproof").val()) || 0;
	outfit.bproof_2 = parseInt(outfitDiv.find(".outfit-bulletproof-color").val()) || 0;

	outfit.chain_1 = parseInt(outfitDiv.find(".outfit-chain").val()) || 0;
	outfit.chain_2 = parseInt(outfitDiv.find(".outfit-chain-color").val()) || 0;

	outfit.helmet_1 = parseInt(outfitDiv.find(".outfit-helmet").val()) || -1;
	outfit.helmet_2 = parseInt(outfitDiv.find(".outfit-helmet-color").val()) || 0

	outfit.glasses_1 = parseInt(outfitDiv.find(".outfit-glasses").val()) || 0;
	outfit.glasses_2 = parseInt(outfitDiv.find(".outfit-glasses-color").val()) || 0;

	outfit.bags_1 = parseInt(outfitDiv.find(".outfit-bag").val()) || 0;
	outfit.bags_2 = parseInt(outfitDiv.find(".outfit-bag-color").val()) || 0;

	return outfit;
}

$("#job-outfit-new-outfit-btn").click(function(){
	inputDialog("Create new outfit", [
		{ id: "outfitLabel", label: "New outfit label:" },
	], function (data) {
		let outfit = {label: data.outfitLabel}
		createNewOutfit(outfit);
	});
})

$("#teleport-current-coords-btn").click(function(){
	$.post(`https://${resName}/get-current-coords`, {}, function (data) {
		var coords = data.coords;

		if (coords) {
			$(`#teleport-x`).val(coords.x)
			$(`#teleport-y`).val(coords.y)
			$(`#teleport-z`).val(coords.z)
		}
	})
});

function addItemToMarket(itemName, itemMinPrice, itemMaxPrice, blackMoney = false, sellTime = 0) {
	let itemsTableDiv = $("#market-modal-items-tbody");

	let itemDiv = $(`
		<tr class="item">
			<th class="item-name">${itemName}</th>
			
			<td class="item-min-price">${itemMinPrice}</td>
			<td class="item-max-price">${itemMaxPrice}</td>

			<td>
				<input class="form-check-input item-blackmoney fs-4" type="checkbox">
			</td>

			<td>
				<input type="number" class="form-control item-selltime" placeholder="Seconds" value=${sellTime}>
			</td>

			<td class="delete-btn"></td>
		</tr>
	`)

	let deleteBtn = $(`<button type="button" class="btn btn-outline-danger">Remove</button>`);

	deleteBtn.click(function(){
		itemDiv.remove();
	})

	itemDiv.find(".delete-btn").append(deleteBtn);
	
	itemDiv.find(".item-blackmoney").prop("checked", blackMoney);

	itemsTableDiv.append(itemDiv);
}

$("#market-modal-new-item-btn").click(function(){
	let itemIdDiv = $("#market-modal-new-item-name-input");
	let itemId = itemIdDiv.val();

	let itemMinPriceDiv = $("#market-modal-new-item-min-price-input");
	let itemMaxPriceDiv = $("#market-modal-new-item-max-price-input");

	let itemMinPrice = itemMinPriceDiv.val();
	let itemMaxPrice = itemMaxPriceDiv.val();

	if(itemId) {
		itemIdDiv.removeClass("is-invalid");
	} else {
		itemIdDiv.addClass("is-invalid");
	}

	if(itemMinPrice) {
		itemMinPriceDiv.removeClass("is-invalid");
	} else {
		itemMinPriceDiv.addClass("is-invalid");
	}

	if(itemMaxPrice) {
		itemMaxPriceDiv.removeClass("is-invalid");
	} else {
		itemMaxPriceDiv.addClass("is-invalid");
	}

	if(itemId && itemMinPrice && itemMaxPrice) {
		itemIdDiv.val("");
		itemMinPriceDiv.val("");
		itemMaxPriceDiv.val("");

		addItemToMarket(itemId, itemMinPrice, itemMaxPrice);
	}
})

$("#market-data-choose-item-btn").click(function() {
	itemsDialog(function(itemName) {
		$("#market-modal-new-item-name-input").val(itemName);
	});
})

function inputAnimations(animations, cb) {
	let animationsModal = $("#animations-modal");
	let animationsForm = $("#animations-modal-form");

	$("#animations").empty();

	if(animations && animations.length > 0) {
		animations.forEach(animation => {
			addAnimation(animation)
		})
	} else {
		addAnimation();
	}

	animationsForm.unbind();
	animationsForm.submit(function(event) {
		if (!this.checkValidity()) {
			event.stopPropagation();
			event.preventDefault();
			return;
		} else {
			$(animationsForm).removeClass("was-validated");
		}

		let animations = [];

		$("#animations").find(".animation-container").each(function() {
			let currentAnimDiv = $(this);

			let animType = currentAnimDiv.find(".animation-type").prop("checked");

			// If it's a scenario
			if(animType) {
				animations.push({
					type: "scenario",
					scenarioName: currentAnimDiv.find(".scenario-name").val(),
					scenarioDuration: parseInt(currentAnimDiv.find(".scenario-duration").val())
				})
			} else { // If it's an animation
				animations.push({
					type: "animation",
					animDict: currentAnimDiv.find(".animation-dictionary").val(),
					animName: currentAnimDiv.find(".animation-name").val(),
					animDuration: parseInt(currentAnimDiv.find(".animation-duration").val())
				})
			}
		})

		animationsModal.modal("hide");

		cb(animations)
	})

	animationsModal.modal("show");
}

function addAnimation(animation) {
	if(!animation) {
		animation = {};
	}

	let fullAnimContainer = $(`
		<div class="animation-container mb-5">
			<div class="form-check form-switch">
				<input class="form-check-input animation-type" type="checkbox">
				<label class="form-check-label animation-type-label">Animation</label>
			</div>

			<div class="animation">
				<div class="input-group">
					<span class="input-group-text">${getLocalizedText("menu:dynamic:animations:animation_dictionary")}</span>
					<input type="text" class="form-control animation-dictionary" value="${animation.animDict || ""}" required>
				</div>
				<div class="input-group mt-1">
					<span class="input-group-text">${getLocalizedText("menu:dynamic:animations:animation_name")}</span>
					<input type="text" class="form-control animation-name" value="${animation.animName || ""}" required>
				</div>
				<div class="input-group mt-1">
					<span class="input-group-text">${getLocalizedText("menu:dynamic:animations:animation_duration")}</span>
					<input type="number" class="form-control animation-duration" min="1" value="${animation.animDuration || ""}" required>
				</div>
			</div>

			<div class="scenario" style="display: none">
				<div class="input-group">
					<span class="input-group-text">${getLocalizedText("menu:dynamic:animations:scenario_name")}</span>
					<input type="text" class="form-control scenario-name" value="${animation.scenarioName || ""}">
				</div>
				<div class="input-group mt-1">
					<span class="input-group-text">${getLocalizedText("menu:dynamic:animations:scenario_duration")}</span>
					<input type="number" class="form-control scenario-duration" min="1" value="${animation.scenarioDuration || ""}">
				</div>
			</div>

			<button type="button" class="btn btn-warning float-end btn-sm mt-1 remove-anim-btn">${getLocalizedText("menu:dynamic:animations:remove")}</button>
		</div>
	`);

	let scenarioContainer = fullAnimContainer.find(".scenario");
	let animationContainer = fullAnimContainer.find(".animation");
	let switchLabel = fullAnimContainer.find(".animation-type-label");
	let switchInput = fullAnimContainer.find(".animation-type");

	let removeAnimBtn = fullAnimContainer.find(".remove-anim-btn");

	fullAnimContainer.find(".animation-type").change(function() {
		let isChecked = $(this).prop("checked");

		if(isChecked) {
			scenarioContainer.show();
			scenarioContainer.find(".form-control").prop("required", true);

			animationContainer.hide();
			animationContainer.find(".form-control").prop("required", false);

			switchLabel.text("Scenario");
		} else {
			scenarioContainer.hide();
			scenarioContainer.find(".form-control").prop("required", false);

			animationContainer.show();
			animationContainer.find(".form-control").prop("required", true);

			switchLabel.text("Animation");
		}
	})

	removeAnimBtn.click(function() {
		$(this).parent().remove();
	})

	if(animation && animation.type == "scenario") {
		switchInput.prop("checked", true).trigger("change");
	}

	$("#animations").append(fullAnimContainer);
}

$("#add-animation-btn").click(function(){
	addAnimation();
})

$("#harvest-add-item-btn").click(function() {
	addItemToHarvestable();
});

$("#harvest-animations-btn").click(function() {
	let editMarkerModal = $("#edit-marker-dialog-modal");
	inputAnimations(editMarkerModal.data("animations"), function(animations) {
		editMarkerModal.data("animations", animations)
	});
});

$("#harvest-item-requires-tool").change(function() {
	toggleRequiresTool( $(this).prop("checked") );
});

$("#harvest-item-tool-lose-on-use").change(function(){
	toggleLoseToolOnUse( $(this).prop("checked") );
});

$("#harvest-disappear-after-use").change(function(){
	toggleDisappearsAfterUse( $(this).prop("checked") );
});

$("#harvest-choose-account-btn").click(function() {
	accountsDialog(accountName => {
		$("#harvest-minimum-account-name").val(accountName);
	})
})

function addItemToHarvestable(itemName = "", minQuantity = "", maxQuantity = "", secondsToHarvest = "", chances = "") {
	var itemDiv = $(`
		<div class="mb-4 harvestable-item">
			<p class="text-center fs-3 text-bold">Harvestable Item</p>

			<div class="input-group">
				<span class="input-group-text">${getLocalizedText("menu:dynamic:harvest:name")}</span>
				<input type="text" class="form-control harvest-item-name" placeholder="item_name" required value=${itemName}>
				<button type="button" class="btn btn-secondary choose-item-btn translatable" data-translation-id="menu:dialog:choose_item">Choose item</button>
			</div>
			<div class="input-group mt-1">
				<span class="input-group-text">${getLocalizedText("menu:dynamic:harvest:min_quantity")}</span>
				<input type="number" class="form-control harvest-item-min-quantity" placeholder="1" required value=${minQuantity}>
			</div>
			<div class="input-group mt-1">
				<span class="input-group-text">${getLocalizedText("menu:dynamic:harvest:max_quantity")}</span>
				<input type="number" class="form-control harvest-item-max-quantity" placeholder="1" required value=${maxQuantity}>
			</div>
			<div class="input-group mt-1">
				<span class="input-group-text">${getLocalizedText("menu:dynamic:harvest:time_to_harvest")}</span>
				<input type="number" class="form-control harvest-item-time" placeholder="5" required value=${secondsToHarvest}>
			</div>	
			<div class="input-group mt-1">
				<span class="input-group-text">${getLocalizedText("menu:dynamic:harvest:probabilty")}</span>
				<input type="number" class="form-control harvest-item-chance" placeholder="50%" required value=${chances}>
			</div>

			<button type="button" class="btn btn-sm btn-danger float-end mt-1 remove-harvestable-item-btn">Remove</button>
		</div>
	`);

	$(itemDiv).find(".remove-harvestable-item-btn").click(function() {
		$(this).parent().remove();
	})

	$(itemDiv).find(".choose-item-btn").click(function() {
		itemsDialog(function(itemName) {
			$(itemDiv).find(".harvest-item-name").val(itemName);
		})
	})

	$("#harvest-modal-items").append(itemDiv);
}

$("#process-animations-btn").click(function() {
	let editMarkerModal = $("#edit-marker-dialog-modal");

	inputAnimations(editMarkerModal.data("animations"), function(animations) {
		editMarkerModal.data("animations", animations)
	});
})

$("#process-data-choose-item-to-remove-btn").click(function() {
	itemsDialog(function(itemName) {	
		$("#item-to-remove-name").val(itemName);
	});
})

$("#process-data-choose-item-to-give-btn").click(function() {
	itemsDialog(function(itemName) {
		$("#item-to-add-name").val(itemName);
	})
})

$("#process-requires-minimum-account-money").change(function() {
	let isEnabled = $(this).prop("checked");

	$("#process-minimum-account-name-div").find("input, button").prop("disabled", !isEnabled);
	$("#process-minimum-account-name-div").find("input, button").prop("required", isEnabled);
});

$("#process-choose-account-btn").click(function() {
	accountsDialog(accountName => {
		$("#process-minimum-account-name").val(accountName);
	})
})

$("#job-shop-all-jobs").change(function() {
	let jobRanks = $(this).data("ranks");
	let jobName = $(this).val();

	let allRanksSelect = $("#job-shop-all-ranks");

	allRanksSelect.find(".job-shop-rank").remove();

	console.log(jobRanks[jobName])

	let ranksArray = Array.isArray(jobRanks[jobName]) ? jobRanks[jobName] : Object.values(jobRanks[jobName]);

	//console.log(ranksArray)

	ranksArray.forEach(rank => {
		let rankDiv = $(`<option class="job-shop-rank" value=${rank.grade}>${rank.label}</option>`);

		allRanksSelect.append(rankDiv);
	})
})

function loadAllJobsOnlinePlayers() {
	$.post(`https://${resName}/getAllJobsOnlinePlayers`, {}, function(jobsOnlinePlayers) {
		allJobsStatisticsChart.data.labels = [];

		allJobsStatisticsChart.data.datasets[0] = {};
		allJobsStatisticsChart.data.datasets[0].data = [];

		allJobsStatisticsChart.data.datasets[0].label = getLocalizedText("menu:online_players");
		allJobsStatisticsChart.data.datasets[0].backgroundColor = "rgba(26, 188, 156, 0.2)";
		allJobsStatisticsChart.data.datasets[0].borderColor = "rgba(26, 188, 156, 0.4)";
		allJobsStatisticsChart.data.datasets[0].borderWidth = 1;
		allJobsStatisticsChart.options.scales.y.ticks.callback = function(value, index, values) {
			if (Number.isInteger(value)) { return value; } 
		}

		let maximumValue = 0;

		jobsOnlinePlayers.forEach(jobData => {
			allJobsStatisticsChart.data.labels.push(jobData.label);

			allJobsStatisticsChart.data.datasets[0].data.push(jobData.playersCount);

			if (jobData.playersCount > maximumValue) {
				maximumValue = jobData.playersCount;
			}
		});

		allJobsStatisticsChart.options.scales.y.suggestedMax = maximumValue + 1;

		allJobsStatisticsChart.update();
	});
}

function loadAllJobsTotalPlayers() {
	$.post(`https://${resName}/getAllJobsTotalPlayers`, {}, function(jobsTotalPlayers) {
		allJobsStatisticsChart.data.labels = [];

		allJobsStatisticsChart.data.datasets[0] = {};
		allJobsStatisticsChart.data.datasets[0].data = [];

		allJobsStatisticsChart.data.datasets[0].label = getLocalizedText("menu:total_players");
		allJobsStatisticsChart.data.datasets[0].backgroundColor = "rgba(39, 174, 96, 0.2)";
		allJobsStatisticsChart.data.datasets[0].borderColor = "rgba(39, 174, 96, 0.4)";
		allJobsStatisticsChart.data.datasets[0].borderWidth = 1;
		allJobsStatisticsChart.options.scales.y.ticks.callback = function(value, index, values) {
			if (Number.isInteger(value)) { return value; } 
		}

		let maximumValue = 0;

		jobsTotalPlayers.forEach(jobData => {
			allJobsStatisticsChart.data.labels.push(jobData.label);

			allJobsStatisticsChart.data.datasets[0].data.push(jobData.playersCount);

			if (jobData.playersCount > maximumValue) {
				maximumValue = jobData.playersCount;
			}
		});
		allJobsStatisticsChart.options.scales.y.suggestedMax = maximumValue + 1;

		allJobsStatisticsChart.update();
	});
}

function loadAllJobsSocietyMoney() {
	$.post(`https://${resName}/getJobsSocietyMoney`, {}, function(jobsSocietyMoney) {
		allJobsStatisticsChart.data.labels = [];

		allJobsStatisticsChart.data.datasets[0] = {};
		allJobsStatisticsChart.data.datasets[0].data = [];

		allJobsStatisticsChart.data.datasets[0].label = getLocalizedText("menu:society_money");
		allJobsStatisticsChart.data.datasets[0].backgroundColor = "rgba(241, 196, 15, 0.2)";
		allJobsStatisticsChart.data.datasets[0].borderColor = "rgba(241, 196, 15, 0.4)";

		allJobsStatisticsChart.data.datasets[0].borderWidth = 1;
		allJobsStatisticsChart.options.scales.y.ticks.callback = function(value, index, values) {
			return "$" + value;
		}

		let maximumValue = 0;

		jobsSocietyMoney.forEach(jobData => {
			allJobsStatisticsChart.data.labels.push(jobData.label);

			allJobsStatisticsChart.data.datasets[0].data.push(jobData.money);

			if (jobData.money > maximumValue) {
				maximumValue = jobData.money;
			}
		});

		allJobsStatisticsChart.options.scales.y.suggestedMax = maximumValue + maximumValue * 0.10;

		allJobsStatisticsChart.update();
	});
}

$('input[type=radio][name=all-jobs-statistics-type]').change(function() {
    let action = $(this).val();

	switch(action) {
		case "online-players": {
			loadAllJobsOnlinePlayers();
			break;
		}

		case "total-players": {
			loadAllJobsTotalPlayers();
			break;
		}

		case "society-money": {
			loadAllJobsSocietyMoney();
			break;
		}
	}
});

function loadRanksDistrubutions(){
	let jobName = $("#edit-job").data("jobName");

	$.post(`https://${resName}/getRanksDistribution`, JSON.stringify({jobName: jobName }), function(rankDistribution) {
		jobStatisticsChart.data.labels = [];

		jobStatisticsChart.data.datasets[0] = {};
		jobStatisticsChart.data.datasets[0].data = [];

		jobStatisticsChart.data.datasets[0].label = getLocalizedText("menu:chart:players_in_rank");

		jobStatisticsChart.data.datasets[0].backgroundColor = "rgba(241, 196, 15, 0.2)";
		jobStatisticsChart.data.datasets[0].borderColor = "rgba(241, 196, 15, 0.4)";
		jobStatisticsChart.data.datasets[0].borderWidth = 1;

		jobStatisticsChart.options.scales.y.ticks.callback = function(value, index, values) {
			if (Number.isInteger(value)) { return value; } 
		}
		
		let maximumValue = 0;

		rankDistribution.forEach(rankData => {
			jobStatisticsChart.data.labels.push(rankData.label);

			jobStatisticsChart.data.datasets[0].data.push(rankData.playersCount);

			if (rankData.playersCount > maximumValue) {
				maximumValue = rankData.playersCount;
			}
		});

		jobStatisticsChart.options.scales.y.suggestedMax = maximumValue + 1;

		jobStatisticsChart.update();
	})
}

function init(version, fullConfig) {
	$("#job-creator-version").text(version);

	loadSettings(fullConfig);

	loadAllJobsOnlinePlayers();

	refresh().then(() => {
		$("#job-creator").show();
	});
}

function exit() {
	// Resets current active tab (jobs is the default one)
	$("#job-creator").find(".nav-link, .tab-pane").each(function() {
		if($(this).data("isDefault") == "1") {
			$(this).addClass(["active", "show"])
		} else {
			$(this).removeClass(["active", "show"])
		}
	})

	$("#job-creator").hide();

	$.post(`https://${resName}/exit`)
}

/* Progress bar */
let progressBarInterval = null;
function startTimedProgressBar(time, text) {
	let progressBarDiv = $("#job-creator-progressbar-div");
	let progressBar = $("#job-creator-progressbar")

    $("#job-creator-progressbar-text").text(text);
    progressBar.css({width: `0%`});
    progressBarDiv.fadeIn();

    let minTime = time/100;

    let progress = 0;

	progressBar.css({"transition-duration": `${minTime}ms`})

    progressBarInterval = setInterval(() => {
        if(progress >= 99) {
            progressBarDiv.hide();
            clearInterval(progressBarInterval);

			progressBarInterval = null;
        } else {
            progress++;
            progressBar.css({width: `${progress}%`});
        }
    }, minTime);
}

function stopProgressBar() {
	if(progressBarInterval) {
		clearInterval(progressBarInterval);
		$("#job-creator-progressbar-div").fadeOut();
	}
}
/* Progress bar END */

window.addEventListener('message', (event) => {
	let data = event.data;
	let action = data.action;

	if (action == 'show') {
		init(data.version, data.fullConfig);
	} else if(action == "progressBar") {
		startTimedProgressBar(data.time, data.text)
	} else if(action == "stopProgressBar") {
		stopProgressBar();
	} else if(action == "notAllowed") {
		$("#not-allowed-ace").text(`
			add_ace group.admin ${data.acePermission} allow # Add permission to group
		`)

		$("#not-allowed-steamid").text(`
			# Can also be identifier.${data.steamId}
		`)

		$("#not-allowed-license").text(`
			add_principal identifier.${data.license} group.admin # Add player to the group
		`)
		$("#not-allowed-container").show();
	}
})

$("#close-main-btn").click(function () {
	exit()
})

$("#close-btn-not-allowed-menu").click(function() {
	$("#not-allowed-container").hide();
	exit();
})

/*
 
░██████╗███████╗████████╗████████╗██╗███╗░░██╗░██████╗░░██████╗
██╔════╝██╔════╝╚══██╔══╝╚══██╔══╝██║████╗░██║██╔════╝░██╔════╝
╚█████╗░█████╗░░░░░██║░░░░░░██║░░░██║██╔██╗██║██║░░██╗░╚█████╗░
░╚═══██╗██╔══╝░░░░░██║░░░░░░██║░░░██║██║╚████║██║░░╚██╗░╚═══██╗
██████╔╝███████╗░░░██║░░░░░░██║░░░██║██║░╚███║╚██████╔╝██████╔╝
╚═════╝░╚══════╝░░░╚═╝░░░░░░╚═╝░░░╚═╝╚═╝░░╚══╝░╚═════╝░╚═════╝░
*/

function clearLicensesInList(type) {
	if(type === "driver") {
		var listDiv = $("#settings_drivingLicensesList");
	} else if(type === "weapon") {
		var listDiv = $("#settings_weaponLicensesList");
	}

	if(listDiv) {
		listDiv.empty();
	}
}

function addNewLicenseInList(licenseName, type) {
	if(type === "driver") {
		var listDiv = $("#settings_drivingLicensesList");
	} else if(type === "weapon") {
		var listDiv = $("#settings_weaponLicensesList");
	}

	if(listDiv) {
		listDiv.append(`
			<li class="list-group-item d-flex justify-content-between align-items-center license" data-license="${licenseName}">
				${licenseName}
				<button class="btn remove-license"><i class="bi bi-x"></i></button>
			</li>
		`);

		listDiv.find(".remove-license").click(function() {
			$(this).parent().remove();
		});
	}
}

$("#settings_addNewDrivingLicenseBtn").click(function() {
	let drivingLicenseName = $("#settings_newDrivingLicense").val();
	
	if(drivingLicenseName) {
		$("#settings_newDrivingLicense").val("");
		addNewLicenseInList(drivingLicenseName, "driver");
	}
})

$("#settings_addNewWeaponLicenseBtn").click(function() {
	let weaponLicenseName = $("#settings_newWeaponLicense").val();
	
	if(weaponLicenseName) {
		$("#settings_newWeaponLicense").val("");
		addNewLicenseInList(weaponLicenseName, "weapon");
	}
})

function getSettingsLicenses(type) {
	if(type === "driver") {
		var listDiv = $("#settings_drivingLicensesList");
	} else if(type === "weapon") {
		var listDiv = $("#settings_weaponLicensesList");
	}

	let licenses = {};

	listDiv.find(".license").each(function(index, element) {
		licenses[ $(element).data("license") ] = true;
	})

	return licenses;
}

function getSeparatedDiscordWebhooks() {
	let webhooks = {};

	$("#settings_specific_webhooks").find(".form-control").each(function(index, element) {
		let markerType = $(element).data("markerType");
		let webhook = $(element).val();

		if(webhook) {
			webhooks[markerType] = webhook;
		}
	});

	return webhooks;
}

$("#settings").submit(function(event) {
	if (!this.checkValidity()) {
		event.preventDefault();
		event.stopPropagation();

		return;
	} else {
		$(this).removeClass("was-validated");
	}

	let clientSettings = {
		useBillingUI: $("#settings_useBillingUI").prop("checked"),
		markerDistance: parseFloat( $("#settings_markerDistance").val() ),
		use3Dtext: $("#settings_use3Dtext").prop("checked"),
		textSize: parseInt( $("#settings_textSize").val() ),
		textFont: parseInt( $("#settings_textFont").val() ),
		carLockpickTime: parseInt( $("#settings_carLockpickTime").val() ),
		enableAlarmWhenLockpicking: $("#settings_enableAlarmWhenLockpicking").prop("checked"),
		useJSFourIdCard: $("#settings_useJSFourIdCard").prop("checked"),
		canUseActionsMenuWhileOffDuty: $("#settings_canUseActionsMenuWhileOffDuty").prop("checked"),
		licenses: {
			driver: getSettingsLicenses("driver"),
			weapon: getSettingsLicenses("weapon"),
		},
		marketSellOnePerTime: $("#settings_marketSellOnePerTime").prop("checked"),
		menuPosition: $("#settings_menuPosition").val(),
		actionsMenuKey: $("#settings_actionsMenuKey").val(),
		freezeWhenHandcuffed: $("#settings_freezeWhenHandcuffed").prop("checked"),
	}

	let sharedSettings = {
		allowAfkFarming: $("#settings_allowAfkFarming").prop("checked"),
		locale: $("#settings_locale").val()
	}

	let serverSettings = {
		unemployedJob: $("#settings_unemployedJob").val(),
		unemployedGrade: parseInt( $("#settings_unemployedGrade").val() ),

		acePermission: $("#settings_acePermission").val(),

		areDiscordLogsActive: $("#settings_isDiscordLogActive").prop("checked"),
		mainDiscordWebhook: $("#settings_discordWebhook").val(),
		specificWebhooks: getSeparatedDiscordWebhooks(),

		handcuffRequireItem: $("#settings_handcuffRequireItem").prop("checked"),
		handcuffsItemName: $("#settings_handcuffsItemName").val(),

		lockpickCarRequireItem: $("#settings_lockpickCarRequireItem").prop("checked"),
		lockpickItemName: $("#settings_lockpickItemName").val(),
		lockpickRemoveOnUse: $("#settings_lockpickRemoveOnUse").prop("checked"),

		robbableAccounts: getRobbableAccounts(),

		canAlwaysCarryItem: $("#settings_canAlwaysCarryItem").prop("checked"),

		depositableInSafeAccounts: getDepositableInSafeAccounts(),

		enableCashInSafesOldESX: $("#settings_enableCashInSafesOldESX").prop("checked"),

		repairVehicleRequireItem: $("#settings_repairVehicleRequireItem").prop("checked"),
		repairVehicleItemName: $("#settings_repairVehicleItemName").val(),
		repairVehicleRemoveOnUse: $("#settings_repairVehicleRemoveOnUse").prop("checked"),

		cleanVehicleRequireItem: $("#settings_cleanVehicleRequireItem").prop("checked"),
		cleanVehicleItemName: $("#settings_cleanVehicleItemName").val(),
		cleanVehicleRemoveOnUse: $("#settings_cleanVehicleRemoveOnUse").prop("checked"),

		healRequireItem: $("#settings_healRequireItem").prop("checked"),
		healItemName: $("#settings_healItemName").val(),
		healRemoveOnuse: $("#settings_healRemoveOnUse").prop("checked"),
		
		reviveRequireItem: $("#settings_reviveRequireItem").prop("checked"),
		reviveItemName: $("#settings_reviveItemName").val(),
		reviveRemoveOnuse: $("#settings_reviveRemoveOnUse").prop("checked"),

		enablePropertyOutfits: $("#settings_enablePropertyOutfits").prop("checked"),

		parkAllOwnedVehiclesOnRestart: $("#settings_parkAllOwnedVehiclesOnRestart").prop("checked")
	}

	$.post(`https://${resName}/saveSettings`, JSON.stringify({
		clientSettings: clientSettings,
		sharedSettings: sharedSettings,
		serverSettings: serverSettings,
	}));

	refreshTranslations(sharedSettings.locale);
})

function toggleDiscordLogsInSettings(enable) {
	$("#settings_discordWebhook").prop("disabled", !enable);
	$("#settings_discordWebhook").prop("required", enable);
	
	$("#settings_specific_webhooks").find(`.form-control`).prop("disabled", !enable);
}

$("#settings_isDiscordLogActive").change(function() {
	let enabled = $(this).prop("checked");

	toggleDiscordLogsInSettings(enabled);
})

function loadSettings(fullConfig) {
	// CLIENT
	$("#settings_useBillingUI").prop("checked", fullConfig.useBillingUI);
	$("#settings_markerDistance").val(fullConfig.markerDistance);

	// 3D Text
	$("#settings_use3Dtext").prop("checked", fullConfig.use3Dtext);
	$("#settings_textSize").val(fullConfig.textSize);
	$("#settings_textFont").val(fullConfig.textFont);
	
	// Car lockpicking
	$("#settings_carLockpickTime").val(fullConfig.carLockpickTime);
	$("#settings_enableAlarmWhenLockpicking").prop("checked", fullConfig.enableAlarmWhenLockpicking);

	$("#settings_useJSFourIdCard").prop("checked", fullConfig.useJSFourIdCard);
	$("#settings_canUseActionsMenuWhileOffDuty").prop("checked", fullConfig.canUseActionsMenuWhileOffDuty);
	$("#settings_marketSellOnePerTime").prop("checked", fullConfig.marketSellOnePerTime);

	// Weapon/Driving licenses
	if(fullConfig.licenses) {
		for(const[licenseType, licenses] of Object.entries(fullConfig.licenses)) {
			clearLicensesInList(licenseType);

			Object.keys(licenses).forEach(licenseName => {
				addNewLicenseInList(licenseName, licenseType);
			})
		}
	}

	// Menu position
	$("#settings_menuPosition").val(fullConfig.menuPosition);

	// Actions key
	$("#settings_actionsMenuKey").val(fullConfig.actionsMenuKey);

	// SHARED
	$("#settings_allowAfkFarming").prop("checked", fullConfig.allowAfkFarming);
	$("#settings_locale").val(fullConfig.locale);

	// SERVER
	$("#settings_unemployedJob").val(fullConfig.unemployedJob);
	$("#settings_unemployedGrade").val(fullConfig.unemployedGrade);
	$("#settings_acePermission").val(fullConfig.acePermission);
	
	// Discord logs webhooks
	$("#settings_isDiscordLogActive").prop("checked", fullConfig.areDiscordLogsActive);
	toggleDiscordLogsInSettings(fullConfig.areDiscordLogsActive);

	$("#settings_discordWebhook").val(fullConfig.mainDiscordWebhook);

	// Handcuffs
	toggleSettingsHandcuffsRequireItem(fullConfig.handcuffRequireItem);
	$("#settings_handcuffsItemName").val(fullConfig.handcuffsItemName)

	$("#settings_freezeWhenHandcuffed").prop("checked", fullConfig.freezeWhenHandcuffed);

	// Lockpick
	toggleSettingsLockpickRequireItem(fullConfig.lockpickCarRequireItem);
	$("#settings_lockpickItemName").val(fullConfig.lockpickItemName)
	$("#settings_lockpickRemoveOnUse").prop("checked", fullConfig.lockpickRemoveOnUse)

	// Vehicle repair
	toggleSettingsVehicleRepairRequireItem(fullConfig.repairVehicleRequireItem);
	$("#settings_repairVehicleItemName").val(fullConfig.repairVehicleItemName);
	$("#settings_repairVehicleRemoveOnUse").prop("checked", fullConfig.repairVehicleRemoveOnUse);

	// Vehicle cleaning
	toggleSettingsVehicleCleaningRequireItem(fullConfig.cleanVehicleRequireItem);
	$("#settings_cleanVehicleItemName").val(fullConfig.cleanVehicleItemName);
	$("#settings_cleanVehicleRemoveOnUse").prop("checked", fullConfig.cleanVehicleRemoveOnUse);

	// Healing
	toggleSettingsHealingRequireItem(fullConfig.healRequireItem);
	$("#settings_healItemName").val(fullConfig.healItemName);
	$("#settings_healRemoveOnUse").prop("checked", fullConfig.healRemoveOnUse);

	// Reviving
	toggleSettingsRevivingRequireItem(fullConfig.reviveRequireItem);
	$("#settings_reviveItemName").val(fullConfig.reviveItemName);
	$("#settings_reviveRemoveOnUse").prop("checked", fullConfig.reviveRemoveOnuse);

	// Robbable accounts
	$("#settings_robbableAccountsList").empty();
	if(fullConfig.robbableAccounts) {
		fullConfig.robbableAccounts.forEach(account => {
			addNewRobbableAccountInList(account)
		});
	}

	$("#settings_canAlwaysCarryItem").prop("checked", fullConfig.canAlwaysCarryItem);

	// Depositable accounts
	$("#settings_depositableAccountsList").empty();
	if(fullConfig.depositableInSafeAccounts) {
		fullConfig.depositableInSafeAccounts.forEach(account => {
			addNewDepositableAccountInList(account)
		});
	}

	$("#settings_enableCashInSafesOldESX").prop("checked", fullConfig.enableCashInSafesOldESX);

	$("#settings_enablePropertyOutfits").prop("checked", fullConfig.enablePropertyOutfits);

	$("#settings_parkAllOwnedVehiclesOnRestart").prop("checked", fullConfig.parkAllOwnedVehiclesOnRestart);

	for(const[markerType, webhook] of Object.entries(fullConfig.specificWebhooks)) {
		$("#settings_specific_webhooks").find(`[data-marker-type="${markerType}"]`).val(webhook);
	}
}

$("#settingsRestoreDefaultBtn").click(function() {
	inputDialog( getLocalizedText("menu:are_you_sure_to_restore_settings"), [], function(){
		$.post(`https://${resName}/getDefaultConfiguration`, {}, function(defaultConfiguration) {
			loadSettings(defaultConfiguration);
		})
	});
})

function addNewRobbableAccountInList(accountName) {
	var listDiv = $("#settings_robbableAccountsList");

	if(listDiv) {
		listDiv.append(`
			<li class="list-group-item d-flex justify-content-between align-items-center robbable-account" data-account="${accountName}">
				${accountName}
				<button class="btn remove-account"><i class="bi bi-x"></i></button>
			</li>
		`);

		listDiv.find(".remove-account").click(function() {
			$(this).parent().remove();
		});
	}
}
$("#settings_addNewRobbableAccountBtn").click(function() {
	let robbableAccount = $("#settings_newRobbableAccount").val();
	
	if(robbableAccount) {
		$("#settings_newRobbableAccount").val("");
		addNewRobbableAccountInList(robbableAccount);
	}
})

function getRobbableAccounts() {
	var listDiv = $("#settings_robbableAccountsList");

	let robbableAccounts = [];

	listDiv.find(".robbable-account").each(function(index, element) {
		robbableAccounts.push( $(element).data("account") );
	})

	return robbableAccounts;
}

function addNewDepositableAccountInList(accountName) {
	var listDiv = $("#settings_depositableAccountsList");

	if(listDiv) {
		listDiv.append(`
			<li class="list-group-item d-flex justify-content-between align-items-center depositable-account" data-account="${accountName}">
				${accountName}
				<button class="btn remove-account"><i class="bi bi-x"></i></button>
			</li>
		`);

		listDiv.find(".remove-account").click(function() {
			$(this).parent().remove();
		});
	}
}

$("#settings_addNewDepositableAccountBtn").click(function() {
	let depositableAccount = $("#settings_newDepositableAccount").val();
	
	if(depositableAccount) {
		$("#settings_newDepositableAccount").val("");
		addNewDepositableAccountInList(depositableAccount);
	}
})

function getDepositableInSafeAccounts() {
	var listDiv = $("#settings_depositableAccountsList");

	let depositableAccounts = [];

	listDiv.find(".depositable-account").each(function(index, element) {
		depositableAccounts.push( $(element).data("account") );
	})

	return depositableAccounts;
}

// Handcuffs settings
function toggleSettingsHandcuffsRequireItem(enable) {
	$("#settings_handcuffRequireItem").prop("checked", enable);

	$("#settings_handcuffsItemName").prop("disabled", !enable);
	$("#settings_handcuffsItemName").prop("required", enable);
}

$("#settings_handcuffRequireItem").change(function() {
	toggleSettingsHandcuffsRequireItem( $("#settings_handcuffRequireItem").prop("checked") );
})

// Lockpick settings
function toggleSettingsLockpickRequireItem(enable) {
	$("#settings_lockpickCarRequireItem").prop("checked", enable);

	$("#settings_lockpickItemName").prop("disabled", !enable);
	$("#settings_lockpickItemName").prop("required", enable);

	$("#settings_lockpickRemoveOnUse").prop("disabled", !enable);
}

$("#settings_lockpickCarRequireItem").change(function() {
	toggleSettingsLockpickRequireItem( $(this).prop("checked") );
})

// Vehicle repair settings
function toggleSettingsVehicleRepairRequireItem(enable) {
	$("#settings_repairVehicleRequireItem").prop("checked", enable);

	$("#settings_repairVehicleItemName").prop("disabled", !enable);
	$("#settings_repairVehicleItemName").prop("required", enable);

	$("#settings_repairVehicleRemoveOnUse").prop("disabled", !enable);
}

$("#settings_repairVehicleRequireItem").change(function() {
	toggleSettingsVehicleRepairRequireItem( $(this).prop("checked") );
})

// Vehicle cleaning settings
function toggleSettingsVehicleCleaningRequireItem(enable) {
	$("#settings_cleanVehicleRequireItem").prop("checked", enable);

	$("#settings_cleanVehicleItemName").prop("disabled", !enable);
	$("#settings_cleanVehicleItemName").prop("required", enable);

	$("#settings_cleanVehicleRemoveOnUse").prop("disabled", !enable);
}

$("#settings_cleanVehicleRequireItem").change(function() {
	toggleSettingsVehicleCleaningRequireItem( $(this).prop("checked") );
})

// Healing settings
function toggleSettingsHealingRequireItem(enable) {
	$("#settings_healRequireItem").prop("checked", enable);

	$("#settings_healItemName").prop("disabled", !enable);
	$("#settings_healItemName").prop("required", enable);

	$("#settings_healRemoveOnUse").prop("disabled", !enable);
}

$("#settings_healRequireItem").change(function() {
	toggleSettingsHealingRequireItem( $(this).prop("checked") );
})

// Reviving settings
function toggleSettingsRevivingRequireItem(enable) {
	$("#settings_reviveRequireItem").prop("checked", enable);

	$("#settings_reviveItemName").prop("disabled", !enable);
	$("#settings_reviveItemName").prop("required", enable);

	$("#settings_reviveRemoveOnUse").prop("disabled", !enable);
}

$("#settings_reviveRequireItem").change(function() {
	toggleSettingsRevivingRequireItem( $(this).prop("checked") );
})

// Closes menu when clicking ESC
$(document).on('keyup', function(e) {
	if (e.key == "Escape") {
		if( $("#job-creator").is(":visible") ) {
			exit();
		} else if( $("#edit-job").is(":visible") ) {
			exitFromEditJob();
		}
	}
});