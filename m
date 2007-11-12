From: hxsrmeng <hxsrmeng@gmail.com>
Subject: Kernel oops with "Unable to handle kernel paging request"
Date: Mon, 12 Nov 2007 16:11:34 -0500
Message-ID: <1194901894.5521.8.camel@OpenSUSE-desktop.Home>
Reply-To: hxsrmeng@gmail.com,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
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

Hi friends,

I am trying out a dm-cache module at
http://www.acis.ufl.edu/~ming/dmcache/index.html

64-bit machine with Kernel 2.6.16.53.

Everything is fine until I use "dmsetup" to remove the target dm-cache
module added.

I attached the dmesg | ksymoops message hereafter. Would anybody give me
any hint about how I can trace the oops? Thanks in advance.

$dmesg | ksymoops
ksymoops 2.4.11 on x86_64 2.6.16.53-0.16-.  Options used
     -V (default)
     -k /proc/kallsyms (default)
     -l /proc/modules (default)
     -o /lib/modules/2.6.16.53/ (default)
     -m /boot/System.map-2.6.16.53(default)

Warning: You did not tell me where to find symbol information.  I will
assume that the log matches the kernel and modules that are running
right now and I'll use the default options above for symbol resolution.
If the current kernel and/or modules do not match the log, you can get
more accurate output by telling me the kernel version and where to find
map, modules, ksyms etc.  ksymoops -h explains the options.

Warning (read_ksyms): no kernel symbols in ksyms, is /proc/kallsyms a
valid ksyms file?
No modules in ksyms, skipping objects
No ksyms, skipping lsmod
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
activating NMI Watchdog ... done.
testing NMI watchdog ... OK.
ehci_hcd 0000:00:1d.7: debug port 1
e1000: 0000:0d:00.0: e1000_probe: (PCI Express:2.5Gb/s:Width x1)
00:30:48:92:3c:76
e1000: eth0: e1000_probe: Intel(R) PRO/1000 Network Connection
e1000: 0000:0e:00.0: e1000_probe: (PCI Express:2.5Gb/s:Width x1)
00:30:48:92:3c:77
e1000: eth1: e1000_probe: Intel(R) PRO/1000 Network Connection
SGI XFS with ACLs, security attributes, realtime, large block/inode
numbers, no debug enabled
e1000: eth0: e1000_watchdog: NIC Link is Up 100 Mbps Full Duplex
e1000: eth0: e1000_watchdog: 10/100 speed: disabling TSO
lo: Disabled Privacy Extensions
Unable to handle kernel NULL pointer dereference at 0000000000000004
RIP:
[<0000000000000004>]
Oops: 0010 [1] SMP
CPU 0
Pid: 5176, comm: dmsetup Tainted: G     U 2.6.16.53 #2
RIP: 0010:[<0000000000000004>] [<0000000000000004>]
Using defaults from ksymoops -t elf64-x86-64 -a i386:x86-64
RSP: 0018:ffff810071dedad0  EFLAGS: 00010206
RAX: 0000000000000000 RBX: 0000000000000010 RCX: 0000000000000000
RDX: ffff810072130300 RSI: 0000000000000003 RDI: 0000000000011200
RBP: ffffc200003a2000 R08: ffff810071dedbf8 R09: 0000000000000001
R10: 0000000000000001 R11: 0000000000000000 R12: ffff810072130300
R13: 0000000000011210 R14: ffff810071dedbf8 R15: 0000000000000011
FS:  00002ba169eaaae0(0000) GS:ffffffff803b1000(0000)
knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000004 CR3: 0000000071c62000 CR4: 00000000000006e0
Stack: ffffffff8015fb85 ffff810071dedb18 ffffffff8012afdc
0000000000000246
       0000000000000036 0000000000000000 ffff81007d6032c0
ffff8100376cd0c0
       0000000000000082 0000000000000400
Call Trace: <ffffffff8015fb85>{mempool_alloc+49}
<ffffffff8012afdc>{__wake_up+56}
       <ffffffff80184e7d>{bio_alloc_bioset+28}
<ffffffff880dfa7a>{:dm_mod:dispatch_io+124}
       <ffffffff880df958>{:dm_mod:vm_get_page+0}
<ffffffff880df91e>{:dm_mod:vm_next_page+0}
       <ffffffff880dfd70>{:dm_mod:sync_io+122}
<ffffffff880dfe11>{:dm_mod:dm_io_sync_vm+56}
       <ffffffff880df958>{:dm_mod:vm_get_page+0}
<ffffffff880df91e>{:dm_mod:vm_next_page+0}
       <ffffffff8832d31c>{:dm_cache:cache_dtr+545}
<ffffffff8012afdc>{__wake_up+56}
       <ffffffff880df5ae>{:dm_mod:dev_remove+0}
<ffffffff880dca64>{:dm_mod:dm_table_put+88}
       <ffffffff880dba6d>{:dm_mod:dm_put+155}
<ffffffff880df655>{:dm_mod:dev_remove+167}
       <ffffffff880df41d>{:dm_mod:ctl_ioctl+527}
<ffffffff80191715>{do_ioctl+85}
       <ffffffff80191968>{vfs_ioctl+573} <ffffffff801919e3>{sys_ioctl
+98}
       <ffffffff8010af6a>{system_call+126}
Code:  Bad RIP value.
CR2: 0000000000000004
Warning (Oops_read): Code line not seen, dumping what data is available


>>RIP; 00000004 Before first symbol   <=====

>>RDX; ffff810072130300 <phys_startup_64
+ffff810072030200/ffffffff7fffff00>
>>RBP; ffffc200003a2000 <phys_startup_64
+ffffc200002a1f00/ffffffff7fffff00>
>>R08; ffff810071dedbf8 <phys_startup_64
+ffff810071cedaf8/ffffffff7fffff00>
>>R12; ffff810072130300 <phys_startup_64
+ffff810072030200/ffffffff7fffff00>
>>R14; ffff810071dedbf8 <phys_startup_64
+ffff810071cedaf8/ffffffff7fffff00>

Trace; ffffffff8015fb85 <mempool_alloc+31/e2>
Trace; ffffffff80184e7d <bio_alloc_bioset+1c/e9>
Trace; ffffffff880df958 <_end+7c3debc/7f15e564>
Trace; ffffffff880dfd70 <_end+7c3e2d4/7f15e564>
Trace; ffffffff880df958 <_end+7c3debc/7f15e564>
Trace; ffffffff8832d31c <_end+7e8b880/7f15e564>
Trace; ffffffff880df5ae <_end+7c3db12/7f15e564>
Trace; ffffffff880dba6d <_end+7c39fd1/7f15e564>
Trace; ffffffff880df41d <_end+7c3d981/7f15e564>
Trace; ffffffff80191968 <vfs_ioctl+23d/256>
Trace; ffffffff8010af6a <system_call+7e/83>


3 warnings issued.  Results may not be reliable.
