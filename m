From: lnx dm <lnxdm@yahoo.com>
Subject: persistent device names on rhel4
Date: Tue, 18 Jul 2006 06:32:42 -0700 (PDT)
Message-ID: <20060718133242.2043.qmail@web55703.mail.re3.yahoo.com>
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

I am using multipathing on rhel4 u3 x86_64 with
EVA4000 and HSV200 controller.

I had a few questions:

1. lsmod shows the below modules=20

dm_mirror              29017  0
dm_round_robin          4929  1
dm_multipath           21841  2 dm_round_robin
dm_mod                 67457  9 dm_mirror,dm_multipath

Do need to insert "multipath" module also ?
If yes then what it is for ?

without using multipath module I can see multiple
paths in multipath -v2 -l output

2. How do I ensure that the same device gets mounted
across reboots ?
I verified that across the reboots mpath6 refers to
the same device, wwid is same for mpath6 across
reboots

# multipath -v2 -l
mpath6 (3600805f300176640a435a927359c0003)
[size=3D440 GB][features=3D"0"][hwhandler=3D"0"]
\_ round-robin 0 [active]
 \_ 2:0:0:1     sdag 66:0   [active][ready]
 \_ 0:0:0:1     sda  8:0    [active][ready]

I have /dev/mapper/mpath6 in /etc/fstab and it works
correctly.

# ls -l /dev/mpath/mpath6
lrwxrwxrwx  1 root root 7 Jul 18 06:13
/dev/mpath/mpath6 -> ../dm-6

What is the difference if I use /dev/dm-6 ?

which will be better ?

Thanks.

__________________________________________________
Do You Yahoo!?
Tired of spam?  Yahoo! Mail has the best spam protection around=20
http://mail.yahoo.com=20
