From: Milan Broz <mbroz@redhat.com>
Subject: Re: [PATCH 3/7] dm-crypt: avoid deadlock in mempools
Date: Mon, 16 Feb 2015 10:31:05 +0100
Message-ID: <54E1B8D9.3050803@redhat.com>
References: <alpine.LRH.2.02.1502130823540.6449@file01.intranet.prod.int.rdu2.redhat.com>	<20150213211614.GA7180@redhat.com>	<alpine.LRH.2.02.1502131708030.447@file01.intranet.prod.int.rdu2.redhat.com>
	<20150214011445.GA14223@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20150214011445.GA14223@redhat.com>
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
Cc: Ondrej Kozina <okozina@redhat.com>, device-mapper development <dm-devel@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

On 02/14/2015 02:14 AM, Mike Snitzer wrote:
> On Fri, Feb 13 2015 at  5:09P -0500,
> Mikulas Patocka <mpatocka@redhat.com> wrote:
> 
>>
>>
>> On Fri, 13 Feb 2015, Mike Snitzer wrote:
>>
>>>   * In order to not degrade performance with excessive locking, we try
>>> - * non-blocking allocations without a mutex first and if it fails, we fallback
>>> + * non-blocking allocation without a mutex first and if it fails, we fallback
>>>   * to a blocking allocation with a mutex.
>>>   */
>>>  static struct bio *crypt_alloc_buffer(struct dm_crypt_io *io, unsigned size)
>>
>> There are multiple allocations, so I would leave plural there.
> 
> Fixed, and tweaked the headers (already did that last time around so
> nothing new, you just didn't pick up my headers for your v2).  I pushed
> your patchset to linux-next (for 3.21), see:
> https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/log/?h=for-next
> 
> Ondrej and Milan, please let us know if you hit any problems with this
> patchset and/or branch.

Will try to test it soon on some strange configurations :)

Just to be sure - nothing of this patchset is planned for 3.20?

(TBH I would like to see it upstream asap but too late for 3.20 here I guess...)

Thanks,
Milan
