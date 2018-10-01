From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 2/2] multipathd: try SCSI persistent reservations
	for SCSI only
Date: Mon,  1 Oct 2018 20:45:07 +0200
Message-ID: <20181001184507.4162-3-mwilck@suse.com>
References: <20181001184507.4162-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20181001184507.4162-1-mwilck@suse.com>
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

This avoids error messages when PERSISTENT RESERVE IN ioctls
are tried on non-SCSI devices.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/multipathd/main.c b/multipathd/main.c
index cc493c18..43e255e0 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -3129,6 +3129,9 @@ int mpath_pr_event_handle(struct path *pp)
 	pthread_attr_t attr;
 	struct multipath * mpp;
 
+	if (pp->bus != SYSFS_BUS_SCSI)
+		return 0;
+
 	mpp = pp->mpp;
 
 	if (!get_be64(mpp->reservation_key))
-- 
2.19.0
