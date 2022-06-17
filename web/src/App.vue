<script setup>
import { ref, onMounted, onUnmounted } from 'vue'
const events = ref({
	active: [],
	inactive: []
})

const activePanel = ref(false);
const currentEvent = ref({
	title: '',
	description: '',
	duration: 1,
})

const fetchNui = async (cbName, data) => {
	const options = {
		method: 'POST',
		headers: {
			'Content-Type': 'application/json; charset=utf-8',
		},
		body: JSON.stringify(data),
	}
	const name = window.GetParentResourceName ? GetParentResourceName() : 'test-nui'
	const resp = await fetch(`https://${name}/${cbName}`, options);
	return await resp.json();
}

const createEvent = () => {
	if (currentEvent.value.title === '' || currentEvent.value.description === '') return
	fetchNui('create_event', {
		title: currentEvent.value.title,
		description: currentEvent.value.description,
		duration: currentEvent.value.duration,
	}).then(() => {
		currentEvent.value = {
			title: '',
			description: '',
			duration: 1,
		}
		activePanel.value = false
	})
}

const addEvent = (event) => {
  if (!event) return
  // Find the matching logo from the job
  const logo = "https://pngimg.com/uploads/bmw_logo/bmw_logo_PNG19705.png"
  // Add the event to the active events array and sort it
  console.log(JSON.stringify(events.value.active))
  if (!logo) return

  if (events.value.active.find(e => e.id === event.id)) return
  events.value.active.push({
    id: event.id,
		title: event.title,
		description: event.description,
		duration: event.duration,
		time: new Date(),
		active: true,
		logo: logo,
		coords: event.coords,
  })
  events.value.active.sort((a, b) => a.time - b.time)
  console.log(JSON.stringify(events.value.active))
  setTimeout(() => {
    moveEvent(event.id)
  }, event.duration * 60000)
}

const moveEvent = (id) => {
  if (!id) return
  const event = events.value.active.find(e => e.id === id)
  if (!event) return
  event.active = false
  events.value.active.splice(events.value.active.indexOf(event), 1)
  events.value.inactive.push(event)
}

const closePanel = () => {
	fetchNui('close_nui').then((resp) => {
		if (resp.success) {
			activePanel.value = false
		}
	})
}

const messageHandler = (e) => {
	switch (e.data.action) {
    case 'showEvent':
      activePanel.value = true
      break
		case 'startEvent':
			addEvent(e.data.event)
			break
	}
}

onMounted(() => window.addEventListener('message', messageHandler))
onUnmounted(() => window.removeEventListener('message', messageHandler))
</script>

<template>
  <div class="absolute top-0 left-0 w-96 h-96 bg-slate-700">
    <span v-for="event in events.active">
      {{ event }}
    </span>
    Hola
  </div>
  <transition name="slide-up">
		<div v-if="activePanel" class="absolute w-[25em] bg-[#1a1a1bf2] rounded-xl shadow-xl flex flex-col items-center justify-start">
			<div class="flex justify-between w-5/6">
				<h1 class="self-start text-neutral-200 font-bold text-2xl mt-4 underline">Nuevo evento</h1>
				<button @click="closePanel" class="focus:ring-2 focus:ring-yellow-600 focus:text-yellow-500 bg-neutral-700 h-8 w-8 font-semibold text-gray-400 hover:underline mt-4 hover:text-yellow-500 transition duration-150 rounded">
					<i class="fa-solid fa-xmark"></i>
				</button>
			</div>
			<form class="w-full flex flex-col items-center mt-3" name="send" method="POST" @submit="createEvent">
				<div class="flex justify-between items-center w-5/6 mb-1 font-semibold">
					<label class="text-neutral-200 text-sm" for="title">Titulo</label>
					<span class="text-sm text-neutral-300">{{ currentEvent.title.length }}/30</span>
				</div>
				<input v-model="currentEvent.title" required name="title" maxlength="30" type="text" class="bg-neutral-700 rounded-sm text-md font-light px-2 w-5/6 py-1 mb-2 text-neutral-200">
				<div class="flex justify-between items-center w-5/6 mb-1 font-semibold">
					<label class="text-neutral-200 text-sm" for="description">Descripcion</label>
					<span type="text" class="text-sm text-neutral-300">{{ currentEvent.description.length }}/250</span>
				</div>
				<textarea v-model="currentEvent.description" required name="description" maxlength="250" class="resize-none bg-neutral-700 rounded-sm font-light h-32 px-2 w-5/6 py-1 mb-2 text-neutral-200"/>
				<div class="flex justify-between items-center w-5/6 mb-1 font-semibold">
					<label class="text-neutral-200 text-sm" for="duration">Duracion (min)</label>
					<span type="text" class="text-sm text-neutral-300">{{ currentEvent.duration }}m</span>
				</div>
				<input v-model="currentEvent.duration" type="range" step="1" min="1" max="60" required name="duration" class="slider bg-neutral-700 rounded-sm font-light w-5/6 text-neutral-200">
				<button type="submit" value="Submit" class="bg-neutral-700 mb-4 mt-3 hover:bg-[#ffa200] font-bold w-5/6 py-1 text-neutral-100 text-md rounded-sm transition duration-150">Crear evento</button>
			</form>
		</div>
	</transition>
</template>

<style>
@import url('https://fonts.googleapis.com/css2?family=Inter:wght@100;300;400;500;600;700;800;900&display=swap');

#app {
	margin: 0;
	font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Roboto', 'Oxygen',
	'Ubuntu', 'Cantarell', 'Fira Sans', 'Droid Sans', 'Helvetica Neue',
	sans-serif;
	-webkit-font-smoothing: antialiased;
	-moz-osx-font-smoothing: grayscale;
	height: 100vh;
	display: flex;
	justify-content: center;
	align-items: center;
}

button, input, textarea, span {
  outline: none;
}

.slider {
	-webkit-appearance: none;
	-webkit-transition: .2s;
	transition: opacity .2s;
	height: 0.8em;
	margin-top: 4px;
}

.slider::-webkit-slider-thumb {
	-webkit-appearance: none;
	appearance: none;
	width: 18px;
	height: 18px;
	border-radius: 2px;
	background: #ffa200;
	cursor: pointer;
	opacity: 0.8;
	transition: opacity .2s;
}

.slider::-webkit-slider-thumb:hover {
	opacity: 1;
}

input::-webkit-outer-spin-button,
input::-webkit-inner-spin-button {
	-webkit-appearance: none;
	margin: 0;
}

::-webkit-scrollbar {
	width: 4px;
	border-radius: 8px;
	background: #464545;
}

::-webkit-scrollbar-thumb {
	background: #505050;
	border-radius: 8px;
}

.slide-up-enter-active {
	transition: all 0.25s cubic-bezier(.68,.83,.75,.91);
}
.slide-up-leave-active {
	transition: all 0.25s cubic-bezier(.68,.83,.75,.91);
}
.slide-up-enter-from,
.slide-up-leave-to {
	transform: translateY(60px);
	opacity: 0;
}
</style>
