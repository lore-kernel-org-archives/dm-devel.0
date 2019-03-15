From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 8/9] libmultipath: check_rdac(): pre-check in
	hwtable
Date: Fri, 15 Mar 2019 17:11:54 +0100
Message-ID: <20190315161155.24062-9-mwilck@suse.com>
References: <20190315161155.24062-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190315161155.24062-1-mwilck@suse.com>
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
Cc: NetApp RDAC team <ng-eseries-upstream-maintainers@netapp.com>, dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>, Steve.Schremmer@netapp.com, Hannes Reinecke <hare@suse.com>
List-Id: dm-devel.ids

Currently check_rdac() always runs an SG_IO for VPD 0xc9 to check
if the storage supports RDAC. This is an extra IO, and may cause
annoying error messages on the storage side for non-RDAC arrays.
Do the RDAC override only for arrays that have legacy configuration
to use the rdac checker.

Cc: Steve.Schremmer@netapp.com
Cc: NetApp RDAC team <ng-eseries-upstream-maintainers@netapp.com>
Cc: Hannes Reinecke <hare@suse.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/propsel.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index d5fbd94e..2eb6fc2a 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -470,9 +470,17 @@ check_rdac(struct path * pp)
 {
 	int len;
 	char buff[44];
+	const char *checker_name = NULL;
+	/* dummy, for do_set_from_hwe */
+	const char *origin __attribute__((unused));
 
 	if (pp->bus != SYSFS_BUS_SCSI)
 		return 0;
+	/* Avoid ioctl if this is likely not an RDAC array */
+	do_set_from_hwe(checker_name, pp, checker_name, NULL);
+out:    /* for do_set_from_hwe */
+	if (!checker_name || strcmp(checker_name, RDAC))
+		return 0;
 	len = get_vpd_sgio(pp->fd, 0xC9, buff, 44);
 	if (len <= 0)
 		return 0;
-- 
2.21.0
