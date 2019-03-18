From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v3 09/10] libmultipath: check_rdac(): pre-check
	in hwtable
Date: Mon, 18 Mar 2019 12:24:44 +0100
Message-ID: <20190318112445.6636-10-mwilck@suse.com>
References: <20190318112445.6636-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190318112445.6636-1-mwilck@suse.com>
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
Do not use the RDAC override for arrays that have legacy configuration
to use a checker other than "rdac". For "unkown" devices with no checker
configured in either the hwtable or multipath.conf, the VPD call will
be tried.

Cc: Steve.Schremmer@netapp.com
Cc: NetApp RDAC team <ng-eseries-upstream-maintainers@netapp.com>
Cc: Hannes Reinecke <hare@suse.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/propsel.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index caf55b68..e6263e9b 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -478,9 +478,14 @@ check_rdac(struct path * pp)
 {
 	int len;
 	char buff[44];
+	const char *checker_name;
 
 	if (pp->bus != SYSFS_BUS_SCSI)
 		return 0;
+	/* Avoid ioctl if this is likely not an RDAC array */
+	if (__do_set_from_hwe(checker_name, pp, checker_name) &&
+	    strcmp(checker_name, RDAC))
+		return 0;
 	len = get_vpd_sgio(pp->fd, 0xC9, buff, 44);
 	if (len <= 0)
 		return 0;
-- 
2.21.0
