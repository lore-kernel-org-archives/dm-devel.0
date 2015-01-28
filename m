From: Jens Axboe <axboe@kernel.dk>
Subject: Re: blk-mq DM changes for 3.20 [was: Re: blk-mq request
 allocation stalls]
Date: Wed, 28 Jan 2015 09:42:26 -0700
Message-ID: <54C91172.10002@kernel.dk>
References: <54B3EB4A.9090404@kernel.dk> <54B3F255.5080802@sandisk.com>
	<54B3F78D.2020704@kernel.dk> <54B3FE89.200@sandisk.com>
	<54B3FFAE.4070609@kernel.dk>
	<alpine.LNX.2.00.1501121738000.4026@localhost.lm.intel.com>
	<54B40E8A.6010005@kernel.dk>
	<alpine.LNX.2.00.1501121818510.4026@localhost.lm.intel.com>
	<alpine.LNX.2.00.1501121830010.4026@localhost.lm.intel.com>
	<54B532EE.20700@kernel.dk> <20150127184258.GB2078@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20150127184258.GB2078@redhat.com>
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

On 01/27/2015 11:42 AM, Mike Snitzer wrote:
> Hey Jens,
>
> I _think_ we've resolved the issues Bart raised for request-based DM's
> support for blk-mq devices (anything remaining seems specific to iSER's
> blk-mq support which is in development).  Though Keith did have that one
> additional patch for that block scatter gather attribute that we still
> need to review closer.
>
> Anyway, I think what we have is a solid start and see no reason to hold
> these changes back further.  So I've rebased the 'dm-for-3.20' branch of
> linux-dm.git ontop of 3.19-rc6 and reordered the required block changes
> to be at the front of the series, see:
> https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/log/?h=dm-for-3.20
>
> (these changes have been in Linux next for a month, via linux-dm.git
> 'for-next')
>
> With your OK, I'd be happy to carry the required block changes and
> ultimately request Linus pull them for 3.20 (I can backfill your Acks if
> you approve).  BUT I also have no problem with you picking up the block
> changes to submit via your block tree (I'd just have to rebase ontop of
> your 3.20 branch once you pull them in).

I'd prefer to take these prep patches through the block tree. Only one I 
don't really like is this one:

https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-for-3.20&id=23556c2461407495099d1eb20b0de43432dc727d

I prefer keeping the alloc path as lean as possible, normal allocs 
always initialize ->bio since they need to associate a bio with it. Do
you have the oops trace from this one? Just curious if we can get rid of 
it, depending on how deep in the caller this is.

-- 
Jens Axboe
