'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "assets/AssetManifest.json": "3c3f00794d4666e1fcb0547d28b3c756",
"assets/assets/images/bananaBunch.png": "529180d40f8688b792889bdd6f51869e",
"assets/assets/images/cards/10_of_clubs.png": "c29b28f3eceb7284d141163e3bd37736",
"assets/assets/images/cards/10_of_diamonds.png": "4324d71291ce16ef4161df8cf852298e",
"assets/assets/images/cards/10_of_hearts.png": "2e6327a66fbf8d05d379d87d56251a1e",
"assets/assets/images/cards/10_of_spades.png": "2401fe3648865f6bc3c01a538c512d7c",
"assets/assets/images/cards/2_of_clubs.png": "c83a7af4125e22d9733f6514295f3d4c",
"assets/assets/images/cards/2_of_diamonds.png": "0b5b5249b22ada06106be8b73938be9e",
"assets/assets/images/cards/2_of_hearts.png": "f97ad85b1e89af6a88c70205cdea06f6",
"assets/assets/images/cards/2_of_spades.png": "2354275da56e304199f694388a8aaae6",
"assets/assets/images/cards/3_of_clubs.png": "23a7a6ac76db02bbde27988e49ac5fca",
"assets/assets/images/cards/3_of_diamonds.png": "b529e1c14fef2ffc07c3c4eac94c31f4",
"assets/assets/images/cards/3_of_hearts.png": "1c16fe1052c3a4d1715ee1288209ebe9",
"assets/assets/images/cards/3_of_spades.png": "ad02dc95b434842c3465a7a4dbaca615",
"assets/assets/images/cards/4_of_clubs.png": "02deab4916f717f0b9478fad476ec40f",
"assets/assets/images/cards/4_of_diamonds.png": "58bd0a6383829cbce3747c245c0b204c",
"assets/assets/images/cards/4_of_hearts.png": "5ad913da63724447b7c94d1fb2d293a6",
"assets/assets/images/cards/4_of_spades.png": "df185c634b2fee0418bd613524938832",
"assets/assets/images/cards/5_of_clubs.png": "3781bf44a82cad8ef837e6ba281427c9",
"assets/assets/images/cards/5_of_diamonds.png": "e27b4b0aadc6a28953f53cfd573e9e2d",
"assets/assets/images/cards/5_of_hearts.png": "8f6a2068fd6f32c372ea8dab0cde6f40",
"assets/assets/images/cards/5_of_spades.png": "aa8a072015826f2e582a59e9606e0cd3",
"assets/assets/images/cards/6_of_clubs.png": "9c2fdf6a8916a2b3daea26a7974eed28",
"assets/assets/images/cards/6_of_diamonds.png": "ee5053d458469b151ef1f4503b5ab12f",
"assets/assets/images/cards/6_of_hearts.png": "9cd2258c8c8c175ead46f94800741891",
"assets/assets/images/cards/6_of_spades.png": "5d221b2a958bb6b66b4e57de437c0906",
"assets/assets/images/cards/7_of_clubs.png": "112be1dfa65edf2cabf9122b2c49eb22",
"assets/assets/images/cards/7_of_diamonds.png": "df3e8e93d277f2b73d2c5ddf348c065c",
"assets/assets/images/cards/7_of_hearts.png": "a9afa10fcea89a4227bb4b81f49a35e8",
"assets/assets/images/cards/7_of_spades.png": "c0f5e5f9013f1d24eccd395ab9312766",
"assets/assets/images/cards/8_of_clubs.png": "6ed0b85e676230d360186c3469b08cdf",
"assets/assets/images/cards/8_of_diamonds.png": "8afee604213ca296067245ce18458af2",
"assets/assets/images/cards/8_of_hearts.png": "e6c01b136dca0b2c3c03a115d4ab21e1",
"assets/assets/images/cards/8_of_spades.png": "747667555c7c5d6799ca3545463372b0",
"assets/assets/images/cards/9_of_clubs.png": "784ea7703fcff1e10745e014d98a24aa",
"assets/assets/images/cards/9_of_diamonds.png": "86608eb9bf92b21b9e33a1ffa4c46ccc",
"assets/assets/images/cards/9_of_hearts.png": "cdb8fda5b30f3973b1ec7f200c24a18f",
"assets/assets/images/cards/9_of_spades.png": "e5b29fdec7e761281073496181d31ab9",
"assets/assets/images/cards/ace_of_clubs.png": "07d1c180bead76a0b8cf8e488dfc2755",
"assets/assets/images/cards/ace_of_diamonds.png": "60b16fdaed475d30edab3bc92f4bd3c9",
"assets/assets/images/cards/ace_of_hearts.png": "41453bfa387b05e68828f2b0159c19d9",
"assets/assets/images/cards/ace_of_spades.png": "ce4f163fc9fddc4e9f173d74b2970cc2",
"assets/assets/images/cards/card_backside.png": "35c531fe880c4282ae850ae220c440df",
"assets/assets/images/cards/jack_of_clubs.png": "d96ecf4f3c246b8c781f82d1bb2bd1dc",
"assets/assets/images/cards/jack_of_diamonds.png": "c936f66eb6ca786d62a2c49876367017",
"assets/assets/images/cards/jack_of_hearts.png": "9be659a7f009932fe8f49a213c22e439",
"assets/assets/images/cards/jack_of_spades.png": "d77ce402c3977e303abeed8ec5bb35a5",
"assets/assets/images/cards/king_of_clubs.png": "f0dc748d3d36f265ab670c8ce0332e3d",
"assets/assets/images/cards/king_of_diamonds.png": "9588f72f2c9d6898c9af3b20bcde7c2f",
"assets/assets/images/cards/king_of_hearts.png": "e8d050e1412d4866d34f9a41b0c48238",
"assets/assets/images/cards/king_of_spades.png": "aebc913c5eb0ecd7859218636929c8ae",
"assets/assets/images/cards/queen_of_clubs.png": "fd943099b2abeb6cf01bebb4dc66cbbe",
"assets/assets/images/cards/queen_of_diamonds.png": "f91b8d276604290828523a097fd4af26",
"assets/assets/images/cards/queen_of_hearts.png": "8065dc2a89d1be1e9908343fb99d82cc",
"assets/assets/images/cards/queen_of_spades.png": "445df3cf193554d44a50f43d4597c324",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/fonts/MaterialIcons-Regular.otf": "95db9098c58fd6db106f1116bae85a0b",
"assets/NOTICES": "bede28d2c5519b8b1180fb2ef394afc3",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "6d342eb68f170c97609e9da345464e5e",
"assets/shaders/ink_sparkle.frag": "7df61621299d0edaf84ca1605b2a35db",
"canvaskit/canvaskit.js": "2bc454a691c631b07a9307ac4ca47797",
"canvaskit/canvaskit.wasm": "bf50631470eb967688cca13ee181af62",
"canvaskit/profiling/canvaskit.js": "38164e5a72bdad0faa4ce740c9b8e564",
"canvaskit/profiling/canvaskit.wasm": "95a45378b69e77af5ed2bc72b2209b94",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"flutter.js": "f85e6fb278b0fd20c349186fb46ae36d",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "791c3259db756ae3627dd6788e451e7b",
"/": "791c3259db756ae3627dd6788e451e7b",
"main.dart.js": "49930591d41fe8d3ecad9bed04bbdd45",
"manifest.json": "47c4715d481b48a4289c707760ad649b",
"version.json": "a7b28f7a1262e65a2ac10e3125b14d3d"
};

// The application shell files that are downloaded before a service worker can
// start.
const CORE = [
  "main.dart.js",
"index.html",
"assets/AssetManifest.json",
"assets/FontManifest.json"];
// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});

// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});

// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});

self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});

// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}

// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
