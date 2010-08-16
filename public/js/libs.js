function inputPlaceholder(input,color){if(!input){return null}if(input.placeholder&&"placeholder" in document.createElement(input.tagName)){return input}color=color||"#AAA";var default_color=input.style.color;var placeholder=input.getAttribute("placeholder");if(input.value===""||input.value==placeholder){input.value=placeholder;input.style.color=color;input.setAttribute("data-placeholder-visible","true")}var add_event=
/*@cc_on'attachEvent'||@*/
"addEventListener";input[add_event](
/*@cc_on'on'+@*/
"focus",function(){input.style.color=default_color;if(input.getAttribute("data-placeholder-visible")){input.setAttribute("data-placeholder-visible","");input.value=""}},false);input[add_event](
/*@cc_on'on'+@*/
"blur",function(){if(input.value===""){input.setAttribute("data-placeholder-visible","true");input.value=placeholder;input.style.color=color}else{input.style.color=default_color;input.setAttribute("data-placeholder-visible","")}},false);input.form&&input.form[add_event](
/*@cc_on'on'+@*/
"submit",function(){if(input.getAttribute("data-placeholder-visible")){input.value=""}},false);return input};