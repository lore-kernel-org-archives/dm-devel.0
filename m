From: Eric Biggers <ebiggers@kernel.org>
Subject: Re: [PATCH v5 7/7] crypto: arm64/aes - implement accelerated
 ESSIV/CBC mode
Date: Thu, 27 Jun 2019 09:40:45 -0700
Message-ID: <20190627164045.GE686@sol.localdomain>
References: <20190626204047.32131-1-ard.biesheuvel@linaro.org>
 <20190626204047.32131-8-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20190626204047.32131-8-ard.biesheuvel@linaro.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, linux-fscrypt@vger.kernel.org, Gilad Ben-Yossef <gilad@benyossef.com>, dm-devel@redhat.com, linux-crypto@vger.kernel.org, Milan Broz <gmazyland@gmail.com>, linux-arm-kernel@lists.infradead.org
List-Id: dm-devel.ids

On Wed, Jun 26, 2019 at 10:40:47PM +0200, Ard Biesheuvel wrote:
> Add an accelerated version of the 'essiv(cbc(aes),aes,sha256'
> skcipher, which is used by fscrypt, and in some cases, by dm-crypt.
> This avoids a separate call into the AES cipher for every invocation.

This technically should say "in some cases by fscrypt and dm-crypt", since as
we've discussed previously, most of the time this is not what fscrypt uses.

- Eric
