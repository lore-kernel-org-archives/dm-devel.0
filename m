From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 03/15] Revert "libmultipath: fixup strlcpy"
Date: Sat,  7 Mar 2015 21:31:34 -0600
Message-ID: <1425785506-20419-4-git-send-email-bmarzins@redhat.com>
References: <1425785506-20419-1-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1425785506-20419-1-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

This reverts commit 3a64d6491a1e83adcaf5f97edd18b7898dce241d.

strlcpy already had a check to make sure that as long as the size passed in
wasn't zero, it would leave enough space to write the final null. So, the
only check that was necessary was to see if strlcpy was called with
size = 0.

strlcpy returns the number of bytes that it took, or would take, to write
the entire string. There is no reason why bytes would usually end up
equalling size, so this commit caused strlcpy to stop null terminating many
strings.

Cc: "Hannes Reinecke <hare@suse.de>"
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/util.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/libmultipath/util.c b/libmultipath/util.c
index b8487ac..ac0d1b2 100644
--- a/libmultipath/util.c
+++ b/libmultipath/util.c
@@ -112,7 +112,8 @@ size_t strlcpy(char *dst, const char *src, size_t size)
 		bytes++;
 	}
 
-	if (bytes == size)
+	/* If size == 0 there is no space for a final null... */
+	if (size)
 		*q = '\0';
 	return bytes;
 }
-- 
1.8.3.1
