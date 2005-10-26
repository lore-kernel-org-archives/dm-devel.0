From: "Phil Lowden (plowden)" <plowden@cisco.com>
Subject: LVM2 plus device-mapper-multipath filter question
Date: Wed, 26 Oct 2005 15:45:17 -0400
Message-ID: <013350FE9CC8AC4EB602045723F47222B9A2CA@xmb-rtp-215.amer.cisco.com>
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

I'm using LVM2 with device-mapper-multipath 0.4.5 on GA RHEL 4 update 2=20
release, kernel version 2.6.9-22.ELsmp.  Storage is 4 Clariion CX600
LUNs.

I've got this filter statement in /etc/lvm/lvm.conf:

  filter =3D [ "a|^/dev/mapper/.*|", "r/.*/" ]
=20
and this for types:

  types =3D [ "device-mapper", 16 ]

I notice any LVM2 commands that show PVs uses the dm-* devices:

# pvs
  PV         VG      Fmt  Attr PSize    PFree =20
  /dev/dm-0  vgtest2 lvm2 a-      4.00G   3.90G
  /dev/dm-1  vgtest2 lvm2 a-      3.00G   2.90G
  /dev/dm-2  vgtest2 lvm2 a-      2.00G   1.90G
  /dev/dm-3  vgtest2 lvm2 a-   1020.00M 920.00M

This is true except when /etc/lvm/.cache is brand new:

# rm /etc/lvm/.cache
# pvs
  PV                                            VG      Fmt  Attr PSize
PFree =20
  /dev/mapper/3600601604b600d00743e69d8862fda11 vgtest2 lvm2 a-
1020.00M 920.00M
  /dev/mapper/3600601604b600d00753e69d8862fda11 vgtest2 lvm2 a-
2.00G   1.90G
  /dev/mapper/3600601604b600d00763e69d8862fda11 vgtest2 lvm2 a-
3.00G   2.90G
  /dev/mapper/3600601604b600d00773e69d8862fda11 vgtest2 lvm2 a-
4.00G   3.90G
# pvs
  PV         VG      Fmt  Attr PSize    PFree =20
  /dev/dm-0  vgtest2 lvm2 a-      4.00G   3.90G
  /dev/dm-1  vgtest2 lvm2 a-      3.00G   2.90G
  /dev/dm-2  vgtest2 lvm2 a-      2.00G   1.90G
  /dev/dm-3  vgtest2 lvm2 a-   1020.00M 920.00M

Here's the /etc/lvm.cache file:

# This file is automatically maintained by lvm.

persistent_filter_cache {
        valid_devices=3D[
                "/dev/mapper/3600601604b600d00763e69d8862fda11",
                "/dev/mpath/3600601604b600d00773e69d8862fda11",
                "/dev/mapper/3600601604b600d00753e69d8862fda11",
                "/dev/mpath/3600601604b600d00753e69d8862fda11",
                "/dev/mapper/vgtest2-lvstripe1",
                "/dev/vgtest2/lvstripe1",
                "/dev/mapper/3600601604b600d00773e69d8862fda11",
                "/dev/dm-2",
                "/dev/dm-3",
                "/dev/dm-4",
                "/dev/mpath/3600601604b600d00763e69d8862fda11",
                "/dev/dm-1",
                "/dev/mpath/3600601604b600d00743e69d8862fda11",
                "/dev/dm-0",
                "/dev/mapper/3600601604b600d00743e69d8862fda11"
        ]
}

If I remove everything but the /dev/mapper and lvstripe1 entries I get
this:

# pvs
  PV                                            VG      Fmt  Attr PSize
PFree =20
  /dev/mapper/3600601604b600d00743e69d8862fda11 vgtest2 lvm2 a-
1020.00M 920.00M
  /dev/mapper/3600601604b600d00753e69d8862fda11 vgtest2 lvm2 a-
2.00G   1.90G
  /dev/mapper/3600601604b600d00763e69d8862fda11 vgtest2 lvm2 a-
3.00G   2.90G
  /dev/mapper/3600601604b600d00773e69d8862fda11 vgtest2 lvm2 a-
4.00G   3.90G
# pvs
  PV                                            VG      Fmt  Attr PSize
PFree =20
  /dev/mapper/3600601604b600d00743e69d8862fda11 vgtest2 lvm2 a-
1020.00M 920.00M
  /dev/mapper/3600601604b600d00753e69d8862fda11 vgtest2 lvm2 a-
2.00G   1.90G
  /dev/mapper/3600601604b600d00763e69d8862fda11 vgtest2 lvm2 a-
3.00G   2.90G
  /dev/mapper/3600601604b600d00773e69d8862fda11 vgtest2 lvm2 a-
4.00G   3.90G

Is this just cosmetic?  Is there a config change I can do to make path
listings consistent? =20

Thanks in advance,
Phil Lowden
