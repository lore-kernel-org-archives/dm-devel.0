From: Tim Burgess <tim.burgess@anu.edu.au>
Subject: system hang issues with mirror target
Date: Wed, 16 Feb 2005 21:37:47 +1100
Message-ID: <4213227B.9000407@anu.edu.au>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------000905070107000107080708"
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

This is a multi-part message in MIME format.
--------------000905070107000107080708
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Hi folks,

As promised, here are the details of the system hangs I've experienced
using the dm mirror target.  In addition, there are some serious
performance issues I've noticed using the vanilla kernel (as compared
with SuSE SLES9 SP1).

There are two configurations I have been testing, both fail under heavy
i/o activity.  The system we are testing is 16 fibre channel JBOD drives
connected to 4 qlogic 23xx HBAs on a 4 processor SGI sn2 itanium system.

We can reliably see ~680MB/s write performance from this setup using the
stripe target across all 16 drives.  The issue comes with mirroring.

Note - we REALLY have an interest in resolving these issues, so I'm more
than happy to test any changes on this system with relatively quick (as
much as timezone differences permit) turnaround.

The desired configuration is a single stripe over 8 mirror pairs.  Each
of the underlying devices should eventually be a multipath target, but
for illustrative purposes we aren't bothering (In addition, the mirror
should prevent applications seeing failure if a single path fails).

Under SuSE SLES9 SP1, this configuration can sustain ~340MB/s to the
mirror target (i.e. 680 to disk).  However, after a certain seemingly
random period of time (minutes not hours) doing heavy i/o (repeated dd's
of the whole stripe device), the kernel will panic (dump attached).

The behaviour can also be reproduced with only a single pair of mirrors,
no stripe, by running one dd's to each mirror simultaneously.

The configuration info and sysrq-p outputs are attached in the file
stack_trace_dm_deadhang.

Using the vanilla (2.6.11-rc4) kernel, however, the performance we see
from this configuration is dismal - about 120MB/s to the mirror.
Watching iostat it appears that i/o is occurring to only mirror pair at
a time, usually for 5-10 seconds, before another pair becomes active
(there is clearly some overlap, since 120MB/s is more than a single
mirrored pair of disks is able to sustain, but the observation holds).

As a result (???) of the poor performance I have not reproduced the
error on 2.6.11-rc4.

HOWEVER (stay tuned folks), by reordering the layers (mirror over two
stripes) I was able to restore the full performance observed under SuSE,
as well as the crash observed under SuSE (not a panic this time, just a
complete system lock).

The configuration information, SysRq-p and SysRq-t outputs are attached
in the file stack_trace_dm_livehang_vanilla.

NOTE: sysrq-t removed - I suspect my first post didn't get through 
because it was too large...

Thanks again for your work,

Tim





-- 
--------------------------------------------------------------------------
                                      ANU Supercomputer Facility
     tim.burgess@anu.edu.au           and APAC National Facility
     Phone: +61 2 6125 1431           Leonard Huxley Bldg (No. 56)
     Fax:   +61 2 6125 8199           Australian National University
                                      Canberra, ACT, 0200, Australia
--------------------------------------------------------------------------
    "Money can buy bandwidth, but latency is forever" -- John Mashey
--------------------------------------------------------------------------





-- 
--------------------------------------------------------------------------
                                     ANU Supercomputer Facility
    tim.burgess@anu.edu.au           and APAC National Facility
    Phone: +61 2 6125 1431           Leonard Huxley Bldg (No. 56)
    Fax:   +61 2 6125 8199           Australian National University
                                     Canberra, ACT, 0200, Australia
--------------------------------------------------------------------------
   "Money can buy bandwidth, but latency is forever" -- John Mashey
--------------------------------------------------------------------------


--------------000905070107000107080708
Content-Type: text/plain; x-mac-type="0"; x-mac-creator="0";
	name="stack_trace_dm_deadhang"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="stack_trace_dm_deadhang"

Command:

# while true; do time dd if=/dev/zero of=/dev/mapper/reliable bs=1024k count=65536; done

Setup:

#!/bin/sh
dmsetup remove_all

