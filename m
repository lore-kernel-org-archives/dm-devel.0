From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: linux-next: Tree for Sep 13 (dm-thin-pool)
Date: Thu, 13 Sep 2018 14:51:48 -0400
Message-ID: <20180913185147.GA5647@redhat.com>
References: <20180913152753.60866288@canb.auug.org.au>
 <258e14a1-0dbc-74ff-23a5-cd676fdf4579@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <258e14a1-0dbc-74ff-23a5-cd676fdf4579@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Linux-Next Mailing List <linux-next@vger.kernel.org>, Joe Thornber <dm-devel@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: dm-devel.ids

On Thu, Sep 13 2018 at  1:28pm -0400,
Randy Dunlap <rdunlap@infradead.org> wrote:

> On 9/12/18 10:27 PM, Stephen Rothwell wrote:
> > Hi all,
> > 
> > News: there will be no linux-next releases on Friday or Monday.
> > 
> > Changes since 20180912:
> > 
> 
> on i386:
> 
> ERROR: "__udivdi3" [drivers/md/dm-thin-pool.ko] undefined!

Well, as I pointed out in reply that nobody will see to the buildbots:

There is something off in this report... I cannot reproduce.  It is
almost like the warning was generated when building an older version of
this change, but then reported against the latest commit.

I switched to sector_div() specifically because of the undefined
__udivdi3 error.

So I'm ignoring this given I cannot reproduce when using 'make ARCH=i386'
