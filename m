From: Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH] There's no need to include linux/version.h in
 drivers/md/dm-bufio.c
Date: Fri, 3 Feb 2012 22:38:56 +0100 (CET)
Message-ID: <alpine.LNX.2.00.1202032238380.25026@pobox.suse.cz>
References: <alpine.LNX.2.00.1201152110290.13389@swampdragon.chaosbits.net> <Pine.LNX.4.64.1201151728510.26479@hs20-bc2-1.build.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.1201151728510.26479@hs20-bc2-1.build.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Jesper Juhl <jj@chaosbits.net>, dm-devel@redhat.com, Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Sun, 15 Jan 2012, Mikulas Patocka wrote:

> Acked-by: Mikulas Patocka <mpatocka@redhat.com>
> 
> On Sun, 15 Jan 2012, Jesper Juhl wrote:
> 
> > As 'make versioncheck' points out, drivers/md/dm-bufio.c has no need
> > to include linux/version.h, so this patch removes the unneeded
> > include.
> > 
> > Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> > ---
> >  drivers/md/dm-bufio.c |    1 -
> >  1 files changed, 0 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
> > index 0a6806f..b6e58c7 100644
> > --- a/drivers/md/dm-bufio.c
> > +++ b/drivers/md/dm-bufio.c
> > @@ -12,7 +12,6 @@
> >  #include <linux/dm-io.h>
> >  #include <linux/slab.h>
> >  #include <linux/vmalloc.h>
> > -#include <linux/version.h>
> >  #include <linux/shrinker.h>
> >  #include <linux/module.h>

As this doesn't seem to be present in -next, I am taking it. Thanks,

-- 
Jiri Kosina
SUSE Labs
