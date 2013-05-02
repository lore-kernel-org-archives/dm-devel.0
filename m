From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH 09/16] Add existing multipath devices to wwids
	file on
Date: Thu,  2 May 2013 16:46:30 -0500
Message-ID: <1367531197-8987-10-git-send-email-bmarzins@redhat.com>
References: <1367531197-8987-1-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1367531197-8987-1-git-send-email-bmarzins@redhat.com>
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
Cc: Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

When multipathd started up, it didn't add any existing devices to the
wwids file.  Because of this, devices that were always set up in the
initramfs were not counted as valid multipath devices, and checking
if one of their paths was a multipath path device gave the incorrect
answer.  This patch makes multipath add those devices when it does
its initial configuration on startup.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/multipathd/main.c b/multipathd/main.c
index f6e68e8..440d254 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1357,6 +1357,7 @@ configure (struct vectors * vecs, int start_waiters)
 
 	sync_maps_state(mpvec);
 	vector_foreach_slot(mpvec, mpp, i){
+		remember_wwid(mpp->wwid);
 		update_map_pr(mpp);
 	}
 
-- 
1.8.2
