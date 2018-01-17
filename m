From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-rq queue stalls
Date: Wed, 17 Jan 2018 13:18:52 -0500
Message-ID: <20180117181852.GA5798@redhat.com>
References: <1516212342.2820.26.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1516212342.2820.26.camel@wdc.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, "dm-devel@redhat.com" <dm-devel@redhat.com>, Laurence Oberman <loberman@redhat.com>, Ming Lei <ming.lei@redhat.com>
List-Id: dm-devel.ids

On Wed, Jan 17 2018 at  1:05pm -0500,
Bart Van Assche <Bart.VanAssche@wdc.com> wrote:

> Hello Mike,
> 
> With Jens' latest for-next branch (commit 6c4f43dfecae) and with commit
> 6077c2d70609 ("dm rq: Avoid that request processing stalls sporadically")
> reverted I see again queue stalls every now and then. An example:
> 
> # srp-test/run_tests -c -d -r 10 -t 02-mq -e kyber
> Running test /home/bart/software/infiniband/srp-test/tests/02-mq ...
> Test file I/O on top of multipath concurrently with logout and login (0 min; mq)
> /dev/disk/by-id/dm-uuid-mpath-3600140572616d6469736b31000000000: not found
> Test /home/bart/software/infiniband/srp-test/tests/02-mq failed
> 
> I have attached the output of the following command to this e-mail:
> (cd /sys/kernel/debug/block && find -type f | xargs grep -aH '')
> 
> Can you have a look at this?

Yes, though I need to prepare for a trip that starts on Sunday (so I'll
be distracted through the end of next week).

But Ming Lei should be able to help make sense of this situation too.
Also Laurence may be able to help reproduce your specific srp-test on
his testbed.

Mike


