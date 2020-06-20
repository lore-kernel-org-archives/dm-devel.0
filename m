From: Ignat Korchagin <ignat-lDpJ742SOEtZroRs9YW3xA@public.gmane.org>
Subject: Re: [RFC PATCH 0/1] dm-crypt excessive overhead
Date: Sat, 20 Jun 2020 22:02:36 +0100
Message-ID: <CALrw=nHZK7JhUO+-vAeMxCZqTBGBkWckBeg56pFuc1bo6yep6A@mail.gmail.com>
References: <20200619164132.1648-1-ignat@cloudflare.com>
 <20200619165548.GA24779@redhat.com>
 <alpine.LRH.2.02.2006191429060.23991@file01.intranet.prod.int.rdu2.redhat.com>
 <20200620012332.GA25340@gondor.apana.org.au>
 <alpine.LRH.2.02.2006201535280.24999@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-crypt-bounces-4q3lyFh4P1g@public.gmane.org>
In-Reply-To: <alpine.LRH.2.02.2006201535280.24999-Hpncn10jQN4oNljnaZt3ZvA+iT7yCHsGwRM8/txMwJMAicBL8TP8PQ@public.gmane.org>
List-Unsubscribe: <https://www.saout.de/mailman/options/dm-crypt>,
 <mailto:dm-crypt-request-4q3lyFh4P1g@public.gmane.org?subject=unsubscribe>
List-Archive: <https://www.saout.de/pipermail/dm-crypt/>
List-Post: <mailto:dm-crypt-4q3lyFh4P1g@public.gmane.org>
List-Help: <mailto:dm-crypt-request-4q3lyFh4P1g@public.gmane.org?subject=help>
List-Subscribe: <https://www.saout.de/mailman/listinfo/dm-crypt>,
 <mailto:dm-crypt-request-4q3lyFh4P1g@public.gmane.org?subject=subscribe>
Errors-To: dm-crypt-bounces-4q3lyFh4P1g@public.gmane.org
Sender: "dm-crypt" <dm-crypt-bounces-4q3lyFh4P1g@public.gmane.org>
To: Mikulas Patocka <mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>, Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, kernel-team <kernel-team-lDpJ742SOEtZroRs9YW3xA@public.gmane.org>, dm-crypt-4q3lyFh4P1g@public.gmane.org, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: dm-devel.ids

Yes, it should.

I got one when I was testing the first iteration (without the tasklet)
of the patch on an NVME? disk.

On Sat, Jun 20, 2020 at 8:36 PM Mikulas Patocka <mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>
>
>
> On Sat, 20 Jun 2020, Herbert Xu wrote:
>
> > On Fri, Jun 19, 2020 at 02:39:39PM -0400, Mikulas Patocka wrote:
> > >
> > > I'm looking at this and I'd like to know why does the crypto API fail in
> > > hard-irq context and why does it work in tasklet context. What's the exact
> > > reason behind this?
> >
> > You're not supposed to do any real work in IRQ handlers.  All
> > the substantial work should be postponed to softirq context.
>
> I see.
>
> BTW - should it also warn if it is running in a process context with
> interrupts disabled?
>
> Mikulas
>
> > Why do you need to do work in hard IRQ context?
> >
> > Cheers,
> > --
> > Email: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
> > Home Page: http://gondor.apana.org.au/~herbert/
> > PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
> >
>
_______________________________________________
dm-crypt mailing list
dm-crypt-4q3lyFh4P1g@public.gmane.org
https://www.saout.de/mailman/listinfo/dm-crypt
