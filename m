From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 3/3] dm-crypt: Implement eboiv - encrypted
 byte-offset initialization vector.
Date: Fri, 5 Jul 2019 16:51:11 +0800
Message-ID: <20190705085111.ibpv3bmbxzy4mxgo@gondor.apana.org.au>
References: <20190704131033.9919-1-gmazyland@gmail.com>
	<20190704131033.9919-3-gmazyland@gmail.com>
	<7a8d13ee-2d3f-5357-48c6-37f56d7eff07@gmail.com>
	<CAKv+Gu_c+OpOwrr0dSM=j=HiDpfM4sarq6u=6AXrU8jwLaEr-w@mail.gmail.com>
	<CAKv+Gu8a6cBQYsbYs8CDyGbhHx0E=+1SU7afqoy9Cs+K8PMfqA@mail.gmail.com>
	<4286b8f6-03b5-a8b4-4db2-35dda954e518@gmail.com>
	<CAKv+Gu_Nesqtz-xs0LkHYZ6HXrKkbJjq8dKL6Cnrk9ZsQ=T3jg@mail.gmail.com>
	<20190705030827.k6f7hnhxjsoxdj6b@gondor.apana.org.au>
	<CAKv+Gu-Nye8TF68bZ=fKzU-SBpW7nx3F8ECcZjLjKD_TTbtsmw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu-Nye8TF68bZ=fKzU-SBpW7nx3F8ECcZjLjKD_TTbtsmw@mail.gmail.com>
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
Cc: "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" <linux-crypto@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>, Milan Broz <gmazyland@gmail.com>, Eric Biggers <ebiggers@google.com>
List-Id: dm-devel.ids

On Fri, Jul 05, 2019 at 08:32:03AM +0200, Ard Biesheuvel wrote:
>
> > AFAICS this is using the same key as the actual data.  So why
> > don't you combine it with the actual data when encrypting/decrypting?
> >
> > That is, add a block at the front of the actual data containing
> > the little-endian byte offset and then use an IV of zero.
> >
> 
> That would only work for encryption.

True.  So this doesn't obviate the need to access the single-block
cipher.  But the code probably should still do it that way for
encryption for performance reasons.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
