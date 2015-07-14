From: Ming Lin <mlin@kernel.org>
Subject: Re: [PATCH v5 00/11] simplify block layer based on immutable biovecs
Date: Tue, 14 Jul 2015 13:51:26 -0700
Message-ID: <1436907086.16756.1.camel@ssi>
References: <1436166674-31362-1-git-send-email-mlin@kernel.org>
	 <1436764355.30675.10.camel@hasee> <20150713153537.GA30898@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150713153537.GA30898@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Kent Overstreet <kent.overstreet@gmail.com>, Dongsu Park <dpark@posteo.net>, NeilBrown <neilb@suse.de>, "Alasdair G. Kergon" <agk@redhat.com>, Jeff Moyer <jmoyer@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Mon, 2015-07-13 at 11:35 -0400, Mike Snitzer wrote:
> On Mon, Jul 13 2015 at  1:12am -0400,
> Ming Lin <mlin@kernel.org> wrote:
> 
> > On Mon, 2015-07-06 at 00:11 -0700, mlin@kernel.org wrote:
> > > Hi Mike,
> > > 
> > > On Wed, 2015-06-10 at 17:46 -0400, Mike Snitzer wrote:
> > > > I've been busy getting DM changes for the 4.2 merge window finalized.
> > > > As such I haven't connected with others on the team to discuss this
> > > > issue.
> > > > 
> > > > I'll see if we can make time in the next 2 days.  But I also have
> > > > RHEL-specific kernel deadlines I'm coming up against.
> > > > 
> > > > Seems late to be staging this extensive a change for 4.2... are you
> > > > pushing for this code to land in the 4.2 merge window?  Or do we have
> > > > time to work this further and target the 4.3 merge?
> > > > 
> > > 
> > > 4.2-rc1 was out.
> > > Would you have time to work together for 4.3 merge? 
> > 
> > Ping ...
> > 
> > What can I do to move forward?
> 
> You can show further testing.  Particularly that you've covered all the
> edge cases.
> 
> Until someone can produce some perf test results where they are actually
> properly controlling for the splitting, we have no useful information.
> 
> The primary concerns associated with this patchset are:
> 1) In the context of RAID, XFS's use of bio_add_page() used to build up
>    optimal IOs when the underlying block device provides striping info
>    via IO limits.  With this patchset how large will bios become in
>    practice _without_ bio_add_page() being bounded by the underlying IO
>    limits?
> 
> 2) The late splitting that occurs for the (presummably) large bios that
>    are sent down.. how does it cope/perform in the face of very
>    low/fragmented system memory?
> 
> 3) More open-ended comment than question: Linux has evolved to perform
>    well on "enterprise" systems.  We generally don't fall off a cliff on 
>    performance like we used to.  The concern associated with this
>    patchset is that if it goes in without _real_ due-diligence on
>    "enterprise" scale systems and workloads it'll be too late once we
>    notice the problem(s).
> 
> So we really need answers to 1 and 2 above in order to feel better about
> the risks associated 3.
> 
> Alasdair's feedback to you on testing still applies (and hasn't been
> done AFAIK):
> https://www.redhat.com/archives/dm-devel/2015-May/msg00203.html
> 
> Particularly:
> "you might need to instrument the kernels to tell you the sizes of the
> bios being created and the amount of splitting actually happening."
> 
> and
> 
> "You may also want to test systems with a restricted amount of available
> memory to show how the splitting via worker thread performs.  (Again,
> instrument to prove the extent to which the new code is being exercised.)"
> 
> > This patchset not only simplify block layer a lot, it's also a
> > prerequisite of the direct IO rewrite patches, which I saw 40%
> > performance improvement for null_blk and 10% improvement for NVMe
> > drives. I have been fixing bugs for the direct IO patches. I'll post it
> > once it passes xfstests.
> > 
> > Mike,
> > Can I have your ACK? Or do you have other test plan?
> 
> I'm not the only person with concerns.  I share Alasdair's concerns.
> Jeff Moyer is also concerned about the implications of this patchset.
> We're all in favor of this patchset's cleanup _if and only if_ it can be
> proven that we aren't going to be falling off a cliff on performance due
> to some pathological workload (be it under memory pressure or whatever).
> 
> Apologies for not being able to put time to this like I hoped.  But that
> doesn't mean you are off the hook on showing you've done the testing and
> understand the scope and implications of the changes you're pushing for.
> 
> I will do additional review to answer 1 and 2 above.  And Jeff Moyer
> told me he'd test the patchset on one of his testbeds.
> 
> But if you can help answer 1 and 2 above that'd go a long way.

Thanks for the response.
I'm working on more testing.

I'll ask if I have question about the testing.

Thanks,
Ming

> 
> Thanks,
> Mike
