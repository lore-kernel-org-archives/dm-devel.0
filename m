From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 17/57] libmultipath: additional logging messages
	when formatting callout
Date: Wed, 27 Apr 2016 13:10:18 +0200
Message-ID: <1461755458-29225-18-git-send-email-hare@suse.de>
References: <1461755458-29225-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1461755458-29225-1-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@gmail.com>
Cc: Hannes Reinecke <hare@suse.com>, dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 libmultipath/callout.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/libmultipath/callout.c b/libmultipath/callout.c
index 4cbbd06..d671b0c 100644
--- a/libmultipath/callout.c
+++ b/libmultipath/callout.c
@@ -201,8 +201,10 @@ apply_format (char * string, char * cmd, struct path * pp)
 	}
 	pos++;
 
-	if (!*pos)
+	if (!*pos) {
+		condlog(3, "formatted callout = %s", dst);
 		return 0;
+	}
 
 	len = strlen(pos) + 1;
 	myfree -= len;
@@ -211,6 +213,6 @@ apply_format (char * string, char * cmd, struct path * pp)
 		return 1;
 
 	snprintf(p, len, "%s", pos);
-	condlog(3, "reformated callout = %s", dst);
+	condlog(3, "reformatted callout = %s", dst);
 	return 0;
 }
-- 
2.6.6
