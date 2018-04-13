From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v5 17/22] multipath -u: cleanup logic
Date: Sat, 14 Apr 2018 00:00:10 +0200
Message-ID: <20180413220015.7032-18-mwilck@suse.com>
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

The CMD_VALID_PATH logic is complex and hard to read and understand.
This patch cleans it up a bit (preparing for folluw-up patches).
It doesn't change any logic.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipath/main.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/multipath/main.c b/multipath/main.c
index 5d847f08..61ba90a6 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -585,15 +585,17 @@ configure (struct config *conf, enum mpath_cmds cmd,
 			if (is_failed_wwid(refwwid) == WWID_IS_FAILED) {
 				r = 1;
 				goto print_valid;
-			} else if ((!find_multipaths_on(conf) &&
+			}
+			if ((!find_multipaths_on(conf) &&
 				    ignore_wwids_on(conf)) ||
 				   check_wwids_file(refwwid, 0) == 0)
 				r = 0;
-			if (r == 0 ||
-			    !find_multipaths_on(conf) ||
-			    !ignore_wwids_on(conf)) {
+			if (!ignore_wwids_on(conf))
 				goto print_valid;
-			}
+			/* At this point, either r==0 or find_multipaths_on. */
+			if (r == 0)
+				goto print_valid;
+			/* find_multipaths_on: Fall through to path detection */
 		}
 	}
 
-- 
2.16.1
