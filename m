From: "A, Rajashekhar" <Rajashekhar.A@netapp.com>
Subject: In discovery.c,
	Sysfs attribute is not closed while collecting target node name...
Date: Sun, 5 Aug 2007 23:33:01 +0530
Message-ID: <7026BCCA258BA2438F885772CA0B43130B1ECA57@exbtc01.hq.netapp.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi,

Here is the code snippet from scsi_sysfs_pathinfo function.
attr is not closed when target node name is collected successfully. The
function just returns 0 at the end.=20
Shouldn't it be sysfs_close_attribute(attr); and then return 0; ???

	/*
	 * target node name
	 */
	if(safe_sprintf(attr_path,
=09
"%s/class/fc_transport/target%i:%i:%i/node_name",
			sysfs_path,
			pp->sg_id.host_no,
			pp->sg_id.channel,
			pp->sg_id.scsi_id)) {
		condlog(0, "attr_path too small");
		return 1;
	}
	if (!(attr =3D sysfs_open_attribute(attr_path)))
		return 0;

	if (sysfs_read_attribute(attr))
		goto err;

	if (attr->len > 0)
		strncpy(pp->tgt_node_name, attr->value, attr->len - 1);

	condlog(3, "%s: tgt_node_name =3D %s",
		pp->dev, pp->tgt_node_name);

	return 0;
err:
	sysfs_close_attribute(attr);
	return 1;

Best Regards,
Rajashekhar M A

-----Original Message-----
From: bmarzins@sourceware.org [mailto:bmarzins@sourceware.org]=20
Sent: Friday, June 01, 2007 5:57 AM
To: dm-cvs@sourceware.org; dm-devel@redhat.com
Subject: [dm-devel] multipath-tools libmultipath/discovery.c libmu ...

CVSROOT:	/cvs/dm
Module name:	multipath-tools
Branch: 	RHEL5_FC6
Changes by:	bmarzins@sourceware.org	2007-06-01 00:26:42

Modified files:
	libmultipath   : discovery.c switchgroup.c=20
Added files:
	path_priority/pp_rdac: Makefile pp_rdac.c=20

Log message:
	Reverting the earlier RDAC related path priority fixes, and
addning the new
	priority callout.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/di
scovery.c.diff?cvsroot=3Ddm&only_with_tag=3DRHEL5_FC6&r1=3D1.32.2.3&r2=3D=
1.32.2.
4
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/sw
itchgroup.c.diff?cvsroot=3Ddm&only_with_tag=3DRHEL5_FC6&r1=3D1.5.2.1&r2=3D=
1.5.2.
2
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/path_priority/p
p_rdac/Makefile.diff?cvsroot=3Ddm&only_with_tag=3DRHEL5_FC6&r1=3DNONE&r2=3D=
1.1.2
.1
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/path_priority/p
p_rdac/pp_rdac.c.diff?cvsroot=3Ddm&only_with_tag=3DRHEL5_FC6&r1=3DNONE&r2=
=3D1.1.
2.1

--- multipath-tools/libmultipath/discovery.c	2007/05/02 00:16:36
1.32.2.3
+++ multipath-tools/libmultipath/discovery.c	2007/06/01 00:26:41
1.32.2.4
@@ -763,7 +763,7 @@
 	if (mask & DI_CHECKER && get_state(pp))
 		goto blank;
 =09
-	if (mask & DI_PRIO && pp->state =3D=3D PATH_UP)
+	if (mask & DI_PRIO && pp->state !=3D PATH_DOWN)
 		get_prio(pp);
=20
 	if (mask & DI_WWID && !strlen(pp->wwid))
--- multipath-tools/libmultipath/switchgroup.c	2007/04/24 18:49:16
1.5.2.1
+++ multipath-tools/libmultipath/switchgroup.c	2007/06/01 00:26:41
1.5.2.2
@@ -28,7 +28,7 @@
 		priority =3D 0;
=20
 		vector_foreach_slot (pgp->paths, pp, j) {
-			if (pp->state =3D=3D PATH_UP)
+			if (pp->state !=3D PATH_DOWN)
 				priority +=3D pp->priority;
 		}
 		pgp->priority =3D priority;

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
