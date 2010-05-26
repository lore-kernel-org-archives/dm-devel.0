From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: how to load dm-multisnapshot [with LVM patch]
Date: Wed, 26 May 2010 07:50:50 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1005260742340.31622@hs20-bc2-1.build.redhat.com>
References: <AANLkTin9s-W4vvlRasZKfNqQo4r8t8hc-eE2zQTPL_jp@mail.gmail.com>
	<AANLkTinNk5D7ojJyoBnHhMDfECB7eoYrnjQS4ptW3oVI@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="279731514-1974843086-1274874627=:31622"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <AANLkTinNk5D7ojJyoBnHhMDfECB7eoYrnjQS4ptW3oVI@mail.gmail.com>
Content-ID: <Pine.LNX.4.64.1005260750341.31622@hs20-bc2-1.build.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Busby <chaimvy@gmail.com>
Cc: daire.byrne@gmail.com, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--279731514-1974843086-1274874627=:31622
Content-Type: TEXT/PLAIN; CHARSET=X-UNKNOWN
Content-Transfer-Encoding: QUOTED-PRINTABLE
Content-ID: <Pine.LNX.4.64.1005260750342.31622@hs20-bc2-1.build.redhat.com>

On Wed, 26 May 2010, Busby wrote:

> Hi,
>      I have debug the lvm2.02.64 (with the shared-snapshot patches).
>      In the last email I mentioned the 'Cannot update volume group vg00 w=
ith
> unknown segments in it!'
>      The debug mesg: " vg_has_unknown_segments  function: snapshot0 has
> unknown seg."
>       I don't know when the snapshot0 has been created?why its segtype
> unkown?
>      Hope for your help.
>      Thank you.
>
> Best regards,
> Busby

Hi

I think that you didn't run aclocal and autoconf before ./configure and=20
make. So the multisnapshot module wasn't compiled in.

Do make distclean, then aclocal, autoconf, ./configure, make

Mikulas

> =D4=DA 2010=C4=EA5=D4=C224=C8=D5 =CF=C2=CE=E75:04=A3=ACBusby <chaimvy@gma=
il.com>=D0=B4=B5=C0=A3=BA
>=20
> > Hi All,
> >
> > I get the patches from:
> > Linux kernel 2.6.34 patch:
> > http://people.redhat.com/mpatocka/patches/kernel/new-snapshots/r19/
> >
> > LVM2-2.02.64 patch:
> > http://people.redhat.com/msnitzer/patches/multisnap/lvm2/LVM2-2.02.64/
> >
> >
> >
> > but when I used it, the segment type can not find, can anyone help me?
> >
> >
> >
> > [root@new-host-34 ~]# pvcreate /dev/sd[bcdef]
> >
> > [root@new-host-34 ~]# vgcreate vg00 /dev/sd[bcdef]
> >
> > [root@new-host-34 ~]# lvcreate -L 100G -n lv_test /dev/vg00
> >
> > [root@new-host-34 ~]# lvcreate -L 200G -c 256 --sharedstore  mikulas -s
> > /dev/vg00/lv_test
> >
> >   *WARNING: Unrecognised segment type multisnapshot*
> >
> > *  Cannot update volume group vg00 with unknown segments in it!*
> >
> > [root@new-host-34 ~]# lvscan
> >
> > ACTIVE         '/dev/vg00/lv_test' [100.00 GiB] inherit
> >
> >   inactive          '/dev/vg00/lv_test-shared' [200.00 GiB] inherit
> >
> > [root@new-host-34 ~]# lvcreate -s -n lv_test_ss1 /dev/vg00/lv_test
> >
> >   *Unable to create new logical volume with no extents*
> >
> >
> >
> >
> >
> > The dm modules in the system:
> >
> >
> >
> > [root@new-host-34 LVM2.2.02.64]# lsmod |grep dm
> > dm_snapshot            25583  0
> > dm_store_daniel        11304  0
> > dm_store_mikulas       43265  0
> > dm_multisnapshot       20276  2 dm_store_daniel,dm_store_mikulas
> > dm_mirror              11564  0
> > dm_multipath           14594  0
> > scsi_dh                 5480  1 dm_multipath
> > dm_region_hash          8233  1 dm_mirror
> > dm_log                  8158  2 dm_mirror,dm_region_hash
> > dm_mod                 58855  9 dm_snapshot,*
> > dm_store_daniel,dm_store_mikulas,dm_multisnapshot*
> > ,dm_mirror,dm_multipath,dm_log
> >
> >
> >
> >
> >
> >         I just want to use the multisnap by LVM2 command. But I don't k=
now
> > is there any document about HOW-TO?
> >
> >         Thank you very much.
> >
> >
> >
> >
> >
> >
> >
> > Best regards,
> >
> > Busby
> >
>=20
--279731514-1974843086-1274874627=:31622
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--279731514-1974843086-1274874627=:31622--
