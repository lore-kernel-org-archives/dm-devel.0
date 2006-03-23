From: li nux <lnxluv@yahoo.com>
Subject: how to disable a path
Date: Thu, 23 Mar 2006 05:48:32 -0800 (PST)
Message-ID: <20060323134832.64490.qmail@web33315.mail.mud.yahoo.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
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
To: dm <dm-devel@redhat.com>
List-Id: dm-devel.ids

I have setup multipathing on rhel4 u3 x86_64 like
this:

There are two paths to the disk, sda and sde
# multipath -v2 -l
mpath0 (3600805f300176640a435a927359c0003)
[size=3D440 GB][features=3D"0"][hwhandler=3D"0"]
\_ round-robin 0 [enabled]
 \_ 0:0:0:1 sda 8:0   [active][ready]
 \_ 2:0:0:1 sde 8:64  [active][ready]

I need help in the following:

1. How to disable a particular path lets say sda.
I tried to blacklist sda by putting the entry in
/etc/multipath.conf:

devnode_blacklist {
       devnode "sda"
}

But on running multipath, it gives a segmentation
fault
# multipath
Segmentation fault

strace shows that it faults immediately after close()
open("/var/lib/multipath/bindings", O_RDWR|O_CREAT,
0600) =3D 11
----------<snip>----------
close(11)                               =3D 0
--- SIGSEGV (Segmentation fault) @ 0 (0) ---


2. How to correlate /dev/dm- entries to the disks, how
to find which device /dev/dm-10 is mapped to

-lnx

__________________________________________________
Do You Yahoo!?
Tired of spam?  Yahoo! Mail has the best spam protection around=20
http://mail.yahoo.com=20
