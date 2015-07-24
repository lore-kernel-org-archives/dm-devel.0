From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: [PATCH v5 00/11] simplify block layer based on immutable biovecs
Date: Fri, 24 Jul 2015 12:50:25 -0700
Message-ID: <20150724195025.GD1928@kmo-pixel>
References: <1436166674-31362-1-git-send-email-mlin@kernel.org>
 <1436764355.30675.10.camel@hasee>
 <20150713153537.GA30898@redhat.com>
 <1436907086.16756.1.camel@ssi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1436907086.16756.1.camel@ssi>
Sender: linux-kernel-owner@vger.kernel.org
To: Ming Lin <mlin@kernel.org>
Cc: Mike Snitzer <snitzer@redhat.com>, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Dongsu Park <dpark@posteo.net>, NeilBrown <neilb@suse.de>, "Alasdair G. Kergon" <agk@redhat.com>, Jeff Moyer <jmoyer@redhat.com>, dm-devel@redhat.com, bcrl@kvack.org
List-Id: dm-devel.ids

On Tue, Jul 14, 2015 at 01:51:26PM -0700, Ming Lin wrote:
> On Mon, 2015-07-13 at 11:35 -0400, Mike Snitzer wrote:
> > On Mon, Jul 13 2015 at  1:12am -0400,
> > Ming Lin <mlin@kernel.org> wrote:
> > 
> > > On Mon, 2015-07-06 at 00:11 -0700, mlin@kernel.org wrote:
> > > > Hi Mike,
> > > > 
> > > > On Wed, 2015-06-10 at 17:46 -0400, Mike Snitzer wrote:
> > > > > I've been busy getting DM changes for the 4.2 merge window finalized.
> > > > > As such I haven't connected with others on the team to discuss this
> > > > > issue.
> > > > > 
> > > > > I'll see if we can make time in the next 2 days.  But I also have
> > > > > RHEL-specific kernel deadlines I'm coming up against.
> > > > > 
> > > > > Seems late to be staging this extensive a change for 4.2... are you
> > > > > pushing for this code to land in the 4.2 merge window?  Or do we have
> > > > > time to work this further and target the 4.3 merge?
> > > > > 
> > > > 
> > > > 4.2-rc1 was out.
> > > > Would you have time to work together for 4.3 merge? 
> > > 
> > > Ping ...
> > > 
> > > What can I do to move forward?
> > 
> > You can show further testing.  Particularly that you've covered all the
> > edge cases.
> > 
> > Until someone can produce some perf test results where they are actually
> > properly controlling for the splitting, we have no useful information.
> > 
> > The primary concerns associated with this patchset are:
> > 1) In the context of RAID, XFS's use of bio_add_page() used to build up
> >    optimal IOs when the underlying block device provides striping info
> >    via IO limits.  With this patchset how large will bios become in
> >    practice _without_ bio_add_page() being bounded by the underlying IO
> >    limits?

CCing Ben because I know he has a fair amount of experience with performance on
high end arrays

My thought here is that this only matters at all in the context of readahead -
that is, you can think of the splitting issue as being equivalent to wanting to
return partially complete results for IOs, and that's really only useful with
readahead.

But as long as readahead is pipelining (and it should be), and the window is
big enough - I don't think there'll be any issues.

But yeah we should probably have some data to back this up.

> > 2) The late splitting that occurs for the (presummably) large bios that
> >    are sent down.. how does it cope/perform in the face of very
> >    low/fragmented system memory?

It's all backed by mempools, and there's several other memory allocations in the
block IO path (sglists, requests, etc.) - should be a nonissue.

This patch set will help us improve performance on high end devices, by
simplifying the bio_add_page() path and not having it touch request_queue stuff
(which is behind several pointers at that point), and deferring that to the
driver - I saw a nontrivial performance boost awhile back when I converted the
mtip driver to do splitting as needed while it was mapping the sglist.
