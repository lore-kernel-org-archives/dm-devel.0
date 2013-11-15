From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 03/13] libmultipath: fixup strlcpy
Date: Fri, 15 Nov 2013 11:29:34 +0100
Message-ID: <1384511384-27642-4-git-send-email-hare@suse.de>
References: <1384511384-27642-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1384511384-27642-1-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

The final comparison was wrong; 'size' was never decreased.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/util.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/libmultipath/util.c b/libmultipath/util.c
index 41ac21b..a9f5939 100644
--- a/libmultipath/util.c
+++ b/libmultipath/util.c
@@ -112,8 +112,7 @@ size_t strlcpy(char *dst, const char *src, size_t size)
 		bytes++;
 	}
 
-	/* If size == 0 there is no space for a final null... */
-	if (size)
+	if (bytes == size)
 		*q = '\0';
 	return bytes;
 }
-- 
1.8.1.4
