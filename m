From: Milan Broz <gmazyland@gmail.com>
Subject: Re: [RFC PATCH 0/3] crypto: switch to shash for ESSIV
	generation
Date: Sat, 15 Jun 2019 20:19:22 +0200
Message-ID: <9cd635ec-970b-bd1b-59f4-1a07395e69a0@gmail.com>
References: <20190614083404.20514-1-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190614083404.20514-1-ard.biesheuvel@linaro.org>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-crypto@vger.kernel.org
Cc: device-mapper development <dm-devel@redhat.com>, Mike Snitzer <msnitzer@redhat.com>, Herbert Xu <herbert@gondor.apana.org.au>, Eric Biggers <ebiggers@google.com>
List-Id: dm-devel.ids

On 14/06/2019 10:34, Ard Biesheuvel wrote:
> This series is presented as an RFC for a couple of reasons:
> - it is only build tested
> - it is unclear whether this is the right way to move away from the use of
>   bare ciphers in non-crypto code
> - we haven't really discussed whether moving away from the use of bare ciphers
>   in non-crypto code is a goal we agree on
> 
> This series creates an ESSIV shash template that takes a (cipher,hash) tuple,
> where the digest size of the hash must be a valid key length for the cipher.
> The setkey() operation takes the hash of the input key, and sets into the
> cipher as the encryption key. Digest operations accept input up to the
> block size of the cipher, and perform a single block encryption operation to
> produce the ESSIV output.
> 
> This matches what both users of ESSIV in the kernel do, and so it is proposed
> as a replacement for those, in patches #2 and #3.
> 
> As for the discussion: the code is untested, so it is presented for discussion
> only. I'd like to understand whether we agree that phasing out the bare cipher
> interface from non-crypto code is a good idea, and whether this approach is
> suitable for fscrypt and dm-crypt.

If you want some discussion, it would be very helpful if you cc device-mapper list
to reach dm-crypt developers. Please add at least dm-devel list.

Just a few comments:

 - ESSIV is useful only for CBC mode. I wish we move to some better mode
in the future instead of cementing CBC use... But if it helps people
to actually use unpredictable IV for CBC, it is the right approach.
(yes, I know XTS has own problems as well... but IMO that should be the default
for sector/fs-block encryption these days :)

- I do not think there is a problem if ESSIV moves to crypto API,
but there it is presented as a hash... It is really just an IV generator.

> - wiring up some essiv(x,y) combinations into the testing framework. I wonder
>   if anything other than essiv(aes,sha256) makes sense.

In cryptsetup testsuite, we test serpent and twofish ciphers at least, but in
reality, essiv(aes,sha256) is the most used combination.
If it makes sense, I can run some tests with dm-crypt and this patchset.

Thanks,
Milan
