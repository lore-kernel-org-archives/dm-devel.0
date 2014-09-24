From: Brassow Jonathan <jbrassow@redhat.com>
Subject: Re: [PATCH] dm-raid: add RAID discard support
Date: Tue, 23 Sep 2014 23:05:51 -0500
Message-ID: <7C39EB56-623A-4318-A558-258ABA32FF12@redhat.com>
References: <1411491106-23676-1-git-send-email-heinzm@redhat.com>
	<yq18ulaszpk.fsf@sermon.lab.mkp.net>
	<20140924093308.120fe616@notabene.brown>
	<yq1zjdpsqry.fsf@sermon.lab.mkp.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <yq1zjdpsqry.fsf@sermon.lab.mkp.net>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Heinz Mauelshagen <heinzm@redhat.com>, Shaohua Li <shli@kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: dm-devel.ids


On Sep 23, 2014, at 9:20 PM, Martin K. Petersen wrote:

>>>>>> "Neil" == NeilBrown  <neilb@suse.de> writes:
> 
> Neil,
> 
> Several people have pointed out the issues with the reliability of
> discard_zeroes_data in the past. My objection with Heinz' patch is
> purely that we are perpetuating an interface that we have come to learn
> that we can't entirely trust.
> 
> Neil> If it is a "hint", then why isn't it
> Neil> "discard_sometimes_zeroes_data"?
> 
> Because at the time we put it in it was expected to be a solid
> guarantee. However, as it turns out the spec is vaguely worded and only
> says that the device must return zeroes if a block has been successfully
> discarded. But since discard itself is only a hint the device is free to
> silently ignore all or parts of the request. *sigh*
> 
> There were several approaches being entertained in both T10 and T13
> about how to tighten this up, including a FORCE bit that would cause the
> device to return an error if parts of the request were being ignored. I
> was hoping that we would be able to use that. However, the consensus at
> the T10 meeting this summer was that WRITE SAME is the only reliable way
> to ensure that zeroed blocks are returned. And the spec was amended to
> clarify that.
> 
> Neil> If a read from a discarded region doesn't reliably return zeros,
> Neil> then raid5 cannot support discard.  Should I turn of discard
> Neil> support in raid5?
> 
> I've been on the fence about this for a while.
> 
> The good news is that while the spec has been vague and many battles
> fought in the standards bodies, most vendors are reasonably sane when it
> comes to implementing this. We haven't had any corruption horror stories
> from the field that I'm aware of. The first couple of generations of
> SSDs were a travesty in this department but current devices behave
> reasonably well. Hardware RAID vendors generally solve the RAID5 SSD
> problem by explicitly whitelisting drives that are known to do the right
> thing. Sadly we don't have a good device list. And for most drives the
> discards only get dropped in rare corner cases so it's not trivial to
> write a test tool to generate such a list.
> 
> I was really hoping we'd get better guarantees from the standards folks
> this summer. But as the spec is currently written switching to a WRITE
> SAME bias in our discard heuristics may have the opposite effect of what
> we desire. That's because the spec mandates that if a device can not
> discard the blocks in the request it must write zeroes to them. IOW, we
> get the determinism at the expense of potentially ending up writing the
> blocks in question, thus increasing write wear. Probably not what we
> want for the discard use case.
> 
> I am in the process of tweaking the discard code to adhere to the August
> 27th T10 SBC-4 draft. The net takeaway is that if you depend on reading
> zeroes back you should be using blkdev_issue_zeroout() and not
> blkdev_issue_discard(). raid5.c effectively needs to translate discard
> requests from above to zeroouts below.
> 
> I am torn between making blkdev_issue_zeroout() unprovision if possible
> or having an explicit allocate flag. Some users only care about getting
> zeroes back but others use blkdev_issue_zeroout() to preallocate blocks
> (which is the current behavior).
> 
> Right now we have:
> 
>  discard		Unprovision, may or may not return zeroes
>  zeroout		Provision, return zeroes
> 
> We'll have to move to a model where we have a third variant:
> 
>  discard		Unprovision, may or may not return zeroes
>  zeroout, deallocate	Unprovision if possible, return zeroes
>  zeroout, allocate     Provision, return zeroes
> 
> The zeroout, deallocate variant would be enabled if the device supports
> WRITE SAME w/UNMAP and has the LBPRZ flag set (and is not our libata
> SATL).
> 
> Discard is the bane of my existence :(

It's not really so bad if it doesn't return zero's, is it?  As long as it returns the previous contents.  You mentioned that the discard was a hint - the drive may or may not discard the entire portion.  If that means the portions that are discarded will always return zero and the portions that aren't will always return their previous contents, is there any problem?  The real issue is randomness, no?  Could this be why "we haven't had any corruption horror stories", or is it because we got lucky with sane vendors?

 brassow
