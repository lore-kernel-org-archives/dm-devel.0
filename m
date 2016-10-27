From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: alua: add prefix with device
	name for asymmetric access state and reported target port
	group messages
Date: Thu, 27 Oct 2016 15:21:10 +0200
Message-ID: <20161027132110.6598-1-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Before:
Oct 27 15:11:21 | reported target port group is 2
Oct 27 15:11:21 | aas = 01 [active/non-optimized]

After:
Oct 27 15:11:47 | sda: reported target port group is 2
Oct 27 15:11:47 | sda: aas = 01 [active/non-optimized]

Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/prioritizers/alua.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/libmultipath/prioritizers/alua.c b/libmultipath/prioritizers/alua.c
index f5456ee..03d0a0e 100644
--- a/libmultipath/prioritizers/alua.c
+++ b/libmultipath/prioritizers/alua.c
@@ -65,12 +65,12 @@ get_alua_info(struct path * pp, unsigned int timeout)
 			return -ALUA_PRIO_NOT_SUPPORTED;
 		return -ALUA_PRIO_RTPG_FAILED;
 	}
-	condlog(3, "reported target port group is %i", tpg);
+	condlog(3, "%s: reported target port group is %i", pp->dev, tpg);
 	rc = get_asymmetric_access_state(pp->fd, tpg, timeout);
 	if (rc < 0)
 		return -ALUA_PRIO_GETAAS_FAILED;
 
-	condlog(3, "aas = %02x [%s]%s", rc, aas_print_string(rc),
+	condlog(3, "%s: aas = %02x [%s]%s", pp->dev, rc, aas_print_string(rc),
 		(rc & 0x80) ? " [preferred]" : "");
 	return rc;
 }
-- 
2.10.1
