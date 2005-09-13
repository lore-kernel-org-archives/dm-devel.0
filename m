From: Nicola Murino <n.murino@theorematica.it>
Subject: EMC Cx300 multipath seems to work
Date: Tue, 13 Sep 2005 10:02:18 +0200
Message-ID: <4326878A.3090303@theorematica.it>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1376838185=="
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
Cc: christophe.varoqui@free.fr
List-Id: dm-devel.ids

This is a multi-part message in MIME format.
--===============1376838185==
Content-Type: multipart/alternative;
	boundary="------------050104070404070109030502"

This is a multi-part message in MIME format.
--------------050104070404070109030502
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Hi,

multipath seems to work on gentoo, I have to load the modules in proper
order, this is my configuration:

cat /etc/conf.d/local.start
# /etc/conf.d/local.start

# This is a good place to load any misc programs
# on startup ( use 1>&2 to hide output)
/sbin/modprobe dm-emc
/sbin/modprobe qla2300
/bin/sleep 5
/sbin/udevstart
/etc/init.d/multipathd start

is critical the command udevstart without only one path is seen,

I experienced a kernel oops with kernel-2.6.12 (both vanilla-sources and
gentoo-sources) when I load qla2300 module, here are the logs:

Unable to handle kernel NULL pointer dereference at virtual address 00000000
 printing eip:
