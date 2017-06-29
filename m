From: Ming Lei <tom.leiming@gmail.com>
Subject: Re: [PATCH 1/1] block: Convert hd_struct in_flight from atomic to percpu
Date: Thu, 29 Jun 2017 16:40:23 +0800
Message-ID: <CACVXFVMG=gD1Dq2SRKxhfPS33mzCC_dkSpVoYskaLE7PXV7xGQ@mail.gmail.com>
References: <20170628211010.4C8C9124035@b01ledav002.gho.pok.ibm.com> <c91629be-26db-96bb-9a55-18a6861888b2@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <c91629be-26db-96bb-9a55-18a6861888b2@kernel.dk>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Brian King <brking@linux.vnet.ibm.com>, linux-block <linux-block@vger.kernel.org>, "open list:DEVICE-MAPPER (LVM)" <dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Thu, Jun 29, 2017 at 5:49 AM, Jens Axboe <axboe@kernel.dk> wrote:
> On 06/28/2017 03:12 PM, Brian King wrote:
>> This patch converts the in_flight counter in struct hd_struct from a
>> pair of atomics to a pair of percpu counters. This eliminates a couple
>> of atomics from the hot path. When running this on a Power system, to
>> a single null_blk device with 80 submission queues, irq mode 0, with
>> 80 fio jobs, I saw IOPs go from 1.5M IO/s to 11.4 IO/s.
>
> This has been done before, but I've never really liked it. The reason is
> that it means that reading the part stat inflight count now has to
> iterate over every possible CPU. Did you use partitions in your testing?
> How many CPUs were configured? When I last tested this a few years ago
> on even a quad core nehalem (which is notoriously shitty for cross-node
> latencies), it was a net loss.

One year ago, I saw null_blk's IOPS can be decreased to 10%
of non-RQF_IO_STAT on a dual socket ARM64(each CPU has
96 cores, and dual numa nodes) too, the performance can be
recovered basically if per numa-node counter is introduced and
used in this case, but the patch was never posted out.
If anyone is interested in that, I can rebase the patch on current
block tree and post out. I guess the performance issue might be
related with system cache coherency implementation more or less.
This issue on ARM64 can be observed with the following userspace
atomic counting test too:

       http://kernel.ubuntu.com/~ming/test/cache/

>
> I do agree that we should do something about it, and it's one of those
> items I've highlighted in talks about blk-mq on pending issues to fix
> up. It's just not great as it currently stands, but I don't think per
> CPU counters is the right way to fix it, at least not for the inflight
> counter.

Yeah, it won't be a issue for non-mq path, and for blk-mq path,
maybe we can use some blk-mq knowledge(tagset?) to figure out
the 'in_flight' counter. I thought about it before, but never got a perfect
solution, and looks it is a bit hard, :-)


Thanks,
Ming Lei
