From: Avi Kivity <avi@redhat.com>
Subject: 2.6.31-rc4 oops in fsnotify extending logical volume
Date: Wed, 29 Jul 2009 18:20:41 +0300
Message-ID: <4A7068C9.40802@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754574AbZG2PP7@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: dm-devel@redhat.com, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: dm-devel.ids

# lvextend -L +50G /dev/vg0/images

[ 6818.345369] BUG: unable to handle kernel NULL pointer dereference at 
(null)
[ 6818.345408] IP: [<ffffffff811156fc>] fsnotify+0xd8/0x11a
[ 6818.345441] PGD 3a71dd067 PUD 3dfc49067 PMD 0
[ 6818.345475] Oops: 0000 [#1] PREEMPT SMP
[ 6818.345508] last sysfs file: /sys/devices/virtual/block/ram9/uevent
[ 6818.345530] CPU 4
[ 6818.345547] Modules linked in: kvm_intel nfs lockd nfs_acl autofs4 
sunrpc cpufreq_ondemand acpi_cpufreq freq_table kvm bnx2 shpchp [last 
unloaded: kvm_intel]
[ 6818.345667] Pid: 5005, comm: lvextend Not tainted 2.6.31-rc4 #45 IBM 
System x -[794622G]-
[ 6818.345694] RIP: 0010:[<ffffffff811156fc>]  [<ffffffff811156fc>] 
fsnotify+0xd8/0x11a
[ 6818.345727] RSP: 0018:ffff8803a71b9e58  EFLAGS: 00010246
[ 6818.345746] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 
ffff880351450270
[ 6818.345770] RDX: 0000000000000000 RSI: ffffffff81117e3f RDI: 
ffff8803a71b8000
[ 6818.345793] RBP: ffff8803a71b9eb8 R08: ffff8803a71b9e08 R09: 
ffff880351450270
[ 6818.345817] R10: 00000037c8811140 R11: ffff8803a71b9d58 R12: 
0000000000000008
[ 6818.345840] R13: ffff88027c38dec8 R14: 0000000000000008 R15: 
0000000000000000
[ 6818.345864] FS:  00007f7bbf907790(0000) GS:ffffc90000800000(0000) 
knlGS:0000000000000000
[ 6818.346199] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 6818.346524] CR2: 0000000000000000 CR3: 000000021bf13000 CR4: 
00000000000026e0
[ 6818.346852] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[ 6818.347185] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
0000000000000400
[ 6818.347514] Process lvextend (pid: 5005, threadinfo ffff8803a71b8000, 
task ffff88047f102e60)
[ 6818.348215] Stack:
[ 6818.348531]  0000000000001000 ffff880351450270 0000000000000000 
0000000300000000
[ 6818.348876] <0> ffff88039488a900 000000007ef22600 ffff88027c38dec8 
ffff88039488a900
[ 6818.349533] <0> 0000000000000008 ffff88027c38dec8 ffff88027ef22600 
ffff88027c38dec8
[ 6818.350498] Call Trace:
[ 6818.350820]  [<ffffffff810eec08>] __fput+0xc4/0x1c5
[ 6818.351147]  [<ffffffff810eed23>] fput+0x1a/0x1c
[ 6818.351473]  [<ffffffff810ebde5>] filp_close+0x68/0x72
[ 6818.351797]  [<ffffffff810ebe9c>] sys_close+0xad/0xe7
[ 6818.352142]  [<ffffffff8100bd32>] system_call_fastpath+0x16/0x1b
[ 6818.352469] Code: 44 89 f6 4c 89 ef e8 bf 02 00 00 48 85 c0 48 89 c1 
74 27 48 8b 43 20 48 89 ce 48 89 4d a8 48 89 df ff 50 08 48 8b 4d a8 48 
8b 1b <48> 8b 03 48 81 fb 80 fc 55 81 0f 18 08 75 92 8b 75 cc 48 c7 c7

-- 
error compiling committee.c: too many arguments to function
