From: doug wandell <pankakekid@yahoo.com>
Subject: Re: Multipath device gone
Date: Wed, 18 Dec 2013 10:49:56 -0800 (PST)
Message-ID: <1387392596.90026.YahooMailNeo@web124705.mail.ne1.yahoo.com>
References: <1387312578.20189.YahooMailNeo@web124706.mail.ne1.yahoo.com>
Reply-To: doug wandell <pankakekid@yahoo.com>,
        device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1387312578.20189.YahooMailNeo@web124706.mail.ne1.yahoo.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

SOLVED.

While I do not pretend to understand the underlying mechanics of why this w=
orked, the following

cd /etc
mv multipath.conf multipath.conf.hold
touch multipath.conf
service multipathd restart
mv multipath.conf.hold multipath.conf
service multipathd restart
multipath -v2

resolved the issue for me.

root@oracle-flash ~>ls -l /dev/mapper |grep mpath
brw-rw---- 1 root disk 253,=A0 2 Dec 18 11:17 mpath1
brw-rw---- 1 root disk 253,=A0 3 Dec 18 11:17 mpath1p1
brw-rw---- 1 root disk 253,=A0 4 Dec 18 11:17 mpath1p2
brw-rw---- 1 root disk 253,=A0 5 Dec 18 11:17 mpath1p3
brw-rw---- 1 root disk 253,=A0 6 Dec 18 11:17 mpath1p4
brw-rw---- 1 root disk 253,=A0 7 Dec 18 11:17 mpath1p5
brw-rw---- 1 root disk 253,=A0 8 Dec 18 11:17 mpath1p6
brw-rw---- 1 root disk 253,=A0 9 Dec 18 11:17 mpath1p7
brw-rw---- 1 root disk 253, 10 Dec 18 11:17 mpath1p8





On Tuesday, December 17, 2013 3:36 PM, doug wandell <pankakekid@yahoo.com> =
wrote:
Hello,
I have a RHEL5.10 Server (x86_64) system connected to a storage array via i=
scsi.=A0 After configuring iscsi and multipathd and installing the database=
, all seemed well.=A0 One reboot, the 8 iscsi sessions were established and=
 appear to be correct:

root@oracle-flash ~>iscsiadm -m session
tcp: [1] 192.168.42.1:3260,1 iqn.2010-06.com.purestorage:flasharray.1d8d233=
897606807
tcp: [2] 192.168.41.1:3260,1 iqn.2010-06.com.purestorage:flasharray.1d8d233=
897606807
tcp: [3] 192.168.41.1:3260,1 iqn.2010-06.com.purestorage:flasharray.1d8d233=
897606807
tcp: [4] 192.168.41.1:3260,1 iqn.2010-06.com.purestorage:flasharray.1d8d233=
897606807
tcp: [5] 192.168.41.1:3260,1 iqn.2010-06.com.purestorage:flasharray.1d8d233=
897606807
tcp: [6] 192.168.42.1:3260,1 iqn.2010-06.com.purestorage:flasharray.1d8d233=
897606807
tcp: [7] 192.168.42.1:3260,1 iqn.2010-06.com.purestorage:flasharray.1d8d233=
897606807
tcp: [8] 192.168.42.1:3260,1 iqn.2010-06.com.purestorage:flasharray.1d8d233=
897606807


No multipath device (mpath1) however:


