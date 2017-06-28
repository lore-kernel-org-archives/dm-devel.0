From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 1/1] block: Convert hd_struct in_flight from
 atomic to percpu
Date: Wed, 28 Jun 2017 15:49:52 -0600
Message-ID: <c91629be-26db-96bb-9a55-18a6861888b2@kernel.dk>
References: <20170628211010.4C8C9124035@b01ledav002.gho.pok.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170628211010.4C8C9124035@b01ledav002.gho.pok.ibm.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Brian King <brking@linux.vnet.ibm.com>, linux-block@vger.kernel.org
Cc: dm-devel@redhat.com, agk@redhat.com, snitzer@redhat.com
List-Id: dm-devel.ids

On 06/28/2017 03:12 PM, Brian King wrote:
> This patch converts the in_flight counter in struct hd_struct from a
> pair of atomics to a pair of percpu counters. This eliminates a couple
> of atomics from the hot path. When running this on a Power system, to
> a single null_blk device with 80 submission queues, irq mode 0, with
> 80 fio jobs, I saw IOPs go from 1.5M IO/s to 11.4 IO/s.

This has been done before, but I've never really liked it. The reason is
that it means that reading the part stat inflight count now has to
iterate over every possible CPU. Did you use partitions in your testing?
How many CPUs were configured? When I last tested this a few years ago
on even a quad core nehalem (which is notoriously shitty for cross-node
latencies), it was a net loss.

I do agree that we should do something about it, and it's one of those
items I've highlighted in talks about blk-mq on pending issues to fix
up. It's just not great as it currently stands, but I don't think per
CPU counters is the right way to fix it, at least not for the inflight
counter.

-- 
Jens Axboe
