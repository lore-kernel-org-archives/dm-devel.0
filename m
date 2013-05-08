From: David Shaw <dshaw@jabberwocky.com>
Subject: Re: Writing to a DM snapshot blocks for a long time
Date: Wed, 8 May 2013 13:07:33 -0400
Message-ID: <AA965924-0FA7-47E6-8FBE-D7D4CADC3C29@jabberwocky.com>
References: <2B7FCFD0-6B78-482F-9D36-D855DE6F67CF@jabberwocky.com>
	<alpine.DEB.2.10.1305072201090.13746@trent.utfs.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Mac OS X Mail 6.3 \(1503\))
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.DEB.2.10.1305072201090.13746@trent.utfs.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christian Kujau <lists@nerdbynature.de>
Cc: dm-devel@redhat.com, ext3-users@redhat.com
List-Id: dm-devel.ids

On May 8, 2013, at 1:05 AM, Christian Kujau <lists@nerdbynature.de> wrote:

> On Mon, 6 May 2013 at 17:16, David Shaw wrote:
>> What I'm doing is creating a snapshot using DM directly (not through 
>> LVM), mounting the snapshot, and then writing to both sides (the mounted 
>> snapshot as well as the original filesystem). 
> [...]
>> I managed to get this down to a simple reproduction case.  All this
>> is starting with a LVM VG named "tests", which contains two LVs named 
> 
> I'm confused: are your using LVM or not?

In effect, yes, I am.  The only difference is that I'm calling the dmsetup commands manually rather than creating the snapshot via lvcreate.

My apologies - I think in an effort to be complete, I used way too much verbiage and confused the issue.  To restate this in a simpler way: I create a LVM snapshot of a large (~6TB) ext4 filesystem, then mount it.  On occasion (so this is not 100% reproducible) overwriting a file on the snapshot blocks for a long time (~60 seconds) before completing.  I can write to the origin volume without any problem, and I can write new files to the snapshot without any problem.  It's only when overwriting a file on the snapshot (i.e. a file that exists on the origin, but I'm overwriting it on the snapshot) does the block happen.  Once the initial blockage has passed, things generally proceed without any further blockage.

I got a backtrace via "echo t > /proc/sysrq-trigger" of /bin/cp stuck in this state, which is pasted below.

A week or two ago, there was a post here about "(LONG) Delay when writing to ext4 LVM after boot".  Reading that post over again, it sounds somewhat similar, at least in symptoms.  My case isn't a new boot, but the snapshot is certainly a newly-mounted filesystem.  FWIW, flex_bg is set on my filesystem.  The flex block group size is 16.  A possibly useful tidbit is that both the snap and origin are mounted nodelalloc.

> $ uname -rv
> 3.8-trunk-amd64 #1 SMP Debian 3.8-1~experimental.1

I'm running 2.6.35.14-97.fc14.x86_64 (i.e. Fedora 14)

The backtrace:

