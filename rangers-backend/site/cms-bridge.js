(()=>{
const api='../api/cms'; let edits=[];
function key(el){if(el.id)return '#'+el.id;let a=[];while(el&&el!==document.body){let n=el.tagName.toLowerCase(),i=1,s=el;while((s=s.previousElementSibling))if(s.tagName===el.tagName)i++;a.unshift(n+':nth-of-type('+i+')');el=el.parentElement;}return a.join(' > ');}
function page(){return new URLSearchParams(location.search).get('view')||'home';}
function media(v){if(v.startsWith('storage/uploads/'))return '../'+v;return v;}
function apply(){for(const e of edits){if(e.page_slug!=='global'&&e.page_slug!==page())continue;let node;try{node=document.querySelector(e.element_key)}catch(_){continue}if(!node)continue;
if(e.kind==='text')node.textContent=e.content;
if(e.kind==='html')node.innerHTML=e.content; // trusted admin only
if(e.kind==='image'&&node.tagName==='IMG')node.src=media(e.content);
if(e.kind==='video'&&node.tagName==='VIDEO')node.src=media(e.content);
if(e.kind==='link'&&node.tagName==='A')node.href=e.content;
if(e.kind==='style')node.style.cssText=e.content;
}}
async function refresh(){try{let r=await fetch(api+'?page='+encodeURIComponent(page()),{cache:'no-store'});if(r.ok){edits=(await r.json()).elements||[];apply()}}catch(e){console.warn('CMS unavailable',e)}}
const obs=new MutationObserver(()=>{if(!window.__cmsApplying){window.__cmsApplying=true;queueMicrotask(()=>{obs.disconnect();apply();obs.observe(document.getElementById('appMain')||document.body,{childList:true,subtree:true});window.__cmsApplying=false})}});
window.RangersCMS={apply,refresh,key,page};
window.addEventListener('popstate',refresh);document.addEventListener('click',e=>{if(e.target.closest('[data-route]'))setTimeout(refresh,90)},true);
document.addEventListener('DOMContentLoaded',()=>{refresh();obs.observe(document.getElementById('appMain')||document.body,{childList:true,subtree:true})});
if(new URLSearchParams(location.search).has('cms_preview')){
const css=document.createElement('style');css.textContent='[data-cms-hover]{outline:2px solid #e8a500!important;outline-offset:2px;cursor:crosshair!important}';document.head.append(css);
document.addEventListener('mouseover',e=>{document.querySelectorAll('[data-cms-hover]').forEach(x=>x.removeAttribute('data-cms-hover'));if(e.target.closest('#appMain,#siteHeader,#siteFooter'))e.target.setAttribute('data-cms-hover','')});
document.addEventListener('click',e=>{const boundary=e.target.closest('#appMain,#siteHeader,#siteFooter');if(!boundary)return;e.preventDefault();e.stopPropagation();const el=e.target.closest('img,video,a,button,[data-cms-editable]')||(e.target.nodeType===1?e.target:e.target.parentElement);if(!el||!boundary.contains(el))return;let kind=el.tagName==='IMG'?'image':el.tagName==='VIDEO'?'video':el.tagName==='A'?'link':'text';let value=kind==='image'||kind==='video'?el.getAttribute('src'):kind==='link'?el.getAttribute('href'):el.textContent.trim();window.parent.postMessage({type:'rangers-cms-select',key:key(el),page:el.closest('#siteHeader,#siteFooter')?'global':page(),kind,value:value.slice(0,100000)},location.origin)},true);
}
})();