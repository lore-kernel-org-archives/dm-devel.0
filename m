From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [RFC PATCH] dm: fix excessive dm-mq context switching
Date: Sun, 7 Feb 2016 11:53:40 -0500
Message-ID: <20160207165340.GA6298@redhat.com>
References: <20160203180406.GA11591@redhat.com>
	<20160203182423.GA12913@redhat.com> <56B2F5BC.1010700@suse.de>
	<20160204135420.GA18227@redhat.com>
	<20160205151334.GA82754@redhat.com>
	<20160205180515.GA25808@redhat.com>
	<20160205191909.GA25982@redhat.com>
	<56B7659C.8040601@dev.mellanox.co.il>
	<56B772D6.2090403@sandisk.com>
	<56B77444.3030106@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <56B77444.3030106@dev.mellanox.co.il>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Sagi Grimberg <sagig@dev.mellanox.co.il>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "keith.busch@intel.com" <keith.busch@intel.com>, device-mapper development <dm-devel@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Bart Van Assche <bart.vanassche@sandisk.com>
List-Id: dm-devel.ids

On Sun, Feb 07 2016 at 11:43am -0500,
Sagi Grimberg <sagig@dev.mellanox.co.il> wrote:

> 
> >Hello Sagi,
> 
> Hey Bart,
> 
> >Did you run your test on a NUMA system ?
> 
> I did.
> 
> >If so, can you check with e.g.
> >perf record -ags -e LLC-load-misses sleep 10 && perf report whether this
> >workload triggers perhaps lock contention ? What you need to look for in
> >the perf output is whether any functions occupy more than 10% CPU time.
> 
> I will, thanks for the tip!

Also, I found ftrace's function_graph tracer very helpful (it is how I
found the various issues fixed by the first context switch patch).  Here
is my latest script:

#!/bin/sh

set -xv

NULL_BLK_HW_QUEUES=4
NULL_BLK_QUEUE_DEPTH=4096

DM_MQ_HW_QUEUES=4
DM_MQ_QUEUE_DEPTH=2048

FIO=/root/snitm/git/fio/fio
FIO_QUEUE_DEPTH=32
FIO_RUNTIME=10
FIO_NUMJOBS=12

PERF=perf
#PERF=/root/snitm/git/linux/tools/perf/perf

run_fio() {
    DEVICE=$1
    TASK_NAME=$(basename ${DEVICE})
    PERF_RECORD=$2
    RUN_CMD="${FIO} --cpus_allowed_policy=split --group_reporting --rw=randread --bs=4k --numjobs=${FIO_NUMJOBS} \
              --iodepth=${FIO_QUEUE_DEPTH} --runtime=${FIO_RUNTIME} --time_based --loops=1 --ioengine=libaio \
              --direct=1 --invalidate=1 --randrepeat=1 --norandommap --exitall --name task_${TASK_NAME} --filename=${DEVICE}"

    if [ ! -z "${PERF_RECORD}" ]; then
    ${PERF_RECORD} ${RUN_CMD}
    mv perf.data perf.data.${TASK_NAME}
    else
    ${RUN_CMD}
    fi
}

run_fio_with_ftrace() {
    DEVICE=$1
    TASK_NAME=$(basename ${DEVICE})

    echo > /sys/kernel/debug/tracing/trace
    echo 0 > /sys/kernel/debug/tracing/tracing_on
    echo function_graph > /sys/kernel/debug/tracing/current_tracer
    echo 1 > /sys/kernel/debug/tracing/tracing_on
    run_fio $DEVICE
    echo 0 > /sys/kernel/debug/tracing/tracing_on
    cat /sys/kernel/debug/tracing/trace > trace.${TASK_NAME}
    echo nop > /sys/kernel/debug/tracing/current_tracer
}

dmsetup remove dm_mq
modprobe -r null_blk

modprobe null_blk gb=4 bs=512 hw_queue_depth=${NULL_BLK_QUEUE_DEPTH} nr_devices=1 queue_mode=2 irqmode=1 completion_nsec=1 submit_queues=${NULL_BLK_HW_QUEUES}
#run_fio /dev/nullb0 "${PERF} record -ag -e cs"
#run_fio /dev/nullb0 "${PERF} stat"

echo Y > /sys/module/dm_mod/parameters/use_blk_mq
echo ${DM_MQ_QUEUE_DEPTH} > /sys/module/dm_mod/parameters/blk_mq_queue_depth
echo ${DM_MQ_HW_QUEUES} > /sys/module/dm_mod/parameters/blk_mq_nr_hw_queues
echo "0 8388608 multipath 0 0 1 1 service-time 0 1 2 /dev/nullb0 1000 1" | dmsetup create dm_mq
#echo "0 8388608 linear /dev/nullb0 0" | dmsetup create dm_mq

run_fio_with_ftrace /dev/mapper/dm_mq

#run_fio /dev/mapper/dm_mq
#run_fio /dev/mapper/dm_mq "${PERF} record -ag -e cs"
#run_fio /dev/mapper/dm_mq "${PERF} record -ag"
#run_fio /dev/mapper/dm_mq "${PERF} stat"

#run_fio /dev/mapper/dm_mq "trace-cmd record -e all"
