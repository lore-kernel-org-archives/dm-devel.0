From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH 3/3] dm-crypt: Implement eboiv - encrypted
 byte-offset initialization vector.
Date: Fri, 5 Jul 2019 08:32:03 +0200
Message-ID: <CAKv+Gu-Nye8TF68bZ=fKzU-SBpW7nx3F8ECcZjLjKD_TTbtsmw@mail.gmail.com>
References: <20190704131033.9919-1-gmazyland@gmail.com>
	<20190704131033.9919-3-gmazyland@gmail.com>
	<7a8d13ee-2d3f-5357-48c6-37f56d7eff07@gmail.com>
	<CAKv+Gu_c+OpOwrr0dSM=j=HiDpfM4sarq6u=6AXrU8jwLaEr-w@mail.gmail.com>
	<CAKv+Gu8a6cBQYsbYs8CDyGbhHx0E=+1SU7afqoy9Cs+K8PMfqA@mail.gmail.com>
	<4286b8f6-03b5-a8b4-4db2-35dda954e518@gmail.com>
	<CAKv+Gu_Nesqtz-xs0LkHYZ6HXrKkbJjq8dKL6Cnrk9ZsQ=T3jg@mail.gmail.com>
	<20190705030827.k6f7hnhxjsoxdj6b@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190705030827.k6f7hnhxjsoxdj6b@gondor.apana.org.au>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" <linux-crypto@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>, Milan Broz <gmazyland@gmail.com>, Eric Biggers <ebiggers@google.com>
List-Id: dm-devel.ids

On Fri, 5 Jul 2019 at 05:08, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Thu, Jul 04, 2019 at 08:11:46PM +0200, Ard Biesheuvel wrote:
> >
> > To be clear, making the cipher API internal only is something that I
> > am proposing but hasn't been widely discussed yet. So if you make a
> > good argument why it is a terrible idea, I'm sure it will be taken
> > into account.
> >
> > The main issue is that the cipher API is suboptimal if you process
> > many blocks in sequence, since SIMD implementations will not be able
> > to amortize the cost of kernel_fpu_begin()/end(). This is something
> > that we might be able to fix in other ways (and a SIMD get/put
> > interface has already been proposed which looks suitable for this as
> > well) but that would still involve an API change for something that
> > isn't the correct abstraction in the first place in many cases. (There
> > are multiple implementations of ccm(aes) using cipher_encrypt_one() in
> > a loop, for instance, and these are not able to benefit from, e.g,
> > the accelerated implementation that I created for arm64, since it open
> > codes the CCM operations)
>
> I agree with what you guys have concluded so far.  But I do have
> something I want to say about eboiv's implementation itself.
>
> AFAICS this is using the same key as the actual data.  So why
> don't you combine it with the actual data when encrypting/decrypting?
>
> That is, add a block at the front of the actual data containing
> the little-endian byte offset and then use an IV of zero.
>

That would only work for encryption.
