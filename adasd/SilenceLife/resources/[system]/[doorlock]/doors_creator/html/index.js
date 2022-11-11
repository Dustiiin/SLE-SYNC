const resName = GetParentResourceName();

// Utils

// Fetch all the forms we want to apply custom Bootstrap validation styles to
let forms = document.querySelectorAll('.needs-validation')

// Loop over them and prevent submission
Array.prototype.slice.call(forms)
.forEach(function (form) {
	form.addEventListener('submit', function (event) {

	event.preventDefault();

	form.classList.add('was-validated')
	}, false)
})

function maxTwoDecimals() {
	if(isNaN(this.value)) {
		return
	}

	let number = parseFloat(this.value);

	if(number) {
		this.value = number.toFixed(2);
	}
}

$(".max-two-decimals").change(maxTwoDecimals)

// Language stuff
let TRANSLATIONS = {};

function translateEverything() {
	$("body").find(".translatable").each(function() {
		let translationId = $(this).data("translationId")

		$(this).prop("innerHTML", TRANSLATIONS[translationId]);
	})
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

/* UTILS */

function jobsDialog() {
	return new Promise((resolve, reject) => {
		let inputJobsModal = $("#input-jobs-dialog-modal")
		inputJobsModal.modal("show");
	
		$("#input-job-search").val("");
		
		$.post(`https://${resName}/getAllJobs`, JSON.stringify({}), function (jobs) {
			let jobListDiv = $("#jobs-list");
	
			jobListDiv.empty();
	
			for(const[jobName, jobData] of Object.entries(jobs)) {
				let jobDiv = $(`
					<div class="form-check fs-3 mb-2">
						<p class="fw-bold mb-0">${jobData.label}</p>
						
						<div class="job-grades">
	
						</div>
					</div>
				`);
	
				for(let [grade, gradeData] of Object.entries(jobData.grades)) {
					// QB-Core
					if(gradeData.grade == undefined) {
						gradeData.grade = grade;
						gradeData.label = gradeData.name;
					}

					let rankDiv = $(`
						<div class="rank-div">
							<input class="form-check-input" type="checkbox" data-job-name="${jobName}" data-grade=${gradeData.grade}>
							<label class="form-check-label">
								${gradeData.grade} - ${gradeData.label}
							</label>
						</div>
					`);
	
					jobDiv.find(".job-grades").append(rankDiv);
				}
	
				jobListDiv.append(jobDiv);
			}
	
			// Unbinds the button and rebinds it to callback the selected jobs
			$("#input-jobs-confirm-btn").unbind().click(function() {
				let selectedJobs = {};
	
				let isThereAnyJob = false;
	
				jobListDiv.find("input:checked").each(function() {
					isThereAnyJob = true;
	
					let jobName = $(this).data("jobName");
					let grade = $(this).data("grade");
	
					if(!selectedJobs[jobName]) {
						selectedJobs[jobName] = {};
					}
					
					selectedJobs[jobName][grade] = true;
				});
	
				inputJobsModal.modal("hide");
	
				resolve(isThereAnyJob ? selectedJobs : false);
			})
		});
	})
}
$("#input-job-search").on("keyup", function() {
	let text = $(this).val().toLowerCase();

	$("#jobs-list .form-check").filter(function() {
      $(this).toggle($(this).text().toLowerCase().indexOf(text) > -1)
    });
})

function itemsDialog(cb) {
	let inputItemsModal = $("#input-items-dialog-modal")
	inputItemsModal.modal("show");

	$("#input-item-search").val("");
	
	// On press of enter, callback the value of the search
	$("#input-item-search").off("keypress");
	$("#input-item-search").keypress(function (e) {
		if (e.which == 13) {
			let search = $(this).val().toLowerCase();

			if(search.length > 0) {
				inputItemsModal.modal("hide");
	
				cb(search);
			}
		}
	});

	$.post(`https://${resName}/getAllItems`, JSON.stringify({}), function (items) {
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

function buildingsDialog(cb) {
	let inputBuildingModal = $("#input-building-dialog-modal")
	inputBuildingModal.modal("show");

	$("#input-building-search").val("");
	
	// On press of enter, callback the value of the search
	$("#input-building-search").off("keypress");
	$("#input-building-search").keypress(function (e) {
		if (e.which == 13) {
			let search = $(this).val().toLowerCase();

			if(search.length > 0) {
				inputBuildingModal.modal("hide");
	
				cb(search);
			}
		}
	});

	$.post(`https://${resName}/getAllBuildings`, JSON.stringify({}), function (buildings) {
		let buildingsListDiv = $("#buildings-list");

		buildingsListDiv.empty();

		for(const[_, buildingData] of Object.entries(buildings)) {
			let buildingDiv = $(`
				<li class="list-group-item list-group-item-action">${buildingData.id} - ${buildingData.label}</li>
			`);

			buildingDiv.click(function() {
				inputBuildingModal.modal("hide");
				cb(buildingData.id);
			});

			buildingsListDiv.append(buildingDiv);
		}
	});
}
$("#input-building-search").on("keyup", function() {
	let text = $(this).val().toLowerCase();

	$("#buildings-list li").filter(function() {
      $(this).toggle($(this).text().toLowerCase().indexOf(text) > -1)
    });
})

async function playersListDialog(cb) {
	// Get players list
	let playersList = await $.get(`https://${resName}/getPlayersList`);

	let modal = $("#players-dialog-modal");

	$("#input-players-search").val("");

	let playerListDiv = $("#players-list")

	playerListDiv.empty();

	for(const playerData of playersList) {
		let playerDiv = $(`
			<li class="list-group-item list-group-item-action clickable"}>${playerData.playerName}</li>
		`);

		playerDiv.click(function() {
			modal.modal("hide");
			cb(playerData.identifier);
		});

		playerListDiv.append(playerDiv);
	}

	modal.modal("show");
}
$("#input-players-search").on("keyup", function() {
	let text = $(this).val().toLowerCase();

	$("#players-list li").filter(function() {
      $(this).toggle($(this).text().toLowerCase().indexOf(text) > -1)
    });
})

/* DOORS */
let doorsDatatable = $("#doors-container").DataTable( {
	"lengthMenu": [10, 15, 20],
	"createdRow": function ( row, data, index ) {
		$(row).addClass("clickable");

		$(row).click(function() {
			let doorsId = parseInt(data[1]);

			editDoor(doorsId);
		})
	},
} );

let doors = {};

function loadDoors() {
    $.post(`https://${resName}/getAllDoors`, {}, async function(rawDoors) {
		// Manually create the table to avoid incompatibilities due table indexing

		doors = {};

		for(const[k, doorsData] of Object.entries(rawDoors)) {
			doors[doorsData.id] = doorsData;
		}

		doorsDatatable.clear();

		for(const[doorsId, doorsData] of Object.entries(doors)) {
			doorsDatatable.row.add([
				doorsData.distance,
				doorsId,
                doorsData.label,
                doorsData.doors ? Object.entries(doorsData.doors).length : 0,
				doorsData.parentBuilding ? buildings[doorsData.parentBuilding].label : getLocalizedText("menu:none")
			])
		}

		doorsDatatable.draw()
	})
}

function setDoorsModalType(type) {
	$("#door-modal").data("type", type);

	switch(type) {
		case "building": {
			$("#used-doors-div").hide();
			$("#maximum-distance-div").hide().find("input").prop("required", false);
			$("#icon-coordinates-div").hide().find("input").prop("required", false);
			$("#use-building-rules-div").hide();
			$("#sliding-door-div").hide();
			$("#can-be-lockpicked-div").hide();

			showBuildingOptions();

			break;
		}

		case "door": {
			$("#used-doors-div").show();
			$("#maximum-distance-div").show().find("input").prop("required", true);
			$("#icon-coordinates-div").show().find("input").prop("required", true);
			$("#use-building-rules-div").show();
			$("#sliding-door-div").show();
			$("#can-be-lockpicked-div").show();

			break;
		}
	}
}

function setupDefaultModalValues() {
	let doorModal = $("#door-modal");

	doorModal.find(".form-control").val("");

	$("#door-label").val( getLocalizedText("menu:default") );

	$(`input[name="doors-default-state"][value="0"]`).prop("checked", true);


	$("#requires-job").prop("checked", false).change();
	$("#requires-item").prop("checked", false).change();
	$("#requires-code").prop("checked", false).change();
	$("#auto-closure-switch").prop("checked", false).change();

	$("#requires-identifier").prop("checked", false).change();
	$("#allowed-identifiers").empty();

	$("#is-vault-door").prop("checked", false).change();
}

$("#new-door-btn").click(function() {
	let doorModal = $("#door-modal");

	setDoorsModalType("door");

	// Converts from create modal to edit modal
	doorModal.data("action", "create");
	
	$("#delete-door-btn").hide();
	$("#save-door-btn").text( getLocalizedText("menu:create") );
	
	// Resets fields
	setupDefaultModalValues();
	$("#used-doors-table").empty();
	$("#maximum-distance").val(4.0);

	setParentBuilding(null);

	doorModal.modal("show");
})

function setUsedDoors(doors = {}) {
	let usedDoorsTable = $("#used-doors-table");

	usedDoorsTable.empty();

	for(const[doorObject, doorData] of Object.entries(doors)) {
		let x = (doorData.coords.x).toFixed(2);
		let y = (doorData.coords.y).toFixed(2);
		let z = (doorData.coords.z).toFixed(2);

		let newRow = $(`
			<tr class="used-door">
				<td class="x-coord">${x}</td>
				<td class="y-coord">${y}</td>
				<td class="z-coord">${z}</td>
				<td class="model">${doorData.model}</td>
			</tr>
		`)

		newRow.data("doorObject", doorObject);

		usedDoorsTable.append(newRow);
	}
}

$("#select-doors-btn").click(function() {
	closeMenu();
	let doorModal = $("#door-modal");
	doorModal.modal("hide");

	let action = doorModal.data("action");
	if(action === "edit") {
		var doorsId = doorModal.data("doorsId");
	}
	
	$.post(`https://${resName}/selectDoors`, JSON.stringify({doorsId: doorsId}), function(doors) {
		if(doors) {
			setUsedDoors(doors);
		}

		$("#doors_creator").show();
		doorModal.modal("show");
	})
})

$("#choose-icon-coords-btn").click(function() {
	closeMenu();
	let doorModal = $("#door-modal");
	doorModal.modal("hide");

	$.post(`https://${resName}/chooseIconCoords`, {}, function(coords) {
		if(coords) {
			$("#icon-coords-x").val(coords.x).change();
			$("#icon-coords-y").val(coords.y).change();
			$("#icon-coords-z").val(coords.z).change();
		}
		
		$("#doors_creator").show();
		doorModal.modal("show");
	})
})

function getUsedDoors() {
	let doorsTable = $("#used-doors-table");
	let usedDoors = {};
	
	let isThereAtLeastOneDoor = false;

	doorsTable.find(".used-door").each(function() {
		isThereAtLeastOneDoor = true;

		let doorObject = $(this).data("doorObject");

		let model = parseInt( $(this).find(".model").text() );

		let x = parseFloat( $(this).find(".x-coord").text() );
		let y = parseFloat( $(this).find(".y-coord").text() );
		let z = parseFloat( $(this).find(".z-coord").text() );

		usedDoors[doorObject] = {
			coords: {
				x: x,
				y: y,
				z: z
			},

			model: model
		}
	});

	return isThereAtLeastOneDoor && usedDoors || null;
}

$("#choose-maximum-distance-btn").click(function() {
	closeMenu();
	let doorModal = $("#door-modal");
	doorModal.modal("hide");

	let doors = getUsedDoors();

	if(doors) {
		let currentDistance = parseFloat( $("#maximum-distance").val() );
		$.post(`https://${resName}/chooseMaximumDistance`, JSON.stringify({doors: doors, distance: currentDistance}), function(maxDistance) {
			if(maxDistance) {
				$("#maximum-distance").val(maxDistance);
			}
	
			$("#doors_creator").show();
			doorModal.modal("show");
		})
	}
})

async function getJobLabel(jobName) {
	return new Promise((resolve, reject) => {
		$.post(`https://${resName}/getJobLabel`, JSON.stringify({jobName: jobName}), function(jobLabel) {
			resolve(jobLabel);
		})
	})
}

async function setRequiredJob(requiresJob, allowedJobs) {
	$("#requires-job").prop("checked", requiresJob).change();

	let allowedJobsDiv = $("#allowed-jobs");

	allowedJobsDiv.val("");

	if(allowedJobs) {
		allowedJobsDiv.data("allowedJobs", allowedJobs);

		let text = "";

		let isTheFirst = true;

		for(const[jobName, _] of Object.entries(allowedJobs)) {
			if(isTheFirst) {
				text = await getJobLabel(jobName);

				isTheFirst = false;
			} else {
				text += `, ${await getJobLabel(jobName)}`;
			}
		}

		allowedJobsDiv.val(text);
	} else {
		allowedJobsDiv.data("allowedJobs", null);
	}
}

async function setRequiredItem(requiresItem, requiredItem) {
	$("#requires-item").prop("checked", requiresItem).change();

	let requiredItemDiv = $("#required-item");

	requiredItemDiv.val(requiredItem);
}

$("#requires-code").change(function() {
	let isEnabled = $(this).prop("checked");

	$("#required-code").prop("disabled", !isEnabled).prop("required", isEnabled);;
})

function setRequiredCode(requiredCode) {
	$("#requires-code").prop("checked", requiredCode != undefined).change();
	
	$("#required-code").val(requiredCode);
}

function hideBuildingOptions() {
	$("#requires-job-div").hide();
	$("#requires-item-div").hide();
	$("#requires-code-div").hide();
	$("#auto-closure-div").hide();
	$("#default-doors-state-div").hide();
	$("#requires-identifier-div").hide();
}

function showBuildingOptions() {
	$("#requires-job-div").show();
	$("#requires-item-div").show();
	$("#requires-code-div").show();
	$("#auto-closure-div").show();
	$("#default-doors-state-div").show();
	$("#requires-identifier-div").show();
}

function setParentBuilding(buildingId) {
	if(buildingId != undefined) {
		$("#use-building-rules").prop("checked", true).change();
		$("#parent-building").data("buildingId", buildingId).val(buildings[buildingId].label);
	} else {
		$("#use-building-rules").prop("checked", false).change();
		$("#parent-building").data("buildingId", null).val("");
	}
}

function editDoor(doorsId) {
	setDoorsModalType("door");

	let doorModal = $("#door-modal");

	doorModal.find("input .form-control").val("");

	doorModal.data("doorsId", doorsId);

	// Converts from create modal to edit modal
	doorModal.data("action", "edit");
	
	$("#delete-door-btn").show();
	$("#save-door-btn").text( getLocalizedText("menu:save") );
	
	let doorsData = doors[doorsId];

	$("#door-label").val(doorsData.label);

	setUsedDoors(doorsData.doors);

	$(`input[name="doors-default-state"][value="${doorsData.defaultState}"]`).prop("checked", true);

	$("#maximum-distance").val(doorsData.maxDistance);

	setRequiredJob(doorsData.allowedJobs ? true : false, doorsData.allowedJobs);
	setRequiredItem(doorsData.requiredItem ? true : false, doorsData.requiredItem);
	setRequiredCode(doorsData.requiredCode);

	setAutoClosure(doorsData.autoClosureSeconds);

	setParentBuilding(doorsData.parentBuilding);

	$("#requires-job-and-item").prop("checked", doorsData.requiresJobAndItem);

	$("#is-sliding-door").prop("checked", doorsData.isSliding);
	$("#can-be-lockpicked").prop("checked", doorsData.canBeLockpicked);

	// Requires identifier
	$("#requires-identifier").prop("checked", doorsData.requiresIdentifier).change();

	// Add identifiers
	$("#allowed-identifiers").empty();
	if(doorsData.allowedIdentifiers) {
		for(const [identifier, _] of Object.entries(doorsData.allowedIdentifiers)) {
			addIdentifierToList(identifier);
		}
	}

	setVaultData(doorsData.vault);

	$("#icon-coords-x").val(doorsData.iconCoords.x).change();
	$("#icon-coords-y").val(doorsData.iconCoords.y).change();
	$("#icon-coords-z").val(doorsData.iconCoords.z).change();

	doorModal.modal("show");
}

function submitDoor() {
	let doorModal = $("#door-modal");

	let action = doorModal.data("action");

	let doorData = {
		label: $("#door-label").val(),
		defaultState: parseInt( $("input[name='doors-default-state']:checked").val() ),
		maxDistance: parseFloat( $("#maximum-distance").val() ),

		iconCoords: {
			x: parseFloat( $("#icon-coords-x").val() ),
			y: parseFloat( $("#icon-coords-y").val() ),
			z: parseFloat( $("#icon-coords-z").val() )
		},

		doors: getUsedDoors(),

		allowedJobs: $("#requires-job").prop("checked") ? $("#allowed-jobs").data("allowedJobs") : null,
		requiredItem: $("#requires-item").prop("checked") ? $("#required-item").val() : null,

		requiresJobAndItem: $("#requires-job-and-item").prop("checked"),

		requiredCode: $("#requires-code").prop("checked") ? $("#required-code").val() : null,

		autoClosureSeconds: $("#auto-closure-switch").prop("checked") ? parseInt( $("#auto-closure").val() ) : null,

		parentBuilding: $("#use-building-rules").prop("checked") ? $("#parent-building").data("buildingId") : null,

		isSliding: $("#is-sliding-door").prop("checked"),

		requiresIdentifier: $("#requires-identifier").prop("checked"),
		allowedIdentifiers: getAllowedIdentifiers(),

		vault: getVaultData(),

		canBeLockpicked: $("#can-be-lockpicked").prop("checked")
	}

	switch(action) {
		case "create": {
			$.post(`https://${resName}/createDoor`, JSON.stringify(doorData), function(isSuccessful) {
				if(isSuccessful) {
					loadDoors();
					doorModal.modal("hide");
				}
			});

			break;
		}

		case "edit": {
			let doorsId = doorModal.data("doorsId");

			$.post(`https://${resName}/updateDoor`, JSON.stringify({doorsId: doorsId, doorData: doorData}), function(isSuccessful) {
				if(isSuccessful) {
					loadDoors();
					doorModal.modal("hide");
				}
			});

			break;
		}
	}
}

function submitBuilding() {
	let buildingModal = $("#door-modal");

	let action = buildingModal.data("action");

	let buildingData = {
		label: $("#door-label").val(),
		defaultState: parseInt( $("input[name='doors-default-state']:checked").val() ),

		allowedJobs: $("#requires-job").prop("checked") ? $("#allowed-jobs").data("allowedJobs") : null,
		requiredItem: $("#requires-item").prop("checked") ? $("#required-item").val() : null,

		requiresJobAndItem: $("#requires-job-and-item").prop("checked"),

		requiredCode: $("#requires-code").prop("checked") ? $("#required-code").val() : null,

		autoClosureSeconds: $("#auto-closure-switch").prop("checked") ? parseInt( $("#auto-closure").val() ) : null,

		requiresIdentifier: $("#requires-identifier").prop("checked"),
		allowedIdentifiers: getAllowedIdentifiers()

	}

	switch(action) {
		case "create": {
			$.post(`https://${resName}/createBuilding`, JSON.stringify(buildingData), function(isSuccessful) {
				if(isSuccessful) {
					loadBuildings();
					buildingModal.modal("hide");
				}
			});

			break;
		}

		case "edit": {
			let buildingId = buildingModal.data("buildingId");

			$.post(`https://${resName}/updateBuilding`, JSON.stringify({buildingId: buildingId, buildingData: buildingData}), function(isSuccessful) {
				if(isSuccessful) {
					loadBuildings();
					buildingModal.modal("hide");
				}
			});
			
			break;
		}
	}
}

$("#door-form").submit(function(event) {
	if (!this.checkValidity()) {
		event.preventDefault();
		event.stopPropagation();

		return;
	} else {
		$(this).removeClass("was-validated");
	}

	let type = $("#door-modal").data("type");

	if(type == "door") {
		submitDoor();
	} else if(type == "building") {
		submitBuilding();
	}
})

$("#delete-door-btn").click(function() {
	let doorModal = $("#door-modal");

	let type = doorModal.data("type");

	switch(type) {
		case "door": {
			let doorsId = doorModal.data("doorsId");

			$.post(`https://${resName}/deleteDoor`, JSON.stringify({doorsId: doorsId}), function(isSuccessful) {
				if(isSuccessful) {
					loadDoors();
					doorModal.modal("hide");
				}
			});

			break;
		}

		case "building": {
			let buildingId = doorModal.data("buildingId");

			$.post(`https://${resName}/deleteBuilding`, JSON.stringify({buildingId: buildingId}), function(isSuccessful) {
				if(isSuccessful) {
					loadBuildings();
					doorModal.modal("hide");
				}
			});

			break;
		}
	}
});

/* DOORS - Jobs */
$("#requires-job").change(function() {
	let isEnabled = $(this).prop("checked");

	$("#choose-jobs-btn").prop("disabled", !isEnabled);
});

$("#choose-jobs-btn").click(async function() {
	let allowedJobs = await jobsDialog();

	setRequiredJob(allowedJobs ? true : false, allowedJobs);
});

/* DOORS - Item */
$("#requires-item").change(function() {
	let isEnabled = $(this).prop("checked");

	$("#choose-item-btn").prop("disabled", !isEnabled);
	$("#required-item").prop("disabled", !isEnabled);
	$("#required-item").prop("required", isEnabled);
});

$("#choose-item-btn").click(function() {
	itemsDialog(itemName => {
		if(itemName) {
			$("#required-item").val(itemName);
		}
	})
});

/* DOORS - Item & Job */
function requiresBothJobAndItem() {
	let requiresItem = $("#requires-item").prop("checked");
	let requiresJob = $("#requires-job").prop("checked");

	let requiresBoth = requiresItem && requiresJob;

	$("#requires-job-and-item-div").toggle(requiresBoth);

	if(!requiresBoth) {
		$("#requires-job-and-item").prop("checked", false);
	}
}
$("#requires-item, #requires-job").change(requiresBothJobAndItem);

/* DOORS - Auto closure */
$("#auto-closure-switch").change(function() {
	let isEnabled = $(this).prop("checked");

	$("#auto-closure").prop("disabled", !isEnabled);
})

function setAutoClosure(seconds) {
	$("#auto-closure-switch").prop("checked", seconds ? true : false).change();
	$("#auto-closure").val(seconds ? seconds : null);
}

/* BUILDINGS */
let buildingsDatatable = $("#buildings-container").DataTable( {
	"lengthMenu": [10, 15, 20],
	"createdRow": function ( row, data, index ) {
		$(row).addClass("clickable");

		$(row).click(function() {
			let buildingId = parseInt(data[0]);

			editBuilding(buildingId);
		})
	},
} );

let buildings = {};

function loadBuildings() {
    $.post(`https://${resName}/getAllBuildings`, {}, async function(rawBuildings) {
		// Manually create the table to avoid incompatibilities due table indexing

		buildings = {};

		for(const[k, buildingData] of Object.entries(rawBuildings)) {
			buildings[buildingData.id] = buildingData;
		}

		buildingsDatatable.clear();

		for(const[buildingId, buildingData] of Object.entries(buildings)) {
			buildingsDatatable.row.add([
				buildingId,
                buildingData.label,
                buildingData.defaultState === 0 ? getLocalizedText("menu:unlocked") : getLocalizedText("menu:locked"),
			])
		}

		buildingsDatatable.draw()
	})
}

$("#new-building-btn").click(function() {
	let buildingModal = $("#door-modal");

	setDoorsModalType("building");
	setupDefaultModalValues();

	buildingModal.data("action", "create");

	buildingModal.modal("show");
});

function editBuilding(buildingId) {
	let buildingData = buildings[buildingId];

	setDoorsModalType("building");

	let buildingModal = $("#door-modal");

	buildingModal.data("action", "edit");
	
	buildingModal.find("input .form-control").val("");
	buildingModal.data("buildingId", buildingId);

	// Converts from create modal to edit modal
	buildingModal.data("action", "edit");
	
	$("#delete-door-btn").show();
	$("#save-door-btn").text( getLocalizedText("menu:save") );
	
	$("#door-label").val(buildingData.label);

	$(`input[name="doors-default-state"][value="${buildingData.defaultState}"]`).prop("checked", true);

	setRequiredJob(buildingData.allowedJobs ? true : false, buildingData.allowedJobs);
	setRequiredItem(buildingData.requiredItem ? true : false, buildingData.requiredItem);
	setRequiredCode(buildingData.requiredCode);

	setAutoClosure(buildingData.autoClosureSeconds);

	$("#requires-job-and-item").prop("checked", buildingData.requiresJobAndItem);

	// Requires identifier
	$("#requires-identifier").prop("checked", buildingData.requiresIdentifier).change();

	// Add identifiers
	$("#allowed-identifiers").empty();
	if(buildingData.allowedIdentifiers) {
		for(const [identifier, _] of Object.entries(buildingData.allowedIdentifiers)) {
			addIdentifierToList(identifier);
		}
	}

	buildingModal.modal("show");
}

$("#use-building-rules").change(function() {
	let isEnabled = $(this).prop("checked");

	$("#choose-building-btn").prop("disabled", !isEnabled);

	if(isEnabled) {
		hideBuildingOptions();
	} else {
		showBuildingOptions();
	}
})

$("#choose-building-btn").click(function() {
	buildingsDialog(buildingId => {
		if(buildingId) {
			setParentBuilding(buildingId);
		}
	});
});

/* SETTINGS */
$("#settings_enableDoorlockAnimation").change(function() {
	let isEnabled = $(this).prop("checked");

	$("#doorlock-animation-div").find("input").prop("disabled", !isEnabled).prop("required", isEnabled);
})

function setDoorlockAnimation(doorLockAnimation) {
	$("#settings_enableDoorlockAnimation").prop("checked", doorLockAnimation.isEnabled).change();
	
	$("#settings_doorlockAnimationDictionary").val(doorLockAnimation.dict);
	$("#settings_doorlockAnimationName").val(doorLockAnimation.name);
	$("#settings_doorlockAnimationDuration").val(doorLockAnimation.duration);
}

function getDoorlockAnimation() {
	if( $("#settings_enableDoorlockAnimation").prop("checked") ) {
		let doorLockAnimation = {
			dict: $("#settings_doorlockAnimationDictionary").val(),
			name: $("#settings_doorlockAnimationName").val(),
			duration: parseInt( $("#settings_doorlockAnimationDuration").val() ),
			isEnabled: true
		}

		return doorLockAnimation;
	} else {
		let doorLockAnimation = {
			isEnabled: false
		}

		return doorLockAnimation;
	}
}

function loadSettings(fullConfig) {
	$("#settings_locale").val(fullConfig.locale);
	$("#settings_acePermission").val(fullConfig.acePermission);
	$("#settings_saveDoorStateAfterRestart").prop("checked", fullConfig.saveDoorStateAfterRestart);

	$("#settings_doorlockIconSize").val(fullConfig.doorLockIconSize);

	$("#settings_lockpickName").val(fullConfig.lockpickName);
	$("#settings_lockpickMinimumQuantity").val(fullConfig.lockpickMinimumQuantity);
	$("#settings_lockpickLoseOnUse").prop("checked", fullConfig.lockpickLoseOnUse);

	$("#settings_use3dTextInsteadOfIcon").prop("checked", fullConfig.use3dTextInsteadOfIcon);

	setDoorlockAnimation(fullConfig.doorLockAnimation);
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
		doorLockAnimation: getDoorlockAnimation(),
		doorLockIconSize: parseFloat( $("#settings_doorlockIconSize").val() ),
		use3dTextInsteadOfIcon: $("#settings_use3dTextInsteadOfIcon").prop("checked")
	}

	let sharedSettings = {
		locale: $("#settings_locale").val()
	}

	let serverSettings = {
		acePermission: $("#settings_acePermission").val(),
		saveDoorStateAfterRestart: $("#settings_saveDoorStateAfterRestart").prop("checked"),

		lockpickName: $("#settings_lockpickName").val(),
		lockpickMinimumQuantity: parseInt( $("#settings_lockpickMinimumQuantity").val() ),
		lockpickLoseOnUse: $("#settings_lockpickLoseOnUse").prop("checked"),
	}

	$.post(`https://${resName}/saveSettings`, JSON.stringify({
		clientSettings: clientSettings,
		sharedSettings: sharedSettings,
		serverSettings: serverSettings,
	}));

	refreshTranslations(sharedSettings.locale);
});

// Doors Identifiers 
$("#requires-identifier").change(function() {
	let isEnabled = $(this).prop("checked");

	$("#identifiers-div").find("input, button").prop("disabled", !isEnabled);
});

$("#is-vault-door").change(function() {
	let isEnabled = $(this).prop("checked");

	$("#vault-door-options").toggle(isEnabled);

	$("#vault-speed").prop("required", isEnabled);
})

function addIdentifierToList(identifier) {
	let allowedIdentifiers = $("#allowed-identifiers");

	let identifierDiv = $(`
		<li class="list-group-item mt-1" data-identifier="${identifier}">${identifier} <span class="btn-close float-end clickable"></span></li>
	`)

	identifierDiv.find(".btn-close").click(function() {
		$(this).parent().remove();
	});

	allowedIdentifiers.append(identifierDiv);
}

$("#add-identifier-btn").click(function() {
	let identifierDiv = $("#identifier-to-add")
	let identifier = identifierDiv.val();

	if(identifier) {
		addIdentifierToList(identifier);
		identifierDiv.val("");
	}
})

$("#choose-player-btn").click(function() {
	playersListDialog(identifier => {
		$("#identifier-to-add").val(identifier);
	});
})

function getAllowedIdentifiers() {
	let identifiers = {};

	$("#allowed-identifiers").find("li").each(function() {
		identifiers[$(this).data("identifier")] = true;
	});

	return identifiers;
}

function getVaultData() {
	if(!$("#is-vault-door").prop("checked"))
		return null;

	let vaultData = {
		speed: parseFloat( $("#vault-speed").val() ),
		doorHeavy: $("#vault-make-door-extremely-heavy").prop("checked"),
		invertedDirection: $("#vault-inverted-direction").prop("checked"),
		openedAngle: parseFloat( $("#vault-opened-angle").val() ),
		closedAngle: parseFloat( $("#vault-closed-angle").val() ),
	}

	return vaultData
}

function setVaultData(vaultData) {
	if(vaultData) {
		$("#is-vault-door").prop("checked", true).change();
		$("#vault-speed").val(vaultData.speed);
		$("#vault-make-door-extremely-heavy").prop("checked", vaultData.doorHeavy);
		$("#vault-inverted-direction").prop("checked", vaultData.invertedDirection);
		$("#vault-opened-angle").val(vaultData.openedAngle);
		$("#vault-closed-angle").val(vaultData.closedAngle);

	} else {
		$("#is-vault-door").prop("checked", false).change();
	}
}

// Open/Close menu
function openMenu(version, fullConfig) {
	$("#doors-creator-version").text(version);

    $("#doors_creator").show();

	loadBuildings();
    loadDoors();

	loadSettings(fullConfig);
}

function closeMenu() {
	// Resets current active tab
	$("#doors_creator").find(".nav-link, .tab-pane").each(function() {
		if($(this).data("isDefault") == "1") {
			$(this).addClass(["active", "show"])
		} else {
			$(this).removeClass(["active", "show"])
		}
	})
	
    $("#doors_creator").hide();

    $.post(`https://${resName}/close`, {})
}
$("#close-main-btn").click(closeMenu);

// Messages received by client
window.addEventListener('message', (event) => {
	let data = event.data;
	let action = data.action;

    if (action == 'openMenu') {
		openMenu(data.version, data.fullConfig);
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

$("#close-btn-not-allowed-menu").click(function() {
	$("#not-allowed-container").hide();
	closeMenu();
})