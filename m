From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v13 6/6] md: dm-crypt: omit parsing of the
 encapsulated cipher
Date: Wed, 4 Sep 2019 09:38:36 -0400
Message-ID: <20190904133836.GA17836@redhat.com>
References: <20190819141738.1231-1-ard.biesheuvel@linaro.org>
	<20190819141738.1231-7-ard.biesheuvel@linaro.org>
	<20190903185827.GD13472@redhat.com>
	<403192f0-d1c4-0c60-5af1-7dee8516d629@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <403192f0-d1c4-0c60-5af1-7dee8516d629@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Milan Broz <gmazyland@gmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, Eric Biggers <ebiggers@google.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, dm-devel@redhat.com, Gilad Ben-Yossef <gilad@benyossef.com>, linux-fscrypt@vger.kernel.org, linux-crypto@vger.kernel.org
List-Id: dm-devel.ids

On Wed, Sep 04 2019 at  7:01am -0400,
Milan Broz <gmazyland@gmail.com> wrote:

> On 03/09/2019 20:58, Mike Snitzer wrote:
> > On Mon, Aug 19 2019 at 10:17am -0400,
> > Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
> > 
> >> Only the ESSIV IV generation mode used to use cc->cipher so it could
> >> instantiate the bare cipher used to encrypt the IV. However, this is
> >> now taken care of by the ESSIV template, and so no users of cc->cipher
> >> remain. So remove it altogether.
> >>
> >> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> > 
> > Acked-by: Mike Snitzer <snitzer@redhat.com>
> > 
> > Might be wise to bump the dm-crypt target's version number (from
> > {1, 19, 0} to {1, 20, 0}) at the end of this patch too though...
> 
> The function should be exactly the same, dependencies on needed modules are set.
> 
> In cryptsetup we always report dm target + kernel version,
> so we know that since version 5.4 it uses crypto API for ESSIV.
> I think version bump here is really not so important.
> 
> Just my two cents :)

Yes, that's fine.. I staged it for 5.4 yesterday without the version bump.

Thanks,
Mike