dmsetup create mirror0 <<EOF
0 16777216  mirror core 1 2048 2 /dev/sdd 0 /dev/sdt 0
EOF

dmsetup create mirror1 <<EOF
0 16777216 mirror core 1 2048 2 /dev/sde 0 /dev/sdu 0
EOF

dmsetup create mirror2 <<EOF
0 16777216  mirror core 1 2048 2 /dev/sdf 0 /dev/sdv 0
EOF

dmsetup create mirror3 <<EOF
0 16777216 mirror core 1 2048 2 /dev/sdg 0 /dev/sdw 0
EOF

dmsetup create mirror4 <<EOF
0 16777216  mirror core 1 2048 2 /dev/sdp 0 /dev/sdae 0
EOF

dmsetup create mirror5 <<EOF
0 16777216 mirror core 1 2048 2 /dev/sdq 0 /dev/sdaf 0
EOF

dmsetup create mirror6 <<EOF
0 16777216  mirror core 1 2048 2 /dev/sdr 0 /dev/sdag 0
EOF

dmsetup create mirror7 <<EOF
0 16777216 mirror core 1 2048 2 /dev/sds 0 /dev/sdah 0
EOF

dmsetup create reliable <<EOF
0 134217728 striped 8 512 /dev/mapper/mirror0 0 /dev/mapper/mirror1 0 /dev/mapper/mirror2 0 /dev/mapper/mirror3 0 /dev/mapper/mirror4 0 /dev/mapper/mirror5 0 /dev/mapper/mirror6 0 /dev/mapper/mirror7 0
EOF

Stack Dump:

Pid: 0, CPU 0, comm:              swapper
psr : 0000101008026018 ifs : 8000000000000389 ip  : [<a0000002054d3ce0>]    Tainted: GF U (2.6.5-7.139-default SLES9_SP1_BRANCH-200501141541330000)
ip is at mirror_end_io+0xe0/0x300 [dm_mirror]
unat: 0000000000000000 pfs : 0000000000000389 rsc : 0000000000000003
rnat: 0000000000000000 bsps: a000000100a09be0 pr  : 80000000ff659969
ldrs: 0000000000000000 ccv : 00000000ffffc000 fpsr: 0009804c8a70033f
csd : 0000000000000000 ssd : 0000000000000000
b0  : a0000002054d3cb0 b6  : a0000001001143d0 b7  : a0000002054d3c00
f6  : 1003e000000009e37783b f7  : 000000000000000000000
f8  : 1003e00000b14c68db1da f9  : 10009c1c0000000000000
f10 : 1003e00000b14c68db1da f11 : 1003e00000000000011ee
r1  : a0000002056d0000 r2  : 000000000000001b r3  : a0000002055c4000
r8  : 0000000000000000 r9  : 00000000b14c68db r10 : 000000000000003f
r11 : 00000b14c68db1da r12 : a00000010072fb80 r13 : a000000100728000
r14 : 0000000000000001 r15 : a0000002055c41b0 r16 : e00000b0f6c26150
r17 : a0000002055c41b0 r18 : 0000000000000038 r19 : e00000b0f6c26138
r20 : 00000000000001b0 r21 : a0000002055c4000 r22 : 000000000000001b
r23 : 00000000b14c68db r24 : 000000000000003f r25 : 00000b14c68db1da
r26 : e00000b0f6c26148 r27 : 000000009e37783b r28 : 0000000000000b4d
r29 : e00000b012d69b08 r30 : a0000002055c41b0 r31 : e000003009f1f098

