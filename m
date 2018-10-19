From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm_cache BUG() after power loss
Date: Fri, 19 Oct 2018 09:03:50 -0400
Message-ID: <20181019130350.GA11067@redhat.com>
References: <20181009160051.xlcpnnmyvhbivglk@sesse.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20181009160051.xlcpnnmyvhbivglk@sesse.net>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Steinar H. Gunderson" <steinar+kernel@gunderson.no>
Cc: dm-devel@redhat.com, ejt@redhat.com
List-Id: dm-devel.ids

On Tue, Oct 09 2018 at 12:00pm -0400,
Steinar H. Gunderson <steinar+kernel@gunderson.no> wrote:

> Hi,
> 
> We had a power loss event, and when a server with dm-cache came up again,
> it paniced (see below for the panic text). I couldn't find any other way to
> remedy this than to blow away the metadata volume, which I assumed was safe
> as the cache is in writethrough mode (after several catastrophic events with
> dm-cache earlier, I don't trust writeback anymore). Unfortunately, this was
> seemingly not enough, as the underlying devices came back with various levels
> of corruption and eventually had to be restored from backup. (It's running
> without dm-cache now.)

Please provide the "dmsetup table" line for the cache device if you can.

Are you using writeback mode?

There was a writeback bug that got fixed not too long ago that impacted
users who suffered power loss (or sudden loss of storage), see:
http://git.kernel.org/linus/5b1fe7bec8a8

BUT, it does look like 4.18.11 already has that commit.

Given the "block manager: array validator check failed for block 2156"
error it could easily be that you need to run cache_check and
cache_repair.  Joe (cc'd) may have more specific repair guidance for
you (though Joe is going on vacation.. bad timing).

Mike


> Here's the panic:
> 
> [   13.388089] device-mapper: cache: You have created a cache device with a lot of individual cache blocks (1114672)
> [   13.388089] All these mappings can consume a lot of kernel memory, and take some time to read/write.
> [   13.388089] Please consider increasing the cache block size to reduce the overall cache block count.
> [   13.452782] device-mapper: array: array_block_check failed: blocknr 1082331758718 != wanted 2156
> [   13.462194] device-mapper: block manager: array validator check failed for block 2156
> [   13.470643] device-mapper: array: get_ablock failed
> [   13.475869] device-mapper: cache metadata: dm_array_cursor_next for mapping failed
> [   13.484075] ------------[ cut here ]------------
> [   13.489036] kernel BUG at drivers/md/dm-bufio.c:1180!
> [   13.494443] invalid opcode: 0000 [#1] SMP PTI
> [   13.499144] CPU: 34 PID: 5918 Comm: dmsetup Not tainted 4.18.11 #1
> [   13.505671] Hardware name: Supermicro X10DRi/X10DRI-T, BIOS 1.1 04/14/2015
> [   13.512885] RIP: 0010:dm_bufio_release+0x18/0x74 [dm_bufio]
> [   13.518797] Code: 43 18 48 b8 00 02 00 00 00 00 ad de 48 89 43 20 5b c3 55 53 48 8b 6f 60 48 89 fb 48 89 ef e8 04 7e 20 e1 8b 43 3c 85 c0 75 02 <0f> 0b ff c8 85 c0 89 43 3c 75 47 31 c9 ba 01 00 00 00 be 03 00 00
> [   13.538588] RSP: 0018:ffffc90000a03ba0 EFLAGS: 00010246
> [   13.544157] RAX: 0000000000000000 RBX: ffff881025a6cea0 RCX: 00000000ffffffff
> [   13.551632] RDX: ffff8810303a3980 RSI: ffff881025a6cea0 RDI: ffff881032b37800
> [   13.559110] RBP: ffff881032b37800 R08: 0000000000000000 R09: ffff8800000b8c80
> [   13.566591] R10: ffffc90000a03b00 R11: ffffffff82194947 R12: 0000000000000000
> [   13.574071] R13: ffff881027631340 R14: 00000000000011e4 R15: ffffffffa0127443
> [   13.581550] FS:  00007f3cd0894400(0000) GS:ffff88103f480000(0000) knlGS:0000000000000000
> [   13.590256] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   13.596337] CR2: 0000563e475af7a8 CR3: 000000102f802006 CR4: 00000000001606e0
> [   13.603812] Call Trace:
> [   13.606614]  dm_array_cursor_end+0x1c/0x27 [dm_persistent_data]
> [   13.612880]  dm_cache_load_mappings+0x2be/0x2fe [dm_cache]
> [   13.618717]  ? retrieve_status+0x176/0x176 [dm_mod]
> [   13.623935]  cache_preresume+0xc6/0x195 [dm_cache]
> [   13.629067]  dm_table_resume_targets+0x38/0xaa [dm_mod]
> [   13.634641]  dm_resume+0x7e/0xa7 [dm_mod]
> [   13.639000]  dev_suspend+0x15b/0x1bc [dm_mod]
> [   13.643706]  ctl_ioctl+0x2f8/0x394 [dm_mod]
> [   13.648238]  dm_ctl_ioctl+0x5/0x8 [dm_mod]
> [   13.652681]  vfs_ioctl+0x19/0x26
> [   13.656247]  do_vfs_ioctl+0x4d0/0x547
> [   13.660255]  ? handle_mm_fault+0x151/0x1b9
> [   13.664695]  ksys_ioctl+0x4b/0x6b
> [   13.668355]  __x64_sys_ioctl+0x11/0x14
> [   13.672446]  do_syscall_64+0x4a/0xd3
> [   13.676365]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> [   13.681758] RIP: 0033:0x7f3ccff7edd7
> [   13.685670] Code: 00 00 00 48 8b 05 c1 80 2b 00 64 c7 00 26 00 00 00 48 c7 c0 ff ff ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 91 80 2b 00 f7 d8 64 89 01 48
> [   13.705454] RSP: 002b:00007ffcdf6a6f18 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> [   13.713640] RAX: ffffffffffffffda RBX: 000055f036494280 RCX: 00007f3ccff7edd7
> [   13.721117] RDX: 000055f036494280 RSI: 00000000c138fd06 RDI: 0000000000000003
> [   13.728595] RBP: 000000000000000f R08: 00007f3cd048a648 R09: 00007ffcdf6a6d80
> [   13.736073] R10: 00007f3cd0489b53 R11: 0000000000000246 R12: 000055f0364942b0
> [   13.743553] R13: 00007f3cd0489b53 R14: 000055f036493030 R15: 0000000000000001
> [   13.751034] Modules linked in: raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid1 raid10 raid6_pq raid0 md_mod sd_mod usbhid dm_cache_smq dm_cache dm_bio_prison dm_persistent_data dm_bufio dm_mod libcrc32c crc32c_generic ixgbe i2c_i801 mdio ehci_pci crc32c_intel mpt3sas ahci ptp raid_class i2c_core ehci_hcd libahci pps_core unix
> [   13.783877] ---[ end trace 1140618cbf25a884 ]---
> [   13.792516] RIP: 0010:dm_bufio_release+0x18/0x74 [dm_bufio]
> [   13.798431] Code: 43 18 48 b8 00 02 00 00 00 00 ad de 48 89 43 20 5b c3 55 53 48 8b 6f 60 48 89 fb 48 89 ef e8 04 7e 20 e1 8b 43 3c 85 c0 75 02 <0f> 0b ff c8 85 c0 89 43 3c 75 47 31 c9 ba 01 00 00 00 be 03 00 00
> [   13.818221] RSP: 0018:ffffc90000a03ba0 EFLAGS: 00010246
> [   13.823787] RAX: 0000000000000000 RBX: ffff881025a6cea0 RCX: 00000000ffffffff
> [   13.831260] RDX: ffff8810303a3980 RSI: ffff881025a6cea0 RDI: ffff881032b37800
> [   13.838742] RBP: ffff881032b37800 R08: 0000000000000000 R09: ffff8800000b8c80
> [   13.846220] R10: ffffc90000a03b00 R11: ffffffff82194947 R12: 0000000000000000
> [   13.853701] R13: ffff881027631340 R14: 00000000000011e4 R15: ffffffffa0127443
> [   13.861182] FS:  00007f3cd0894400(0000) GS:ffff88103f480000(0000) knlGS:0000000000000000
> [   13.869889] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   13.875988] CR2: 0000563e475af7a8 CR3: 000000102f802006 CR4: 00000000001606e0
> 
> /* Steinar */
> -- 
> Homepage: https://www.sesse.net/
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
