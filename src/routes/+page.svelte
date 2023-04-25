<script lang="ts">
	import { env } from '$env/dynamic/public';
</script>
<h1>Welcome to SvelteKit</h1>
<p>Visit <a href={env.PUBLIC_MY_LINK_URL}>{env.PUBLIC_MY_LINK_NAME}</a></p>
