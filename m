From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] block: factor out bio_check_eod()
Date: Wed, 18 Jul 2007 13:45:58 +0200
Message-ID: <20070718114558.GR11657@kernel.dk>
References: <18010.12472.209452.148229@notabene.brown> <20070530093503.GA15559@kernel.dk> <20070718105655.GB22374@htj.dyndns.org> <20070718105946.GC22374@htj.dyndns.org> <20070718110619.GM11657@kernel.dk> <469DF700.4030806@gmail.com> <20070718113103.GO11657@kernel.dk> <469DFA75.6070205@gmail.com> <20070718113450.GP11657@kernel.dk> <469DFC61.2070301@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <469DFC61.2070301@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: Neil Brown <neilb@suse.de>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, David Chinner <dgc@sgi.com>, Phillip Susi <psusi@cfl.rr.com>, Stefan Bader <Stefan.Bader@de.ibm.com>, Andreas Dilger <adilger@clusterfs.com>
List-Id: dm-devel.ids

On Wed, Jul 18 2007, Tejun Heo wrote:
> Jens Axboe wrote:
> > On Wed, Jul 18 2007, Tejun Heo wrote:
> >> Jens Axboe wrote:
> >>> On Wed, Jul 18 2007, Tejun Heo wrote:
> >>>> Jens Axboe wrote:
> >>>>> On Wed, Jul 18 2007, Tejun Heo wrote:
> >>>>>> End of device check is done twice in __generic_make_request() and it's
> >>>>>> fully inlined each time.  Factor out bio_check_eod().
> >>>>> Tejun, yeah I should seperate the cleanups and put them in the upstream
> >>>>> branch. Will do so and add your signed-off to both of them.
> >>>>>
> >>>> Would they be different from the one I just posted?  No big deal either
> >>>> way.  I'm just basing the zero-length barrier on top of these patches.
> >>>> Oh well, the changes are trivial anyway.
> >>> This one ended up being the same, but in the first one you missed some
> >>> of the cleanups. I ended up splitting the patch some more though, see
> >>> the series:
> >>>
> >>> http://git.kernel.dk/?p=linux-2.6-block.git;a=shortlog;h=barrier
> >> Alright, will base on 662d5c5e6afb79d05db5563205b809c0de530286.  Thanks.
> > 
> > 1781c6a39fb6e31836557618c4505f5f7bc61605, no? Unless you want to rewrite
> > it completely :-)
> 
> I think I'll start from 662d5c5e and steal most parts from 1781c6a3.  I
> like stealing, you know. :-) I think 1781c6a3 also can use splitting -
> zero length barrier implementation and issue_flush conversion.

Yes that's true, I could split that in two as well. Will do so!

> Anyways, how do I pull from git.kernel.dk?
> git://git.kernel.dk/linux-2.6-block.git gives me connection reset by server.

git://git.kernel.dk/data/git/linux-2.6-block.git

somewhat annoying, I'll see if I can prefix it with git-daemon in the
future.

-- 
Jens Axboe

