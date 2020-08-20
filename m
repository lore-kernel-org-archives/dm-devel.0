From: Milan Broz <gmazyland@gmail.com>
Subject: [PATCH] dm-crypt: Document encrypted keyring key option.
Date: Thu, 20 Aug 2020 21:20:26 +0200
Message-ID: <20200820192026.34617-1-gmazyland@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
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

Commit 27f5411a718c431c20007e3a2fbba6589942d04f introduced
support for encrypted keyring type.

This patch fixes documentation in admin guide to mention this type.

Signed-off-by: Milan Broz <gmazyland@gmail.com>
---
 Documentation/admin-guide/device-mapper/dm-crypt.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/device-mapper/dm-crypt.rst b/Documentation/admin-guide/device-mapper/dm-crypt.rst
index 94466921415d..64d678411cc0 100644
--- a/Documentation/admin-guide/device-mapper/dm-crypt.rst
+++ b/Documentation/admin-guide/device-mapper/dm-crypt.rst
@@ -67,7 +67,7 @@ Parameters::
     the value passed in <key_size>.
 
 <key_type>
-    Either 'logon' or 'user' kernel key type.
+    Either 'logon', 'user' or 'encrypted' kernel key type.
 
 <key_description>
     The kernel keyring key description crypt target should look for
-- 
2.28.0
