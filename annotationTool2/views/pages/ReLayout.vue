<template>
  <div class="rewidth">
    <router-view/>
  </div>
</template>

<script>
export default {
    name: 'ReLayout'
};
</script>

<style scoped>
.rewidth {
    margin-left: auto;
    margin-right: auto;
    max-width: 700px;
}
</style>
