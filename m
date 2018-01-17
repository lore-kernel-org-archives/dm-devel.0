From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 7/7] multipathd: ignore uevents for non-mpath
	devices
Date: Wed, 17 Jan 2018 08:49:39 +0100
Message-ID: <20180117074939.7795-8-mwilck@suse.com>
References: <20180117074939.7795-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180117074939.7795-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, dm-devel@redhat.com
Cc: Ritika Srivastava <ritika.srivastava@oracle.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

multipathd can't deal with other devices anyway. Proceeding further
with events for other devices just generates log noise.

Based on an idea from Ritika Srivastava <ritika.srivastava@oracle.com>.
("multipath-tools: Skip CHANGE uevent for non-mpath devices").

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index ff3ecb640487..26632291657f 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1121,7 +1121,7 @@ uev_trigger (struct uevent * uev, void * trigger_data)
 	 * Add events are ignored here as the tables
 	 * are not fully initialised then.
 	 */
-	if (!strncmp(uev->kernel, "dm-", 3)) {
+	if (!strncmp(uev->kernel, "dm-", 3) && uevent_is_mpath(uev)) {
 		if (!strncmp(uev->action, "change", 6)) {
 			r = uev_add_map(uev, vecs);
 
-- 
2.15.1
