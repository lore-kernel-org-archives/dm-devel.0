From: Nix <nix@esperi.org.uk>
Subject: Re: 2.6.24.2: 4KSTACKS + pcdrw + dm + mount -> stack overflow: ide-cd related? dm-related?
Date: Sun, 24 Feb 2008 15:59:23 +0000
Message-ID: <87skzipcpw.fsf@hades.wkstn.nix>
References: <87wsovkth5.fsf@hades.wkstn.nix>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1757981AbYBXQAW@vger.kernel.org>
In-Reply-To: <87wsovkth5.fsf@hades.wkstn.nix> (nix@esperi.org.uk's message of "24 Feb 2008 01:56:56 -0000")
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: petero2@telia.com, dm-devel@redhat.com
List-Id: dm-devel.ids

On 24 Feb 2008, nix@esperi.org.uk outgrape:

> A loop mount/umounting a pcdrw or iso9660 (through the pktcdvd device)
> sees a stack overflow in four or five tries. Doing the same thing with
> the same CD in a normal non-pktcdvd-mounted drive doesn't cause a crash.

> (This may or may not be PREEMPT+PREEMPT_BKL-specific: I'll try turning
> them off tomorrow and repeating.)

It is not preempt-specific, nor dm-specific. Nor it is very easy to
capture tracebacks of: even netconsole generally gives up when faced
with a string of recursive tracebacks blurring past forever at blinding
speed.

But while I'd normally blame pktcdvd there's only one pktcdvd function
in these tracebacks (pkt_open) and it's not got a significant stack
footprint.

More notable is a great stack of mutual recursion between
dm_bio_destructor() and the CDROM code: it seems to burn most of the
stack on this sort of thrashing. Here's one of those tracebacks again:

do_IRQ: stack overflow: 480
id: 4645, comm: mount Not tainted 2.6.24.2-dirty #4
 [<c0104171>] do_IRQ+0x66/0xc5
 [<c0102f8b>] common_interrupt+0x23/0x28
 [<c027b5da>] ide_outsl+0x5/0x9
 [<c027c540>] ata_output_data+0x4d/0x64
 [<c027b8a6>] atapi_output_bytes+0x19/0x3f
 [<c0285377>] cdrom_transfer_packet_command+0xb5/0xde
 [<c0282607>] cdrom_timer_expiry+0x0/0x51
 [<c02840c3>] cdrom_start_packet_command+0x14f/0x157
 [<c02853e9>] cdrom_do_pc_continuation+0x0/0x2c
 [<c027aa33>] ide_do_request+0x70a/0x943
 [<c0363ef3>] schedule_timeout+0x13/0x8b
 [<c021faeb>] elv_drain_elevator+0x15/0x58
 [<c0220277>] elv_insert+0xf6/0x1d9
 [<c0285377>] cdrom_transfer_packet_command+0xb5/0xde
 [<c0282607>] cdrom_timer_expiry+0x0/0x51
 [<c027b038>] ide_do_drive_cmd+0x99/0xe9
 [<c0282abe>] cdrom_queue_packet_command+0x35/0xa9
 [<c0363b2b>] schedule+0x321/0x33e
 [<c0363ef3>] schedule_timeout+0x13/0x8b
 [<c0282d11>] cdrom_read_tocentry+0x96/0xa1
 [<c02220d3>] blk_end_sync_rq+0x0/0x23
 [<c028315b>] cdrom_read_toc+0x14b/0x42e
 [<c02220d3>] blk_end_sync_rq+0x0/0x23
 [<c027b07e>] ide_do_drive_cmd+0xdf/0xe9
 [<c0283ed2>] ide_cdrom_audio_ioctl+0x13c/0x1de
 [<c02af8fe>] dm_bio_destructor+0x0/0x8
 [<c017162c>] end_bio_bh_io_sync+0x0/0x27
 [<c0282f42>] cdrom_check_status+0x55/0x60
 [<c02220d3>] blk_end_sync_rq+0x0/0x23
 [<c02865ba>] cdrom_count_tracks+0x64/0x16a
 [<c02afbd9>] clone_endio+0x0/0xa3
 [<c02af8fe>] dm_bio_destructor+0x0/0x8
 [<c02896c4>] cdrom_open+0x190/0x8f8
 [<c017162c>] end_bio_bh_io_sync+0x0/0x27
 [<c0172e9a>] bio_fs_destructor+0x0/0xb
 [<c017162c>] end_bio_bh_io_sync+0x0/0x27
 [<c0172e9a>] bio_fs_destructor+0x0/0xb
 [<c02afbd9>] clone_endio+0x0/0xa3
 [<c02af8fe>] dm_bio_destructor+0x0/0x8
 [<c017162c>] end_bio_bh_io_sync+0x0/0x27
 [<c0172e9a>] bio_fs_destructor+0x0/0xb
 [<c02afbd9>] clone_endio+0x0/0xa3
 [<c02af8fe>] dm_bio_destructor+0x0/0x8
 [<c02252d3>] get_disk+0x4e/0x65
 [<c02252f1>] exact_lock+0x7/0xd
 [<c025a2cc>] kobj_lookup+0x104/0x12e
 [<c02828e8>] idecd_open+0x72/0x86
 [<c0174458>] do_open+0x198/0x238
 [<c02afbd9>] clone_endio+0x0/0xa3
 [<c0174561>] __blkdev_get+0x69/0x74
 [<c017457e>] blkdev_get+0x12/0x14
 [<c0263333>] pkt_open+0x8d/0xc96
 [<c017162c>] end_bio_bh_io_sync+0x0/0x27
 [<c0172e9a>] bio_fs_destructor+0x0/0xb
 [<c02afbd9>] clone_endio+0x0/0xa3
 [<c02af8fe>] dm_bio_destructor+0x0/0x8
 [<c02afbd9>] clone_endio+0x0/0xa3
 [<c02af8fe>] dm_bio_destructor+0x0/0x8
 [<c017162c>] end_bio_bh_io_sync+0x0/0x27
 [<c0172e9a>] bio_fs_destructor+0x0/0xb
 [<c017162c>] end_bio_bh_io_sync+0x0/0x27
 [<c0172e9a>] bio_fs_destructor+0x0/0xb
 [<c017162c>] end_bio_bh_io_sync+0x0/0x27
 [<c0172e9a>] bio_fs_destructor+0x0/0xb
 [<c017162c>] end_bio_bh_io_sync+0x0/0x27
 [<c0172e9a>] bio_fs_destructor+0x0/0xb
 [<c02afbd9>] clone_endio+0x0/0xa3
 [<c02af8fe>] dm_bio_destructor+0x0/0x8
 [<c022998c>] kobject_get+0xf/0x13
 [<c02252d3>] get_disk+0x4e/0x65
 [<c02252f1>] exact_lock+0x7/0xd
 [<c025a2cc>] kobj_lookup+0x104/0x12e
 [<c0224ed0>] exact_match+0x0/0x4
 [<c0174344>] do_open+0x84/0x238
 [<c0174561>] 
EIP: 0060:[<c01033d2>] EFLAGS: 00010093 CPU: 0
EIP is at dump_trace+0x52/0x8b
EAX: 0000082a EBX: 00000046 ECX: 0000020a EDX: 00000000
ESI: 00000000 EDI: 00000000 EBP: 00000ffc ESP: eeede1c4
 DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
rocess mount (pid: 4645, ti=eeede000 task=ee537320 task.ti=eeede000)v<tack:  00001000 c03f6c0c 00000000 c0523b64 00000000 c0103423 c036e79c c03f6c0c 
       00000002 c0103bf2 c03f6c0c c0103f85 c03ccd19 00001225 ee5375d0 c0505178 
       c0429436 00000002 c0429477 eeede220 0000000d c0104171 c03cce23 000001e0 

Just looking for `dm_' in there should point out something odd.  (Of
course dm is just acting on behalf of others here, so it may be that the
IDE CDROM code is doing something demented: in which case why does this
only stack-overrun if I mount /dev/pktcdvd/cdrw, and not /dev/cdrw?
For that matter, why is dm getting involved at all? This CD-RW isn't
dm-managed in any way, shape or form...)

-- 
`The rest is a tale of post and counter-post.' --- Ian Rawlings
                                                   describes USENET
