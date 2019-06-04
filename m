From: Helen Koike <helen.koike@collabora.com>
Subject: [PATCH] Documentation/dm-init: fix multi device example
Date: Tue,  4 Jun 2019 15:27:19 -0300
Message-ID: <20190604182719.15944-1-helen.koike@collabora.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: dm-devel@redhat.com, swboyd@chromium.org
Cc: wad@chromium.org, keescook@chromium.org, snitzer@redhat.com, linux-doc@vger.kernel.org, richard.weinberger@gmail.com, linux-kernel@vger.kernel.org, linux-lvm@redhat.com, enric.balletbo@collabora.com, kernel@collabora.com, agk@redhat.com, Helen Koike <helen.koike@collabora.com>, Jonathan Corbet <corbet@lwn.net>
List-Id: dm-devel.ids

The example in the docs regarding multiple device-mappers is invalid (it
has a wrong number of arguments), it's a left over from previous
versions of the patch.
Replace the example with an valid and tested one.

Signed-off-by: Helen Koike <helen.koike@collabora.com>

---

 Documentation/device-mapper/dm-init.txt | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/Documentation/device-mapper/dm-init.txt b/Documentation/device-mapper/dm-init.txt
index 8464ee7c01b8..130b3c3679c5 100644
--- a/Documentation/device-mapper/dm-init.txt
+++ b/Documentation/device-mapper/dm-init.txt
@@ -74,13 +74,13 @@ this target to /dev/mapper/lroot (depending on the rules). No uuid was assigned.
 An example of multiple device-mappers, with the dm-mod.create="..." contents is shown here
 split on multiple lines for readability:
 
-  vroot,,,ro,
-    0 1740800 verity 254:0 254:0 1740800 sha1
-      76e9be054b15884a9fa85973e9cb274c93afadb6
-      5b3549d54d6c7a3837b9b81ed72e49463a64c03680c47835bef94d768e5646fe;
-  vram,,,rw,
-    0 32768 linear 1:0 0,
-    32768 32768 linear 1:1 0
+  dm-linear,,1,rw,
+    0 32768 linear 8:1 0,
+    32768 1024000 linear 8:2 0;
+  dm-verity,,3,ro,
+    0 1638400 verity 1 /dev/sdc1 /dev/sdc2 4096 4096 204800 1 sha256
+    ac87db56303c9c1da433d7209b5a6ef3e4779df141200cbd7c157dcb8dd89c42
+    5ebfe87f7df3235b80a117ebc4078e44f55045487ad4a96581d1adb564615b51
 
 Other examples (per target):
 
-- 
2.20.1
