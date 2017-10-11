From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: md: rename some drivers/md/ files to have an "md-" prefix
Date: Tue, 10 Oct 2017 20:01:02 -0400
Message-ID: <20171011000102.GB15061@redhat.com>
References: <20171010210241.2332-1-snitzer@redhat.com>
 <1507670992.2815.59.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1507670992.2815.59.camel@wdc.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "shli@kernel.org" <shli@kernel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Tue, Oct 10 2017 at  5:29pm -0400,
Bart Van Assche <Bart.VanAssche@wdc.com> wrote:

> On Tue, 2017-10-10 at 17:02 -0400, Mike Snitzer wrote:
> > Motivated by the desire to illiminate the imprecise nature of
> > DM-specific patches being unnecessarily sent to both the MD maintainer
> > and mailing-list.  Which is born out of the fact that DM files also
> > reside in drivers/md/
> > 
> > Now all MD-specific files in drivers/md/ start with either "raid" or
> > "md-" and the MAINTAINERS file has been updated accordingly.
> 
> Hello Mike,
> 
> Although this patch looks fine to me: has it been considered to move the
> device mapper files into a new subdirectory, e.g. drivers/dm?

I did think about it briefly.  But there is some sharing between DM and
MD (due to dm-raid.c) -- so I figured it easiest to leave well enough
alone.

This patch will be perfectly fine so long as we just add the appropriate
prefixes to new DM and MD source files.

Mike
