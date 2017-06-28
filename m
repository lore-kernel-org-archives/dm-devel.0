From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/1] block: Convert hd_struct in_flight from
 atomic to percpu
Date: Wed, 28 Jun 2017 17:04:24 -0500
Message-ID: <93d463ba-58aa-c830-9319-a0774d364b1e@linux.vnet.ibm.com>
References: <20170628211010.4C8C9124035@b01ledav002.gho.pok.ibm.com>
	<c91629be-26db-96bb-9a55-18a6861888b2@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <c91629be-26db-96bb-9a55-18a6861888b2@kernel.dk>
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
To: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org
Cc: dm-devel@redhat.com, agk@redhat.com, snitzer@redhat.com
List-Id: dm-devel.ids

On 06/28/2017 04:49 PM, Jens Axboe wrote:
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

I did not use partitions. I was running this on a 4 socket Power 8 machine with
5 cores per socket, running with 4 threads per core, so a total of 80
logical CPUs were usable in Linux.

I was missing the fact that part_round_stats_single calls part_in_flight
and had only noticed the sysfs and procfs users of part_in_flight previously.

-Brian

-- 
Brian King
Power Linux I/O
IBM Linux Technology Center
