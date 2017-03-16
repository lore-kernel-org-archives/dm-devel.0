From: Milan Broz <gmazyland@gmail.com>
Subject: [PATCH 1/7] dm-crypt: Fix documentation of integrity
	table option.
Date: Thu, 16 Mar 2017 15:39:38 +0100
Message-ID: <20170316143944.19843-2-gmazyland@gmail.com>
References: <20170316143944.19843-1-gmazyland@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170316143944.19843-1-gmazyland@gmail.com>
In-Reply-To: <cover.1483551181.git.gmazyland@gmail.com>
References: <cover.1483551181.git.gmazyland@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: Milan Broz <gmazyland@gmail.com>
List-Id: dm-devel.ids

This patch updates old documentation to really implemented version,
previous "hmac" option was merged to the same processing path.

Signed-off-by: Milan Broz <gmazyland@gmail.com>
---
 Documentation/device-mapper/dm-crypt.txt | 20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

diff --git a/Documentation/device-mapper/dm-crypt.txt b/Documentation/device-mapper/dm-crypt.txt
index a2a6627aa659..058f26ddf875 100644
--- a/Documentation/device-mapper/dm-crypt.txt
+++ b/Documentation/device-mapper/dm-crypt.txt
@@ -94,20 +94,16 @@ submit_from_crypt_cpus
     same context.
 
 integrity:<bytes>:<type>
-    Calculates and verifies integrity for the encrypted device (uses
-    authenticated encryption). This mode requires metadata stored in per-bio
-    integrity structure of <bytes> in size.
+    The device requires additional <bytes> metadata per-sector stored
+    in per-bio integrity structure. This metadata must by provided
+    by underlying dm-integrity target.
 
-    This option requires that the underlying device is created by dm-integrity
-    target and provides exactly <bytes> of per-sector metadata.
+    The <type> can be "none" if metadata is used only for persistent IV.
 
-    There can by two options for <type>. The first one is used when encryption
-    mode is Authenticated mode (AEAD mode), then type must be just "aead".
-    The second option is integrity calculated by keyed hash (HMAC), then
-    <type> is for example "hmac(sha256)".
-
-    If random IV is used (persistently stored IV in metadata per-sector),
-    then <bytes> includes both space for random IV and authentication tag.
+    For Authenticated Encryption with Additional Data (AEAD)
+    the <type> is "aead". An AEAD mode additionally calculates and verifies
+    integrity for the encrypted device. The additional space is then
+    used for storing authentication tag (and persistent IV if needed).
 
 Example scripts
 ===============
-- 
2.11.0