Call Trace:
 [<a000000100019840>] show_stack+0x80/0xa0
                                sp=a00000010072f750 bsp=a0000001007297d0
 [<a00000010003bdb0>] die+0x1b0/0x2a0
                                sp=a00000010072f920 bsp=a000000100729798
 [<a00000010005b350>] ia64_do_page_fault+0x730/0xa60
                                sp=a00000010072f920 bsp=a000000100729730
 [<a000000100010100>] ia64_leave_kernel+0x0/0x260
                                sp=a00000010072f9b0 bsp=a000000100729730
 [<a0000002054d3ce0>] mirror_end_io+0xe0/0x300 [dm_mirror]
                                sp=a00000010072fb80 bsp=a0000001007296e8
 [<a000000204e599b0>] clone_endio+0xd0/0x2a0 [dm_mod]
                                sp=a00000010072fb80 bsp=a0000001007296a0
 [<a00000010016fc80>] bio_endio+0x120/0x180
                                sp=a00000010072fb80 bsp=a000000100729668
 [<a0000002054d77d0>] write_callback+0x130/0x160 [dm_mirror]
                                sp=a00000010072fb80 bsp=a000000100729640
 [<a000000204e67750>] dec_count+0x170/0x180 [dm_mod]
                                sp=a00000010072fb90 bsp=a0000001007295f0
 [<a000000204e679a0>] endio+0x240/0x2a0 [dm_mod]
                                sp=a00000010072fb90 bsp=a000000100729588
 [<a00000010016fc80>] bio_endio+0x120/0x180
                                sp=a00000010072fba0 bsp=a000000100729550
 [<a0000001003ba660>] __end_that_request_first+0x240/0x4a0
                                sp=a00000010072fba0 bsp=a0000001007294d8
 [<a000000204d85000>] scsi_end_request+0x60/0x280 [scsi_mod]
                                sp=a00000010072fba0 bsp=a000000100729490
 [<a000000204d854d0>] scsi_io_completion+0x2b0/0x920 [scsi_mod]
                                sp=a00000010072fba0 bsp=a000000100729410
 [<a000000204d36d50>] sd_rw_intr+0x110/0x560 [sd_mod]
                                sp=a00000010072fba0 bsp=a0000001007293b8
 [<a000000204d763e0>] scsi_finish_command+0x2c0/0x2e0 [scsi_mod]
                                sp=a00000010072fba0 bsp=a000000100729388
 [<a000000204d77da0>] scsi_softirq+0x320/0x360 [scsi_mod]
                                sp=a00000010072fba0 bsp=a000000100729348
 [<a0000001000aa5c0>] __do_softirq+0x100/0x200
                                sp=a00000010072fbb0 bsp=a0000001007292c8
 [<a0000001000aa740>] do_softirq+0x80/0xe0
                                sp=a00000010072fbb0 bsp=a000000100729268
 [<a000000100016cc0>] ia64_handle_irq+0x1e0/0x200
                                sp=a00000010072fbb0 bsp=a000000100729220
 [<a000000100010100>] ia64_leave_kernel+0x0/0x260
                                sp=a00000010072fbb0 bsp=a000000100729220
 [<a0000001000172a0>] ia64_save_scratch_fpregs+0x0/0x40
                                sp=a00000010072fd80 bsp=a0000001007291f0
 [<a000000100018bb0>] default_idle+0xb0/0x180
                                sp=a00000010072fd80 bsp=a0000001007291a0
 [<a0000001000194d0>] cpu_idle+0x110/0x1e0
                                sp=a00000010072fe20 bsp=a000000100729140
 [<a000000100009100>] ia64_spinlock_contention_end+0xa0/0x100
                                sp=a00000010072fe20 bsp=a000000100729128
 [<a0000001006c4cf0>] start_kernel+0x4d0/0x6c0
                                sp=a00000010072fe20 bsp=a0000001007290c8
 [<a000000100008590>] _start+0x270/0x290
                                sp=a00000010072fe30 bsp=a000000100729030
 <0>In interrupt handler - not syncing<0>Kernel panic: Aiee, killing interrupt handler!


--------------000905070107000107080708
Content-Type: text/plain; x-mac-type="0"; x-mac-creator="0";
	name="s_t_dm_livehang_vanilla_noT"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="s_t_dm_livehang_vanilla_noT"

#!/bin/sh
dmsetup remove_all

dmsetup create stripe0 <<EOF
0 134217728 striped 8 512 /dev/sdd 0 /dev/sde 0 /dev/sdf 0 /dev/sdg 0 /dev/sdp 0 /dev/sdq 0 /dev/sdr 0 /dev/sds 0
EOF

dmsetup create stripe1 <<EOF
0 134217728 striped 8 512 /dev/sdt 0 /dev/sdu 0 /dev/sdv 0 /dev/sdw 0 /dev/sdae 0 /dev/sdaf 0 /dev/sdag 0 /dev/sdah 0
EOF

