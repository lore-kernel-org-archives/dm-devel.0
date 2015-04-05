From: Milan Broz <gmazyland@gmail.com>
Subject: [PATCH] dm-crypt: Update URLs to new cryptsetup project
	page.
Date: Sun,  5 Apr 2015 18:03:10 +0200
Message-ID: <1428249790-13835-1-git-send-email-gmazyland@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
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

Cryptsetup home page moved to GitLab.
Also remove link to abandonded Truecrypt page.

Signed-off-by: Milan Broz <gmazyland@gmail.com>
---
 Documentation/device-mapper/dm-crypt.txt | 4 ++--
 Documentation/device-mapper/verity.txt   | 4 ++--
 drivers/md/dm-crypt.c                    | 2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/Documentation/device-mapper/dm-crypt.txt b/Documentation/device-mapper/dm-crypt.txt
index ad69778..692171f 100644
--- a/Documentation/device-mapper/dm-crypt.txt
+++ b/Documentation/device-mapper/dm-crypt.txt
@@ -5,7 +5,7 @@ Device-Mapper's "crypt" target provides transparent encryption of block devices
 using the kernel crypto API.
 
 For a more detailed description of supported parameters see:
-http://code.google.com/p/cryptsetup/wiki/DMCrypt
+https://gitlab.com/cryptsetup/cryptsetup/wikis/DMCrypt
 
 Parameters: <cipher> <key> <iv_offset> <device path> \
 	      <offset> [<#opt_params> <opt_params>]
@@ -80,7 +80,7 @@ Example scripts
 ===============
 LUKS (Linux Unified Key Setup) is now the preferred way to set up disk
 encryption with dm-crypt using the 'cryptsetup' utility, see
-http://code.google.com/p/cryptsetup/
+https://gitlab.com/cryptsetup/cryptsetup
 
 [[
 #!/bin/sh
diff --git a/Documentation/device-mapper/verity.txt b/Documentation/device-mapper/verity.txt
index 9884681..0075f70 100644
--- a/Documentation/device-mapper/verity.txt
+++ b/Documentation/device-mapper/verity.txt
@@ -125,7 +125,7 @@ block boundary) are the hash blocks which are stored a depth at a time
 
 The full specification of kernel parameters and on-disk metadata format
 is available at the cryptsetup project's wiki page
-  http://code.google.com/p/cryptsetup/wiki/DMVerity
+  https://gitlab.com/cryptsetup/cryptsetup/wikis/DMVerity
 
 Status
 ======
@@ -142,7 +142,7 @@ Set up a device:
 
 A command line tool veritysetup is available to compute or verify
 the hash tree or activate the kernel device. This is available from
-the cryptsetup upstream repository http://code.google.com/p/cryptsetup/
+the cryptsetup upstream repository https://gitlab.com/cryptsetup/cryptsetup/
 (as a libcryptsetup extension).
 
 Create hash on the device:
diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 713a962..ea09d54 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -228,7 +228,7 @@ static struct crypto_ablkcipher *any_tfm(struct crypt_config *cc)
  *
  * tcw:  Compatible implementation of the block chaining mode used
  *       by the TrueCrypt device encryption system (prior to version 4.1).
- *       For more info see: http://www.truecrypt.org
+ *       For more info see: https://gitlab.com/cryptsetup/cryptsetup/wikis/TrueCryptOnDiskFormat
  *       It operates on full 512 byte sectors and uses CBC
  *       with an IV derived from initial key and the sector number.
  *       In addition, whitening value is applied on every sector, whitening
-- 
2.1.4
