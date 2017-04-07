From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 9/9] multipath: fix segfault with
	disable_changed_wwids
Date: Fri,  7 Apr 2017 01:16:38 -0500
Message-ID: <1491545798-22183-10-git-send-email-bmarzins@redhat.com>
References: <1491545798-22183-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1491545798-22183-1-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Shichangkuo <shi.changkuo@h3c.com>
List-Id: dm-devel.ids

When a path wwid changes, uev_update_path was dereferencing pp->mpp
without checking if it was NULL.

Cc: Shichangkuo <shi.changkuo@h3c.com>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 995e580..0c61caa 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1002,7 +1002,8 @@ uev_update_path (struct uevent *uev, struct vectors * vecs)
 				if (!pp->wwid_changed) {
 					pp->wwid_changed = 1;
 					pp->tick = 1;
-					dm_fail_path(pp->mpp->alias, pp->dev_t);
+					if (pp->mpp)
+						dm_fail_path(pp->mpp->alias, pp->dev_t);
 				}
 				goto out;
 			} else
-- 
1.8.3.1
