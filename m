From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 2/4] libmultipath: decrease log level of uevent
	filter/merge messages
Date: Wed,  4 Apr 2018 18:21:58 +0200
Message-ID: <20180404162200.6518-3-mwilck@suse.com>
References: <20180404162200.6518-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180404162200.6518-1-mwilck@suse.com>
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
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

There should be no need to log these at -v2. The messages are
informational.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/uevent.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/libmultipath/uevent.c b/libmultipath/uevent.c
index 3955c49..fd8ca35 100644
--- a/libmultipath/uevent.c
+++ b/libmultipath/uevent.c
@@ -333,7 +333,7 @@ uevent_filter(struct uevent *later, struct list_head *tmpq)
 		 * by the later uevent
 		 */
 		if (uevent_can_filter(earlier, later)) {
-			condlog(2, "uevent: %s-%s has filtered by uevent: %s-%s",
+			condlog(3, "uevent: %s-%s has filtered by uevent: %s-%s",
 				earlier->kernel, earlier->action,
 				later->kernel, later->action);
 
@@ -357,7 +357,7 @@ uevent_merge(struct uevent *later, struct list_head *tmpq)
 		 * merge earlier uevents to the later uevent
 		 */
 		if (uevent_can_merge(earlier, later)) {
-			condlog(2, "merged uevent: %s-%s-%s with uevent: %s-%s-%s",
+			condlog(3, "merged uevent: %s-%s-%s with uevent: %s-%s-%s",
 				earlier->action, earlier->kernel, earlier->wwid,
 				later->action, later->kernel, later->wwid);
 
-- 
2.16.1