dmsetup create mirror <<EOF
0 134217728 mirror core 1 2048 2 /dev/mapper/stripe0 0 /dev/mapper/stripe1 0
EOF

SysRq : Show Regs
Modules linked in: dm_mirror evdev joydev sg st sr_mod ide_cd cdrom ipv6 binfmt_misc tg3 usbcore nls_iso8859_1 nls_cp437 dm_mod xfs exportfs qla2300 qla2xxx scsi_transport_fc qla1280 sgiioc4 sd_mod scsi_mod

Pid: 0, CPU 1, comm:              swapper
psr : 0000101008026018 ifs : 8000000000000002 ip  : [<a00000010053a6c0>]    Not tainted
ip is at _read_lock+0x80/0xc0
unat: 0000000000000000 pfs : 000000000000040a rsc : 0000000000000003
rnat: 8000000000000004 bsps: 0000000000000000 pr  : 80000000e9556569
ldrs: 0000000000000000 ccv : 0000000000000000 fpsr: 0009804c0270033f
csd : 0000000000000000 ssd : 0000000000000000
b0  : a00000020500f5e0 b6  : a000000100003320 b7  : a00000020500f560
f6  : 1003e000000000000003d f7  : 1003e0000000000007a00
f8  : 1003e0000000000001dc9 f9  : 1003e000000000000007d
f10 : 1003e000000000000007a f11 : 1003e0000000000000100
r1  : a00000010095b0c0 r2  : 0000000080000000 r3  : 0000000080000000
r8  : 0000000080000000 r9  : e00000346143d1a0 r10 : 0000000000000000
r11 : e00000346143d1b0 r12 : e00000b0f6037b60 r13 : e00000b0f6030000
r14 : 0000000080000001 r15 : a0000002050139f8 r16 : 0000000000000000
r17 : 0000000000000011 r18 : e00000346143d198 r19 : a00000020500f560
r20 : a0007fff65270000 r21 : e00000b0f6030d84 r22 : 00000000161c7c00
r23 : a00000010076d1d0 r24 : e00000b0f24dd860 r25 : 000000000000217f
r26 : e00000b0f1af6440 r27 : e00000b0f1af6400 r28 : e00000b013ba1898
r29 : 0000000000004000 r30 : 0000000000004000 r31 : e00000b0f24dd850

