From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] IBM hwtable update
Date: Wed, 07 Dec 2005 12:11:23 +0100
Message-ID: <4396C35B.7030109@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------010607020300040905080308"
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: christophe varoqui <christophe.varoqui@free.fr>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

This is a multi-part message in MIME format.
--------------010607020300040905080308
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Christophe,

attached is a patch to update hwtable.c with some IBM Storage Servers.
Especially the DS6000 should be handled properly as it again has
asymmetric paths.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke			hare@suse.de
SuSE Linux Products GmbH		S390 & zSeries
Maxfeldstra=DFe 5				+49 911 74053 688
90409 N=FCrnberg				http://www.suse.de

--------------010607020300040905080308
Content-Type: text/x-patch;
 name="multipath-tools-ibm-hwtable-update.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="multipath-tools-ibm-hwtable-update.patch"

Subject: Hardware entries for IBM Storage Servers

Several IBM Storage Servers (most notably the DS range) need
specific hardware entries. This patch adds hardware entries
for:

- IBM ESS F20 (aka Shark)
- IBM DS6000
- IBM DS8000
- IBM SVC

Signed-off-by: Hannes Reinecke <hare@suse.de>

---

 libmultipath/hwtable.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -39,6 +39,20 @@ setup_default_hwtable (vector hw)
 		   "1 queue_if_no_path", "emc_clariion", -FAILBACK_IMMEDIATE);
 	r += store_hwe_ext(hw, "IBM", "3542", GROUP_BY_SERIAL, DEFAULT_GETUID,
 		   NULL, "0", "0", "tur", FAILBACK_UNDEF);
+	/* IBM ESS F20 aka Shark */
+	r += store_hwe_ext(hw, "IBM", "2105F20", GROUP_BY_SERIAL,
+		   DEFAULT_GETUID, NULL, "0", "1 queue_if_no_path",
+		   "tur", FAILBACK_UNDEF);
+       /* IBM DS6000 */
+	r += store_hwe_ext(hw, "IBM", "1750500", GROUP_BY_PRIO, DEFAULT_GETUID,
+		   "/sbin/mpath_prio_alua /dev/%n", "0", "1 queue_if_no_path",
+		   "tur", FAILBACK_UNDEF);
+	/* IBM DS8000 */
+	r += store_hwe_ext(hw, "IBM", "2107900", GROUP_BY_SERIAL, DEFAULT_GETUID,
+		   NULL, "0", "1 queue_if_no_path", "tur", FAILBACK_UNDEF);
+	/* IBM SAN Volume Controller */
+	r += store_hwe_ext(hw, "IBM", "2145", MULTIBUS, DEFAULT_GETUID,
+		   NULL, "0", "1 queue_if_no_path", "tur", FAILBACK_UNDEF);
 	r += store_hwe_ext(hw, "NETAPP", "LUN", GROUP_BY_PRIO, DEFAULT_GETUID,
 		  "/sbin/mpath_prio_netapp /dev/%n", NULL,
 		  "1 queue_if_no_path", "readsector0", FAILBACK_UNDEF);

--------------010607020300040905080308
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------010607020300040905080308--
