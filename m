From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH v2 1/4] mpathpersist: remove broken/unused code
Date: Fri, 13 Sep 2019 17:04:01 -0500
Message-ID: <1568412244-23982-2-git-send-email-bmarzins@redhat.com>
References: <1568412244-23982-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1568412244-23982-1-git-send-email-bmarzins@redhat.com>
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

The test for an empty pp->dev in updatepaths() dates back to when
disassemble_map() didn't fill in pp->dev for newly added paths, and it
was meant to catch paths that got added by disassemble_map().  With the
mpathpersist speedup code, all paths get added by disassemble_map().
However, disassemble_map() now calls devt2devname() to set pp->dev if
possible.  This means that there is no point in calling devt2devname()
again in updatepaths(). If for some reason it did return success, the
current code would still fail, since it doesn't set pp->udev in this
code path. The best thing to do if disassemble_map() couldn't set
pp->dev is simply to fail the path.

Reviewed-by: Martin Wilck <mwilck@suse.com>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmpathpersist/mpath_persist.c | 16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/libmpathpersist/mpath_persist.c b/libmpathpersist/mpath_persist.c
index 53022f5b..603cfc3b 100644
--- a/libmpathpersist/mpath_persist.c
+++ b/libmpathpersist/mpath_persist.c
@@ -82,18 +82,10 @@ updatepaths (struct multipath * mpp)
 
 		vector_foreach_slot (pgp->paths, pp, j){
 			if (!strlen(pp->dev)){
-				if (devt2devname(pp->dev, FILE_NAME_SIZE,
-						 pp->dev_t)){
-					/*
-					 * path is not in sysfs anymore
-					 */
-					pp->state = PATH_DOWN;
-					continue;
-				}
-				pp->mpp = mpp;
-				conf = get_multipath_config();
-				pathinfo(pp, conf, DI_ALL);
-				put_multipath_config(conf);
+				/*
+				 * path is not in sysfs anymore
+				 */
+				pp->state = PATH_DOWN;
 				continue;
 			}
 			pp->mpp = mpp;
-- 
2.17.2