> ./dm-2/hctx0/cpu3/completed:0 0
> ./dm-2/hctx0/cpu3/merged:0
> ./dm-2/hctx0/cpu3/dispatched:0 0
> ./dm-2/hctx0/cpu2/completed:0 0
> ./dm-2/hctx0/cpu2/merged:0
> ./dm-2/hctx0/cpu2/dispatched:0 0
> ./dm-2/hctx0/cpu1/completed:25 0
> ./dm-2/hctx0/cpu1/merged:0
> ./dm-2/hctx0/cpu1/dispatched:26 0
> ./dm-2/hctx0/cpu0/completed:0 0
> ./dm-2/hctx0/cpu0/merged:0
> ./dm-2/hctx0/cpu0/dispatched:0 0
> ./dm-2/hctx0/active:0
> ./dm-2/hctx0/run:27
> ./dm-2/hctx0/queued:26
> ./dm-2/hctx0/dispatched:       0	6
> ./dm-2/hctx0/dispatched:       1	25
> ./dm-2/hctx0/dispatched:       2	0
> ./dm-2/hctx0/dispatched:       4	0
> ./dm-2/hctx0/dispatched:       8	0
> ./dm-2/hctx0/dispatched:      16	0
> ./dm-2/hctx0/dispatched:      32+	0
> ./dm-2/hctx0/io_poll:considered=0
> ./dm-2/hctx0/io_poll:invoked=0
> ./dm-2/hctx0/io_poll:success=0
> ./dm-2/hctx0/sched_tags_bitmap:00000000: 0000 0000 0000 0000 0000 0000 0000 0020
> ./dm-2/hctx0/sched_tags_bitmap:00000010: 0000 0000 0000 0000 0000 0000 0000 0000
> ./dm-2/hctx0/sched_tags:nr_tags=256
> ./dm-2/hctx0/sched_tags:nr_reserved_tags=0
> ./dm-2/hctx0/sched_tags:active_queues=0
> ./dm-2/hctx0/sched_tags:
> ./dm-2/hctx0/sched_tags:bitmap_tags:
> ./dm-2/hctx0/sched_tags:depth=256
> ./dm-2/hctx0/sched_tags:busy=1
> ./dm-2/hctx0/sched_tags:bits_per_word=64
> ./dm-2/hctx0/sched_tags:map_nr=4
> ./dm-2/hctx0/sched_tags:alloc_hint={83, 124, 234, 58}
> ./dm-2/hctx0/sched_tags:wake_batch=8
> ./dm-2/hctx0/sched_tags:wake_index=0
> ./dm-2/hctx0/sched_tags:ws={
> ./dm-2/hctx0/sched_tags:	{.wait_cnt=8, .wait=inactive},
> ./dm-2/hctx0/sched_tags:	{.wait_cnt=8, .wait=inactive},
> ./dm-2/hctx0/sched_tags:	{.wait_cnt=8, .wait=inactive},
> ./dm-2/hctx0/sched_tags:	{.wait_cnt=8, .wait=inactive},
> ./dm-2/hctx0/sched_tags:	{.wait_cnt=8, .wait=inactive},
> ./dm-2/hctx0/sched_tags:	{.wait_cnt=8, .wait=inactive},
> ./dm-2/hctx0/sched_tags:	{.wait_cnt=8, .wait=inactive},
> ./dm-2/hctx0/sched_tags:	{.wait_cnt=8, .wait=inactive},
> ./dm-2/hctx0/sched_tags:}
> ./dm-2/hctx0/sched_tags:round_robin=0
> ./dm-2/hctx0/tags_bitmap:00000000: 0000 0000 0000 0000 0000 0000 0000 0000
> ./dm-2/hctx0/tags_bitmap:00000010: 0000 0000 0000 0000 0000 0000 0000 0000
> ./dm-2/hctx0/tags_bitmap:00000020: 0000 0000 0000 0000 0000 0000 0000 0000
> ./dm-2/hctx0/tags_bitmap:00000030: 0000 0000 0000 0000 0000 0000 0000 0000
> ./dm-2/hctx0/tags_bitmap:00000040: 0000 0000 0000 0000 0000 0000 0000 0000
> ./dm-2/hctx0/tags_bitmap:00000050: 0000 0000 0000 0000 0000 0000 0000 0000
> ./dm-2/hctx0/tags_bitmap:00000060: 0000 0000 0000 0000 0000 0000 0000 0000
> ./dm-2/hctx0/tags_bitmap:00000070: 0000 0000 0000 0000 0000 0000 0000 0000
> ./dm-2/hctx0/tags_bitmap:00000080: 0000 0000 0000 0000 0000 0000 0000 0000
> ./dm-2/hctx0/tags_bitmap:00000090: 0000 0000 0000 0000 0000 0000 0000 0000
> ./dm-2/hctx0/tags_bitmap:000000a0: 0000 0000 0000 0000 0000 0000 0000 0000
> ./dm-2/hctx0/tags_bitmap:000000b0: 0000 0000 0000 0000 0000 0000 0000 0000
> ./dm-2/hctx0/tags_bitmap:000000c0: 0000 0000 0000 0000 0000 0000 0000 0000
> ./dm-2/hctx0/tags_bitmap:000000d0: 0000 0000 0000 0000 0000 0000 0000 0000
> ./dm-2/hctx0/tags_bitmap:000000e0: 0000 0000 0000 0000 0000 0000 0000 0000
> ./dm-2/hctx0/tags_bitmap:000000f0: 0000 0000 0000 0000 0000 0000 0000 0000
> ./dm-2/hctx0/tags:nr_tags=2048
> ./dm-2/hctx0/tags:nr_reserved_tags=0
> ./dm-2/hctx0/tags:active_queues=0
> ./dm-2/hctx0/tags:
> ./dm-2/hctx0/tags:bitmap_tags:
> ./dm-2/hctx0/tags:depth=2048
> ./dm-2/hctx0/tags:busy=0
> ./dm-2/hctx0/tags:bits_per_word=64
> ./dm-2/hctx0/tags:map_nr=32
> ./dm-2/hctx0/tags:alloc_hint={1060, 81, 1050, 844}
> ./dm-2/hctx0/tags:wake_batch=8
> ./dm-2/hctx0/tags:wake_index=0
> ./dm-2/hctx0/tags:ws={
> ./dm-2/hctx0/tags:	{.wait_cnt=8, .wait=inactive},
> ./dm-2/hctx0/tags:	{.wait_cnt=8, .wait=inactive},
> ./dm-2/hctx0/tags:	{.wait_cnt=8, .wait=inactive},
> ./dm-2/hctx0/tags:	{.wait_cnt=8, .wait=inactive},
> ./dm-2/hctx0/tags:	{.wait_cnt=8, .wait=inactive},
> ./dm-2/hctx0/tags:	{.wait_cnt=8, .wait=inactive},
> ./dm-2/hctx0/tags:	{.wait_cnt=8, .wait=inactive},
> ./dm-2/hctx0/tags:	{.wait_cnt=8, .wait=inactive},
> ./dm-2/hctx0/tags:}
> ./dm-2/hctx0/tags:round_robin=0
> ./dm-2/hctx0/ctx_map:00000000: 00
> ./dm-2/hctx0/dispatch:00000000a7224aed {.op=READ, .cmd_flags=, .rq_flags=STARTED|IO_STAT, complete=0, .tag=-1, .internal_tag=125}
> ./dm-2/hctx0/flags:alloc_policy=FIFO SHOULD_MERGE|SG_MERGE
> ./dm-2/hctx0/state:SCHED_RESTART
> ./dm-2/sched/starved:0
> ./dm-2/sched/batching:5
> ./dm-2/write_hints:hint0: 0
> ./dm-2/write_hints:hint1: 0
> ./dm-2/write_hints:hint2: 0
> ./dm-2/write_hints:hint3: 0
> ./dm-2/write_hints:hint4: 0
> ./dm-2/state:SAME_COMP|IO_STAT|INIT_DONE|POLL|REGISTERED
> ./dm-2/poll_stat:read  (512 Bytes): samples=0
> ./dm-2/poll_stat:write (512 Bytes): samples=0
> ./dm-2/poll_stat:read  (1024 Bytes): samples=0
> ./dm-2/poll_stat:write (1024 Bytes): samples=0
> ./dm-2/poll_stat:read  (2048 Bytes): samples=0
> ./dm-2/poll_stat:write (2048 Bytes): samples=0
> ./dm-2/poll_stat:read  (4096 Bytes): samples=0
> ./dm-2/poll_stat:write (4096 Bytes): samples=0
> ./dm-2/poll_stat:read  (8192 Bytes): samples=0
> ./dm-2/poll_stat:write (8192 Bytes): samples=0
> ./dm-2/poll_stat:read  (16384 Bytes): samples=0
> ./dm-2/poll_stat:write (16384 Bytes): samples=0
> ./dm-2/poll_stat:read  (32768 Bytes): samples=0
> ./dm-2/poll_stat:write (32768 Bytes): samples=0
> ./dm-2/poll_stat:read  (65536 Bytes): samples=0
> ./dm-2/poll_stat:write (65536 Bytes): samples=0
> ./dm-1/hctx0/cpu3/completed:26 0
> ./dm-1/hctx0/cpu3/merged:0
> ./dm-1/hctx0/cpu3/dispatched:26 0
> ./dm-1/hctx0/cpu2/completed:2 0
> ./dm-1/hctx0/cpu2/merged:0
> ./dm-1/hctx0/cpu2/dispatched:2 0
> ./dm-1/hctx0/cpu1/completed:2 0
> ./dm-1/hctx0/cpu1/merged:0
> ./dm-1/hctx0/cpu1/dispatched:2 0
> ./dm-1/hctx0/cpu0/completed:2 0
> ./dm-1/hctx0/cpu0/merged:0
> ./dm-1/hctx0/cpu0/dispatched:2 0
> ./dm-1/hctx0/active:0
> ./dm-1/hctx0/run:34
> ./dm-1/hctx0/queued:32
> ./dm-1/hctx0/dispatched:       0	7
> ./dm-1/hctx0/dispatched:       1	32
> ./dm-1/hctx0/dispatched:       2	0
> ./dm-1/hctx0/dispatched:       4	0
> ./dm-1/hctx0/dispatched:       8	0
> ./dm-1/hctx0/dispatched:      16	0
> ./dm-1/hctx0/dispatched:      32+	0
> ./dm-1/hctx0/io_poll:considered=0
> ./dm-1/hctx0/io_poll:invoked=0
> ./dm-1/hctx0/io_poll:success=0
> ./dm-1/hctx0/sched_tags_bitmap:00000000: 0000 0000 0000 0000 0000 0000 0000 0000
> ./dm-1/hctx0/sched_tags_bitmap:00000010: 0000 0000 0000 0000 0000 0000 0000 0000
> ./dm-1/hctx0/sched_tags:nr_tags=256
> ./dm-1/hctx0/sched_tags:nr_reserved_tags=0
> ./dm-1/hctx0/sched_tags:active_queues=0
> ./dm-1/hctx0/sched_tags:
> ./dm-1/hctx0/sched_tags:bitmap_tags:
> ./dm-1/hctx0/sched_tags:depth=256
> ./dm-1/hctx0/sched_tags:busy=0
> ./dm-1/hctx0/sched_tags:bits_per_word=64
> ./dm-1/hctx0/sched_tags:map_nr=4
> ./dm-1/hctx0/sched_tags:alloc_hint={125, 55, 142, 82}
> ./dm-1/hctx0/sched_tags:wake_batch=8
> ./dm-1/hctx0/sched_tags:wake_index=0
> ./dm-1/hctx0/sched_tags:ws={
> ./dm-1/hctx0/sched_tags:	{.wait_cnt=8, .wait=inactive},
> ./dm-1/hctx0/sched_tags:	{.wait_cnt=8, .wait=inactive},
> ./dm-1/hctx0/sched_tags:	{.wait_cnt=8, .wait=inactive},
> ./dm-1/hctx0/sched_tags:	{.wait_cnt=8, .wait=inactive},
> ./dm-1/hctx0/sched_tags:	{.wait_cnt=8, .wait=inactive},
> ./dm-1/hctx0/sched_tags:	{.wait_cnt=8, .wait=inactive},
> ./dm-1/hctx0/sched_tags:	{.wait_cnt=8, .wait=inactive},
> ./dm-1/hctx0/sched_tags:	{.wait_cnt=8, .wait=inactive},
> ./dm-1/hctx0/sched_tags:}
> ./dm-1/hctx0/sched_tags:round_robin=0
> ./dm-1/hctx0/tags_bitmap:00000000: 0000 0000 0000 0000 0000 0000 0000 0000
> ./dm-1/hctx0/tags_bitmap:00000010: 0000 0000 0000 0000 0000 0000 0000 0000
> ./dm-1/hctx0/tags_bitmap:00000020: 0000 0000 0000 0000 0000 0000 0000 0000
> ./dm-1/hctx0/tags_bitmap:00000030: 0000 0000 0000 0000 0000 0000 0000 0000
> ./dm-1/hctx0/tags_bitmap:00000040: 0000 0000 0000 0000 0000 0000 0000 0000
> ./dm-1/hctx0/tags_bitmap:00000050: 0000 0000 0000 0000 0000 0000 0000 0000
> ./dm-1/hctx0/tags_bitmap:00000060: 0000 0000 0000 0000 0000 0000 0000 0000
> ./dm-1/hctx0/tags_bitmap:00000070: 0000 0000 0000 0000 0000 0000 0000 0000
> ./dm-1/hctx0/tags_bitmap:00000080: 0000 0000 0000 0000 0000 0000 0000 0000
> ./dm-1/hctx0/tags_bitmap:00000090: 0000 0000 0000 0000 0000 0000 0000 0000
> ./dm-1/hctx0/tags_bitmap:000000a0: 0000 0000 0000 0000 0000 0000 0000 0000
> ./dm-1/hctx0/tags_bitmap:000000b0: 0000 0000 0000 0000 0000 0000 0000 0000
> ./dm-1/hctx0/tags_bitmap:000000c0: 0000 0000 0000 0000 0000 0000 0000 0000
> ./dm-1/hctx0/tags_bitmap:000000d0: 0000 0000 0000 0000 0000 0000 0000 0000
> ./dm-1/hctx0/tags_bitmap:000000e0: 0000 0000 0000 0000 0000 0000 0000 0000
> ./dm-1/hctx0/tags_bitmap:000000f0: 0000 0000 0000 0000 0000 0000 0000 0000
> ./dm-1/hctx0/tags:nr_tags=2048
> ./dm-1/hctx0/tags:nr_reserved_tags=0
> ./dm-1/hctx0/tags:active_queues=0
> ./dm-1/hctx0/tags:
> ./dm-1/hctx0/tags:bitmap_tags:
> ./dm-1/hctx0/tags:depth=2048
> ./dm-1/hctx0/tags:busy=0
> ./dm-1/hctx0/tags:bits_per_word=64
> ./dm-1/hctx0/tags:map_nr=32
> ./dm-1/hctx0/tags:alloc_hint={478, 1303, 102, 127}
> ./dm-1/hctx0/tags:wake_batch=8
> ./dm-1/hctx0/tags:wake_index=0
> ./dm-1/hctx0/tags:ws={
> ./dm-1/hctx0/tags:	{.wait_cnt=8, .wait=inactive},
> ./dm-1/hctx0/tags:	{.wait_cnt=8, .wait=inactive},
> ./dm-1/hctx0/tags:	{.wait_cnt=8, .wait=inactive},
> ./dm-1/hctx0/tags:	{.wait_cnt=8, .wait=inactive},
> ./dm-1/hctx0/tags:	{.wait_cnt=8, .wait=inactive},
> ./dm-1/hctx0/tags:	{.wait_cnt=8, .wait=inactive},
> ./dm-1/hctx0/tags:	{.wait_cnt=8, .wait=inactive},
> ./dm-1/hctx0/tags:	{.wait_cnt=8, .wait=inactive},
> ./dm-1/hctx0/tags:}
> ./dm-1/hctx0/tags:round_robin=0
> ./dm-1/hctx0/ctx_map:00000000: 00
> ./dm-1/hctx0/flags:alloc_policy=FIFO SHOULD_MERGE|SG_MERGE
> ./dm-1/hctx0/state:
> ./dm-1/sched/starved:0
> ./dm-1/sched/batching:1
> ./dm-1/write_hints:hint0: 0
> ./dm-1/write_hints:hint1: 0
> ./dm-1/write_hints:hint2: 0
> ./dm-1/write_hints:hint3: 0
> ./dm-1/write_hints:hint4: 0
> ./dm-1/state:SAME_COMP|IO_STAT|INIT_DONE|POLL|REGISTERED
> ./dm-1/poll_stat:read  (512 Bytes): samples=0
> ./dm-1/poll_stat:write (512 Bytes): samples=0
> ./dm-1/poll_stat:read  (1024 Bytes): samples=0
> ./dm-1/poll_stat:write (1024 Bytes): samples=0
> ./dm-1/poll_stat:read  (2048 Bytes): samples=0
> ./dm-1/poll_stat:write (2048 Bytes): samples=0
> ./dm-1/poll_stat:read  (4096 Bytes): samples=0
> ./dm-1/poll_stat:write (4096 Bytes): samples=0
> ./dm-1/poll_stat:read  (8192 Bytes): samples=0
> ./dm-1/poll_stat:write (8192 Bytes): samples=0
> ./dm-1/poll_stat:read  (16384 Bytes): samples=0
> ./dm-1/poll_stat:write (16384 Bytes): samples=0
> ./dm-1/poll_stat:read  (32768 Bytes): samples=0
> ./dm-1/poll_stat:write (32768 Bytes): samples=0
> ./dm-1/poll_stat:read  (65536 Bytes): samples=0
> ./dm-1/poll_stat:write (65536 Bytes): samples=0
> ./dm-0/hctx0/cpu3/completed:13 0
> ./dm-0/hctx0/cpu3/merged:0
> ./dm-0/hctx0/cpu3/dispatched:14 0
> ./dm-0/hctx0/cpu2/completed:0 0
> ./dm-0/hctx0/cpu2/merged:0
> ./dm-0/hctx0/cpu2/dispatched:0 0
> ./dm-0/hctx0/cpu1/completed:0 0
> ./dm-0/hctx0/cpu1/merged:0
> ./dm-0/hctx0/cpu1/dispatched:0 0
> ./dm-0/hctx0/cpu0/completed:0 0
> ./dm-0/hctx0/cpu0/merged:0
> ./dm-0/hctx0/cpu0/dispatched:0 0
> ./dm-0/hctx0/active:0
> ./dm-0/hctx0/run:15
> ./dm-0/hctx0/queued:14
> ./dm-0/hctx0/dispatched:       0	2
> ./dm-0/hctx0/dispatched:       1	13
> ./dm-0/hctx0/dispatched:       2	0
> ./dm-0/hctx0/dispatched:       4	0
> ./dm-0/hctx0/dispatched:       8	0
> ./dm-0/hctx0/dispatched:      16	0
> ./dm-0/hctx0/dispatched:      32+	0
> ./dm-0/hctx0/io_poll:considered=0
> ./dm-0/hctx0/io_poll:invoked=0
> ./dm-0/hctx0/io_poll:success=0
> ./dm-0/hctx0/sched_tags_bitmap:00000000: 0001 0000 0000 0000 0000 0000 0000 0000
> ./dm-0/hctx0/sched_tags_bitmap:00000010: 0000 0000 0000 0000 0000 0000 0000 0000
> ./dm-0/hctx0/sched_tags:nr_tags=256
> ./dm-0/hctx0/sched_tags:nr_reserved_tags=0
> ./dm-0/hctx0/sched_tags:active_queues=0
> ./dm-0/hctx0/sched_tags:
> ./dm-0/hctx0/sched_tags:bitmap_tags:
> ./dm-0/hctx0/sched_tags:depth=256
> ./dm-0/hctx0/sched_tags:busy=1
> ./dm-0/hctx0/sched_tags:bits_per_word=64
> ./dm-0/hctx0/sched_tags:map_nr=4
> ./dm-0/hctx0/sched_tags:alloc_hint={11, 18, 205, 9}
> ./dm-0/hctx0/sched_tags:wake_batch=8
> ./dm-0/hctx0/sched_tags:wake_index=0
> ./dm-0/hctx0/sched_tags:ws={
> ./dm-0/hctx0/sched_tags:	{.wait_cnt=8, .wait=inactive},
> ./dm-0/hctx0/sched_tags:	{.wait_cnt=8, .wait=inactive},
> ./dm-0/hctx0/sched_tags:	{.wait_cnt=8, .wait=inactive},
> ./dm-0/hctx0/sched_tags:	{.wait_cnt=8, .wait=inactive},
> ./dm-0/hctx0/sched_tags:	{.wait_cnt=8, .wait=inactive},
> ./dm-0/hctx0/sched_tags:	{.wait_cnt=8, .wait=inactive},
> ./dm-0/hctx0/sched_tags:	{.wait_cnt=8, .wait=inactive},
> ./dm-0/hctx0/sched_tags:	{.wait_cnt=8, .wait=inactive},
> ./dm-0/hctx0/sched_tags:}
> ./dm-0/hctx0/sched_tags:round_robin=0
> ./dm-0/hctx0/tags_bitmap:00000000: 0000 0000 0000 0000 0000 0000 0000 0000
> ./dm-0/hctx0/tags_bitmap:00000010: 0000 0000 0000 0000 0000 0000 0000 0000
> ./dm-0/hctx0/tags_bitmap:00000020: 0000 0000 0000 0000 0000 0000 0000 0000
> ./dm-0/hctx0/tags_bitmap:00000030: 0000 0000 0000 0000 0000 0000 0000 0000
> ./dm-0/hctx0/tags_bitmap:00000040: 0000 0000 0000 0000 0000 0000 0000 0000
> ./dm-0/hctx0/tags_bitmap:00000050: 0000 0000 0000 0000 0000 0000 0000 0000
> ./dm-0/hctx0/tags_bitmap:00000060: 0000 0000 0000 0000 0000 0000 0000 0000
> ./dm-0/hctx0/tags_bitmap:00000070: 0000 0000 0000 0000 0000 0000 0000 0000
> ./dm-0/hctx0/tags_bitmap:00000080: 0000 0000 0000 0000 0000 0000 0000 0000
> ./dm-0/hctx0/tags_bitmap:00000090: 0000 0000 0000 0000 0000 0000 0000 0000
> ./dm-0/hctx0/tags_bitmap:000000a0: 0000 0000 0000 0000 0000 0000 0000 0000
> ./dm-0/hctx0/tags_bitmap:000000b0: 0000 0000 0000 0000 0000 0000 0000 0000
> ./dm-0/hctx0/tags_bitmap:000000c0: 0000 0000 0000 0000 0000 0000 0000 0000
> ./dm-0/hctx0/tags_bitmap:000000d0: 0000 0000 0000 0000 0000 0000 0000 0000
> ./dm-0/hctx0/tags_bitmap:000000e0: 0000 0000 0000 0000 0000 0000 0000 0000
> ./dm-0/hctx0/tags_bitmap:000000f0: 0000 0000 0000 0000 0000 0000 0000 0000
> ./dm-0/hctx0/tags:nr_tags=2048
> ./dm-0/hctx0/tags:nr_reserved_tags=0
> ./dm-0/hctx0/tags:active_queues=0
> ./dm-0/hctx0/tags:
> ./dm-0/hctx0/tags:bitmap_tags:
> ./dm-0/hctx0/tags:depth=2048
> ./dm-0/hctx0/tags:busy=0
> ./dm-0/hctx0/tags:bits_per_word=64
> ./dm-0/hctx0/tags:map_nr=32
> ./dm-0/hctx0/tags:alloc_hint={1392, 843, 879, 1030}
> ./dm-0/hctx0/tags:wake_batch=8
> ./dm-0/hctx0/tags:wake_index=0
> ./dm-0/hctx0/tags:ws={
> ./dm-0/hctx0/tags:	{.wait_cnt=8, .wait=inactive},
> ./dm-0/hctx0/tags:	{.wait_cnt=8, .wait=inactive},
> ./dm-0/hctx0/tags:	{.wait_cnt=8, .wait=inactive},
> ./dm-0/hctx0/tags:	{.wait_cnt=8, .wait=inactive},
> ./dm-0/hctx0/tags:	{.wait_cnt=8, .wait=inactive},
> ./dm-0/hctx0/tags:	{.wait_cnt=8, .wait=inactive},
> ./dm-0/hctx0/tags:	{.wait_cnt=8, .wait=inactive},
> ./dm-0/hctx0/tags:	{.wait_cnt=8, .wait=inactive},
> ./dm-0/hctx0/tags:}
> ./dm-0/hctx0/tags:round_robin=0
> ./dm-0/hctx0/ctx_map:00000000: 00
> ./dm-0/hctx0/dispatch:000000002f291aa3 {.op=READ, .cmd_flags=, .rq_flags=STARTED|IO_STAT, complete=0, .tag=-1, .internal_tag=8}
> ./dm-0/hctx0/flags:alloc_policy=FIFO SHOULD_MERGE|SG_MERGE
> ./dm-0/hctx0/state:SCHED_RESTART
> ./dm-0/sched/starved:0
> ./dm-0/sched/batching:1
> ./dm-0/write_hints:hint0: 0
> ./dm-0/write_hints:hint1: 0
> ./dm-0/write_hints:hint2: 0
> ./dm-0/write_hints:hint3: 0
> ./dm-0/write_hints:hint4: 0
> ./dm-0/state:SAME_COMP|NONROT|IO_STAT|INIT_DONE|POLL|WC|FUA|REGISTERED
> ./dm-0/poll_stat:read  (512 Bytes): samples=0
> ./dm-0/poll_stat:write (512 Bytes): samples=0
> ./dm-0/poll_stat:read  (1024 Bytes): samples=0
> ./dm-0/poll_stat:write (1024 Bytes): samples=0
> ./dm-0/poll_stat:read  (2048 Bytes): samples=0
> ./dm-0/poll_stat:write (2048 Bytes): samples=0
> ./dm-0/poll_stat:read  (4096 Bytes): samples=0
> ./dm-0/poll_stat:write (4096 Bytes): samples=0
> ./dm-0/poll_stat:read  (8192 Bytes): samples=0
> ./dm-0/poll_stat:write (8192 Bytes): samples=0
> ./dm-0/poll_stat:read  (16384 Bytes): samples=0
> ./dm-0/poll_stat:write (16384 Bytes): samples=0
> ./dm-0/poll_stat:read  (32768 Bytes): samples=0
> ./dm-0/poll_stat:write (32768 Bytes): samples=0
> ./dm-0/poll_stat:read  (65536 Bytes): samples=0
> ./dm-0/poll_stat:write (65536 Bytes): samples=0
> ./sde/hctx3/cpu3/completed:58 12
> ./sde/hctx3/cpu3/merged:0
> ./sde/hctx3/cpu3/dispatched:58 12
> ./sde/hctx3/active:0
> ./sde/hctx3/run:39
> ./sde/hctx3/queued:70
> ./sde/hctx3/dispatched:       0	2
> ./sde/hctx3/dispatched:       1	36
> ./sde/hctx3/dispatched:       2	0
> ./sde/hctx3/dispatched:       4	0
> ./sde/hctx3/dispatched:       8	0
> ./sde/hctx3/dispatched:      16	0
> ./sde/hctx3/dispatched:      32+	0
> ./sde/hctx3/io_poll:considered=0
> ./sde/hctx3/io_poll:invoked=0
> ./sde/hctx3/io_poll:success=0
> ./sde/hctx3/tags_bitmap:00000000: 0000 0000 0000 0000
> ./sde/hctx3/tags:nr_tags=62
> ./sde/hctx3/tags:nr_reserved_tags=0
> ./sde/hctx3/tags:active_queues=0
> ./sde/hctx3/tags:
> ./sde/hctx3/tags:bitmap_tags:
> ./sde/hctx3/tags:depth=62
> ./sde/hctx3/tags:busy=0
> ./sde/hctx3/tags:bits_per_word=8
> ./sde/hctx3/tags:map_nr=8
> ./sde/hctx3/tags:alloc_hint={42, 53, 24, 50}
> ./sde/hctx3/tags:wake_batch=7
> ./sde/hctx3/tags:wake_index=0
> ./sde/hctx3/tags:ws={
> ./sde/hctx3/tags:	{.wait_cnt=7, .wait=inactive},
> ./sde/hctx3/tags:	{.wait_cnt=7, .wait=inactive},
> ./sde/hctx3/tags:	{.wait_cnt=7, .wait=inactive},
> ./sde/hctx3/tags:	{.wait_cnt=7, .wait=inactive},
> ./sde/hctx3/tags:	{.wait_cnt=7, .wait=inactive},
> ./sde/hctx3/tags:	{.wait_cnt=7, .wait=inactive},
> ./sde/hctx3/tags:	{.wait_cnt=7, .wait=inactive},
> ./sde/hctx3/tags:	{.wait_cnt=7, .wait=inactive},
> ./sde/hctx3/tags:}
> ./sde/hctx3/tags:round_robin=0
> ./sde/hctx3/ctx_map:00000000: 00
> ./sde/hctx3/flags:alloc_policy=FIFO SHOULD_MERGE|TAG_SHARED|SG_MERGE
> ./sde/hctx3/state:
> ./sde/hctx2/cpu2/completed:2 3
> ./sde/hctx2/cpu2/merged:0
> ./sde/hctx2/cpu2/dispatched:2 3
> ./sde/hctx2/active:0
> ./sde/hctx2/run:3
> ./sde/hctx2/queued:5
> ./sde/hctx2/dispatched:       0	0
> ./sde/hctx2/dispatched:       1	3
> ./sde/hctx2/dispatched:       2	0
> ./sde/hctx2/dispatched:       4	0
> ./sde/hctx2/dispatched:       8	0
> ./sde/hctx2/dispatched:      16	0
> ./sde/hctx2/dispatched:      32+	0
> ./sde/hctx2/io_poll:considered=0
> ./sde/hctx2/io_poll:invoked=0
> ./sde/hctx2/io_poll:success=0
> ./sde/hctx2/tags_bitmap:00000000: 0000 0000 0000 0000
> ./sde/hctx2/tags:nr_tags=62
> ./sde/hctx2/tags:nr_reserved_tags=0
> ./sde/hctx2/tags:active_queues=0
> ./sde/hctx2/tags:
> ./sde/hctx2/tags:bitmap_tags:
> ./sde/hctx2/tags:depth=62
> ./sde/hctx2/tags:busy=0
> ./sde/hctx2/tags:bits_per_word=8
> ./sde/hctx2/tags:map_nr=8
> ./sde/hctx2/tags:alloc_hint={24, 37, 46, 30}
> ./sde/hctx2/tags:wake_batch=7
> ./sde/hctx2/tags:wake_index=0
> ./sde/hctx2/tags:ws={
> ./sde/hctx2/tags:	{.wait_cnt=7, .wait=inactive},
> ./sde/hctx2/tags:	{.wait_cnt=7, .wait=inactive},
> ./sde/hctx2/tags:	{.wait_cnt=7, .wait=inactive},
> ./sde/hctx2/tags:	{.wait_cnt=7, .wait=inactive},
> ./sde/hctx2/tags:	{.wait_cnt=7, .wait=inactive},
> ./sde/hctx2/tags:	{.wait_cnt=7, .wait=inactive},
> ./sde/hctx2/tags:	{.wait_cnt=7, .wait=inactive},
> ./sde/hctx2/tags:	{.wait_cnt=7, .wait=inactive},
> ./sde/hctx2/tags:}
> ./sde/hctx2/tags:round_robin=0
> ./sde/hctx2/ctx_map:00000000: 00
> ./sde/hctx2/flags:alloc_policy=FIFO SHOULD_MERGE|TAG_SHARED|SG_MERGE
> ./sde/hctx2/state:
> ./sde/hctx1/cpu1/completed:31 47
> ./sde/hctx1/cpu1/merged:0
> ./sde/hctx1/cpu1/dispatched:31 47
> ./sde/hctx1/active:0
> ./sde/hctx1/run:76
> ./sde/hctx1/queued:78
> ./sde/hctx1/dispatched:       0	3
> ./sde/hctx1/dispatched:       1	71
> ./sde/hctx1/dispatched:       2	0
> ./sde/hctx1/dispatched:       4	0
> ./sde/hctx1/dispatched:       8	0
> ./sde/hctx1/dispatched:      16	0
> ./sde/hctx1/dispatched:      32+	0
> ./sde/hctx1/io_poll:considered=0
> ./sde/hctx1/io_poll:invoked=0
> ./sde/hctx1/io_poll:success=0
> ./sde/hctx1/tags_bitmap:00000000: 0000 0000 0000 0000
> ./sde/hctx1/tags:nr_tags=62
> ./sde/hctx1/tags:nr_reserved_tags=0
> ./sde/hctx1/tags:active_queues=0
> ./sde/hctx1/tags:
> ./sde/hctx1/tags:bitmap_tags:
> ./sde/hctx1/tags:depth=62
> ./sde/hctx1/tags:busy=0
> ./sde/hctx1/tags:bits_per_word=8
> ./sde/hctx1/tags:map_nr=8
> ./sde/hctx1/tags:alloc_hint={29, 0, 21, 37}
> ./sde/hctx1/tags:wake_batch=7
> ./sde/hctx1/tags:wake_index=0
> ./sde/hctx1/tags:ws={
> ./sde/hctx1/tags:	{.wait_cnt=7, .wait=inactive},
> ./sde/hctx1/tags:	{.wait_cnt=7, .wait=inactive},
> ./sde/hctx1/tags:	{.wait_cnt=7, .wait=inactive},
> ./sde/hctx1/tags:	{.wait_cnt=7, .wait=inactive},
> ./sde/hctx1/tags:	{.wait_cnt=7, .wait=inactive},
> ./sde/hctx1/tags:	{.wait_cnt=7, .wait=inactive},
> ./sde/hctx1/tags:	{.wait_cnt=7, .wait=inactive},
> ./sde/hctx1/tags:	{.wait_cnt=7, .wait=inactive},
> ./sde/hctx1/tags:}
> ./sde/hctx1/tags:round_robin=0
> ./sde/hctx1/ctx_map:00000000: 00
> ./sde/hctx1/flags:alloc_policy=FIFO SHOULD_MERGE|TAG_SHARED|SG_MERGE
> ./sde/hctx1/state:
> ./sde/hctx0/cpu0/completed:4 6
> ./sde/hctx0/cpu0/merged:0
> ./sde/hctx0/cpu0/dispatched:4 6
> ./sde/hctx0/active:0
> ./sde/hctx0/run:6
> ./sde/hctx0/queued:10
> ./sde/hctx0/dispatched:       0	0
> ./sde/hctx0/dispatched:       1	6
> ./sde/hctx0/dispatched:       2	0
> ./sde/hctx0/dispatched:       4	0
> ./sde/hctx0/dispatched:       8	0
> ./sde/hctx0/dispatched:      16	0
> ./sde/hctx0/dispatched:      32+	0
> ./sde/hctx0/io_poll:considered=0
> ./sde/hctx0/io_poll:invoked=0
> ./sde/hctx0/io_poll:success=0
> ./sde/hctx0/tags_bitmap:00000000: 0000 0000 0000 0000
> ./sde/hctx0/tags:nr_tags=62
> ./sde/hctx0/tags:nr_reserved_tags=0
> ./sde/hctx0/tags:active_queues=0
> ./sde/hctx0/tags:
> ./sde/hctx0/tags:bitmap_tags:
> ./sde/hctx0/tags:depth=62
> ./sde/hctx0/tags:busy=0
> ./sde/hctx0/tags:bits_per_word=8
> ./sde/hctx0/tags:map_nr=8
> ./sde/hctx0/tags:alloc_hint={27, 47, 46, 38}
> ./sde/hctx0/tags:wake_batch=7
> ./sde/hctx0/tags:wake_index=0
> ./sde/hctx0/tags:ws={
> ./sde/hctx0/tags:	{.wait_cnt=7, .wait=inactive},
> ./sde/hctx0/tags:	{.wait_cnt=7, .wait=inactive},
> ./sde/hctx0/tags:	{.wait_cnt=7, .wait=inactive},
> ./sde/hctx0/tags:	{.wait_cnt=7, .wait=inactive},
> ./sde/hctx0/tags:	{.wait_cnt=7, .wait=inactive},
> ./sde/hctx0/tags:	{.wait_cnt=7, .wait=inactive},
> ./sde/hctx0/tags:	{.wait_cnt=7, .wait=inactive},
> ./sde/hctx0/tags:	{.wait_cnt=7, .wait=inactive},
> ./sde/hctx0/tags:}
> ./sde/hctx0/tags:round_robin=0
> ./sde/hctx0/ctx_map:00000000: 00
> ./sde/hctx0/flags:alloc_policy=FIFO SHOULD_MERGE|TAG_SHARED|SG_MERGE
> ./sde/hctx0/state:
> ./sde/write_hints:hint0: 0
> ./sde/write_hints:hint1: 0
> ./sde/write_hints:hint2: 0
> ./sde/write_hints:hint3: 0
> ./sde/write_hints:hint4: 0
> ./sde/state:SAME_COMP|IO_STAT|INIT_DONE|POLL|REGISTERED|SCSI_PASSTHROUGH
> ./sde/poll_stat:read  (512 Bytes): samples=0
> ./sde/poll_stat:write (512 Bytes): samples=0
> ./sde/poll_stat:read  (1024 Bytes): samples=0
> ./sde/poll_stat:write (1024 Bytes): samples=0
> ./sde/poll_stat:read  (2048 Bytes): samples=0
> ./sde/poll_stat:write (2048 Bytes): samples=0
> ./sde/poll_stat:read  (4096 Bytes): samples=0
> ./sde/poll_stat:write (4096 Bytes): samples=0
> ./sde/poll_stat:read  (8192 Bytes): samples=0
> ./sde/poll_stat:write (8192 Bytes): samples=0
> ./sde/poll_stat:read  (16384 Bytes): samples=0
> ./sde/poll_stat:write (16384 Bytes): samples=0
> ./sde/poll_stat:read  (32768 Bytes): samples=0
> ./sde/poll_stat:write (32768 Bytes): samples=0
> ./sde/poll_stat:read  (65536 Bytes): samples=0
> ./sde/poll_stat:write (65536 Bytes): samples=0
> ./sdd/hctx3/cpu3/completed:17 7
> ./sdd/hctx3/cpu3/merged:0
> ./sdd/hctx3/cpu3/dispatched:17 7
> ./sdd/hctx3/active:0
> ./sdd/hctx3/run:13
> ./sdd/hctx3/queued:24
> ./sdd/hctx3/dispatched:       0	4
> ./sdd/hctx3/dispatched:       1	9
> ./sdd/hctx3/dispatched:       2	0
> ./sdd/hctx3/dispatched:       4	0
> ./sdd/hctx3/dispatched:       8	0
> ./sdd/hctx3/dispatched:      16	0
> ./sdd/hctx3/dispatched:      32+	0
> ./sdd/hctx3/io_poll:considered=0
> ./sdd/hctx3/io_poll:invoked=0
> ./sdd/hctx3/io_poll:success=0
> ./sdd/hctx3/tags_bitmap:00000000: 0000 0000 0000 0000
> ./sdd/hctx3/tags:nr_tags=62
> ./sdd/hctx3/tags:nr_reserved_tags=0
> ./sdd/hctx3/tags:active_queues=0
> ./sdd/hctx3/tags:
> ./sdd/hctx3/tags:bitmap_tags:
> ./sdd/hctx3/tags:depth=62
> ./sdd/hctx3/tags:busy=0
> ./sdd/hctx3/tags:bits_per_word=8
> ./sdd/hctx3/tags:map_nr=8
> ./sdd/hctx3/tags:alloc_hint={42, 53, 24, 50}
> ./sdd/hctx3/tags:wake_batch=7
> ./sdd/hctx3/tags:wake_index=0
> ./sdd/hctx3/tags:ws={
> ./sdd/hctx3/tags:	{.wait_cnt=7, .wait=inactive},
> ./sdd/hctx3/tags:	{.wait_cnt=7, .wait=inactive},
> ./sdd/hctx3/tags:	{.wait_cnt=7, .wait=inactive},
> ./sdd/hctx3/tags:	{.wait_cnt=7, .wait=inactive},
> ./sdd/hctx3/tags:	{.wait_cnt=7, .wait=inactive},
> ./sdd/hctx3/tags:	{.wait_cnt=7, .wait=inactive},
> ./sdd/hctx3/tags:	{.wait_cnt=7, .wait=inactive},
> ./sdd/hctx3/tags:	{.wait_cnt=7, .wait=inactive},
> ./sdd/hctx3/tags:}
> ./sdd/hctx3/tags:round_robin=0
> ./sdd/hctx3/ctx_map:00000000: 00
> ./sdd/hctx3/flags:alloc_policy=FIFO SHOULD_MERGE|TAG_SHARED|SG_MERGE
> ./sdd/hctx3/state:
> ./sdd/hctx2/cpu2/completed:20 37
> ./sdd/hctx2/cpu2/merged:0
> ./sdd/hctx2/cpu2/dispatched:20 37
> ./sdd/hctx2/active:0
> ./sdd/hctx2/run:57
> ./sdd/hctx2/queued:57
> ./sdd/hctx2/dispatched:       0	5
> ./sdd/hctx2/dispatched:       1	52
> ./sdd/hctx2/dispatched:       2	0
> ./sdd/hctx2/dispatched:       4	0
> ./sdd/hctx2/dispatched:       8	0
> ./sdd/hctx2/dispatched:      16	0
> ./sdd/hctx2/dispatched:      32+	0
> ./sdd/hctx2/io_poll:considered=0
> ./sdd/hctx2/io_poll:invoked=0
> ./sdd/hctx2/io_poll:success=0
> ./sdd/hctx2/tags_bitmap:00000000: 0000 0000 0000 0000
> ./sdd/hctx2/tags:nr_tags=62
> ./sdd/hctx2/tags:nr_reserved_tags=0
> ./sdd/hctx2/tags:active_queues=0
> ./sdd/hctx2/tags:
> ./sdd/hctx2/tags:bitmap_tags:
> ./sdd/hctx2/tags:depth=62
> ./sdd/hctx2/tags:busy=0
> ./sdd/hctx2/tags:bits_per_word=8
> ./sdd/hctx2/tags:map_nr=8
> ./sdd/hctx2/tags:alloc_hint={24, 37, 46, 30}
> ./sdd/hctx2/tags:wake_batch=7
> ./sdd/hctx2/tags:wake_index=0
> ./sdd/hctx2/tags:ws={
> ./sdd/hctx2/tags:	{.wait_cnt=7, .wait=inactive},
> ./sdd/hctx2/tags:	{.wait_cnt=7, .wait=inactive},
> ./sdd/hctx2/tags:	{.wait_cnt=7, .wait=inactive},
> ./sdd/hctx2/tags:	{.wait_cnt=7, .wait=inactive},
> ./sdd/hctx2/tags:	{.wait_cnt=7, .wait=inactive},
> ./sdd/hctx2/tags:	{.wait_cnt=7, .wait=inactive},
> ./sdd/hctx2/tags:	{.wait_cnt=7, .wait=inactive},
> ./sdd/hctx2/tags:	{.wait_cnt=7, .wait=inactive},
> ./sdd/hctx2/tags:}
> ./sdd/hctx2/tags:round_robin=0
> ./sdd/hctx2/ctx_map:00000000: 00
> ./sdd/hctx2/flags:alloc_policy=FIFO SHOULD_MERGE|TAG_SHARED|SG_MERGE
> ./sdd/hctx2/state:
> ./sdd/hctx1/cpu1/completed:5 15
> ./sdd/hctx1/cpu1/merged:0
> ./sdd/hctx1/cpu1/dispatched:5 15
> ./sdd/hctx1/active:0
> ./sdd/hctx1/run:26
> ./sdd/hctx1/queued:20
> ./sdd/hctx1/dispatched:       0	7
> ./sdd/hctx1/dispatched:       1	19
> ./sdd/hctx1/dispatched:       2	0
> ./sdd/hctx1/dispatched:       4	0
> ./sdd/hctx1/dispatched:       8	0
> ./sdd/hctx1/dispatched:      16	0
> ./sdd/hctx1/dispatched:      32+	0
> ./sdd/hctx1/io_poll:considered=0
> ./sdd/hctx1/io_poll:invoked=0
> ./sdd/hctx1/io_poll:success=0
> ./sdd/hctx1/tags_bitmap:00000000: 0000 0000 0000 0000
> ./sdd/hctx1/tags:nr_tags=62
> ./sdd/hctx1/tags:nr_reserved_tags=0
> ./sdd/hctx1/tags:active_queues=0
> ./sdd/hctx1/tags:
> ./sdd/hctx1/tags:bitmap_tags:
> ./sdd/hctx1/tags:depth=62
> ./sdd/hctx1/tags:busy=0
> ./sdd/hctx1/tags:bits_per_word=8
> ./sdd/hctx1/tags:map_nr=8
> ./sdd/hctx1/tags:alloc_hint={29, 0, 21, 37}
> ./sdd/hctx1/tags:wake_batch=7
> ./sdd/hctx1/tags:wake_index=0
> ./sdd/hctx1/tags:ws={
> ./sdd/hctx1/tags:	{.wait_cnt=7, .wait=inactive},
> ./sdd/hctx1/tags:	{.wait_cnt=7, .wait=inactive},
> ./sdd/hctx1/tags:	{.wait_cnt=7, .wait=inactive},
> ./sdd/hctx1/tags:	{.wait_cnt=7, .wait=inactive},
> ./sdd/hctx1/tags:	{.wait_cnt=7, .wait=inactive},
> ./sdd/hctx1/tags:	{.wait_cnt=7, .wait=inactive},
> ./sdd/hctx1/tags:	{.wait_cnt=7, .wait=inactive},
> ./sdd/hctx1/tags:	{.wait_cnt=7, .wait=inactive},
> ./sdd/hctx1/tags:}
> ./sdd/hctx1/tags:round_robin=0
> ./sdd/hctx1/ctx_map:00000000: 00
> ./sdd/hctx1/flags:alloc_policy=FIFO SHOULD_MERGE|TAG_SHARED|SG_MERGE
> ./sdd/hctx1/state:
> ./sdd/hctx0/cpu0/completed:34 8
> ./sdd/hctx0/cpu0/merged:0
> ./sdd/hctx0/cpu0/dispatched:34 8
> ./sdd/hctx0/active:0
> ./sdd/hctx0/run:43
> ./sdd/hctx0/queued:42
> ./sdd/hctx0/dispatched:       0	4
> ./sdd/hctx0/dispatched:       1	39
> ./sdd/hctx0/dispatched:       2	0
> ./sdd/hctx0/dispatched:       4	0
> ./sdd/hctx0/dispatched:       8	0
> ./sdd/hctx0/dispatched:      16	0
> ./sdd/hctx0/dispatched:      32+	0
> ./sdd/hctx0/io_poll:considered=0
> ./sdd/hctx0/io_poll:invoked=0
> ./sdd/hctx0/io_poll:success=0
> ./sdd/hctx0/tags_bitmap:00000000: 0000 0000 0000 0000
> ./sdd/hctx0/tags:nr_tags=62
> ./sdd/hctx0/tags:nr_reserved_tags=0
> ./sdd/hctx0/tags:active_queues=0
> ./sdd/hctx0/tags:
> ./sdd/hctx0/tags:bitmap_tags:
> ./sdd/hctx0/tags:depth=62
> ./sdd/hctx0/tags:busy=0
> ./sdd/hctx0/tags:bits_per_word=8
> ./sdd/hctx0/tags:map_nr=8
> ./sdd/hctx0/tags:alloc_hint={27, 47, 46, 38}
> ./sdd/hctx0/tags:wake_batch=7
> ./sdd/hctx0/tags:wake_index=0
> ./sdd/hctx0/tags:ws={
> ./sdd/hctx0/tags:	{.wait_cnt=7, .wait=inactive},
> ./sdd/hctx0/tags:	{.wait_cnt=7, .wait=inactive},
> ./sdd/hctx0/tags:	{.wait_cnt=7, .wait=inactive},
> ./sdd/hctx0/tags:	{.wait_cnt=7, .wait=inactive},
> ./sdd/hctx0/tags:	{.wait_cnt=7, .wait=inactive},
> ./sdd/hctx0/tags:	{.wait_cnt=7, .wait=inactive},
> ./sdd/hctx0/tags:	{.wait_cnt=7, .wait=inactive},
> ./sdd/hctx0/tags:	{.wait_cnt=7, .wait=inactive},
> ./sdd/hctx0/tags:}
> ./sdd/hctx0/tags:round_robin=0
> ./sdd/hctx0/ctx_map:00000000: 00
> ./sdd/hctx0/flags:alloc_policy=FIFO SHOULD_MERGE|TAG_SHARED|SG_MERGE
> ./sdd/hctx0/state:
> ./sdd/write_hints:hint0: 0
> ./sdd/write_hints:hint1: 0
> ./sdd/write_hints:hint2: 0
> ./sdd/write_hints:hint3: 0
> ./sdd/write_hints:hint4: 0
> ./sdd/state:SAME_COMP|NONROT|IO_STAT|INIT_DONE|POLL|WC|FUA|REGISTERED|SCSI_PASSTHROUGH
> ./sdd/poll_stat:read  (512 Bytes): samples=0
> ./sdd/poll_stat:write (512 Bytes): samples=0
> ./sdd/poll_stat:read  (1024 Bytes): samples=0
> ./sdd/poll_stat:write (1024 Bytes): samples=0
> ./sdd/poll_stat:read  (2048 Bytes): samples=0
> ./sdd/poll_stat:write (2048 Bytes): samples=0
> ./sdd/poll_stat:read  (4096 Bytes): samples=0
> ./sdd/poll_stat:write (4096 Bytes): samples=0
> ./sdd/poll_stat:read  (8192 Bytes): samples=0
> ./sdd/poll_stat:write (8192 Bytes): samples=0
> ./sdd/poll_stat:read  (16384 Bytes): samples=0
> ./sdd/poll_stat:write (16384 Bytes): samples=0
> ./sdd/poll_stat:read  (32768 Bytes): samples=0
> ./sdd/poll_stat:write (32768 Bytes): samples=0
> ./sdd/poll_stat:read  (65536 Bytes): samples=0
> ./sdd/poll_stat:write (65536 Bytes): samples=0
> ./sdc/hctx3/cpu3/completed:1 11
> ./sdc/hctx3/cpu3/merged:0
> ./sdc/hctx3/cpu3/dispatched:1 11
> ./sdc/hctx3/active:0
> ./sdc/hctx3/run:15
> ./sdc/hctx3/queued:12
> ./sdc/hctx3/dispatched:       0	2
> ./sdc/hctx3/dispatched:       1	12
> ./sdc/hctx3/dispatched:       2	0
> ./sdc/hctx3/dispatched:       4	0
> ./sdc/hctx3/dispatched:       8	0
> ./sdc/hctx3/dispatched:      16	0
> ./sdc/hctx3/dispatched:      32+	0
> ./sdc/hctx3/io_poll:considered=0
> ./sdc/hctx3/io_poll:invoked=0
> ./sdc/hctx3/io_poll:success=0
> ./sdc/hctx3/tags_bitmap:00000000: 0000 0000 0000 0000
> ./sdc/hctx3/tags:nr_tags=62
> ./sdc/hctx3/tags:nr_reserved_tags=0
> ./sdc/hctx3/tags:active_queues=0
> ./sdc/hctx3/tags:
> ./sdc/hctx3/tags:bitmap_tags:
> ./sdc/hctx3/tags:depth=62
> ./sdc/hctx3/tags:busy=0
> ./sdc/hctx3/tags:bits_per_word=8
> ./sdc/hctx3/tags:map_nr=8
> ./sdc/hctx3/tags:alloc_hint={42, 53, 24, 50}
> ./sdc/hctx3/tags:wake_batch=7
> ./sdc/hctx3/tags:wake_index=0
> ./sdc/hctx3/tags:ws={
> ./sdc/hctx3/tags:	{.wait_cnt=7, .wait=inactive},
> ./sdc/hctx3/tags:	{.wait_cnt=7, .wait=inactive},
> ./sdc/hctx3/tags:	{.wait_cnt=7, .wait=inactive},
> ./sdc/hctx3/tags:	{.wait_cnt=7, .wait=inactive},
> ./sdc/hctx3/tags:	{.wait_cnt=7, .wait=inactive},
> ./sdc/hctx3/tags:	{.wait_cnt=7, .wait=inactive},
> ./sdc/hctx3/tags:	{.wait_cnt=7, .wait=inactive},
> ./sdc/hctx3/tags:	{.wait_cnt=7, .wait=inactive},
> ./sdc/hctx3/tags:}
> ./sdc/hctx3/tags:round_robin=0
> ./sdc/hctx3/ctx_map:00000000: 00
> ./sdc/hctx3/flags:alloc_policy=FIFO SHOULD_MERGE|TAG_SHARED|SG_MERGE
> ./sdc/hctx3/state:
> ./sdc/hctx2/cpu2/completed:16 37
> ./sdc/hctx2/cpu2/merged:0
> ./sdc/hctx2/cpu2/dispatched:16 37
> ./sdc/hctx2/active:0
> ./sdc/hctx2/run:73
> ./sdc/hctx2/queued:53
> ./sdc/hctx2/dispatched:       0	22
> ./sdc/hctx2/dispatched:       1	52
> ./sdc/hctx2/dispatched:       2	0
> ./sdc/hctx2/dispatched:       4	0
> ./sdc/hctx2/dispatched:       8	0
> ./sdc/hctx2/dispatched:      16	0
> ./sdc/hctx2/dispatched:      32+	0
> ./sdc/hctx2/io_poll:considered=0
> ./sdc/hctx2/io_poll:invoked=0
> ./sdc/hctx2/io_poll:success=0
> ./sdc/hctx2/tags_bitmap:00000000: 0000 0000 0000 0000
> ./sdc/hctx2/tags:nr_tags=62
> ./sdc/hctx2/tags:nr_reserved_tags=0
> ./sdc/hctx2/tags:active_queues=0
> ./sdc/hctx2/tags:
> ./sdc/hctx2/tags:bitmap_tags:
> ./sdc/hctx2/tags:depth=62
> ./sdc/hctx2/tags:busy=0
> ./sdc/hctx2/tags:bits_per_word=8
> ./sdc/hctx2/tags:map_nr=8
> ./sdc/hctx2/tags:alloc_hint={24, 37, 46, 30}
> ./sdc/hctx2/tags:wake_batch=7
> ./sdc/hctx2/tags:wake_index=0
> ./sdc/hctx2/tags:ws={
> ./sdc/hctx2/tags:	{.wait_cnt=7, .wait=inactive},
> ./sdc/hctx2/tags:	{.wait_cnt=7, .wait=inactive},
> ./sdc/hctx2/tags:	{.wait_cnt=7, .wait=inactive},
> ./sdc/hctx2/tags:	{.wait_cnt=7, .wait=inactive},
> ./sdc/hctx2/tags:	{.wait_cnt=7, .wait=inactive},
> ./sdc/hctx2/tags:	{.wait_cnt=7, .wait=inactive},
> ./sdc/hctx2/tags:	{.wait_cnt=7, .wait=inactive},
> ./sdc/hctx2/tags:	{.wait_cnt=7, .wait=inactive},
> ./sdc/hctx2/tags:}
> ./sdc/hctx2/tags:round_robin=0
> ./sdc/hctx2/ctx_map:00000000: 00
> ./sdc/hctx2/flags:alloc_policy=FIFO SHOULD_MERGE|TAG_SHARED|SG_MERGE
> ./sdc/hctx2/state:
> ./sdc/hctx1/cpu1/completed:32 8
> ./sdc/hctx1/cpu1/merged:0
> ./sdc/hctx1/cpu1/dispatched:32 8
> ./sdc/hctx1/active:0
> ./sdc/hctx1/run:10
> ./sdc/hctx1/queued:40
> ./sdc/hctx1/dispatched:       0	2
> ./sdc/hctx1/dispatched:       1	8
> ./sdc/hctx1/dispatched:       2	0
> ./sdc/hctx1/dispatched:       4	0
> ./sdc/hctx1/dispatched:       8	0
> ./sdc/hctx1/dispatched:      16	0
> ./sdc/hctx1/dispatched:      32+	0
> ./sdc/hctx1/io_poll:considered=0
> ./sdc/hctx1/io_poll:invoked=0
> ./sdc/hctx1/io_poll:success=0
> ./sdc/hctx1/tags_bitmap:00000000: 0000 0000 0000 0000
> ./sdc/hctx1/tags:nr_tags=62
> ./sdc/hctx1/tags:nr_reserved_tags=0
> ./sdc/hctx1/tags:active_queues=0
> ./sdc/hctx1/tags:
> ./sdc/hctx1/tags:bitmap_tags:
> ./sdc/hctx1/tags:depth=62
> ./sdc/hctx1/tags:busy=0
> ./sdc/hctx1/tags:bits_per_word=8
> ./sdc/hctx1/tags:map_nr=8
> ./sdc/hctx1/tags:alloc_hint={29, 0, 21, 37}
> ./sdc/hctx1/tags:wake_batch=7
> ./sdc/hctx1/tags:wake_index=0
> ./sdc/hctx1/tags:ws={
> ./sdc/hctx1/tags:	{.wait_cnt=7, .wait=inactive},
> ./sdc/hctx1/tags:	{.wait_cnt=7, .wait=inactive},
> ./sdc/hctx1/tags:	{.wait_cnt=7, .wait=inactive},
> ./sdc/hctx1/tags:	{.wait_cnt=7, .wait=inactive},
> ./sdc/hctx1/tags:	{.wait_cnt=7, .wait=inactive},
> ./sdc/hctx1/tags:	{.wait_cnt=7, .wait=inactive},
> ./sdc/hctx1/tags:	{.wait_cnt=7, .wait=inactive},
> ./sdc/hctx1/tags:	{.wait_cnt=7, .wait=inactive},
> ./sdc/hctx1/tags:}
> ./sdc/hctx1/tags:round_robin=0
> ./sdc/hctx1/ctx_map:00000000: 00
> ./sdc/hctx1/flags:alloc_policy=FIFO SHOULD_MERGE|TAG_SHARED|SG_MERGE
> ./sdc/hctx1/state:
> ./sdc/hctx0/cpu0/completed:39 12
> ./sdc/hctx0/cpu0/merged:0
> ./sdc/hctx0/cpu0/dispatched:39 12
> ./sdc/hctx0/active:0
> ./sdc/hctx0/run:48
> ./sdc/hctx0/queued:51
> ./sdc/hctx0/dispatched:       0	0
> ./sdc/hctx0/dispatched:       1	48
> ./sdc/hctx0/dispatched:       2	0
> ./sdc/hctx0/dispatched:       4	0
> ./sdc/hctx0/dispatched:       8	0
> ./sdc/hctx0/dispatched:      16	0
> ./sdc/hctx0/dispatched:      32+	0
> ./sdc/hctx0/io_poll:considered=0
> ./sdc/hctx0/io_poll:invoked=0
> ./sdc/hctx0/io_poll:success=0
> ./sdc/hctx0/tags_bitmap:00000000: 0000 0000 0000 0000
> ./sdc/hctx0/tags:nr_tags=62
> ./sdc/hctx0/tags:nr_reserved_tags=0
> ./sdc/hctx0/tags:active_queues=0
> ./sdc/hctx0/tags:
> ./sdc/hctx0/tags:bitmap_tags:
> ./sdc/hctx0/tags:depth=62
> ./sdc/hctx0/tags:busy=0
> ./sdc/hctx0/tags:bits_per_word=8
> ./sdc/hctx0/tags:map_nr=8
> ./sdc/hctx0/tags:alloc_hint={27, 47, 46, 38}
> ./sdc/hctx0/tags:wake_batch=7
> ./sdc/hctx0/tags:wake_index=0
> ./sdc/hctx0/tags:ws={
> ./sdc/hctx0/tags:	{.wait_cnt=7, .wait=inactive},
> ./sdc/hctx0/tags:	{.wait_cnt=7, .wait=inactive},
> ./sdc/hctx0/tags:	{.wait_cnt=7, .wait=inactive},
> ./sdc/hctx0/tags:	{.wait_cnt=7, .wait=inactive},
> ./sdc/hctx0/tags:	{.wait_cnt=7, .wait=inactive},
> ./sdc/hctx0/tags:	{.wait_cnt=7, .wait=inactive},
> ./sdc/hctx0/tags:	{.wait_cnt=7, .wait=inactive},
> ./sdc/hctx0/tags:	{.wait_cnt=7, .wait=inactive},
> ./sdc/hctx0/tags:}
> ./sdc/hctx0/tags:round_robin=0
> ./sdc/hctx0/ctx_map:00000000: 00
> ./sdc/hctx0/flags:alloc_policy=FIFO SHOULD_MERGE|TAG_SHARED|SG_MERGE
> ./sdc/hctx0/state:
> ./sdc/write_hints:hint0: 0
> ./sdc/write_hints:hint1: 0
> ./sdc/write_hints:hint2: 0
> ./sdc/write_hints:hint3: 0
> ./sdc/write_hints:hint4: 0
> ./sdc/state:SAME_COMP|IO_STAT|INIT_DONE|POLL|REGISTERED|SCSI_PASSTHROUGH
> ./sdc/poll_stat:read  (512 Bytes): samples=0
> ./sdc/poll_stat:write (512 Bytes): samples=0
> ./sdc/poll_stat:read  (1024 Bytes): samples=0
> ./sdc/poll_stat:write (1024 Bytes): samples=0
> ./sdc/poll_stat:read  (2048 Bytes): samples=0
> ./sdc/poll_stat:write (2048 Bytes): samples=0
> ./sdc/poll_stat:read  (4096 Bytes): samples=0
> ./sdc/poll_stat:write (4096 Bytes): samples=0
> ./sdc/poll_stat:read  (8192 Bytes): samples=0
> ./sdc/poll_stat:write (8192 Bytes): samples=0
> ./sdc/poll_stat:read  (16384 Bytes): samples=0
> ./sdc/poll_stat:write (16384 Bytes): samples=0
> ./sdc/poll_stat:read  (32768 Bytes): samples=0
> ./sdc/poll_stat:write (32768 Bytes): samples=0
> ./sdc/poll_stat:read  (65536 Bytes): samples=0
> ./sdc/poll_stat:write (65536 Bytes): samples=0
> ./sdb/hctx0/cpu3/completed:42 6
> ./sdb/hctx0/cpu3/merged:0
> ./sdb/hctx0/cpu3/dispatched:42 6
> ./sdb/hctx0/cpu2/completed:110 13
> ./sdb/hctx0/cpu2/merged:0
> ./sdb/hctx0/cpu2/dispatched:110 13
> ./sdb/hctx0/cpu1/completed:35 39
> ./sdb/hctx0/cpu1/merged:0
> ./sdb/hctx0/cpu1/dispatched:35 39
> ./sdb/hctx0/cpu0/completed:35 26
> ./sdb/hctx0/cpu0/merged:0
> ./sdb/hctx0/cpu0/dispatched:35 26
> ./sdb/hctx0/active:0
> ./sdb/hctx0/run:300
> ./sdb/hctx0/queued:306
> ./sdb/hctx0/dispatched:       0	0
> ./sdb/hctx0/dispatched:       1	306
> ./sdb/hctx0/dispatched:       2	0
> ./sdb/hctx0/dispatched:       4	0
> ./sdb/hctx0/dispatched:       8	0
> ./sdb/hctx0/dispatched:      16	0
> ./sdb/hctx0/dispatched:      32+	0
> ./sdb/hctx0/io_poll:considered=0
> ./sdb/hctx0/io_poll:invoked=0
> ./sdb/hctx0/io_poll:success=0
> ./sdb/hctx0/sched_tags_bitmap:00000000: 0000 0000 0000 0000 0000 0000 0000 0000
> ./sdb/hctx0/sched_tags_bitmap:00000010: 0000 0000 0000 0000 0000 0000 0000 0000
> ./sdb/hctx0/sched_tags:nr_tags=256
> ./sdb/hctx0/sched_tags:nr_reserved_tags=0
> ./sdb/hctx0/sched_tags:active_queues=0
> ./sdb/hctx0/sched_tags:
> ./sdb/hctx0/sched_tags:bitmap_tags:
> ./sdb/hctx0/sched_tags:depth=256
> ./sdb/hctx0/sched_tags:busy=0
> ./sdb/hctx0/sched_tags:bits_per_word=64
> ./sdb/hctx0/sched_tags:map_nr=4
> ./sdb/hctx0/sched_tags:alloc_hint={68, 116, 75, 172}
> ./sdb/hctx0/sched_tags:wake_batch=8
> ./sdb/hctx0/sched_tags:wake_index=0
> ./sdb/hctx0/sched_tags:ws={
> ./sdb/hctx0/sched_tags:	{.wait_cnt=8, .wait=inactive},
> ./sdb/hctx0/sched_tags:	{.wait_cnt=8, .wait=inactive},
> ./sdb/hctx0/sched_tags:	{.wait_cnt=8, .wait=inactive},
> ./sdb/hctx0/sched_tags:	{.wait_cnt=8, .wait=inactive},
> ./sdb/hctx0/sched_tags:	{.wait_cnt=8, .wait=inactive},
> ./sdb/hctx0/sched_tags:	{.wait_cnt=8, .wait=inactive},
> ./sdb/hctx0/sched_tags:	{.wait_cnt=8, .wait=inactive},
> ./sdb/hctx0/sched_tags:	{.wait_cnt=8, .wait=inactive},
> ./sdb/hctx0/sched_tags:}
> ./sdb/hctx0/sched_tags:round_robin=0
> ./sdb/hctx0/tags_bitmap:00000000: 0000 0000 0000 0000 0000 0000 0000 0000
> ./sdb/hctx0/tags_bitmap:00000010: 0000 0000 0000 0000
> ./sdb/hctx0/tags:nr_tags=192
> ./sdb/hctx0/tags:nr_reserved_tags=0
> ./sdb/hctx0/tags:active_queues=0
> ./sdb/hctx0/tags:
> ./sdb/hctx0/tags:bitmap_tags:
> ./sdb/hctx0/tags:depth=192
> ./sdb/hctx0/tags:busy=0
> ./sdb/hctx0/tags:bits_per_word=32
> ./sdb/hctx0/tags:map_nr=6
> ./sdb/hctx0/tags:alloc_hint={5, 24, 47, 126}
> ./sdb/hctx0/tags:wake_batch=8
> ./sdb/hctx0/tags:wake_index=0
> ./sdb/hctx0/tags:ws={
> ./sdb/hctx0/tags:	{.wait_cnt=8, .wait=inactive},
> ./sdb/hctx0/tags:	{.wait_cnt=8, .wait=inactive},
> ./sdb/hctx0/tags:	{.wait_cnt=8, .wait=inactive},
> ./sdb/hctx0/tags:	{.wait_cnt=8, .wait=inactive},
> ./sdb/hctx0/tags:	{.wait_cnt=8, .wait=inactive},
> ./sdb/hctx0/tags:	{.wait_cnt=8, .wait=inactive},
> ./sdb/hctx0/tags:	{.wait_cnt=8, .wait=inactive},
> ./sdb/hctx0/tags:	{.wait_cnt=8, .wait=inactive},
> ./sdb/hctx0/tags:}
> ./sdb/hctx0/tags:round_robin=0
> ./sdb/hctx0/ctx_map:00000000: 00
> ./sdb/hctx0/flags:alloc_policy=FIFO SHOULD_MERGE|SG_MERGE
> ./sdb/hctx0/state:
> ./sdb/sched/starved:0
> ./sdb/sched/batching:1
> ./sdb/write_hints:hint0: 0
> ./sdb/write_hints:hint1: 0
> ./sdb/write_hints:hint2: 0
> ./sdb/write_hints:hint3: 0
> ./sdb/write_hints:hint4: 0
> ./sdb/state:BIDI|SAME_COMP|NONROT|IO_STAT|INIT_DONE|POLL|WC|FUA|REGISTERED|SCSI_PASSTHROUGH
> ./sdb/poll_stat:read  (512 Bytes): samples=0
> ./sdb/poll_stat:write (512 Bytes): samples=0
> ./sdb/poll_stat:read  (1024 Bytes): samples=0
> ./sdb/poll_stat:write (1024 Bytes): samples=0
> ./sdb/poll_stat:read  (2048 Bytes): samples=0
> ./sdb/poll_stat:write (2048 Bytes): samples=0
> ./sdb/poll_stat:read  (4096 Bytes): samples=0
> ./sdb/poll_stat:write (4096 Bytes): samples=0
> ./sdb/poll_stat:read  (8192 Bytes): samples=0
> ./sdb/poll_stat:write (8192 Bytes): samples=0
> ./sdb/poll_stat:read  (16384 Bytes): samples=0
> ./sdb/poll_stat:write (16384 Bytes): samples=0
> ./sdb/poll_stat:read  (32768 Bytes): samples=0
> ./sdb/poll_stat:write (32768 Bytes): samples=0
> ./sdb/poll_stat:read  (65536 Bytes): samples=0
> ./sdb/poll_stat:write (65536 Bytes): samples=0
> ./sda/hctx0/cpu3/completed:46 3
> ./sda/hctx0/cpu3/merged:0
> ./sda/hctx0/cpu3/dispatched:46 3
> ./sda/hctx0/cpu2/completed:41 27
> ./sda/hctx0/cpu2/merged:0
> ./sda/hctx0/cpu2/dispatched:41 27
> ./sda/hctx0/cpu1/completed:2 8
> ./sda/hctx0/cpu1/merged:0
> ./sda/hctx0/cpu1/dispatched:2 8
> ./sda/hctx0/cpu0/completed:1 43
> ./sda/hctx0/cpu0/merged:0
> ./sda/hctx0/cpu0/dispatched:1 43
> ./sda/hctx0/active:0
> ./sda/hctx0/run:144
> ./sda/hctx0/queued:171
> ./sda/hctx0/dispatched:       0	0
> ./sda/hctx0/dispatched:       1	171
> ./sda/hctx0/dispatched:       2	0
> ./sda/hctx0/dispatched:       4	0
> ./sda/hctx0/dispatched:       8	0
> ./sda/hctx0/dispatched:      16	0
> ./sda/hctx0/dispatched:      32+	0
> ./sda/hctx0/io_poll:considered=0
> ./sda/hctx0/io_poll:invoked=0
> ./sda/hctx0/io_poll:success=0
> ./sda/hctx0/tags_bitmap:00000000: 0000 0000 0000 0000 0000 0000 0000 0000
> ./sda/hctx0/tags:nr_tags=128
> ./sda/hctx0/tags:nr_reserved_tags=0
> ./sda/hctx0/tags:active_queues=0
> ./sda/hctx0/tags:
> ./sda/hctx0/tags:bitmap_tags:
> ./sda/hctx0/tags:depth=128
> ./sda/hctx0/tags:busy=0
> ./sda/hctx0/tags:bits_per_word=32
> ./sda/hctx0/tags:map_nr=4
> ./sda/hctx0/tags:alloc_hint={111, 80, 44, 68}
> ./sda/hctx0/tags:wake_batch=8
> ./sda/hctx0/tags:wake_index=0
> ./sda/hctx0/tags:ws={
> ./sda/hctx0/tags:	{.wait_cnt=8, .wait=inactive},
> ./sda/hctx0/tags:	{.wait_cnt=8, .wait=inactive},
> ./sda/hctx0/tags:	{.wait_cnt=8, .wait=inactive},
> ./sda/hctx0/tags:	{.wait_cnt=8, .wait=inactive},
> ./sda/hctx0/tags:	{.wait_cnt=8, .wait=inactive},
> ./sda/hctx0/tags:	{.wait_cnt=8, .wait=inactive},
> ./sda/hctx0/tags:	{.wait_cnt=8, .wait=inactive},
> ./sda/hctx0/tags:	{.wait_cnt=8, .wait=inactive},
> ./sda/hctx0/tags:}
> ./sda/hctx0/tags:round_robin=0
> ./sda/hctx0/ctx_map:00000000: 00
> ./sda/hctx0/flags:alloc_policy=FIFO SHOULD_MERGE|SG_MERGE
> ./sda/hctx0/state:
> ./sda/write_hints:hint0: 0
> ./sda/write_hints:hint1: 0
> ./sda/write_hints:hint2: 0
> ./sda/write_hints:hint3: 0
> ./sda/write_hints:hint4: 0
> ./sda/state:SAME_COMP|IO_STAT|DISCARD|INIT_DONE|POLL|WC|REGISTERED|SCSI_PASSTHROUGH
> ./sda/poll_stat:read  (512 Bytes): samples=0
> ./sda/poll_stat:write (512 Bytes): samples=0
> ./sda/poll_stat:read  (1024 Bytes): samples=0
> ./sda/poll_stat:write (1024 Bytes): samples=0
> ./sda/poll_stat:read  (2048 Bytes): samples=0
> ./sda/poll_stat:write (2048 Bytes): samples=0
> ./sda/poll_stat:read  (4096 Bytes): samples=0
> ./sda/poll_stat:write (4096 Bytes): samples=0
> ./sda/poll_stat:read  (8192 Bytes): samples=0
> ./sda/poll_stat:write (8192 Bytes): samples=0
> ./sda/poll_stat:read  (16384 Bytes): samples=0
> ./sda/poll_stat:write (16384 Bytes): samples=0
> ./sda/poll_stat:read  (32768 Bytes): samples=0
> ./sda/poll_stat:write (32768 Bytes): samples=0
> ./sda/poll_stat:read  (65536 Bytes): samples=0
> ./sda/poll_stat:write (65536 Bytes): samples=0
> ./vda/hctx0/cpu3/completed:1707 27
> ./vda/hctx0/cpu3/merged:0
> ./vda/hctx0/cpu3/dispatched:1707 27
> ./vda/hctx0/cpu2/completed:1027 12
> ./vda/hctx0/cpu2/merged:0
> ./vda/hctx0/cpu2/dispatched:1027 12
> ./vda/hctx0/cpu1/completed:1138 76
> ./vda/hctx0/cpu1/merged:4
> ./vda/hctx0/cpu1/dispatched:1138 76
> ./vda/hctx0/cpu0/completed:2497 44
> ./vda/hctx0/cpu0/merged:2
> ./vda/hctx0/cpu0/dispatched:2497 44
> ./vda/hctx0/active:0
> ./vda/hctx0/run:6412
> ./vda/hctx0/queued:6528
> ./vda/hctx0/dispatched:       0	0
> ./vda/hctx0/dispatched:       1	6361
> ./vda/hctx0/dispatched:       2	20
> ./vda/hctx0/dispatched:       4	13
> ./vda/hctx0/dispatched:       8	8
> ./vda/hctx0/dispatched:      16	8
> ./vda/hctx0/dispatched:      32+	0
> ./vda/hctx0/io_poll:considered=0
> ./vda/hctx0/io_poll:invoked=0
> ./vda/hctx0/io_poll:success=0
> ./vda/hctx0/tags_bitmap:00000000: 0000 0000 0000 0000 0000 0000 0000 0000
> ./vda/hctx0/tags:nr_tags=128
> ./vda/hctx0/tags:nr_reserved_tags=0
> ./vda/hctx0/tags:active_queues=0
> ./vda/hctx0/tags:
> ./vda/hctx0/tags:bitmap_tags:
> ./vda/hctx0/tags:depth=128
> ./vda/hctx0/tags:busy=0
> ./vda/hctx0/tags:bits_per_word=32
> ./vda/hctx0/tags:map_nr=4
> ./vda/hctx0/tags:alloc_hint={28, 24, 114, 37}
> ./vda/hctx0/tags:wake_batch=8
> ./vda/hctx0/tags:wake_index=0
> ./vda/hctx0/tags:ws={
> ./vda/hctx0/tags:	{.wait_cnt=8, .wait=inactive},
> ./vda/hctx0/tags:	{.wait_cnt=8, .wait=inactive},
> ./vda/hctx0/tags:	{.wait_cnt=8, .wait=inactive},
> ./vda/hctx0/tags:	{.wait_cnt=8, .wait=inactive},
> ./vda/hctx0/tags:	{.wait_cnt=8, .wait=inactive},
> ./vda/hctx0/tags:	{.wait_cnt=8, .wait=inactive},
> ./vda/hctx0/tags:	{.wait_cnt=8, .wait=inactive},
> ./vda/hctx0/tags:	{.wait_cnt=8, .wait=inactive},
> ./vda/hctx0/tags:}
> ./vda/hctx0/tags:round_robin=0
> ./vda/hctx0/ctx_map:00000000: 00
> ./vda/hctx0/flags:alloc_policy=FIFO SHOULD_MERGE
> ./vda/hctx0/state:
> ./vda/write_hints:hint0: 0
> ./vda/write_hints:hint1: 0
> ./vda/write_hints:hint2: 0
> ./vda/write_hints:hint3: 0
> ./vda/write_hints:hint4: 0
> ./vda/state:SAME_COMP|IO_STAT|INIT_DONE|NO_SG_MERGE|POLL|WC|REGISTERED
> ./vda/poll_stat:read  (512 Bytes): samples=0
> ./vda/poll_stat:write (512 Bytes): samples=0
> ./vda/poll_stat:read  (1024 Bytes): samples=0
> ./vda/poll_stat:write (1024 Bytes): samples=0
> ./vda/poll_stat:read  (2048 Bytes): samples=0
> ./vda/poll_stat:write (2048 Bytes): samples=0
> ./vda/poll_stat:read  (4096 Bytes): samples=0
> ./vda/poll_stat:write (4096 Bytes): samples=0
> ./vda/poll_stat:read  (8192 Bytes): samples=0
> ./vda/poll_stat:write (8192 Bytes): samples=0
> ./vda/poll_stat:read  (16384 Bytes): samples=0
> ./vda/poll_stat:write (16384 Bytes): samples=0
> ./vda/poll_stat:read  (32768 Bytes): samples=0
> ./vda/poll_stat:write (32768 Bytes): samples=0
> ./vda/poll_stat:read  (65536 Bytes): samples=0
> ./vda/poll_stat:write (65536 Bytes): samples=0
> ./sr0/hctx0/cpu3/completed:0 22
> ./sr0/hctx0/cpu3/merged:0
> ./sr0/hctx0/cpu3/dispatched:0 22
> ./sr0/hctx0/cpu2/completed:46 107
> ./sr0/hctx0/cpu2/merged:0
> ./sr0/hctx0/cpu2/dispatched:46 107
> ./sr0/hctx0/cpu1/completed:0 10
> ./sr0/hctx0/cpu1/merged:0
> ./sr0/hctx0/cpu1/dispatched:0 10
> ./sr0/hctx0/cpu0/completed:0 18
> ./sr0/hctx0/cpu0/merged:0
> ./sr0/hctx0/cpu0/dispatched:0 18
> ./sr0/hctx0/active:0
> ./sr0/hctx0/run:203
> ./sr0/hctx0/queued:203
> ./sr0/hctx0/dispatched:       0	0
> ./sr0/hctx0/dispatched:       1	203
> ./sr0/hctx0/dispatched:       2	0
> ./sr0/hctx0/dispatched:       4	0
> ./sr0/hctx0/dispatched:       8	0
> ./sr0/hctx0/dispatched:      16	0
> ./sr0/hctx0/dispatched:      32+	0
> ./sr0/hctx0/io_poll:considered=0
> ./sr0/hctx0/io_poll:invoked=0
> ./sr0/hctx0/io_poll:success=0
> ./sr0/hctx0/tags_bitmap:00000000: 00
> ./sr0/hctx0/tags:nr_tags=1
> ./sr0/hctx0/tags:nr_reserved_tags=0
> ./sr0/hctx0/tags:active_queues=0
> ./sr0/hctx0/tags:
> ./sr0/hctx0/tags:bitmap_tags:
> ./sr0/hctx0/tags:depth=1
> ./sr0/hctx0/tags:busy=0
> ./sr0/hctx0/tags:bits_per_word=64
> ./sr0/hctx0/tags:map_nr=1
> ./sr0/hctx0/tags:alloc_hint={0, 0, 0, 0}
> ./sr0/hctx0/tags:wake_batch=1
> ./sr0/hctx0/tags:wake_index=7
> ./sr0/hctx0/tags:ws={
> ./sr0/hctx0/tags:	{.wait_cnt=1, .wait=inactive},
> ./sr0/hctx0/tags:	{.wait_cnt=1, .wait=inactive},
> ./sr0/hctx0/tags:	{.wait_cnt=1, .wait=inactive},
> ./sr0/hctx0/tags:	{.wait_cnt=1, .wait=inactive},
> ./sr0/hctx0/tags:	{.wait_cnt=1, .wait=inactive},
> ./sr0/hctx0/tags:	{.wait_cnt=1, .wait=inactive},
> ./sr0/hctx0/tags:	{.wait_cnt=1, .wait=inactive},
> ./sr0/hctx0/tags:	{.wait_cnt=1, .wait=inactive},
> ./sr0/hctx0/tags:}
> ./sr0/hctx0/tags:round_robin=1
> ./sr0/hctx0/ctx_map:00000000: 00
> ./sr0/hctx0/flags:alloc_policy=RR SHOULD_MERGE|SG_MERGE
> ./sr0/hctx0/state:
> ./sr0/write_hints:hint0: 0
> ./sr0/write_hints:hint1: 0
> ./sr0/write_hints:hint2: 0
> ./sr0/write_hints:hint3: 0
> ./sr0/write_hints:hint4: 0
> ./sr0/state:SAME_COMP|IO_STAT|INIT_DONE|POLL|FLUSH_NQ|REGISTERED|SCSI_PASSTHROUGH
> ./sr0/poll_stat:read  (512 Bytes): samples=0
> ./sr0/poll_stat:write (512 Bytes): samples=0
> ./sr0/poll_stat:read  (1024 Bytes): samples=0
> ./sr0/poll_stat:write (1024 Bytes): samples=0
> ./sr0/poll_stat:read  (2048 Bytes): samples=0
> ./sr0/poll_stat:write (2048 Bytes): samples=0
> ./sr0/poll_stat:read  (4096 Bytes): samples=0
> ./sr0/poll_stat:write (4096 Bytes): samples=0
> ./sr0/poll_stat:read  (8192 Bytes): samples=0
> ./sr0/poll_stat:write (8192 Bytes): samples=0
> ./sr0/poll_stat:read  (16384 Bytes): samples=0
> ./sr0/poll_stat:write (16384 Bytes): samples=0
> ./sr0/poll_stat:read  (32768 Bytes): samples=0
> ./sr0/poll_stat:write (32768 Bytes): samples=0
> ./sr0/poll_stat:read  (65536 Bytes): samples=0
> ./sr0/poll_stat:write (65536 Bytes): samples=0
