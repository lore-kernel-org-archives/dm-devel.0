From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 4/5] libmultipath: simplify basenamecpy()
Date: Tue, 17 Dec 2013 08:04:07 +0100
Message-ID: <1387263848-73945-5-git-send-email-hare@suse.de>
References: <1387263848-73945-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1387263848-73945-1-git-send-email-hare@suse.de>
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

strlcpy() already does a strlen() at the end, so no need
to call it explicitly.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/util.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/libmultipath/util.c b/libmultipath/util.c
index 93ab08b..06a6311 100644
--- a/libmultipath/util.c
+++ b/libmultipath/util.c
@@ -44,8 +44,7 @@ basenamecpy (const char * str1, char * str2, int str2len)
 
 	strncpy(str2, p, str2len);
 	str2[str2len - 1] = '\0';
-	strchop(str2);
-	return strlen(str2);
+	return strchop(str2);
 }
 
 int
-- 
1.7.12.4
