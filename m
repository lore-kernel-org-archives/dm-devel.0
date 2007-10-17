From: Tore Anderson <tore@linpro.no>
Subject: Re: multibus / failover and EMC CX600
Date: Wed, 17 Oct 2007 18:01:41 +0200
Message-ID: <471631E5.9050603@linpro.no>
References: <061401c810a7$cac685d0$0a00a8c0@ALDI2><4715E6A4.7060308@linpro.no>	<4715ED28.9020102@suse.de>
	<471600F7.5090607@linpro.no> <066001c810cc$cd9f6f90$0a00a8c0@ALDI2>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <066001c810cc$cd9f6f90$0a00a8c0@ALDI2>
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

* Gerald Nowitzky

> The mpath_prio_emc with group_by_prio did the trick. Thanks!
> =20
> But I am still loosing the paths to the failed devices. I Increased
> dev_loss_tmo, but the maximum seems to be about 600 - thus, after 10
> Minutes, the paths fail:

The maximum is indeed 600 seconds in 2.6.23.

> SANfile_m linux # multipath -l
> hcfshare (360060160c820080063502869e459dc11) dm-0 ,
> [size=3D3.4T][features=3D1 queue_if_no_path][hwhandler=3D1 emc]
> \_ round-robin 0 [prio=3D0][enabled]
>  \_ #:#:#:# -   #:#   [failed][undef]
>  \_ #:#:#:# -   #:#   [failed][undef]
> \_ round-robin 0 [prio=3D0][active]
>  \_ 2:0:0:0 sdd 8:48  [active][undef]
>  \_ 1:0:0:0 sdb 8:16  [active][undef]
> If I put them online again, I run into the -EEXIST prob. Async SCSI
> scanning *is* off in my kernel, so the only thing I could do from
> here is to try the patch, is it?

Matthew Wilcox' patch solved this particular problem for me, yes.  I
still had some problems with -EEXIST when unloading and re-inserting the
HBA driver module, though, but that's a corner case I rarely run into
(as well as being easily worked around by trying again).

Come to think of it, you never said which kernel version you're running..=
.?

> Oct 17 17:26:36 SANfile_m kernel: kobject_add failed for 1:0:1:0 with
> -EEXIST, don't try to register things with the same name in the same
> directory.

One suggestion...  If the sysfs object is still around, you might be
able to delete it manually by running =C2=ABecho 1 >
/sys/class/scsi_device/1:0:1:0/device/delete=C2=BB.  If that works, you c=
an
try to rescan again by doing =C2=ABecho 0 1 0 >
/sys/class/scsi_host/host1/scan=C2=BB.  With some luck it'll work...

If it does, most of the time udev will notice and alert multipath to
check out the new device.  Sometimes it doesn't work, though - simply
run the =C2=ABmultipath=C2=BB command manually in that case.

By the way - the =C2=AB1=C2=BB in =C2=ABhost1=C2=BB maps to the first dig=
it in =C2=AB1:0:1:0=C2=BB,
while the =C2=AB0 1 0=C2=BB in the echo command to the last three.

Regards
--=20
Tore Anderson
