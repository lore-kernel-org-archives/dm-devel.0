From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH 04/16] Don't detect prioritizers that don't work
Date: Wed, 11 Dec 2013 00:42:58 -0600
Message-ID: <1386744190-1295-5-git-send-email-bmarzins@redhat.com>
References: <1386744190-1295-1-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1386744190-1295-1-git-send-email-bmarzins@redhat.com>
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

The current method used by detect_prio was selecting the ALUA
prioritizer for devices that didn't have ALUA enabled.  This patch
makes detect_prio go through all the steps to get a priority with the
ALUA prioritizer.  If it is able to successfully get a priority, then
it selects the ALUA proritizer for the device.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/propsel.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index 211ebcd..df09603 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -396,10 +396,17 @@ select_getuid (struct path * pp)
 void
 detect_prio(struct path * pp)
 {
+	int ret;
 	struct prio *p = &pp->prio;
 
-	if (get_target_port_group_support(pp->fd) > 0)
-		prio_get(p, PRIO_ALUA, DEFAULT_PRIO_ARGS);
+	if (get_target_port_group_support(pp->fd) <= 0)
+		return;
+	ret = get_target_port_group(pp->fd);
+	if (ret < 0)
+		return;
+	if (get_asymmetric_access_state(pp->fd, ret) < 0)
+		return;
+	prio_get(p, PRIO_ALUA, DEFAULT_PRIO_ARGS);
 }
 
 extern int
-- 
1.8.4.2