root@oracle-flash ~>multipath -d
failed to find rport_id for target8:0:0
create: mpath1 (3624a9370266083988b6c502f00010002)=A0 PURE,FlashArray
[size=3D3.0T][features=3D0][hwhandler=3D0][n/a]
\_=A0 [prio=3D1][undef]
=A0\_ 8:0:0:10=A0 sdb 8:16=A0 [undef][ready]
=A0\_ 7:0:0:10=A0 sdc 8:32=A0 [undef][ready]
=A0\_ 13:0:0:10 sdd 8:48=A0 [undef][ready]
=A0\_ 14:0:0:10 sde 8:64=A0 [undef][ready]
=A0\_ 10:0:0:10 sdf 8:80=A0 [undef][ready]
=A0\_ 12:0:0:10 sdg 8:96=A0 [undef][ready]
=A0\_ 11:0:0:10 sdh 8:112 [undef][ready]
=A0\_ 9:0:0:10=A0 sdi 8:128 [undef][ready]
root@oracle-flash ~>multipath -ll
root@oracle-flash ~>multipath -F
root@oracle-flash ~>multipath -r
failed to find rport_id for target8:0:0
failed to find rport_id for target8:0:0
failed to find rport_id for target8:0:0
failed to find rport_id for target8:0:0
failed to find rport_id for target8:0:0
failed to find rport_id for target8:0:0
failed to find rport_id for target8:0:0
failed to find rport_id for target8:0:0
root@oracle-flash ~>ls -l /dev/disk/by-id/
total 0
lrwxrwxrwx 1 root root=A0 9 Dec 16 15:57 ata-TSSTcorp_DVD-ROM_SN-108BB_R8TB=
6GMCC00333 -> ../../hda
lrwxrwxrwx 1 root root=A0 9 Dec 16 15:57 scsi-3600508e000000000ca1771980431=
ca00 -> ../../sda
lrwxrwxrwx 1 root root 10 Dec 16 15:57 scsi-3600508e000000000ca1771980431ca=
00-part1 -> ../../sda1
lrwxrwxrwx 1 root root 10 Dec 16 15:57 scsi-3600508e000000000ca1771980431ca=
00-part2 -> ../../sda2
lrwxrwxrwx 1 root root=A0 9 Dec 16 15:58 scsi-3624a9370266083988b6c502f0001=
0002 -> ../../sdg
lrwxrwxrwx 1 root root 10 Dec 16 15:58 scsi-3624a9370266083988b6c502f000100=
02-part1 -> ../../sdi1
lrwxrwxrwx 1 root root 10 Dec 16 15:58 scsi-3624a9370266083988b6c502f000100=
02-part2 -> ../../sdg2
lrwxrwxrwx 1 root root 10 Dec 16 15:58 scsi-3624a9370266083988b6c502f000100=
02-part3 -> ../../sdg3
lrwxrwxrwx 1 root root 10 Dec 16 15:58 scsi-3624a9370266083988b6c502f000100=
02-part4 -> ../../sde4
lrwxrwxrwx 1 root root 10 Dec 16 15:58 scsi-3624a9370266083988b6c502f000100=
02-part5 -> ../../sdg5
lrwxrwxrwx 1 root root 10 Dec 16 15:58 scsi-3624a9370266083988b6c502f000100=
02-part6 -> ../../sdg6
lrwxrwxrwx 1 root root 10 Dec 16 15:58 scsi-3624a9370266083988b6c502f000100=
02-part7 -> ../../sdg7
lrwxrwxrwx 1 root root 10 Dec 16 15:58 scsi-3624a9370266083988b6c502f000100=
02-part8 -> ../../sdg8
root@oracle-flash ~>cat /var/lib/multipath/bindings
# Multipath bindings, Version : 1.0
# NOTE: this file is automatically maintained by the multipath program.
# You should not need to edit this file in normal circumstances.
#
# Format:
# alias wwid
#
mpath0 3600508e000000000ca1771980431ca00
mpath1 3624a9370266083988b6c502f00010002
root@oracle-flash ~>grep -v ^# /etc/multipath.conf

devices {
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 device {
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 vendor "PURE"
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 path_selector "round-robin 0.
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 path_grouping_policy multi bus
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 rr_min_io 1
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 path_checker tur
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 fast_io_fail_tmo 10
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 dev_loss_tmo 30
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
}

defaults {
=A0=A0=A0=A0=A0=A0=A0 udev_dir=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
 /dev
=A0=A0=A0=A0=A0=A0=A0 user_friendly_names=A0=A0=A0=A0 yes
=A0=A0=A0=A0=A0=A0=A0 polling_interval=A0=A0=A0=A0=A0=A0=A0 10
=A0=A0=A0=A0=A0=A0=A0 selector=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
 "round-robin 0"
=A0=A0=A0=A0=A0=A0=A0 path_grouping_policy=A0=A0=A0 multibus
=A0=A0=A0=A0=A0=A0=A0 path_checker=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 tur
=A0=A0=A0=A0=A0=A0=A0 rr_min_io=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 1
=A0=A0=A0=A0=A0=A0=A0 no_path_retry=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 0
=A0=A0=A0=A0=A0=A0=A0 fast_io_fail_tmo=A0=A0=A0=A0=A0=A0=A0 3
}
blacklist {
=A0=A0=A0=A0=A0=A0=A0 devnode "^sda"
}
multipaths {
=A0=A0=A0=A0=A0=A0=A0 multipath {
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 wwid=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 3624a9370266083988b6c502f00010002
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 alias=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 mpath1
=A0=A0=A0=A0=A0=A0=A0 }
}

I've looked around a bit but I don't see this problem addressed.=A0 Any ide=
as where I can take this next?=A0 Thanks,
DW
