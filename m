From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] fix crash in blk_queue_abort
Date: Fri, 17 Apr 2009 08:36:15 +0200
Message-ID: <20090417063615.GE4593@kernel.dk>
References: <Pine.LNX.4.64.0904161948420.312@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0904161948420.312@hs20-bc2-1.build.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@redhat.com, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Thu, Apr 16 2009, Mikulas Patocka wrote:
> Hi
> 
> This fixes a crash in blk_abort_queue. The crash can be triggered with 
> device mapper multipath.
> 
> I believe that since there is method make_request_fn, the cleanest 
> solution is to add another method, abort_queue_fn. But you can use 
> different solution if you want (like testing some bit whether the device 
> is request-based ... or so).
> 
> Mikulas
> 
> ---
> 
> Fix a crash due to blk_abort_queue being called on non-request device.
> 
> The crash can be reproduced in the following way:
> 
> # dmsetup create alias1 --table "0 `blockdev --getsize /dev/sda` linear /dev/sda 0"
> # dmsetup create alias2 --table "0 `blockdev --getsize /dev/sda` linear /dev/sda 0"
> # dmsetup create mpath --table "0 `blockdev --getsize /dev/sda` multipath 0 0 2 1 round-robin 0 1 0 /dev/mapper/alias1 round-robin 0 1 0 /dev/mapper/alias2"
> # dmsetup reload alias1 --table "0 `blockdev --getsize /dev/sda` error"
> # dmsetup suspend alias1
> # dmsetup resume alias1
> # less -f /dev/mapper/mpath
> 
> TPC: <__lock_acquire+0x5c/0x1c00>
> Caller[000000000047f468]: lock_acquire+0xa8/0xc0
> Caller[000000000065a978]: _spin_lock_irqsave+0x38/0x60
> Caller[000000000054f7b4]: blk_abort_queue+0x34/0x140
> Caller[00000000100ffe04]: deactivate_path+0x44/0x60 [dm_multipath]
> Caller[0000000000468898]: worker_thread+0x1d8/0x2e0
> Caller[000000000046d4ac]: kthread+0x4c/0x80
> Caller[000000000042bc1c]: kernel_thread+0x3c/0x60
> Caller[000000000046d3e4]: kthreadd+0x104/0x180
> 
> The crash happens because queue spinlock pointer is NULL and blk_abort_queue is
> called.
> 
> The problem is that blk_abort_queue assumes that the underlying device is
> request-based. If it uses bios, not requests, it accesses uninitialized data
> structures and crashes.
> 
> This patch changes it to provide a method, abort_queue_fn, that will
> abort the queue. On request-based devices, it points to generic_abort_queue,
> on non-request based devices it can be NULL (no abort) or the driver can
> register its own abort function there.

Lets just add a

        if (!q->request_fn)
                return;

at the top of blk_abort_queue(), no need in making this generic until
someone actually needs different behaviour.

-- 
Jens Axboe
