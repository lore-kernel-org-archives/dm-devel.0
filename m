From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 2/3] alua prioritizer: Fix typo 'perf'
Date: Fri, 15 Jul 2016 08:48:56 +0200
Message-ID: <1468565337-5178-3-git-send-email-hare@suse.de>
References: <1468565337-5178-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1468565337-5178-1-git-send-email-hare@suse.de>
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
Cc: Hannes Reinecke <hare@suse.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

The bit is called the 'preferred_path' bit. Nothing do to with
performance.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 libmultipath/prioritizers/alua.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/libmultipath/prioritizers/alua.c b/libmultipath/prioritizers/alua.c
index b6c5176..6650a20 100644
--- a/libmultipath/prioritizers/alua.c
+++ b/libmultipath/prioritizers/alua.c
@@ -75,7 +75,7 @@ get_alua_info(struct path * pp, unsigned int timeout)
 	return rc;
 }
 
-int get_exclusive_perf_arg(char *args)
+int get_exclusive_pref_arg(char *args)
 {
 	char *ptr;
 
@@ -96,12 +96,12 @@ int getprio (struct path * pp, char * args, unsigned int timeout)
 	int rc;
 	int aas;
 	int priopath;
-	int exclusive_perf;
+	int exclusive_pref;
 
 	if (pp->fd < 0)
 		return -ALUA_PRIO_NO_INFORMATION;
 
-	exclusive_perf = get_exclusive_perf_arg(args);
+	exclusive_pref = get_exclusive_pref_arg(args);
 	rc = get_alua_info(pp, timeout);
 	if (rc >= 0) {
 		aas = (rc & 0x0f);
@@ -122,7 +122,7 @@ int getprio (struct path * pp, char * args, unsigned int timeout)
 			default:
 				rc = 0;
 		}
-		if (priopath && (aas != AAS_OPTIMIZED || exclusive_perf))
+		if (priopath && (aas != AAS_OPTIMIZED || exclusive_pref))
 			rc += 80;
 	} else {
 		switch(-rc) {
-- 
2.6.6
