From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 01/21] libmultipath: fix use of uninitialized
	memory in write()
Date: Fri, 12 Oct 2018 00:26:47 +0200
Message-ID: <20181011222707.3631-2-mwilck@suse.com>
References: <20181011222707.3631-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20181011222707.3631-1-mwilck@suse.com>
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

valgrind complained about this.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/discovery.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 873035e5..3550c3a7 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -661,7 +661,7 @@ sysfs_set_session_tmo(struct multipath *mpp, struct path *pp)
 		} else {
 			snprintf(value, 11, "%u", mpp->fast_io_fail);
 			if (sysfs_attr_set_value(session_dev, "recovery_tmo",
-						 value, 11) <= 0) {
+						 value, strlen(value)) <= 0) {
 				condlog(3, "%s: Failed to set recovery_tmo, "
 					" error %d", pp->dev, errno);
 			}
@@ -693,7 +693,7 @@ sysfs_set_nexus_loss_tmo(struct multipath *mpp, struct path *pp)
 	if (mpp->dev_loss) {
 		snprintf(value, 11, "%u", mpp->dev_loss);
 		if (sysfs_attr_set_value(sas_dev, "I_T_nexus_loss_timeout",
-					 value, 11) <= 0)
+					 value, strlen(value)) <= 0)
 			condlog(3, "%s: failed to update "
 				"I_T Nexus loss timeout, error %d",
 				pp->dev, errno);
-- 
2.19.0
