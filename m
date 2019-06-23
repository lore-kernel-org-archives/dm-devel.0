From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH v4 0/6] crypto: switch to crypto API for
	ESSIV generation
Date: Sun, 23 Jun 2019 11:30:41 +0200
Message-ID: <CAKv+Gu-ZO9Fnfx06XYJ-tp+6nrk0D8TBGa2chmxFW-kjPMmLCw@mail.gmail.com>
References: <20190621080918.22809-1-ard.biesheuvel@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190621080918.22809-1-ard.biesheuvel@arm.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, Eric Biggers <ebiggers@google.com>, linux-fscrypt@vger.kernel.org, Gilad Ben-Yossef <gilad@benyossef.com>, device-mapper development <dm-devel@redhat.com>, "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" <linux-crypto@vger.kernel.org>, Milan Broz <gmazyland@gmail.com>
List-Id: dm-devel.ids

On Fri, 21 Jun 2019 at 10:09, Ard Biesheuvel <ard.biesheuvel@arm.com> wrote:
>
> From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>
...
>
> - given that hardware already exists that can perform en/decryption including
>   ESSIV generation of a range of blocks, it would be useful to encapsulate
>   this in the ESSIV template, and teach at least dm-crypt how to use it
>   (given that it often processes 8 512-byte sectors at a time)

I thought about this a bit more, and it occurred to me that the
capability of issuing several sectors at a time and letting the lower
layers increment the IV between sectors is orthogonal to whether ESSIV
is being used or not, and so it probably belongs in another wrapper.

I.e., if we define a skcipher template like dmplain64le(), which is
defined as taking a sector size as part of the key, and which
increments a 64 LE counter between sectors if multiple are passed, it
can be used not only for ESSIV but also for XTS, which I assume can be
h/w accelerated in the same way.

So with that in mind, I think we should decouple the multi-sector
discussion and leave it for a followup series, preferably proposed by
someone who also has access to some hardware to prototype it on.
