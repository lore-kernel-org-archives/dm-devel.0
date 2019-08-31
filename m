From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH v13 1/6] crypto: essiv - create wrapper
	template for ESSIV generation
Date: Sat, 31 Aug 2019 19:37:48 +0300
Message-ID: <CAKv+Gu-7c+L4KzC=h=rBxLhZRt3RhK3eO2L2NvVrajR0MX_9+g@mail.gmail.com>
References: <20190819141738.1231-1-ard.biesheuvel@linaro.org>
	<20190819141738.1231-2-ard.biesheuvel@linaro.org>
	<20190830045822.GA17901@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190830045822.GA17901@gondor.apana.org.au>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Herbert Xu <herbert@gondor.apana.org.au>, Milan Broz <gmazyland@gmail.com>
Cc: Gilad Ben-Yossef <gilad@benyossef.com>, device-mapper development <dm-devel@redhat.com>, linux-fscrypt@vger.kernel.org, "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" <linux-crypto@vger.kernel.org>, Eric Biggers <ebiggers@google.com>
List-Id: dm-devel.ids

On Fri, 30 Aug 2019 at 07:58, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Mon, Aug 19, 2019 at 05:17:33PM +0300, Ard Biesheuvel wrote:
> > Implement a template that wraps a (skcipher,shash) or (aead,shash) tuple
> > so that we can consolidate the ESSIV handling in fscrypt and dm-crypt and
> > move it into the crypto API. This will result in better test coverage, and
> > will allow future changes to make the bare cipher interface internal to the
> > crypto subsystem, in order to increase robustness of the API against misuse.
> >
> > Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> > ---
> >  crypto/Kconfig  |  28 +
> >  crypto/Makefile |   1 +
> >  crypto/essiv.c  | 663 ++++++++++++++++++++
> >  3 files changed, 692 insertions(+)
>
> Acked-by: Herbert Xu <herbert@gondor.apana.org.au>

Milan,

Hopefully, this can still be taken for v5.4. If not, please coordinate
with Eric on how to get this queued for v5.5

Thanks,
Ard.
