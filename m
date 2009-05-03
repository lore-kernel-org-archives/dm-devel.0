From: Robert Hancock <hancockrwd@gmail.com>
Subject: Re: dm-multipath completely breaks AHCI driver
Date: Sun, 03 May 2009 14:43:01 -0600
Message-ID: <49FE01D5.1070901@gmail.com>
References: <200905031126.52842.arvidjaar@mail.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <200905031126.52842.arvidjaar@mail.ru>
Sender: linux-ide-owner@vger.kernel.org
To: Andrey Borzenkov <arvidjaar@mail.ru>
Cc: dm-devel@redhat.com, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

Andrey Borzenkov wrote:
> Yeah, me knows - it does sound weird.
> 
> I moved my system from to different notebook (it was pure rsync + 
> mkinitrd + couple of adjustments in loaded modules). Older one was using 
> pata_ali, new one is using AHCI (Intel ICH8).
> 
> After booting it (using *the* *same* kernel, only different modules) for 
> the first time I started to get random oopses, file system corruptions 
> as well as scary HSM violations in logs.
> 
> Ubuntu live CD had no issues (even with relatively high IO load during 
> kernel compilation); also my son used this notebook for several months 
> under ArchLinux without any issues either.
> 
> I compiled minimal stripped down kernel which worked. I tried to compile 
> more feature reach one - and immediately got HSM violations. This time I 
> noticed that "bad" one had dm-multipath and "good" one not ... well, 
> removing /etc/mutipath.conf (to block loading of it) - and lo and 
> behold! I am running without any issues ...
> 
> So what I got in logs was:
> 
> [   18.593217] device-mapper: uevent: version 1.0.3
> [   18.593873] device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) 
> initialised: dm-devel@redhat.com
> [   18.664812] device-mapper: multipath: version 1.0.5 loaded
> [   19.070383] ata1.00: exception Emask 0x2 SAct 0x73 SErr 0x3000400 
> action 0x6
> [   19.070389] ata1.00: irq_stat 0x45000008
> [   19.070395] ata1: SError: { Proto TrStaTrns UnrecFIS }
> [   19.070406] ata1.00: cmd 60/08:00:e2:e5:c3/00:00:01:00:00/40 tag 0 
> ncq 4096 in
> [   19.070409]          res 40/00:38:00:00:00/00:00:00:00:00/40 Emask 
> 0x2 (HSM violation)
> [   19.070414] ata1.00: status: { DRDY }
> [   19.070424] ata1.00: cmd 60/40:08:12:60:40/00:00:01:00:00/40 tag 1 
> ncq 32768 in
> [   19.070426]          res 40/00:38:00:00:00/00:00:00:00:00/40 Emask 
> 0x2 (HSM violation)
> [   19.070431] ata1.00: status: { DRDY }
> [   19.070442] ata1.00: cmd 60/18:20:42:c1:c4/00:00:01:00:00/40 tag 4 
> ncq 12288 in
> [   19.070444]          res 41/84:18:59:c1:c4/03:00:01:00:00/61 Emask 
> 0x412 (ATA bus error) <F>
> [   19.070453] ata1.00: status: { DRDY ERR }
> [   19.070455] ata1.00: error: { ICRC ABRT }
> [   19.070460] ata1.00: cmd 60/28:28:22:c3:c4/00:00:01:00:00/40 tag 5 
> ncq 20480 in
> [   19.070461]          res 40/00:38:00:00:00/00:00:00:00:00/40 Emask 
> 0x2 (HSM violation)
> [   19.070464] ata1.00: status: { DRDY }
> [   19.070469] ata1.00: cmd 60/80:30:c2:c3:c4/02:00:01:00:00/40 tag 6 
> ncq 327680 in
> [   19.070470]          res 40/00:38:00:00:00/00:00:00:00:00/40 Emask 
> 0x2 (HSM violation)
> [   19.070473] ata1.00: status: { DRDY }
> [   19.070479] ata1: hard resetting link
> [   19.420110] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [   19.485363] ata1.00: configured for UDMA/100
> [   19.485406] ata1: EH complete

It seems really unlikely that dm-multipath could have this kind of 
effect. This really looks like a hardware problem of some type, as the 
controller is seeing errors on the SATA link and the drive is 
complaining about bad CRCs. Maybe whatever you were doing was stressing 
something more than usual?

