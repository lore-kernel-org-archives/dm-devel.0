From: Levy_Jerome@emc.com
Subject: [RHEL 5.3 PATCH 1/1] scsi_dh: add ALUA notification for
	EMC Clariion devices.
Date: Thu, 18 Sep 2008 09:54:37 -0400
Message-ID: <6416EE16C1AF1E4C86882867E4DD0FF6025D1741@CORPUSMX40B.corp.emc.com>
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Adding sense code data decode for optimal/non-optimal path changeover.
Unfortunately in the read sense code we can't do another inquiry, so we
can't tell the user whether we are on the optimal or non-optimal path,
only that a change has occurred.=20

Jerry Levy, Engineer IV
EMC Global Services Technical Support, PREM ISG
AMER Host Systems Software - UNIX
---

--- scsi_dh_emc.original.c      2008-09-17 14:50:18.000000000 -0400
+++ scsi_dh_emc.c       2008-09-17 14:54:38.000000000 -0400
@@ -435,6 +435,16 @@
                        return SUCCESS;
                break;
        case UNIT_ATTENTION:
+                if (sense_hdr->asc =3D=3D 0x2A && sense_hdr->ascq =3D=3D=
 0x06)
+                        /*
+                         * ALUA status has changed. Report to host,
+                         * no further action required... jml
+                         */
+                        sdev_printk(KERN_NOTICE, sdev,
+                                    "%s: Asymetric access state has
changed.\n",
+                                    CLARIION_NAME);
+                        return SUCCESS;
+                break;
                if (sense_hdr->asc =3D=3D 0x29 && sense_hdr->ascq =3D=3D =
0x00)
                        /*
                         * Unit Attention Code. This is the first IO
