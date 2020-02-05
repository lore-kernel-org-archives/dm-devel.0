From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH v2 12/17] libmultipath: change failed path prio
	timeout
Date: Wed,  5 Feb 2020 12:58:15 -0600
Message-ID: <1580929100-32572-13-git-send-email-bmarzins@redhat.com>
References: <1580929100-32572-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1580929100-32572-1-git-send-email-bmarzins@redhat.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, Martin Wilck <Martin.Wilck@suse.com>
List-Id: dm-devel.ids

multipath will try to get the priority from a PATH_DOWN path, if the
path doesn't currently have a valid priority. However, if the priority
code needs to contact the device to get the priority, this is likely to
fail for PATH_DOWN paths.  This code dates back to when multipathd could
not easily reload device tables with failed paths, so getting the
correct priority was important to have a correctly configured device.
Now multipathd can simply reload the device to move the path to the
correct pathgroup when the path comes back up.  Since there are a number
of prioritizers that don't require talking to the device, multipath
shouldn't completely skip attempting to get the priority of these paths,
but it should set a small timeout, so that it isn't hanging in the
case where it needs to contact a device through a failed path.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/discovery.c | 14 ++++++--------
 libmultipath/prio.c      |  6 +++---
 2 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index bee5b77b..5e88d980 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -1667,11 +1667,10 @@ get_state (struct path * pp, struct config *conf, int daemon, int oldstate)
 }
 
 static int
-get_prio (struct path * pp)
+get_prio (struct path * pp, int timeout)
 {
 	struct prio * p;
 	struct config *conf;
-	int checker_timeout;
 	int old_prio;
 
 	if (!pp)
@@ -1690,11 +1689,8 @@ get_prio (struct path * pp)
 			return 1;
 		}
 	}
-	conf = get_multipath_config();
-	checker_timeout = conf->checker_timeout;
-	put_multipath_config(conf);
 	old_prio = pp->priority;
-	pp->priority = prio_getprio(p, pp, checker_timeout);
+	pp->priority = prio_getprio(p, pp, timeout);
 	if (pp->priority < 0) {
 		/* this changes pp->offline, but why not */
 		int state = path_offline(pp);
@@ -2101,11 +2097,13 @@ int pathinfo(struct path *pp, struct config *conf, int mask)
 
 	 /*
 	  * Retrieve path priority, even for PATH_DOWN paths if it has never
-	  * been successfully obtained before.
+	  * been successfully obtained before. If path is down don't try
+	  * for too long.
 	  */
 	if ((mask & DI_PRIO) && path_state == PATH_UP && strlen(pp->wwid)) {
 		if (pp->state != PATH_DOWN || pp->priority == PRIO_UNDEF) {
-			get_prio(pp);
+			get_prio(pp, (pp->state != PATH_DOWN)?
+				     (conf->checker_timeout * 1000) : 10);
 		}
 	}
 
diff --git a/libmultipath/prio.c b/libmultipath/prio.c
index 87de1f97..194563c4 100644
--- a/libmultipath/prio.c
+++ b/libmultipath/prio.c
@@ -10,11 +10,11 @@
 
 static LIST_HEAD(prioritizers);
 
-unsigned int get_prio_timeout(unsigned int checker_timeout,
+unsigned int get_prio_timeout(unsigned int timeout_ms,
 			      unsigned int default_timeout)
 {
-	if (checker_timeout)
-		return checker_timeout * 1000;
+	if (timeout_ms)
+		return timeout_ms;
 	return default_timeout;
 }
 
-- 
2.17.2
