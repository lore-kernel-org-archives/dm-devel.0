From: Jens Axboe <axboe@kernel.dk>
Subject: Re: blk-mq DM changes for 3.20 [was: Re: blk-mq request
 allocation stalls]
Date: Wed, 28 Jan 2015 10:49:27 -0700
Message-ID: <54C92127.4030408@kernel.dk>
References: <54B3F78D.2020704@kernel.dk> <54B3FE89.200@sandisk.com>
	<54B3FFAE.4070609@kernel.dk>
	<alpine.LNX.2.00.1501121738000.4026@localhost.lm.intel.com>
	<54B40E8A.6010005@kernel.dk>
	<alpine.LNX.2.00.1501121818510.4026@localhost.lm.intel.com>
	<alpine.LNX.2.00.1501121830010.4026@localhost.lm.intel.com>
	<54B532EE.20700@kernel.dk> <20150127184258.GB2078@redhat.com>
	<54C91172.10002@kernel.dk> <20150128174442.GA11951@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20150128174442.GA11951@redhat.com>
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
Cc: Keith Busch <keith.busch@intel.com>, Bart Van Assche <bart.vanassche@sandisk.com>, device-mapper development <dm-devel@redhat.com>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Christoph Hellwig <hch@infradead.org>
List-Id: dm-devel.ids

On 01/28/2015 10:44 AM, Mike Snitzer wrote:
> On Wed, Jan 28 2015 at 11:42am -0500,
> Jens Axboe <axboe@kernel.dk> wrote:
>
>> On 01/27/2015 11:42 AM, Mike Snitzer wrote:
>>> Hey Jens,
>>>
>>> I _think_ we've resolved the issues Bart raised for request-based DM's
>>> support for blk-mq devices (anything remaining seems specific to iSER's
>>> blk-mq support which is in development).  Though Keith did have that one
>>> additional patch for that block scatter gather attribute that we still
>>> need to review closer.
>>>
>>> Anyway, I think what we have is a solid start and see no reason to hold
>>> these changes back further.  So I've rebased the 'dm-for-3.20' branch of
>>> linux-dm.git ontop of 3.19-rc6 and reordered the required block changes
>>> to be at the front of the series, see:
>>> https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/log/?h=dm-for-3.20
>>>
>>> (these changes have been in Linux next for a month, via linux-dm.git
>>> 'for-next')
>>>
>>> With your OK, I'd be happy to carry the required block changes and
>>> ultimately request Linus pull them for 3.20 (I can backfill your Acks if
>>> you approve).  BUT I also have no problem with you picking up the block
>>> changes to submit via your block tree (I'd just have to rebase ontop of
>>> your 3.20 branch once you pull them in).
>>
>> I'd prefer to take these prep patches through the block tree.
>
> Great, should I send the patches or can you cherry-pick?

I already cherry picked them, they are in the for-3.20/core branch.

>> Only one I don't really like is this one:
>>
>> https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-for-3.20&id=23556c2461407495099d1eb20b0de43432dc727d
>>
>> I prefer keeping the alloc path as lean as possible, normal allocs
>> always initialize ->bio since they need to associate a bio with it.
>
> Would be very surprised if this initialization were measurable but..

That's what people always say, and then keep piling more crap in...

> I could push this initialization into the DM-mpath driver (just after
> blk_get_request, like Keith opted for) but that seemed really gross.

It's already doing blk_rq_init() now, so not a huge change and not that 
nasty.

-- 
Jens Axboe
