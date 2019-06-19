From: Eric Biggers <ebiggers@kernel.org>
Subject: Re: [PATCH v3 6/6] crypto: arm64/aes - implement
 accelerated ESSIV/CBC mode
Date: Wed, 19 Jun 2019 15:37:11 -0700
Message-ID: <20190619223710.GC33328@gmail.com>
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

I'm not sure we should bother with this, since fscrypt normally uses AES-256-XTS
for contents encryption.  AES-128-CBC-ESSIV support was only added because
people wanted something that is fast on low-powered embedded devices with crypto
accelerators such as CAAM or CESA that don't support XTS.

In the case of Android, the CDD doesn't even allow AES-128-CBC-ESSIV with
file-based encryption (fscrypt).  It's still the default for "full disk
encryption" (which uses dm-crypt), but that's being deprecated.

So maybe dm-crypt users will want this, but I don't think it's very useful for
fscrypt.

- Eric
