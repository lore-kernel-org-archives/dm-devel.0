From: Brassow Jonathan <jbrassow@redhat.com>
Subject: Re: [PATCH] DM RAID:  Add support for MD RAID10 personality
Date: Tue, 10 Jul 2012 14:27:30 -0500
Message-ID: <5DAA9465-E7B1-4F61-A559-745D653048C2@redhat.com>
References: <1340712231.19015.42.camel@f16> <20120704112159.36cdb42a@notabene.brown> <262AC9F3-56D9-48A8-8A03-32D6B81D4689@redhat.com> <20120704151537.7c91076d@notabene.brown>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120704151537.7c91076d@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: dm-devel@redhat.com, linux-raid@vger.kernel.org, agk@redhat.com
List-Id: dm-devel.ids


On Jul 4, 2012, at 12:15 AM, NeilBrown wrote:

>> 
>> I like your suggestion of changing the parameter names.  I've found the original names somewhat confusing.  ('far_offset' seems to imply to me that the copy would not be the very next stripe, but _offset_ somehow - it seems to have the reverse meaning to me.  I think this comes from the fact that it acts as a modifier to 'far_copy'.)  I toyed with a couple different ways of doing this but figured it was best to just go along.  Anyway, what you are suggesting seems to be:
>> 	raid10_copies <number> (Default: 2)
>> 	raid10_layout <string> (Default: "near"/"adjacent")
>> Where <string> could be "near", "far", "offset" and "some-future-thing".  That seems nice to me and seems to clear up some of the confusion caused by "far_offset" seeming to be a modifier to "far_copies".
> 
> Yes, that is what I'm suggesting.

One problem with this approach is that users can no longer mix and match.  They can't have 2 near copies and 2 far copies, for example.  Perhaps someone might choose this layout for read balancing performance...

The original method didn't allow for two different simultaneous "far" algorithms (because it would add no redundancy unless they were shifted from each other as well as the original), but this new way of specifying makes it worse.

Do you see this as a problem?  If so, we need to find a way to specify the number of copies for each layout /and/ include the potential for "double-shift" vs "single-shift" or some further variant.  One idea I had before was:
	raid10_near_copies <#>
	raid10_far_copies <#>
	raid10_stripe_copies <#>  (similar to far+offset, but still allows for simultaneous "far" w/o "offset")
To allow for the different variants of "shifting", we could have different raid10 variants, like "raid10_2s" or "raid1e_2s" - similar to the extensions on RAID5 ("raid5_ls") that you don't like.  :)

 brassow