f8f262c8
*pde = 00000000
Oops: 0000 [#1]
SMP
Modules linked in: dm_round_robin qla2300 qla2xxx dm_emc dm_multipath dm_mod
CPU:    1
EIP:    0060:[<f8f262c8>]    Not tainted VLI
EFLAGS: 00010086   (2.6.12-gentoo-r10)
EIP is at rr_select_path+0x8/0x50 [dm_round_robin]
eax: f30311cc   ebx: 00000000   ecx: f7f4d08c   edx: f30311cc
esi: f46f1580   edi: 00000001   ebp: f46f1580   esp: f75f1ee0
ds: 007b   es: 007b   ss: 0068
Process kmpathd/1 (pid: 5836, threadinfo=f75f0000 task=c2171530)
Stack: f30311c0 f8f12bf6 f30311cc f46f15b8 f46f1580 f7f4d080 f8f12cd9 f46f1580
       f30311c0 f46f1580 f7f4d080 00000000 f46f158c f8f12fd9 f46f1580 00000001
       c2171530 00000246 00000000 f46f1590 f46f15c8 f7f4d080 f46f15cc f46f1580
Call Trace:
 [<f8f12bf6>] __choose_path_in_pg+0x26/0x60 [dm_multipath]
 [<f8f12cd9>] __choose_pgpath+0xa9/0xc0 [dm_multipath]
 [<f8f12fd9>] process_queued_ios+0xd9/0x100 [dm_multipath]
 [<c012b229>] worker_thread+0x1b9/0x260
 [<f8f12f00>] process_queued_ios+0x0/0x100 [dm_multipath]
 [<c01163c0>] default_wake_function+0x0/0x20
 [<c01163c0>] default_wake_function+0x0/0x20
 [<c012b070>] worker_thread+0x0/0x260
 [<c012f85a>] kthread+0xba/0xc0
 [<c012f7a0>] kthread+0x0/0xc0
 [<c0101015>] kernel_thread_helper+0x5/0x10
Code: 40 08 8b 10 8b 48 04 89 11 89 4a 04 8b 13 89 42 04 89 10 89 58 04 89 03 31 c0 5b c3 8d b4 26 00 00 00 00 53 8b 44 24 08 8b 58 04 <8b> 03 39 d8 74 32 89 c1 8b 50 04 8b 00 85 c9 89 50 04 89 02 8b
 <4>device-mapper: dm-emc: long trespass command will be send
device-mapper: dm-emc: honor reservation bit will not be set (default)
Unable to handle kernel NULL pointer dereference at virtual address 00000000
 printing eip:
f8f262c8
*pde = 00000000
Oops: 0000 [#2]
SMP
Modules linked in: dm_round_robin qla2300 qla2xxx dm_emc dm_multipath dm_mod
CPU:    0
EIP:    0060:[<f8f262c8>]    Not tainted VLI
EFLAGS: 00010086   (2.6.12-gentoo-r10)
EIP is at rr_select_path+0x8/0x50 [dm_round_robin]
eax: f748c8cc   ebx: 00000000   ecx: f7f4d00c   edx: f748c8cc
esi: f46f1680   edi: 00000001   ebp: f46f1680   esp: f7517ee0
ds: 007b   es: 007b   ss: 0068
Process kmpathd/0 (pid: 5835, threadinfo=f7516000 task=f7f0e530)
Stack: f748c8c0 f8f12bf6 f748c8cc f46f16b8 f46f1680 f7f4d000 f8f12cd9 f46f1680
       f748c8c0 f46f1680 f7f4d000 00000000 f46f168c f8f12fd9 f46f1680 c200c558
       f7f0e530 00000246 00000000 f46f1690 f46f16c8 f7f4d000 f46f16cc f46f1680
Call Trace:
 [<f8f12bf6>] __choose_path_in_pg+0x26/0x60 [dm_multipath]
 [<f8f12cd9>] __choose_pgpath+0xa9/0xc0 [dm_multipath]
 [<f8f12fd9>] process_queued_ios+0xd9/0x100 [dm_multipath]
 [<c012b229>] worker_thread+0x1b9/0x260
 [<f8f12f00>] process_queued_ios+0x0/0x100 [dm_multipath]
 [<c01163c0>] default_wake_function+0x0/0x20
 [<c01163c0>] default_wake_function+0x0/0x20
 [<c012b070>] worker_thread+0x0/0x260
 [<c012f85a>] kthread+0xba/0xc0
 [<c012f7a0>] kthread+0x0/0xc0
 [<c0101015>] kernel_thread_helper+0x5/0x10
Code: 40 08 8b 10 8b 48 04 89 11 89 4a 04 8b 13 89 42 04 89 10 89 58 04 89 03 31 c0 5b c3 8d b4 26 00 00 00 00 53 8b 44 24 08 8b 58 04 <8b> 03 39 d8 74 32 89 c1 8b 50 04 8b 00 85 c9 89 50 04 89 02 8b
 <4>device-mapper: dm-emc: long trespass command will be send
device-mapper: dm-emc: honor reservation bit will not be set (default)
Unable to handle kernel NULL pointer dereference at virtual address 00000000
 printing eip:
f8f262c8
*pde = 00000000
Oops: 0000 [#3]
SMP
Modules linked in: dm_round_robin qla2300 qla2xxx dm_emc dm_multipath dm_mod
CPU:    2
EIP:    0060:[<f8f262c8>]    Not tainted VLI
EFLAGS: 00010086   (2.6.12-gentoo-r10)
EIP is at rr_select_path+0x8/0x50 [dm_round_robin]
eax: f7e4850c   ebx: 00000000   ecx: f7f4d10c   edx: f7e4850c
esi: f46e4880   edi: 00000001   ebp: f46e4880   esp: f777dee0
ds: 007b   es: 007b   ss: 0068
Process kmpathd/2 (pid: 5837, threadinfo=f777c000 task=f7d11a40)
Stack: f7e48500 f8f12bf6 f7e4850c f46e48b8 f46e4880 f7f4d100 f8f12cd9 f46e4880
       f7e48500 f46e4880 f7f4d100 00000000 f46e488c f8f12fd9 f46e4880 c201c9d0
       f7d11a40 00000246 00000000 f46e4890 f46e48c8 f7f4d100 f46e48cc f46e4880
Call Trace:
 [<f8f12bf6>] __choose_path_in_pg+0x26/0x60 [dm_multipath]
 [<f8f12cd9>] __choose_pgpath+0xa9/0xc0 [dm_multipath]
 [<f8f12fd9>] process_queued_ios+0xd9/0x100 [dm_multipath]
 [<c012b229>] worker_thread+0x1b9/0x260
 [<f8f12f00>] process_queued_ios+0x0/0x100 [dm_multipath]
 [<c01163c0>] default_wake_function+0x0/0x20
 [<c01163c0>] default_wake_function+0x0/0x20
 [<c012b070>] worker_thread+0x0/0x260
 [<c012f85a>] kthread+0xba/0xc0
 [<c012f7a0>] kthread+0x0/0xc0
 [<c0101015>] kernel_thread_helper+0x5/0x10
Code: 40 08 8b 10 8b 48 04 89 11 89 4a 04 8b 13 89 42 04 89 10 89 58 04 89 03 31 c0 5b c3 8d b4 26 00 00 00 00 53 8b 44 24 08 8b 58 04 <8b> 03 39 d8 74 32 89 c1 8b 50 04 8b 00 85 c9 89 50 04 89 02 8b
 <4>device-mapper: dm-emc: long trespass command will be send

however kernel-2.6.13 works fine (both vanilla and gentoo-sources)

here are my multipath configuration

grep -v "#" /etc/multipath.conf
defaults {
        multipath_tool  "/sbin/multipath -v0"
        udev_dir        /dev
        polling_interval 10
        default_selector        "round-robin 0"
        default_getuid_callout  "/sbin/scsi_id -g -u -s /block/%n"
        default_prio_callout    "/bin/true"
        failback        immediate
}
multipaths {

        multipath {
                wwid                    3600601608c901200ccfe543f4053d911
                alias                   200Gb
                path_grouping_policy    failover
                path_checker            readsector0
                path_selector           "round-robin 0"
                failback                immediate
        }
        multipath {
                wwid                    3600601608c9012006269b8f63b87d911
                alias                   5Gb
                path_grouping_policy    failover
                path_checker            readsector0
                path_selector           "round-robin 0"
                failback                immediate
        }
        multipath {
                wwid                    3600601608c9012008ae5de2cc985d911
                alias                   300Gb
                path_grouping_policy    failover
                path_checker            readsector0
                path_selector           "round-robin 0"
                failback                immediate
        }
}

The tests aren't very accurate because the machine is 100 Km away,
tomorrow I'll do more accurate tests, I'll post results,

big thanks to Cristophe for multipath-tools,
big thanks to gistolero for his accurate testing on gentoo, your posts
are very useful for me,

any suggestions to improve my setup are welcome,

I have to install naviagent? On redhat naviagent register powerpath name
to cx 300, it works with multipath?

Nicola

P.S. for gistolero, I haven't your problem with multipathd (or so seems)
however my hardware is different, I think also that the need to run
udevstart is a gentoo bug, today gentoo has releases udev-0.68-r1 with
start-stop script, if you read start script there is udevstart, however
I haven't yet tested this script because they require unstable
baselayout-1.12




--------------050104070404070109030502
Content-Type: text/html; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <meta content=3D"text/html;charset=3DISO-8859-15"
 http-equiv=3D"Content-Type">
  <title></title>
</head>
<body bgcolor=3D"#ffffff" text=3D"#000000">
Hi, <br>
<br>
multipath seems to work on gentoo, I have to load the modules in proper
order, this is my configuration:<br>
<br>
cat /etc/conf.d/local.start<br>
# /etc/conf.d/local.start<br>
<br>
# This is a good place to load any misc programs<br>
# on startup ( use 1&gt;&amp;2 to hide output)<br>
/sbin/modprobe dm-emc<br>
/sbin/modprobe qla2300<br>
/bin/sleep 5<br>
/sbin/udevstart<br>
/etc/init.d/multipathd start<br>
<br>
is critical the command udevstart without only one path is seen,<br>
<br>
I experienced a kernel oops with kernel-2.6.12 (both vanilla-sources
and gentoo-sources) when I load qla2300 module, here are the logs:<br>
<br>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3DUTF-8">
<meta name=3D"Generator" content=3D"Kate, the KDE Advanced Text Editor">
<pre>Unable to handle kernel NULL pointer dereference at virtual address =
00000000
 printing eip:
f8f262c8
*pde =3D 00000000
Oops: 0000 [#1]
SMP
Modules linked in: dm_round_robin qla2300 qla2xxx dm_emc dm_multipath dm_=
mod
CPU:    1
EIP:    0060:[&lt;f8f262c8&gt;]    Not tainted VLI
EFLAGS: 00010086   (2.6.12-gentoo-r10)
EIP is at rr_select_path+0x8/0x50 [dm_round_robin]
eax: f30311cc   ebx: 00000000   ecx: f7f4d08c   edx: f30311cc
esi: f46f1580   edi: 00000001   ebp: f46f1580   esp: f75f1ee0
ds: 007b   es: 007b   ss: 0068
Process kmpathd/1 (pid: 5836, threadinfo=3Df75f0000 task=3Dc2171530)
Stack: f30311c0 f8f12bf6 f30311cc f46f15b8 f46f1580 f7f4d080 f8f12cd9 f46=
f1580
       f30311c0 f46f1580 f7f4d080 00000000 f46f158c f8f12fd9 f46f1580 000=
00001
       c2171530 00000246 00000000 f46f1590 f46f15c8 f7f4d080 f46f15cc f46=
f1580
Call Trace:
 [&lt;f8f12bf6&gt;] __choose_path_in_pg+0x26/0x60 [dm_multipath]
 [&lt;f8f12cd9&gt;] __choose_pgpath+0xa9/0xc0 [dm_multipath]
 [&lt;f8f12fd9&gt;] process_queued_ios+0xd9/0x100 [dm_multipath]
 [&lt;c012b229&gt;] worker_thread+0x1b9/0x260
 [&lt;f8f12f00&gt;] process_queued_ios+0x0/0x100 [dm_multipath]
 [&lt;c01163c0&gt;] default_wake_function+0x0/0x20
 [&lt;c01163c0&gt;] default_wake_function+0x0/0x20
 [&lt;c012b070&gt;] worker_thread+0x0/0x260
 [&lt;c012f85a&gt;] kthread+0xba/0xc0
 [&lt;c012f7a0&gt;] kthread+0x0/0xc0
 [&lt;c0101015&gt;] kernel_thread_helper+0x5/0x10
Code: 40 08 8b 10 8b 48 04 89 11 89 4a 04 8b 13 89 42 04 89 10 89 58 04 8=
9 03 31 c0 5b c3 8d b4 26 00 00 00 00 53 8b 44 24 08 8b 58 04 &lt;8b&gt; =
03 39 d8 74 32 89 c1 8b 50 04 8b 00 85 c9 89 50 04 89 02 8b
 &lt;4&gt;device-mapper: dm-emc: long trespass command will be send
device-mapper: dm-emc: honor reservation bit will not be set (default)
Unable to handle kernel NULL pointer dereference at virtual address 00000=
000
 printing eip:
f8f262c8
*pde =3D 00000000
Oops: 0000 [#2]
SMP
Modules linked in: dm_round_robin qla2300 qla2xxx dm_emc dm_multipath dm_=
mod
CPU:    0
EIP:    0060:[&lt;f8f262c8&gt;]    Not tainted VLI
EFLAGS: 00010086   (2.6.12-gentoo-r10)
EIP is at rr_select_path+0x8/0x50 [dm_round_robin]
eax: f748c8cc   ebx: 00000000   ecx: f7f4d00c   edx: f748c8cc
esi: f46f1680   edi: 00000001   ebp: f46f1680   esp: f7517ee0
ds: 007b   es: 007b   ss: 0068
Process kmpathd/0 (pid: 5835, threadinfo=3Df7516000 task=3Df7f0e530)
Stack: f748c8c0 f8f12bf6 f748c8cc f46f16b8 f46f1680 f7f4d000 f8f12cd9 f46=
f1680
       f748c8c0 f46f1680 f7f4d000 00000000 f46f168c f8f12fd9 f46f1680 c20=
0c558
       f7f0e530 00000246 00000000 f46f1690 f46f16c8 f7f4d000 f46f16cc f46=
f1680
Call Trace:
 [&lt;f8f12bf6&gt;] __choose_path_in_pg+0x26/0x60 [dm_multipath]
 [&lt;f8f12cd9&gt;] __choose_pgpath+0xa9/0xc0 [dm_multipath]
 [&lt;f8f12fd9&gt;] process_queued_ios+0xd9/0x100 [dm_multipath]
 [&lt;c012b229&gt;] worker_thread+0x1b9/0x260
 [&lt;f8f12f00&gt;] process_queued_ios+0x0/0x100 [dm_multipath]
 [&lt;c01163c0&gt;] default_wake_function+0x0/0x20
 [&lt;c01163c0&gt;] default_wake_function+0x0/0x20
 [&lt;c012b070&gt;] worker_thread+0x0/0x260
 [&lt;c012f85a&gt;] kthread+0xba/0xc0
 [&lt;c012f7a0&gt;] kthread+0x0/0xc0
 [&lt;c0101015&gt;] kernel_thread_helper+0x5/0x10
Code: 40 08 8b 10 8b 48 04 89 11 89 4a 04 8b 13 89 42 04 89 10 89 58 04 8=
9 03 31 c0 5b c3 8d b4 26 00 00 00 00 53 8b 44 24 08 8b 58 04 &lt;8b&gt; =
03 39 d8 74 32 89 c1 8b 50 04 8b 00 85 c9 89 50 04 89 02 8b
 &lt;4&gt;device-mapper: dm-emc: long trespass command will be send
device-mapper: dm-emc: honor reservation bit will not be set (default)
Unable to handle kernel NULL pointer dereference at virtual address 00000=
000
 printing eip:
f8f262c8
*pde =3D 00000000
Oops: 0000 [#3]
SMP
Modules linked in: dm_round_robin qla2300 qla2xxx dm_emc dm_multipath dm_=
mod
CPU:    2
EIP:    0060:[&lt;f8f262c8&gt;]    Not tainted VLI
EFLAGS: 00010086   (2.6.12-gentoo-r10)
EIP is at rr_select_path+0x8/0x50 [dm_round_robin]
eax: f7e4850c   ebx: 00000000   ecx: f7f4d10c   edx: f7e4850c
esi: f46e4880   edi: 00000001   ebp: f46e4880   esp: f777dee0
ds: 007b   es: 007b   ss: 0068
Process kmpathd/2 (pid: 5837, threadinfo=3Df777c000 task=3Df7d11a40)
Stack: f7e48500 f8f12bf6 f7e4850c f46e48b8 f46e4880 f7f4d100 f8f12cd9 f46=
e4880
       f7e48500 f46e4880 f7f4d100 00000000 f46e488c f8f12fd9 f46e4880 c20=
1c9d0
       f7d11a40 00000246 00000000 f46e4890 f46e48c8 f7f4d100 f46e48cc f46=
e4880
Call Trace:
 [&lt;f8f12bf6&gt;] __choose_path_in_pg+0x26/0x60 [dm_multipath]
 [&lt;f8f12cd9&gt;] __choose_pgpath+0xa9/0xc0 [dm_multipath]
 [&lt;f8f12fd9&gt;] process_queued_ios+0xd9/0x100 [dm_multipath]
 [&lt;c012b229&gt;] worker_thread+0x1b9/0x260
 [&lt;f8f12f00&gt;] process_queued_ios+0x0/0x100 [dm_multipath]
 [&lt;c01163c0&gt;] default_wake_function+0x0/0x20
 [&lt;c01163c0&gt;] default_wake_function+0x0/0x20
 [&lt;c012b070&gt;] worker_thread+0x0/0x260
 [&lt;c012f85a&gt;] kthread+0xba/0xc0
 [&lt;c012f7a0&gt;] kthread+0x0/0xc0
 [&lt;c0101015&gt;] kernel_thread_helper+0x5/0x10
Code: 40 08 8b 10 8b 48 04 89 11 89 4a 04 8b 13 89 42 04 89 10 89 58 04 8=
9 03 31 c0 5b c3 8d b4 26 00 00 00 00 53 8b 44 24 08 8b 58 04 &lt;8b&gt; =
03 39 d8 74 32 89 c1 8b 50 04 8b 00 85 c9 89 50 04 89 02 8b
 &lt;4&gt;device-mapper: dm-emc: long trespass command will be send</pre>
however kernel-2.6.13 works fine (both vanilla and gentoo-sources)<br>
<br>
here are my multipath configuration<br>
<br>
grep -v "#" /etc/multipath.conf<br>
defaults {<br>
=A0=A0=A0=A0=A0=A0=A0 multipath_tool=A0 "/sbin/multipath -v0"<br>
=A0=A0=A0=A0=A0=A0=A0 udev_dir=A0=A0=A0=A0=A0=A0=A0 /dev<br>
=A0=A0=A0=A0=A0=A0=A0 polling_interval 10<br>
=A0=A0=A0=A0=A0=A0=A0 default_selector=A0=A0=A0=A0=A0=A0=A0 "round-robin =
0"<br>
=A0=A0=A0=A0=A0=A0=A0 default_getuid_callout=A0 "/sbin/scsi_id -g -u -s /=
block/%n"<br>
=A0=A0=A0=A0=A0=A0=A0 default_prio_callout=A0=A0=A0 "/bin/true"<br>
=A0=A0=A0=A0=A0=A0=A0 failback=A0=A0=A0=A0=A0=A0=A0 immediate<br>
}<br>
multipaths {<br>
<br>
=A0=A0=A0=A0=A0=A0=A0 multipath {<br>
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 wwid=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0
3600601608c901200ccfe543f4053d911<br>
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 alias=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 200Gb<br>
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 path_grouping_policy=A0=A0=A0=
 failover<br>
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 path_checker=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 readsector0<br>
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 path_selector=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0 "round-robin 0"<br>
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 failback=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0 immediate<br>
=A0=A0=A0=A0=A0=A0=A0 }<br>
=A0=A0=A0=A0=A0=A0=A0 multipath {<br>
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 wwid=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0
3600601608c9012006269b8f63b87d911<br>
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 alias=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 5Gb<br>
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 path_grouping_policy=A0=A0=A0=
 failover<br>
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 path_checker=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 readsector0<br>
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 path_selector=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0 "round-robin 0"<br>
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 failback=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0 immediate<br>
=A0=A0=A0=A0=A0=A0=A0 }<br>
=A0=A0=A0=A0=A0=A0=A0 multipath {<br>
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 wwid=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0
3600601608c9012008ae5de2cc985d911<br>
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 alias=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 300Gb<br>
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 path_grouping_policy=A0=A0=A0=
 failover<br>
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 path_checker=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 readsector0<br>
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 path_selector=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0 "round-robin 0"<br>
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 failback=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0 immediate<br>
=A0=A0=A0=A0=A0=A0=A0 }<br>
}<br>
<br>
The tests aren't very accurate because the machine is 100 Km away,
tomorrow I'll do more accurate tests, I'll post results,<br>
<br>
big thanks to Cristophe for multipath-tools,<br>
big thanks to gistolero for his accurate testing on gentoo, your posts
are very useful for me,<br>
<br>
any suggestions to improve my setup are welcome,<br>
<br>
I have to install naviagent? On redhat naviagent register powerpath
name to cx 300, it works with multipath?<br>
<br>
Nicola<br>
<br>
P.S. for gistolero, I haven't your problem with multipathd (or so
seems) however my hardware is different, I think also that the need to
run udevstart is a gentoo bug, today gentoo has releases udev-0.68-r1
with start-stop script, if you read start script there is udevstart,
however I haven't yet tested this script because they require unstable
baselayout-1.12<br>
<br>
<br>
<br>
</body>
</html>

--------------050104070404070109030502--


--===============1376838185==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1376838185==--
