From: Baolin Wang <baolin.wang@linaro.org>
Subject: Re: [PATCH 1/4] scatterlist: Introduce some helper functions
Date: Fri, 4 Mar 2016 14:53:49 +0800
Message-ID: <CAMz4kuKMTTSF7_D47xJqhoKporaibXjame9aLgyrHWDSsKvM4Q@mail.gmail.com>
References: <cover.1456981314.git.baolin.wang@linaro.org>
	<3bff3e286d3ee01ebb7e26d7233075054c42a7a9.1456981314.git.baolin.wang@linaro.org>
	<87povbpe3l.fsf@belgarion.home>
	<CAMz4kuKtwCkgG-3GeCtfnAX5zN8MkwyVr2XVYzaV3Z6SFFcZww@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-crypto-owner@vger.kernel.org>
In-Reply-To: <CAMz4kuKtwCkgG-3GeCtfnAX5zN8MkwyVr2XVYzaV3Z6SFFcZww@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
To: Robert Jarzmik <robert.jarzmik@free.fr>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, David Miller <davem@davemloft.net>, Alasdair G Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, axboe@fb.com, dm-devel@redhat.com, akpm@linux-foundation.org, david.s.gordon@intel.com, Tom Lendacky <thomas.lendacky@amd.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, smueller@chronox.de, tadeusz.struk@intel.com, Masanari Iida <standby24x7@gmail.com>, shli@kernel.org, Mark Brown <broonie@kernel.org>, Linus Walleij <linus.walleij@linaro.org>, Arnd Bergmann <arnd@arndb.de>, LKML <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: dm-devel.ids

>>> + **/
>>> +static inline bool sg_is_contiguous(struct scatterlist *sga,
>>> +                                 struct scatterlist *sgb)
>>> +{
>>> +     return ((sga->page_link & ~0x3UL) + sga->offset + sga->length ==
>>> +             (sgb->page_link & ~0x3UL));
>>> +}
>> I don't understand that one.
>> sga->page_link is a pointer to a "struct page *". How can it be added to an
>> offset within a page ???
>
>
> Ah, sorry that's a mistake. It should check as below:
> static inline bool sg_is_contiguous(struct scatterlist *sga, struct
> scatterlist *sgb)
> {
>     return (unsigned int)sg_virt(sga) + sga->length == (unsigned
> int)sg_virt(sgb);
> }

sorry, it should be:
static inline bool sg_is_contiguous(struct scatterlist *sga,
   struct scatterlist *sgb)
{
    return (unsigned long)sg_virt(sga) + sga->length ==
               (unsigned long)sg_virt(sgb);
}

-- 
Baolin.wang
Best Regards
