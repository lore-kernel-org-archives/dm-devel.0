From: Eric Biggers <ebiggers@kernel.org>
Subject: Re: [PATCH v3 6/6] crypto: arm64/aes - implement
 accelerated ESSIV/CBC mode
Date: Tue, 25 Jun 2019 21:32:58 -0700
Message-ID: <20190626043258.GA23471@sol.localdomain>
References: <20190619162921.12509-1-ard.biesheuvel@linaro.org>
	<20190619162921.12509-7-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20190619162921.12509-7-ard.biesheuvel@linaro.org>
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
Cc: Herbert Xu <herbert@gondor.apana.org.au>, linux-fscrypt@vger.kernel.org, Gilad Ben-Yossef <gilad@benyossef.com>, dm-devel@redhat.com, linux-crypto@vger.kernel.org, Milan Broz <gmazyland@gmail.com>
List-Id: dm-devel.ids

On Wed, Jun 19, 2019 at 06:29:21PM +0200, Ard Biesheuvel wrote:
> Add an accelerated version of the 'essiv(cbc(aes),aes,sha256)'
> skcipher, which is used by fscrypt, and in some cases, by dm-crypt.
> This avoids a separate call into the AES cipher for every invocation.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

This patch causes a self-tests failure:

[   26.787681] alg: skcipher: essiv-cbc-aes-sha256-neon encryption test failed (wrong result) on test vector 1, cfg="two even aligned splits"

- Eric
