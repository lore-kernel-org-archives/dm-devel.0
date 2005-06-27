From: Andrew Morton <akpm@osdl.org>
Subject: Fw: dm-mirror/kmirrord oops
Date: Mon, 27 Jun 2005 00:48:27 -0700
Message-ID: <20050627004827.12a389e0.akpm@osdl.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
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
Cc: Cyril Chaboisseau <cyril.chaboisseau@free.fr>
List-Id: dm-devel.ids



Begin forwarded message:

Date: Mon, 27 Jun 2005 09:07:09 +0200
From: Cyril Chaboisseau <cyril.chaboisseau@free.fr>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: dm-mirror/kmirrord oops


I just had a big problem lately when I wanted to migrate my PV from one
disk to another

to do so, I first created a LVM partition on my second disk,

then I initialized the partition (pvcreate)
# pvcreate /dev/sdb1

I extended my vg to the newly PV
# vgextend vg /dev/sdb1

and then I tried to move the data from the old PV to the newly created
# pvmove -v /dev/sda4 /dev/sdb1

everything went fine for maybe half an hour, but at 21% it froze

I waited for maybe 15/20mn and couldn't do anything
the machine seemed to respond (KDE running with clock and gkrellm
showing progress) but I couldn't launch any command : everytime I typed
one nothing happened

so, I ended up rebooting the machine (reset)


after that, every attempt to boot multi-user or Single failed with an
oops on dm-mirror

at that point I was running 2.6.11.11 + grsec (BTW, the processor is amd64)

I finally stabilized things by commenting some LVM partitions on my fstab
(everything except /usr and /var) but every time I tried to backup
things onto another disk it would crash again

so I tried 2.6.12.1 with CONFIG_DM_MIRROR built-in instead of module

it worked a little but again after some time it crashed again with the
following :




Unable to handle kernel paging request at ffffc2000015c128 RIP: 
<ffffffff802964a8>{core_in_sync+8}
PGD 3ff92067 PUD 3ff91067 PMD 3ff90067 PTE 0
Oops: 0000 [1] 
CPU 0 
Modules linked in: af_packet ipv6 ip_nat_ftp ip_conntrack_ftp iptable_mangle iptable_nat snd_via82xx gameport snd_ac97_codec snd_pcm_oss snd_mixer_oss snd_pcm snd_timer snd_page_alloc snd_mpu401_uart snd_rawmidi snd_seq_device snd soundcore ehci_hcd tsdev eth1394 usbhid uhci_hcd 3c59x rt2500 ohci1394 quota_v2 cpufreq_powersave cpufreq_ondemand powernow_k8 freq_table processor w83627hf i2c_sensor i2c_isa i2c_core sr_mod sbp2 ieee1394 ide_cd cdrom evdev unix
Pid: 848, comm: kmirrord/0 Not tainted 2.6.12.1
RIP: 0010:[core_in_sync+8/32] <ffffffff802964a8>{core_in_sync+8}
RSP: 0018:ffff8100022afbf0  EFLAGS: 00010246
RAX: ffffc2000015b000 RBX: ffff81003b42e2d8 RCX: ffffc2000015f1a0
RDX: 0000000000000001 RSI: 0000000000008940 RDI: ffff81000ff93440
RBP: 0000000000008940 R08: 0000000000008940 R09: ffff810001b71f38
R10: 0000000000000001 R11: ffff810001000000 R12: 0000000000000001
R13: ffff81003b42e2c0 R14: ffff81003b42e2d8 R15: ffff81000ff93440
FS:  00002aaaab00d4a0(0000) GS:ffffffff8047a9c0(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: ffffc2000015c128 CR3: 000000002475a000 CR4: 00000000000006e0
Process kmirrord/0 (pid: 848, threadinfo ffff8100022ae000, task ffff810002264130)
Stack: ffffffff802969da ffff81000bb56b00 0000000000000000 ffff8100022afd28 
       ffffffff802972c7 ffff81003f7c3e00 32c932e0cc32cc37 9300814000002400 
       ffff81003b42e308 0000000000000002 
Call Trace:<ffffffff802969da>{rh_state+58} <ffffffff802972c7>{do_work+1735}
       <ffffffff801536c0>{mempool_free_slab+0} <ffffffff80306184>{thread_return+0}
       <ffffffff8013e5a8>{worker_thread+440} <ffffffff8012c1e0>{default_wake_function+0}
       <ffffffff8012c1e0>{default_wake_function+0} <ffffffff8013e3f0>{worker_thread+0}
       <ffffffff8014241d>{kthread+205} <ffffffff8010f173>{child_rip+8}
       <ffffffff801e4b70>{vgacon_cursor+0} <ffffffff80142460>{keventd_create_kthread+0}
       <ffffffff80142350>{kthread+0} <ffffffff8010f16b>{child_rip+0}
       

Code: 0f a3 30 19 f6 31 c0 85 f6 0f 95 c0 c3 66 66 66 90 66 66 66 
RIP <ffffffff802964a8>{core_in_sync+8} RSP <ffff8100022afbf0>
CR2: ffffc2000015c128



after several attemps to move the PV to another disk, I finally rebooted
multi-user and under a graphical console I realized that a lot of disk
activity was going on plus a /dev/vg/pmove0 LV was created

so I waited until the pvmove finalized and after that, I could copy,
delete, remove LV and so on without any glitch or freeze !




from my understanding, there is a locking problem and if a process tries
to do something on a block while it's being moved, then dm-mirror (or
kmirrod if built-in) crashes

has anyone experienced the same problem ?

could this be related to the 64 bits arch ? (amd64)


thanks for your help



PS : I finally destroyed the whole LVM and reconstructed another one
from backup so I cannot provide anymore information nor reproduce the
bug

-- 
	Cyril Chaboisseau
