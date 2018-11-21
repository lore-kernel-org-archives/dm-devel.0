From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 14/19] libmultipath: decrease log level for
	failed VPD c9
Date: Wed, 21 Nov 2018 11:18:34 +0100
Message-ID: <20181121101839.30784-15-mwilck@suse.com>
References: <20181121101839.30784-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20181121101839.30784-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

It's normal that SCSI devices don't support this page. Only RDAC
devices need it.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/discovery.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 1c87277f..7f983a63 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -1106,7 +1106,9 @@ get_vpd_sgio (int fd, int pg, char * str, int maxlen)
 
 	memset(buff, 0x0, 4096);
 	if (sgio_get_vpd(buff, 4096, fd, pg) < 0) {
-		condlog(3, "failed to issue vpd inquiry for pg%02x",
+		int lvl = pg == 0x80 || pg == 0x83 ? 3 : 4;
+
+		condlog(lvl, "failed to issue vpd inquiry for pg%02x",
 			pg);
 		return -errno;
 	}
-- 
2.19.1
