From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 2/3] block: switch to per-cpu in-flight
	counters
Date: Fri, 30 Nov 2018 14:52:16 -0700
Message-ID: <2a7c33ef-0bd0-d901-6a11-cffca1751b9e@kernel.dk>
References: <20181128004250.325095242@debian.vm>
	<20181130214433.GA15049@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20181130214433.GA15049@redhat.com>
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
To: Mike Snitzer <snitzer@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>
Cc: linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, dm-devel@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

On 11/30/18 2:44 PM, Mike Snitzer wrote:
> On Tue, Nov 27 2018 at  7:42pm -0500,
> Mikulas Patocka <mpatocka@redhat.com> wrote:
> 
>> Now when part_round_stats is gone, we can switch to per-cpu in-flight
>> counters.
>>
>> We use the local-atomic type local_t, so that if part_inc_in_flight or
>> part_dec_in_flight is reentrantly called from an interrupt, the value will
>> be correct.
>>
>> The other counters could be corrupted due to reentrant interrupt, but the
>> corruption only results in slight counter skew - the in_flight counter
>> must be exact, so it needs local_t.
>>
>> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
>>
>> ---
>>  block/bio.c           |    4 ++--
>>  block/blk-core.c      |    4 ++--
>>  block/blk-merge.c     |    2 +-
>>  block/genhd.c         |   47 +++++++++++++++++++++++++++++++++++------------
>>  drivers/md/dm.c       |    4 +---
>>  include/linux/genhd.h |    7 ++++---
>>  6 files changed, 45 insertions(+), 23 deletions(-)
>>
>> Index: linux-block/block/genhd.c
>> ===================================================================
>> --- linux-block.orig/block/genhd.c	2018-11-28 00:09:59.000000000 +0100
>> +++ linux-block/block/genhd.c	2018-11-28 00:09:59.000000000 +0100
>> @@ -45,53 +45,76 @@ static void disk_add_events(struct gendi
>>  static void disk_del_events(struct gendisk *disk);
>>  static void disk_release_events(struct gendisk *disk);
>>  
>> -void part_inc_in_flight(struct request_queue *q, struct hd_struct *part, int rw)
>> +void part_inc_in_flight(struct request_queue *q, int cpu, struct hd_struct *part, int rw)
>>  {
>>  	if (queue_is_mq(q))
>>  		return;
>>  
>> -	atomic_inc(&part->in_flight[rw]);
>> +	local_inc(per_cpu_ptr(part->dkstats, cpu)->in_flight);
>>  	if (part->partno)
>> -		atomic_inc(&part_to_disk(part)->part0.in_flight[rw]);
>> +		local_inc(per_cpu_ptr(part_to_disk(part)->part0.dkstats, cpu)->in_flight);
>>  }
>>  
>> -void part_dec_in_flight(struct request_queue *q, struct hd_struct *part, int rw)
>> +void part_dec_in_flight(struct request_queue *q, int cpu, struct hd_struct *part, int rw)
>>  {
>>  	if (queue_is_mq(q))
>>  		return;
>>  
>> -	atomic_dec(&part->in_flight[rw]);
>> +	local_dec(per_cpu_ptr(part->dkstats, cpu)->in_flight);
>>  	if (part->partno)
>> -		atomic_dec(&part_to_disk(part)->part0.in_flight[rw]);
>> +		local_dec(per_cpu_ptr(part_to_disk(part)->part0.dkstats, cpu)->in_flight);
>>  }
> 
> 
> The above is wrong, needs this incremental fix:

Should also be using this_cpu_inc/dec instead.

-- 
Jens Axboe
