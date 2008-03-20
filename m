From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] multipath: update discovery for sysfs layout
	changes
Date: Thu, 20 Mar 2008 09:28:31 +0100
Message-ID: <47E2202F.7010208@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------040901070506000306000306"
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
--------------040901070506000306000306
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Christophe,

this patch updates the discovery to work when SYSFS_DEPRECATED is
not set. The change here is that the parent of a block device is
'block', and the 'real' parent is the parent of that. Easy and
non-intrusive change.

Please apply.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)

--------------040901070506000306000306
Content-Type: text/plain;
 name="multipath-tools-update-for-new-sysfs-layout"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="multipath-tools-update-for-new-sysfs-layout"

commit e178e517afac5c66403baf564479da31b1219041
Author: Hannes Reinecke <hare@suse.de>
Date:   Thu Mar 20 09:19:34 2008 +0100

    Update discovery to work with new sysfs layout
    
    With the new sysfs layout the parent device of a block device
    it 'block', and only the parent of this is the 'real' parent.
    
    Signed-off-by: Hannes Reinecke <hare@suse.de>

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index a85a248..30c36e5 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -550,6 +550,9 @@ sysfs_pathinfo(struct path * pp)
 	if (!parent)
 		parent = pp->sysdev;
 
+	if (!strncmp(parent->kernel, "block",5))
+		parent = sysfs_device_get_parent(parent);
+
 	condlog(3, "%s: subsystem = %s", pp->dev, parent->subsystem);
 
 	if (!strncmp(parent->subsystem, "scsi",4))

--------------040901070506000306000306
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------040901070506000306000306--