> [   19.586193] device-mapper: multipath round-robin: version 1.0.0 
> loaded
> [   19.586634] device-mapper: table: 254:0: multipath: error getting 
> device
> [   19.586638] device-mapper: ioctl: error adding target to table
> [   31.932088] REISERFS (device sda7): found reiserfs format "3.6" with 
> standard journal
> [   31.932111] REISERFS (device sda7): using ordered data mode
> [   31.932289] REISERFS (device sda7): journal params: device sda7, size 
> 8192, journal first block 18, max trans len 1024, max batch 900, max 
> commit age 30, max trans age 30
> [   31.932559] REISERFS (device sda7): checking transaction log (sda7)
> [   31.999527] REISERFS (device sda7): Using r5 hash to sort names
> [   32.101614] loop: module loaded
> [   32.581870] Adding 4192924k swap on /dev/sda5.  Priority:-1 extents:1 
> across:4192924k 
> [   34.671257] iwl3945 0000:0c:00.0: firmware: requesting 
> iwlwifi-3945-2.ucode
> [   34.924834] iwl3945 0000:0c:00.0: loaded firmware version 15.28.2.8
> [   34.941614] BUG: unable to handle kernel paging request at 08048154
> [   34.949359] IP: [<c0284711>] kmem_cache_alloc+0xa8/0xc1
> [   34.949359] *pde = 7f4b8067 
> [   34.949359] Oops: 0003 [#1] SMP 
> [   34.949359] last sysfs file: /sys/devices/virtual/dmi/id/board_serial
> [   34.949359] Modules linked in: loop ext2 mbcache dm_mirror 
> dm_region_hash dm_log dm_round_robin dm_multipath dm_mod 
> snd_hda_codec_idt iwl3945 snd_hda_intel snd_hda_codec iwlcore snd_hwdep 
> btusb uvcvideo bluetooth snd_pcm videodev sdhci_pci ohci1394 
> snd_page_alloc sdhci v4l1_compat iTCO_wdt ieee1394 lib80211 mmc_core 
> dcdbas ricoh_mmc hid ata_piix ahci libata reiserfs
> [   34.949359] 
> [   34.949359] Pid: 2151, comm: hald Tainted: G        W  (2.6.30-
> rc4-3avb #5) XPS M1330                       
> [   34.949359] EIP: 0060:[<c0284711>] EFLAGS: 00010246 CPU: 1
> [   34.949359] EIP is at kmem_cache_alloc+0xa8/0xc1
> [   34.949359] EAX: 00000000 EBX: 08048154 ECX: 00000025 EDX: 00000094
> [   34.949359] ESI: 00008050 EDI: 08048154 EBP: f5a26f2c ESP: f5a26f14
> [   34.949359]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> [   34.949359] Process hald (pid: 2151, ti=f5a26000 task=f5aabe30 
> task.ti=f5a26000)
> [   34.949359] Stack:
> [   34.949359]  f7001000 c02eb6d5 00000094 f6601260 f5a21d80 00008050 
> f5a26f44 c02eb6d5
> [   34.949359]  f5a21d90 f5a21d80 f71e4dec f71e4e08 f5a26f58 c02a9b43 
> f6f71eec f71e4dec
> [   34.949359]  f5a21d80 f5a26f7c c02a9c6c f6f72100 f5a21db4 ffffffea 
> c02aa7d6 fffffff4
> [   34.949359] Call Trace:
> [   34.949359]  [<c02eb6d5>] ? idr_pre_get+0x27/0x60
> [   34.949359]  [<c02eb6d5>] ? idr_pre_get+0x27/0x60
> [   34.949359]  [<c02a9b43>] ? inotify_handle_get_wd+0x19/0x54
> [   34.949359]  [<c02a9c6c>] ? inotify_add_watch+0x4d/0xe1
> [   34.949359]  [<c02aa7d6>] ? sys_inotify_add_watch+0xbb/0x16c
> [   34.949359]  [<c02aa815>] ? sys_inotify_add_watch+0xfa/0x16c
> [   34.949359]  [<c02029d4>] ? sysenter_do_call+0x12/0x32
> [   34.949359] Code: 02 00 00 75 09 57 9d e8 60 ca fb ff eb 07 e8 d1 de 
> fb ff 57 9d 66 85 f6 79 20 85 db 74 1c 8b 4d f0 89 df c1 e9 02 31 c0 8b 
> 55 f0 <f3> ab f6 c2 02 74 02 66 ab f6 c2 01 74 01 aa 8d 65 f4 89 d8 5b 
> [   34.949359] EIP: [<c0284711>] kmem_cache_alloc+0xa8/0xc1 SS:ESP 
> 0068:f5a26f14
> [   34.949359] CR2: 0000000008048154
> [   35.262159] ---[ end trace a499c68e391b7f63 ]---
> [   35.272994] Registered led device: iwl-phy0::radio
> [   35.282572] Registered led device: iwl-phy0::assoc
> [   35.292096] Registered led device: iwl-phy0::RX
> [   35.302859] Registered led device: iwl-phy0::TX
> [   35.317633] BUG: unable to handle kernel paging request at 62696c2f
> [   35.327346] IP: [<c02846c7>] kmem_cache_alloc+0x5e/0xc1
> [   35.327561] *pde = 00000000 
> [   35.327561] Oops: 0000 [#2] SMP 
> [   35.327561] last sysfs file: /sys/devices/virtual/dmi/id/board_serial
> [   35.327561] Modules linked in: loop ext2 mbcache dm_mirror 
> dm_region_hash dm_log dm_round_robin dm_multipath dm_mod 
> snd_hda_codec_idt iwl3945 snd_hda_intel snd_hda_codec iwlcore snd_hwdep 
> btusb uvcvideo bluetooth snd_pcm videodev sdhci_pci ohci1394 
> snd_page_alloc sdhci v4l1_compat iTCO_wdt ieee1394 lib80211 mmc_core 
> dcdbas ricoh_mmc hid ata_piix ahci libata reiserfs
> [   35.327561] 
> [   35.327561] Pid: 2267, comm: console-kit-dae Tainted: G      D W  
> (2.6.30-rc4-3avb #5) XPS M1330                       
> [   35.327561] EIP: 0060:[<c02846c7>] EFLAGS: 00010002 CPU: 1
> [   35.327561] EIP is at kmem_cache_alloc+0x5e/0xc1
> [   35.327561] EAX: 00000000 EBX: 62696c2f ECX: f7001000 EDX: c22b34bc
> [   35.327561] ESI: 00008050 EDI: 00000246 EBP: f5a5cf2c ESP: f5a5cf14
> [   35.327561]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> [   35.327561] Process console-kit-dae (pid: 2267, ti=f5a5c000 
> task=f59fa550 task.ti=f5a5c000)
> [   35.327561] Stack:
> [   35.327561]  f7001000 c02eb6d5 00000094 f67fe0c0 f67fe0c0 00008050 
> f5a5cf44 c02eb6d5
> [   35.327561]  f67fe0d0 f67fe0c0 f71e4cd4 f71e4cf0 f5a5cf58 c02a9b43 
> f6f7259c f71e4cd4
> [   35.327561]  f67fe0c0 f5a5cf7c c02a9c6c f6f727b0 f67fe0f4 ffffffea 
> c02aa7d6 fffffff4
> [   35.327561] Call Trace:
> [   35.327561]  [<c02eb6d5>] ? idr_pre_get+0x27/0x60
> [   35.327561]  [<c02eb6d5>] ? idr_pre_get+0x27/0x60
> [   35.327561]  [<c02a9b43>] ? inotify_handle_get_wd+0x19/0x54
> [   35.327561]  [<c02a9c6c>] ? inotify_add_watch+0x4d/0xe1
> [   35.327561]  [<c02aa7d6>] ? sys_inotify_add_watch+0xbb/0x16c
> [   35.327561]  [<c02aa815>] ? sys_inotify_add_watch+0xfa/0x16c
> [   35.327561]  [<c02029d4>] ? sysenter_do_call+0x12/0x32
> [   35.327561] Code: 62 f5 21 00 9c 5f fa e8 aa ca fb ff 8b 4d e8 64 a1 
> 88 d4 66 c0 8b 94 81 a4 00 00 00 8b 42 10 89 45 f0 8b 1a 85 db 74 0a 8b 
> 42 0c <8b> 04 83 89 02 eb 15 52 83 c9 ff 89 f2 ff 75 ec 8b 45 e8 e8 4d 
> [   35.327561] EIP: [<c02846c7>] kmem_cache_alloc+0x5e/0xc1 SS:ESP 
> 0068:f5a5cf14
> [   35.327561] CR2: 0000000062696c2f
> [   35.327561] ---[ end trace a499c68e391b7f64 ]---
> [   35.693405] ADDRCONF(NETDEV_UP): wlan0: link is not ready
> 
> The contents of /etc/mutipath.conf was:
> 
> defaults {
> 	getuid_callout	"/bin/echo -n 12345678"
> 	path_checker	readsector0
> }
> multipaths {
> 	multipath {
> 		wwid		12345678
> 		features	"1 queue_if_no_path"
> 		no_path_retry	5
> 		failback	immediate
> 	}
> }
> 
> I was experimenting with multipath-over-loop and completely forgot about 
> it later.
> 
> I understand that it sounds more like "doctor, it hurts when I stab 
> myself in the eye". Still, even with this absolutely weird config result 
> is rather unexpected (what is worse, it is near to impossible to find 
> out the reason; I did it by pure accident). Also I have been running 
> with *exactly* the same config for almost a year without any ill effects 
> at all.
> 
> I am ready to offer debugging aid if required.

