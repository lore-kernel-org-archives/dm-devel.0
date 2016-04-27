From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 46/57] libmultipath: ensure 'dev_t' is set when
	store paths
Date: Wed, 27 Apr 2016 13:10:47 +0200
Message-ID: <1461755458-29225-47-git-send-email-hare@suse.de>
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

We need both, 'pp->dev' and 'pp->dev_t' for correct lookup to
work. So ensure dev_t is always being updated when storing a new path.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 libmultipath/discovery.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 2cf2566..db82b00 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -1599,6 +1599,16 @@ pathinfo (struct path *pp, vector hwtable, int mask)
 	condlog(3, "%s: mask = 0x%x", pp->dev, mask);
 
 	/*
+	 * Sanity check: we need the device number to
+	 * avoid inconsistent information in
+	 * find_path_by_dev()/find_path_by_devt()
+	 */
+	if (!strlen(pp->dev_t) && !(mask & DI_SYSFS)) {
+		condlog(1, "%s: empty device number", pp->dev);
+		mask |= DI_SYSFS;
+	}
+
+	/*
 	 * fetch info available in sysfs
 	 */
 	if (mask & DI_SYSFS && sysfs_pathinfo(pp))
-- 
2.6.6
