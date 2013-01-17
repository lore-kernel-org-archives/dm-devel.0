From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 04/11] Fix inconsistent entries after merging
	hwtable with user's config
Date: Thu, 17 Jan 2013 15:59:26 +0100
Message-ID: <1358434773-2002-5-git-send-email-hare@suse.de>
References: <1358434773-2002-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1358434773-2002-1-git-send-email-hare@suse.de>
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
Cc: dm-devel@redhat.com, Petr Uzel <petr.uzel@suse.cz>
List-Id: dm-devel.ids

From: Petr Uzel <petr.uzel@suse.cz>

When merging the user provided configuration with the internal
hwtable entry in merge_hwe(), it can happen that the resulting
entry has a discrepancy between 'features' and 'no_path_retry'.
Check for this special case and fix it.

Signed-off-by: Petr Uzel <petr.uzel@suse.cz>
---
 libmultipath/config.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/libmultipath/config.c b/libmultipath/config.c
index b317e32..2d88226 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -335,6 +335,15 @@ merge_hwe (struct hwentry * dst, struct hwentry * src)
 	merge_num(retain_hwhandler);
 	merge_num(detect_prio);
 
+	/*
+	 * Make sure features is consistent with
+	 * no_path_retry
+	 */
+	if (dst->no_path_retry == NO_PATH_RETRY_FAIL)
+		remove_feature(&dst->features, "queue_if_no_path");
+	else if (dst->no_path_retry != NO_PATH_RETRY_UNDEF)
+		add_feature(&dst->features, "queue_if_no_path");
+
 	return 0;
 }
 
-- 
1.7.10.4
