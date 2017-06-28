From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 1/1] block: Convert hd_struct in_flight from atomic to
 percpu
Date: Wed, 28 Jun 2017 15:59:46 -0600
Message-ID: <1ad262f4-2aa9-1127-3246-ce5ce80e9f4f@kernel.dk>
References: <20170628211010.4C8C9124035@b01ledav002.gho.pok.ibm.com>
 <9360a4b6-71be-6486-27f0-483180184905@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <9360a4b6-71be-6486-27f0-483180184905@kernel.dk>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>, linux-block@vger.kernel.org
Cc: dm-devel@redhat.com, snitzer@redhat.com, agk@redhat.com
List-Id: dm-devel.ids

On 06/28/2017 03:54 PM, Jens Axboe wrote:
> On 06/28/2017 03:12 PM, Brian King wrote:
>> -static inline int part_in_flight(struct hd_struct *part)
>> +static inline unsigned long part_in_flight(struct hd_struct *part)
>>  {
>> -	return atomic_read(&part->in_flight[0]) + atomic_read(&part->in_flight[1]);
>> +	return part_stat_read(part, in_flight[0]) + part_stat_read(part, in_flight[1]);
> 
> One obvious improvement would be to not do this twice, but only have to
> loop once. Instead of making this an array, make it a structure with a
> read and write count.
> 
> It still doesn't really fix the issue of someone running on a kernel
> with a ton of possible CPUs configured. But it does reduce the overhead
> by 50%.

Or something as simple as this:

#define part_stat_read_double(part, field1, field2)			\
({									\
	typeof((part)->dkstats->field1) res = 0;			\
	unsigned int _cpu;						\
	for_each_possible_cpu(_cpu) {					\
		res += per_cpu_ptr((part)->dkstats, _cpu)->field1;	\
		res += per_cpu_ptr((part)->dkstats, _cpu)->field2;	\
	}								\
	res;								\
})

static inline unsigned long part_in_flight(struct hd_struct *part)
{
	return part_stat_read_double(part, in_flight[0], in_flight[1]);
}

-- 
Jens Axboe
