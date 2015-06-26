From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: DM_CACHE_SMQ is experimental and enabled by default? (was: Re:
 dm cache: add stochastic-multi-queue (smq) policy)
Date: Fri, 26 Jun 2015 12:05:50 -0400
Message-ID: <20150626160549.GA15434@redhat.com>
References: <CAMuHMdVfK8x8xXqaq=yX41qZA0L3VP-sezKfDureYMa-QqfM6g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAMuHMdVfK8x8xXqaq=yX41qZA0L3VP-sezKfDureYMa-QqfM6g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Joe Thornber <ejt@redhat.com>, linux-raid@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Fri, Jun 26 2015 at  3:47am -0400,
Geert Uytterhoeven <geert@linux-m68k.org> wrote:

> On Fri, Jun 26, 2015 at 2:13 AM, Linux Kernel Mailing List
> <linux-kernel@vger.kernel.org> wrote:
> > Gitweb:     http://git.kernel.org/linus/;a=commit;h=66a636356647a9be8885c2ce2948de126577698a
> > Commit:     66a636356647a9be8885c2ce2948de126577698a
> > Parent:     40775257b97e27305cf5c2425be7acaa6edee4ea
> > Refname:    refs/heads/master
> > Author:     Joe Thornber <ejt@redhat.com>
> > AuthorDate: Fri May 15 15:33:34 2015 +0100
> > Committer:  Mike Snitzer <snitzer@redhat.com>
> > CommitDate: Thu Jun 11 17:12:59 2015 -0400
> >
> >     dm cache: add stochastic-multi-queue (smq) policy
> 
> > diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
> > index edcf4ab..b597273 100644
> > --- a/drivers/md/Kconfig
> > +++ b/drivers/md/Kconfig
> > @@ -304,6 +304,18 @@ config DM_CACHE_MQ
> >           This is meant to be a general purpose policy.  It prioritises
> >           reads over writes.
> >
> > +config DM_CACHE_SMQ
> > +       tristate "Stochastic MQ Cache Policy (EXPERIMENTAL)"
> > +       depends on DM_CACHE
> > +       default y
> 
> A feature cannot be "EXPERIMENTAL", and be enabled by default.
> Please drop (at least) one of them.

Thanks for your concern, but: no.

If you look closer the entirety of DM cache is marked EXPERIMENTAL:

config DM_CACHE
       tristate "Cache target (EXPERIMENTAL)"
...
config DM_CACHE_MQ
       tristate "MQ Cache Policy (EXPERIMENTAL)"
...
config DM_CACHE_SMQ
       tristate "Stochastic MQ Cache Policy (EXPERIMENTAL)"
...
config DM_CACHE_CLEANER
       tristate "Cleaner Cache Policy (EXPERIMENTAL)"
