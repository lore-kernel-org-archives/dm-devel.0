From: Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH] docs: device-mapper: Add dm-clone to documentation index
Date: Tue, 26 Nov 2019 19:56:27 +0100
Message-ID: <20191126185627.970-1-geert+renesas@glider.be>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Nikos Tsironis <ntsironis@arrikto.com>, Ilias Tsitsimpis <iliastsi@arrikto.com>, Jonathan Corbet <corbet@lwn.net>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert+renesas@glider.be>
List-Id: dm-devel.ids

When the dm-clone documentation was added, it was not added to the
documentation index, leading to a warning when building the
documentation:

    Documentation/admin-guide/device-mapper/dm-clone.rst: WARNING: document isn't included in any toctree

Fixes: 7431b7835f554f86 ("dm: add clone target")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 Documentation/admin-guide/device-mapper/index.rst | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/admin-guide/device-mapper/index.rst b/Documentation/admin-guide/device-mapper/index.rst
index 4872fb6d29524593..ec62fcc8eeceed83 100644
--- a/Documentation/admin-guide/device-mapper/index.rst
+++ b/Documentation/admin-guide/device-mapper/index.rst
@@ -8,6 +8,7 @@ Device Mapper
     cache-policies
     cache
     delay
+    dm-clone
     dm-crypt
     dm-dust
     dm-flakey
