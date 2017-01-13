From: =?UTF-8?B?T25kcmVqIE1vc27DocSNZWs=?= <omosnacek@gmail.com>
Subject: Re: [RFC PATCH 0/6] Add bulk skcipher requests to crypto API and dm-crypt
Date: Fri, 13 Jan 2017 13:01:56 +0100
Message-ID: <CAAUqJDtqN-ugcaz4VhuW0fzLbmKt4db8ggrRmaAq_zFvO+9Lvw@mail.gmail.com>
References: <cover.1484215956.git.omosnacek@gmail.com> <20170113104128.GA23497@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-crypto-owner@vger.kernel.org>
In-Reply-To: <20170113104128.GA23497@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org, dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>, Milan Broz <gmazyland@gmail.com>, Mikulas Patocka <mpatocka@redhat.com>, Binoy Jayan <binoy.jayan@linaro.org>
List-Id: dm-devel.ids

2017-01-13 11:41 GMT+01:00 Herbert Xu <herbert@gondor.apana.org.au>:
> On Thu, Jan 12, 2017 at 01:59:52PM +0100, Ondrej Mosnacek wrote:
>> the goal of this patchset is to allow those skcipher API users that need to
>> process batches of small messages (especially dm-crypt) to do so efficiently.
>
> Please explain why this can't be done with the existing framework
> using IV generators similar to the ones used for IPsec.

As I already mentioned in another thread, there are basically two reasons:

1) Milan would like to add authenticated encryption support to
dm-crypt (see [1]) and as part of this change, a new random IV mode
would be introduced. This mode generates a random IV for each sector
write, includes it in the authenticated data and stores it in the
sector's metadata (in a separate part of the disk). In this case
dm-crypt will need to have control over the IV generation (or at least
be able to somehow retrieve it after the crypto operation... but
passing RNG responsibility to drivers doesn't seem to be a good idea
anyway).

2) With this API, drivers wouldn't have to provide implementations for
specific IV generation modes, and just implement bulk requests for the
common modes/algorithms (XTS, CBC, ...) while still getting
performance benefit.

Regards,
Ondrej

[1] https://www.redhat.com/archives/dm-devel/2017-January/msg00028.html

>
> Thanks,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
