From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 19/20] libmultipath: decrease log level of
	uevent filter/merge messages
Date: Mon, 19 Mar 2018 16:01:54 +0100
Message-ID: <20180319150155.5363-20-mwilck@suse.com>
References: <20180319150155.5363-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180319150155.5363-1-mwilck@suse.com>
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
Cc: Martin Wilck <mwilck@suse.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

There should be no need to log these at -v2. The messages are
informational.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/uevent.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/libmultipath/uevent.c b/libmultipath/uevent.c
index c6a9e8b485ab..7e2e0f6761f7 100644
--- a/libmultipath/uevent.c
+++ b/libmultipath/uevent.c
@@ -330,7 +330,7 @@ uevent_filter(struct uevent *later, struct list_head *tmpq)
 		 * by the later uevent
 		 */
 		if (uevent_can_filter(earlier, later)) {
-			condlog(2, "uevent: %s-%s has filtered by uevent: %s-%s",
+			condlog(3, "uevent: %s-%s has filtered by uevent: %s-%s",
 				earlier->kernel, earlier->action,
 				later->kernel, later->action);
 
@@ -354,7 +354,7 @@ uevent_merge(struct uevent *later, struct list_head *tmpq)
 		 * merge earlier uevents to the later uevent
 		 */
 		if (uevent_can_merge(earlier, later)) {
-			condlog(2, "merged uevent: %s-%s-%s with uevent: %s-%s-%s",
+			condlog(3, "merged uevent: %s-%s-%s with uevent: %s-%s-%s",
 				earlier->action, earlier->kernel, earlier->wwid,
 				later->action, later->kernel, later->wwid);
 
-- 
2.16.1