Call Trace:
 [<a000000100011660>] show_stack+0x80/0xa0
                                sp=e00000b0f6037700 bsp=e00000b0f6031808
 [<a000000100011ec0>] show_regs+0x840/0x880
                                sp=e00000b0f60378d0 bsp=e00000b0f60317a0
 [<a000000100356190>] sysrq_handle_showregs+0x30/0x60
                                sp=e00000b0f60378e0 bsp=e00000b0f6031778
 [<a000000100355bd0>] __handle_sysrq+0xf0/0x2a0
                                sp=e00000b0f60378e0 bsp=e00000b0f6031720
 [<a000000100355dc0>] handle_sysrq+0x40/0x60
                                sp=e00000b0f60378e0 bsp=e00000b0f60316f0
 [<a000000100372e70>] sn_receive_chars+0x450/0x480
                                sp=e00000b0f60378e0 bsp=e00000b0f6031660
 [<a0000001003731a0>] sn_sal_interrupt+0x1e0/0x240
                                sp=e00000b0f60378f0 bsp=e00000b0f6031618
 [<a0000001000e4190>] handle_IRQ_event+0x90/0x120
                                sp=e00000b0f6037990 bsp=e00000b0f60315d0
 [<a0000001000e44a0>] __do_IRQ+0x280/0x360
                                sp=e00000b0f6037990 bsp=e00000b0f6031578
 [<a00000010000e770>] ia64_handle_irq+0xd0/0x160
                                sp=e00000b0f6037990 bsp=e00000b0f6031538
 [<a00000010000ab20>] ia64_leave_kernel+0x0/0x260
                                sp=e00000b0f6037990 bsp=e00000b0f6031538
 [<a00000010053a6c0>] _read_lock+0x80/0xc0
                                sp=e00000b0f6037b60 bsp=e00000b0f6031528
 [<a00000020500f5e0>] mirror_end_io+0x80/0x200 [dm_mirror]
                                sp=e00000b0f6037b60 bsp=e00000b0f60314e8
 [<a000000204e51b70>] clone_endio+0xd0/0x2c0 [dm_mod]
                                sp=e00000b0f6037b60 bsp=e00000b0f60314a0
 [<a00000010013eb20>] bio_endio+0x100/0x160
                                sp=e00000b0f6037b60 bsp=e00000b0f6031468
 [<a000000205012f10>] write_callback+0x130/0x160 [dm_mirror]
                                sp=e00000b0f6037b60 bsp=e00000b0f6031440
 [<a000000204e60390>] dec_count+0x170/0x180 [dm_mod]
                                sp=e00000b0f6037b70 bsp=e00000b0f60313f0
 [<a000000204e605e0>] endio+0x240/0x2a0 [dm_mod]
                                sp=e00000b0f6037b70 bsp=e00000b0f6031388
 [<a00000010013eb20>] bio_endio+0x100/0x160
                                sp=e00000b0f6037b80 bsp=e00000b0f6031350
 [<a000000204e51ca0>] clone_endio+0x200/0x2c0 [dm_mod]
                                sp=e00000b0f6037b80 bsp=e00000b0f6031308
 [<a00000010013eb20>] bio_endio+0x100/0x160
                                sp=e00000b0f6037b80 bsp=e00000b0f60312d0
 [<a000000100386d80>] __end_that_request_first+0x240/0x4a0
                                sp=e00000b0f6037b80 bsp=e00000b0f6031258
 [<a000000100387010>] end_that_request_chunk+0x30/0x60
                                sp=e00000b0f6037b80 bsp=e00000b0f6031228
 [<a000000204d99d60>] scsi_end_request+0x60/0x220 [scsi_mod]
                                sp=e00000b0f6037b80 bsp=e00000b0f60311d8
 [<a000000204d9a1e0>] scsi_io_completion+0x2c0/0x960 [scsi_mod]
                                sp=e00000b0f6037b80 bsp=e00000b0f6031148
 [<a000000204d43030>] sd_rw_intr+0x1d0/0x5e0 [sd_mod]
                                sp=e00000b0f6037b90 bsp=e00000b0f60310d8
 [<a000000204d8a700>] scsi_finish_command+0x1c0/0x200 [scsi_mod]
                                sp=e00000b0f6037bb0 bsp=e00000b0f60310a8
 [<a000000204d8bf40>] scsi_softirq+0x320/0x360 [scsi_mod]
                                sp=e00000b0f6037bb0 bsp=e00000b0f6031068
 [<a0000001000a6ad0>] __do_softirq+0x130/0x240
                                sp=e00000b0f6037bc0 bsp=e00000b0f6030fc0
 [<a0000001000a6c60>] do_softirq+0x80/0xe0
                                sp=e00000b0f6037bc0 bsp=e00000b0f6030f60
 [<a0000001000a6d40>] irq_exit+0x80/0xa0
                                sp=e00000b0f6037bc0 bsp=e00000b0f6030f48
 [<a00000010000e7e0>] ia64_handle_irq+0x140/0x160
                                sp=e00000b0f6037bc0 bsp=e00000b0f6030f08
 [<a00000010000ab20>] ia64_leave_kernel+0x0/0x260
                                sp=e00000b0f6037bc0 bsp=e00000b0f6030f08
 [<a00000010000ff30>] default_idle+0x170/0x1a0
                                sp=e00000b0f6037d90 bsp=e00000b0f6030e90
 [<a000000100011160>] cpu_idle+0x200/0x2c0
                                sp=e00000b0f6037e30 bsp=e00000b0f6030e20
 [<a00000010004e9a0>] start_secondary+0x2e0/0x300
                                sp=e00000b0f6037e30 bsp=e00000b0f6030de0
 [<a0000001000085f0>] _start+0x2d0/0x300
                                sp=e00000b0f6037e30 bsp=e00000b0f6030de0



--------------000905070107000107080708
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
--------------000905070107000107080708--