2013-05-06 15:53:41 foobar kernel: [1057700.540986] cp            D 0000000000000000     0 18683  18670 0x00000000
2013-05-06 15:53:41 foobar kernel: [1057700.540989]  ffff880018f5d438 0000000000000082 ffff880000000000 ffff88005ec245c0
2013-05-06 15:53:41 foobar kernel: [1057700.540991]  0000000000015540 0000000000015540 ffff880018f5dfd8 0000000000015540
2013-05-06 15:53:41 foobar kernel: [1057700.540994]  0000000000015540 0000000000015540 0000000000015540 ffff880018f5dfd8
2013-05-06 15:53:41 foobar kernel: [1057700.540996] Call Trace:
2013-05-06 15:53:41 foobar kernel: [1057700.540999]  [<ffffffff81138b9b>] ? sync_buffer+0x0/0x2e
2013-05-06 15:53:41 foobar kernel: [1057700.541001]  [<ffffffff81138b9b>] ? sync_buffer+0x0/0x2e
2013-05-06 15:53:41 foobar kernel: [1057700.541003]  [<ffffffff81468b35>] io_schedule+0x48/0x63
2013-05-06 15:53:41 foobar kernel: [1057700.541005]  [<ffffffff81138bc5>] sync_buffer+0x2a/0x2e
2013-05-06 15:53:41 foobar kernel: [1057700.541007]  [<ffffffff814690dd>] __wait_on_bit+0x48/0x7b
2013-05-06 15:53:41 foobar kernel: [1057700.541010]  [<ffffffff8146917e>] out_of_line_wait_on_bit+0x6e/0x79
2013-05-06 15:53:41 foobar kernel: [1057700.541012]  [<ffffffff81138b9b>] ? sync_buffer+0x0/0x2e
2013-05-06 15:53:41 foobar kernel: [1057700.541014]  [<ffffffff81066a44>] ? wake_bit_function+0x0/0x31
2013-05-06 15:53:41 foobar kernel: [1057700.541017]  [<ffffffff81138b58>] __wait_on_buffer+0x24/0x26
2013-05-06 15:53:41 foobar kernel: [1057700.541019]  [<ffffffff811abb14>] ext4_mb_init_cache+0x26b/0x55b
2013-05-06 15:53:41 foobar kernel: [1057700.541022]  [<ffffffff811ac863>] ext4_mb_init_group+0xa3/0x20e
2013-05-06 15:53:41 foobar kernel: [1057700.541025]  [<ffffffff811adc57>] ext4_mb_good_group+0x53/0xd6
2013-05-06 15:53:41 foobar kernel: [1057700.541028]  [<ffffffff811ade0d>] ext4_mb_regular_allocator+0x133/0x281
2013-05-06 15:53:41 foobar kernel: [1057700.541031]  [<ffffffff811aeb67>] ext4_mb_new_blocks+0x189/0x38c
2013-05-06 15:53:41 foobar kernel: [1057700.541033]  [<ffffffff811a4bd6>] ? ext4_ext_find_extent+0x51/0x2b2
2013-05-06 15:53:41 foobar kernel: [1057700.541036]  [<ffffffff811a7af9>] ext4_ext_map_blocks+0x15d1/0x186f
2013-05-06 15:53:41 foobar kernel: [1057700.541039]  [<ffffffff812479a0>] ? alloc_iova+0x1cb/0x1dd
2013-05-06 15:53:41 foobar kernel: [1057700.541042]  [<ffffffff810e7951>] ? zone_statistics+0x65/0x6a
2013-05-06 15:53:41 foobar kernel: [1057700.541044]  [<ffffffff810da22f>] ? get_page_from_freelist+0x3fd/0x674
2013-05-06 15:53:41 foobar kernel: [1057700.541047]  [<ffffffff8103c165>] ? need_resched+0x23/0x2d
2013-05-06 15:53:41 foobar kernel: [1057700.541050]  [<ffffffff8118e2b4>] ext4_map_blocks+0x13b/0x21d
2013-05-06 15:53:41 foobar kernel: [1057700.541053]  [<ffffffff8118e434>] _ext4_get_block+0x9e/0x126
2013-05-06 15:53:41 foobar kernel: [1057700.541055]  [<ffffffff81137f3b>] ? attach_page_buffers+0x27/0x35
2013-05-06 15:53:41 foobar kernel: [1057700.541058]  [<ffffffff8118e50c>] ext4_get_block+0x16/0x18
2013-05-06 15:53:41 foobar kernel: [1057700.541061]  [<ffffffff8113a0fa>] __block_prepare_write+0x12e/0x28d
2013-05-06 15:53:41 foobar kernel: [1057700.541063]  [<ffffffff8118e4f6>] ? ext4_get_block+0x0/0x18
2013-05-06 15:53:41 foobar kernel: [1057700.541066]  [<ffffffff8113a319>] block_write_begin_newtrunc+0x80/0xc1
2013-05-06 15:53:41 foobar kernel: [1057700.541069]  [<ffffffff8113a63f>] block_write_begin+0x38/0x71
2013-05-06 15:53:41 foobar kernel: [1057700.541071]  [<ffffffff8118e4f6>] ? ext4_get_block+0x0/0x18
2013-05-06 15:53:41 foobar kernel: [1057700.541074]  [<ffffffff8118f4f0>] ext4_write_begin+0x14d/0x22e
2013-05-06 15:53:41 foobar kernel: [1057700.541076]  [<ffffffff8118e4f6>] ? ext4_get_block+0x0/0x18
2013-05-06 15:53:41 foobar kernel: [1057700.541079]  [<ffffffff810d371f>] generic_file_buffered_write+0xfa/0x23d
2013-05-06 15:53:41 foobar kernel: [1057700.541081]  [<ffffffff81190c8f>] ? ext4_dirty_inode+0x45/0x4a
2013-05-06 15:53:41 foobar kernel: [1057700.541084]  [<ffffffff810d5184>] __generic_file_aio_write+0x24f/0x27f
2013-05-06 15:53:41 foobar kernel: [1057700.541086]  [<ffffffff810d3e51>] ? find_get_page+0x49/0x6e
2013-05-06 15:53:41 foobar kernel: [1057700.541089]  [<ffffffff8103c165>] ? need_resched+0x23/0x2d
2013-05-06 15:53:41 foobar kernel: [1057700.541091]  [<ffffffff8103c165>] ? need_resched+0x23/0x2d
2013-05-06 15:53:41 foobar kernel: [1057700.541094]  [<ffffffff810d520f>] generic_file_aio_write+0x5b/0xab
2013-05-06 15:53:41 foobar kernel: [1057700.541096]  [<ffffffff81187b43>] ext4_file_write+0xa0/0xad
2013-05-06 15:53:41 foobar kernel: [1057700.541099]  [<ffffffff8111752e>] do_sync_write+0xcb/0x108
2013-05-06 15:53:41 foobar kernel: [1057700.541102]  [<ffffffff811dd241>] ? security_file_permission+0x16/0x18
2013-05-06 15:53:41 foobar kernel: [1057700.541105]  [<ffffffff81117c08>] vfs_write+0xac/0x100
2013-05-06 15:53:41 foobar kernel: [1057700.541108]  [<ffffffff81117e11>] sys_write+0x4a/0x6e
2013-05-06 15:53:41 foobar kernel: [1057700.541110]  [<ffffffff81009cb2>] system_call_fastpath+0x16/0x1b

David
