From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 1/1] block: Convert hd_struct in_flight from
 atomic to percpu
Date: Wed, 28 Jun 2017 15:54:30 -0600
Message-ID: <9360a4b6-71be-6486-27f0-483180184905@kernel.dk>
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
> -static inline int part_in_flight(struct hd_struct *part)
> +static inline unsigned long part_in_flight(struct hd_struct *part)
>  {
> -	return atomic_read(&part->in_flight[0]) + atomic_read(&part->in_flight[1]);
> +	return part_stat_read(part, in_flight[0]) + part_stat_read(part, in_flight[1]);

One obvious improvement would be to not do this twice, but only have to
loop once. Instead of making this an array, make it a structure with a
read and write count.

It still doesn't really fix the issue of someone running on a kernel
with a ton of possible CPUs configured. But it does reduce the overhead
by 50%.

-- 
Jens Axboe
