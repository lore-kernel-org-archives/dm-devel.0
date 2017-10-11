From: Shaohua Li <shli@kernel.org>
Subject: Re: md: rename some drivers/md/ files to have an "md-" prefix
Date: Tue, 10 Oct 2017 18:49:36 -0700
Message-ID: <20171011014936.2fztlbwklk2ivefa@kernel.org>
References: <20171010210241.2332-1-snitzer@redhat.com>
 <20171010212918.fykwmts6y2kfll2i@kernel.org>
 <20171010235535.GA15061@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171010235535.GA15061@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: linux-raid@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On Tue, Oct 10, 2017 at 07:55:35PM -0400, Mike Snitzer wrote:
> On Tue, Oct 10 2017 at  5:29pm -0400,
> Shaohua Li <shli@kernel.org> wrote:
> 
> > On Tue, Oct 10, 2017 at 05:02:41PM -0400, Mike Snitzer wrote:
> > > Motivated by the desire to illiminate the imprecise nature of
> > > DM-specific patches being unnecessarily sent to both the MD maintainer
> > > and mailing-list.  Which is born out of the fact that DM files also
> > > reside in drivers/md/
> > > 
> > > Now all MD-specific files in drivers/md/ start with either "raid" or
> > > "md-" and the MAINTAINERS file has been updated accordingly.
> > > 
> > > Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> > 
> > Good idea! Assume I take this?
> 
> Yes, please do.

Done, thanks!
