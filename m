From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [RFC PATCH 0/1] dm-crypt excessive overhead
Date: Fri, 19 Jun 2020 14:39:39 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.2006191429060.23991@file01.intranet.prod.int.rdu2.redhat.com>
References: <20200619164132.1648-1-ignat@cloudflare.com> <20200619165548.GA24779@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200619165548.GA24779@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ignat Korchagin <ignat@cloudflare.com>, Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>
Cc: Mike Snitzer <snitzer@redhat.com>, agk@redhat.com, dm-devel@redhat.com, dm-crypt@saout.de, linux-kernel@vger.kernel.org, kernel-team@cloudflare.com
List-Id: dm-devel.ids



On Fri, 19 Jun 2020, Mike Snitzer wrote:

> On Fri, Jun 19 2020 at 12:41pm -0400,
> Ignat Korchagin <ignat@cloudflare.com> wrote:
> 
> > This is a follow up from the long-forgotten [1], but with some more convincing
> > evidence. Consider the following script:
> > 
> > [1]: https://www.spinics.net/lists/dm-crypt/msg07516.html
> > [2]: https://blog.cloudflare.com/speeding-up-linux-disk-encryption/
> > 
> > Ignat Korchagin (1):
> >   Add DM_CRYPT_FORCE_INLINE flag to dm-crypt target
> > 
> >  drivers/md/dm-crypt.c | 55 +++++++++++++++++++++++++++++++++----------
> >  1 file changed, 43 insertions(+), 12 deletions(-)
> > 
> > -- 
> > 2.20.1
> > 
> 
> Hi,
> 
> I saw [2] and have been expecting something from cloudflare ever since.
> Nice to see this submission.
> 
> There is useful context in your 0th patch header.  I'll likely merge
> parts of this patch header with the more terse 1/1 header (reality is
> there only needed to be a single patch submission).
> 
> Will review and stage accordingly if all looks fine to me.  Mikulas,
> please have a look too.
> 
> Thanks,
> Mike

+       if (test_bit(DM_CRYPT_FORCE_INLINE, &cc->flags)) {
+               if (in_irq()) {
+                       /* Crypto API will fail hard in hard IRQ context */
+                       tasklet_init(&io->tasklet, kcryptd_crypt_tasklet, (unsigned long)&io->work);
+                       tasklet_schedule(&io->tasklet);
+               } else
+                       kcryptd_crypt(&io->work);
+       } else {
+               INIT_WORK(&io->work, kcryptd_crypt);
+               queue_work(cc->crypt_queue, &io->work);
+       }

I'm looking at this and I'd like to know why does the crypto API fail in 
hard-irq context and why does it work in tasklet context. What's the exact 
reason behind this?

Mikulas
