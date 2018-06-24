From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v3 10/10] libmultipath: avoid error messages from
	RDAC check
Date: Sun, 24 Jun 2018 21:09:44 +0200
Message-ID: <20180624190944.27158-11-mwilck@suse.com>
References: <20180624190944.27158-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180624190944.27158-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Bart Van Assche <Bart.VanAssche@sandisk.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

VPD pages are only valid for SCSI devices, so we should disable
the RDAC detection for non-SCSI devices. Otherwise we'll get
an error about VPD inquiry failed.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/propsel.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index f0847dba..af3ed622 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -466,6 +466,8 @@ check_rdac(struct path * pp)
 	int len;
 	char buff[44];
 
+	if (pp->bus != SYSFS_BUS_SCSI)
+		return 0;
 	len = get_vpd_sgio(pp->fd, 0xC9, buff, 44);
 	if (len <= 0)
 		return 0;
-- 
2.17.1
