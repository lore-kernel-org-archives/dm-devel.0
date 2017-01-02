From: Binoy Jayan <binoy.jayan@linaro.org>
Subject: Re: [RFC PATCH v2] crypto: Add IV generation algorithms
Date: Mon, 2 Jan 2017 12:16:45 +0530
Message-ID: <CAHv-k_8FmeKk_3zUAVCqHp82nHmiWsyfZ_BW+z=SC5VVOrFsAA@mail.gmail.com>
References: <1481618949-20086-1-git-send-email-binoy.jayan@linaro.org>
 <1481618949-20086-2-git-send-email-binoy.jayan@linaro.org>
 <d6d92865-98fa-4d02-035f-9080bc265c35@gmail.com> <20161222085509.GA2160@gondor.apana.org.au>
 <CAHv-k_-EKq2g=Wb+YkPVp9gCXTDEyrxZhQpT5JMSw=WtZ1OC9w@mail.gmail.com>
 <20161223075114.GA3580@gondor.apana.org.au> <CAHv-k_9SynECq7qDbrW59=LsV_WNj+9Ffa=6tATyNKOt36he6Q@mail.gmail.com>
 <20161230102723.GA15713@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-crypto-owner@vger.kernel.org>
In-Reply-To: <20161230102723.GA15713@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Milan Broz <gmazyland@gmail.com>, Oded <oded.golombek@arm.com>, Ofir <Ofir.Drang@arm.com>, "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org, Mark Brown <broonie@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Linux kernel mailing list <linux-kernel@vger.kernel.org>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org, Rajendra <rnayak@codeaurora.org>
List-Id: dm-devel.ids

Hi Herbert,

On 30 December 2016 at 15:57, Herbert Xu <herbert@gondor.apana.org.au> wrote:

> This is just a matter of structuring the key for the IV generator.
> The IV generator's key in this case should be a combination of the
> key to the underlying CBC plus the set of all keys for the IV
> generator itself.  It should then allocate the required number of
> tfms as is currently done by crypt_alloc_tfms in dm-crypt.

Since I used template ciphers for the iv algorithms, I use
crypto_spawn_skcipher_alg and skcipher_register_instance
for creating the underlying cbc algorithm. I guess you suggest
to change that to make use of crypto_alloc_skcipher.

Even if ciphers are allocated this way, all the encryption requests
for cbc should still go through IV generators? So that should mean,
create one instance of IV generator using 'crypto_alloc_skcipher'
and create tfms_count instances of the generator depending on the
number of keys.

Thanks,
Binoy
