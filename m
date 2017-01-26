From: =?UTF-8?B?T25kcmVqIE1vc27DocSNZWs=?=
        <omosnacek+linux-crypto@gmail.com>
Subject: Re: [PATCH] dm: switch dm-verity to async hash crypto API
Date: Thu, 26 Jan 2017 12:34:13 +0100
Message-ID: <CAAUqJDsC8BVnudsirn96O2qTHh4jMmYYe4YBiO83UW-PGfy+Qg@mail.gmail.com>
References: <1485268704-31033-1-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-crypto-owner@vger.kernel.org>
In-Reply-To: <1485268704-31033-1-git-send-email-gilad@benyossef.com>
Sender: linux-crypto-owner@vger.kernel.org
To: Gilad Ben-Yossef <gilad@benyossef.com>
Cc: dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, linux-crypto@vger.kernel.org, gilad.benyossef@arm.com, Ofir <ofir.drang@arm.com>
List-Id: dm-devel.ids

Hi Gilad,

2017-01-24 15:38 GMT+01:00 Gilad Ben-Yossef <gilad@benyossef.com>:
> -       v->tfm = crypto_alloc_shash(v->alg_name, 0, 0);
> +       v->tfm = crypto_alloc_ahash(v->alg_name, 0, CRYPTO_ALG_ASYNC);

I believe you should pass zero as the mask here. When flags == 0 and
mask == CRYPTO_ALG_ASYNC, you are basically saying "I want only algs
that have flags & CRYPTO_ALG_ASYNC == 0", which means you should only
get ahash tfms that are always synchronous (see [1]). However, since
you set a non-NULL callback in verity_hash_init, I don't think this
was your intention. By setting the mask to zero, you should be able to
get also an actual async tfm.

Thanks,
Ondrej

[1] https://lkml.org/lkml/2016/12/13/904
