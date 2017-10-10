From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: md: rename some drivers/md/ files to have an "md-" prefix
Date: Tue, 10 Oct 2017 19:55:35 -0400
Message-ID: <20171010235535.GA15061@redhat.com>
References: <20171010210241.2332-1-snitzer@redhat.com>
 <20171010212918.fykwmts6y2kfll2i@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171010212918.fykwmts6y2kfll2i@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On Tue, Oct 10 2017 at  5:29pm -0400,
Shaohua Li <shli@kernel.org> wrote:

> On Tue, Oct 10, 2017 at 05:02:41PM -0400, Mike Snitzer wrote:
> > Motivated by the desire to illiminate the imprecise nature of
> > DM-specific patches being unnecessarily sent to both the MD maintainer
> > and mailing-list.  Which is born out of the fact that DM files also
> > reside in drivers/md/
> > 
> > Now all MD-specific files in drivers/md/ start with either "raid" or
> > "md-" and the MAINTAINERS file has been updated accordingly.
> > 
> > Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> 
> Good idea! Assume I take this?

Yes, please do.
