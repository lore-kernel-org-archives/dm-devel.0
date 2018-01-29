From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2] multipathd: ignore uevents for non-mpath
	devices
Date: Tue, 30 Jan 2018 00:57:50 +0100
Message-ID: <20180129235750.28425-1-mwilck@suse.com>
References: <0f6c9e29-b4a7-74b9-4ce0-b776214d9466@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <0f6c9e29-b4a7-74b9-4ce0-b776214d9466@oracle.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, ritika.srivastava@oracle.com, dm-devel@redhat.com
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

multipathd can't deal with other devices anyway. Proceeding further
with events for other devices just generates log noise.

Based on an idea from Ritika Srivastava <ritika.srivastava@oracle.com>.
("multipath-tools: Skip CHANGE uevent for non-mpath devices").

Changes in v2: always return immediately for non-mpath case
  (Ritika Srivastava)

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/main.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index ff3ecb640487..a8a0c302e8fe 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1122,6 +1122,8 @@ uev_trigger (struct uevent * uev, void * trigger_data)
 	 * are not fully initialised then.
 	 */
 	if (!strncmp(uev->kernel, "dm-", 3)) {
+		if (!uevent_is_mpath(uev))
+			goto out;
 		if (!strncmp(uev->action, "change", 6)) {
 			r = uev_add_map(uev, vecs);
 
@@ -1132,11 +1134,8 @@ uev_trigger (struct uevent * uev, void * trigger_data)
 			 * cess.
 			 */
 			uev_pathfail_check(uev, vecs);
-			goto out;
-		}
-		if (!strncmp(uev->action, "remove", 6)) {
+		} else if (!strncmp(uev->action, "remove", 6)) {
 			r = uev_remove_map(uev, vecs);
-			goto out;
 		}
 		goto out;
 	}
-- 
2.16.1
