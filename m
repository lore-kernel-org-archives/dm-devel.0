From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v5 13/22] multipath -u: treat failed wwids as
	invalid
Date: Sat, 14 Apr 2018 00:00:06 +0200
Message-ID: <20180413220015.7032-14-mwilck@suse.com>
References: <20180413220015.7032-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180413220015.7032-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

If a WWID has been marked as "failed", don't treat it as "valid multipath
device path" in multipath -c/-u. This is key to achieve consistency between
multipathd and udev rule processing.

Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipath/main.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/multipath/main.c b/multipath/main.c
index 59a72ed0..942caf4c 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -450,8 +450,12 @@ configure (struct config *conf, enum mpath_cmds cmd,
 		 * Paths listed in the wwids file are always considered valid.
 		 */
 		if (cmd == CMD_VALID_PATH) {
-			if ((!find_multipaths_on(conf) && ignore_wwids_on(conf))
-			    || check_wwids_file(refwwid, 0) == 0)
+			if (is_failed_wwid(refwwid) == WWID_IS_FAILED) {
+				r = 1;
+				goto print_valid;
+			} else if ((!find_multipaths_on(conf) &&
+				    ignore_wwids_on(conf)) ||
+				   check_wwids_file(refwwid, 0) == 0)
 				r = 0;
 			if (r == 0 ||
 			    !find_multipaths_on(conf) ||
-- 
2.16.1
