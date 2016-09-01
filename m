From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 8/9] dm: Fix two race conditions related to
 stopping and starting queues
Date: Thu, 1 Sep 2016 13:39:55 -0700
Message-ID: <889bdb89-a16b-927a-adf0-fa04418a0c06@sandisk.com>
References: <82ff8574-8b73-8ba3-9098-741060f38fca@sandisk.com>
	<20160901031355.GB4741@redhat.com>
	<BLUPR02MB1683D3D8F604FEB429143A4381E20@BLUPR02MB1683.namprd02.prod.outlook.com>
	<20160901150503.GA11074@redhat.com>
	<ca45a2b1-99bc-1779-3b4f-a03343ccbd9a@sandisk.com>
	<20160901155051.GA11353@redhat.com> <20160901161253.GA11410@redhat.com>
	<e8cf7d03-82a6-cba3-60c4-c436ae3a24f7@sandisk.com>
	<20160901190505.GA12106@redhat.com>
	<235c0ca3-0c01-6dc8-208e-1a4c153dd69c@sandisk.com>
	<20160901203332.GB12407@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20160901203332.GB12407@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, device-mapper development <dm-devel@redhat.com>, "hch@lst.de" <hch@lst.de>
List-Id: dm-devel.ids

On 09/01/2016 01:33 PM, Mike Snitzer wrote:
> I'm able to easily reproduce this 100% cpu usage using mptest's
> test_02_sdev_delete.
>
> 'dmsetup suspend --nolockfs --noflush mp' hangs, seems rooted in your
> use of blk_mq_freeze_queue():
>
> [  298.136930] dmsetup         D ffff880142cb3b70     0  9478   9414 0x00000080
> [  298.144831]  ffff880142cb3b70 ffff880142cb3b28 ffff880330d6cb00 ffff88032d0022f8
> [  298.153132]  ffff880142cb4000 ffff88032d0022f8 ffff88032b161800 0000000000000001
> [  298.161438]  0000000000000001 ffff880142cb3b88 ffffffff816c06e5 ffff88032d001aa0
> [  298.169740] Call Trace:
> [  298.172473]  [<ffffffff816c06e5>] schedule+0x35/0x80
> [  298.178019]  [<ffffffff8131b937>] blk_mq_freeze_queue_wait+0x57/0xc0
> [  298.185116]  [<ffffffff810c58c0>] ? prepare_to_wait_event+0xf0/0xf0
> [  298.192117]  [<ffffffff8131d92a>] blk_mq_freeze_queue+0x1a/0x20
> [  298.198734]  [<ffffffffa000e910>] dm_stop_queue+0x50/0xc0 [dm_mod]
> [  298.205644]  [<ffffffffa0001824>] __dm_suspend+0x134/0x1f0 [dm_mod]
> [  298.212649]  [<ffffffffa00035b8>] dm_suspend+0xb8/0xd0 [dm_mod]
> [  298.219270]  [<ffffffffa000882e>] dev_suspend+0x18e/0x240 [dm_mod]
> [  298.226175]  [<ffffffffa00086a0>] ? table_load+0x380/0x380 [dm_mod]
> [  298.233180]  [<ffffffffa0009027>] ctl_ioctl+0x1e7/0x4d0 [dm_mod]
> [  298.239890]  [<ffffffff81197f00>] ? lru_cache_add_active_or_unevictable+0x10/0xb0
> [  298.248253]  [<ffffffffa0009323>] dm_ctl_ioctl+0x13/0x20 [dm_mod]
> [  298.255049]  [<ffffffff81227937>] do_vfs_ioctl+0xa7/0x5d0
> [  298.261081]  [<ffffffff8112787f>] ? __audit_syscall_entry+0xaf/0x100
> [  298.268178]  [<ffffffff8100365d>] ? syscall_trace_enter+0x1dd/0x2c0
> [  298.275179]  [<ffffffff81227ed9>] SyS_ioctl+0x79/0x90
> [  298.280821]  [<ffffffff81003a47>] do_syscall_64+0x67/0x160
> [  298.286950]  [<ffffffff816c4921>] entry_SYSCALL64_slow_path+0x25/0x25
>

Hello Mike,

In your dm-4.9 branch I see that you call blk_mq_freeze_queue() while 
holding the block layer queue lock. Please don't do this. 
blk_mq_freeze_queue() can sleep and as you know calling a sleeping 
function while holding a spinlock is not allowed.

Bart.
