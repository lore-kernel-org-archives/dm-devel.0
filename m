From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v13 6/6] md: dm-crypt: omit parsing of the
 encapsulated cipher
Date: Tue, 3 Sep 2019 14:58:28 -0400
Message-ID: <20190903185827.GD13472@redhat.com>
References: <20190819141738.1231-1-ard.biesheuvel@linaro.org>
	<20190819141738.1231-7-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20190819141738.1231-7-ard.biesheuvel@linaro.org>
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
Cc: Herbert Xu <herbert@gondor.apana.org.au>, Eric Biggers <ebiggers@google.com>, dm-devel@redhat.com, Gilad Ben-Yossef <gilad@benyossef.com>, linux-fscrypt@vger.kernel.org, linux-crypto@vger.kernel.org, Milan Broz <gmazyland@gmail.com>
List-Id: dm-devel.ids

On Mon, Aug 19 2019 at 10:17am -0400,
Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:

> Only the ESSIV IV generation mode used to use cc->cipher so it could
> instantiate the bare cipher used to encrypt the IV. However, this is
> now taken care of by the ESSIV template, and so no users of cc->cipher
> remain. So remove it altogether.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

Acked-by: Mike Snitzer <snitzer@redhat.com>

Might be wise to bump the dm-crypt target's version number (from
{1, 19, 0} to {1, 20, 0}) at the end of this patch too though...

But again, Herbert please feel free to pull this into your 5.4 branch.

Thanks,
Mike
