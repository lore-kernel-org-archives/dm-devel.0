From: Eric Biggers <ebiggers@kernel.org>
Subject: Re: [RFC PATCH 0/3] crypto: switch to shash for ESSIV
	generation
Date: Sun, 16 Jun 2019 13:44:19 -0700
Message-ID: <20190616204419.GE923@sol.localdomain>
References: <20190614083404.20514-1-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20190614083404.20514-1-ard.biesheuvel@linaro.org>
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
Cc: dm-devel@redhat.com, linux-fscrypt@vger.kernel.org, linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>
List-Id: dm-devel.ids

[+Cc dm-devel and linux-fscrypt]

On Fri, Jun 14, 2019 at 10:34:01AM +0200, Ard Biesheuvel wrote:
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
> 
> Remaining work:
> - wiring up some essiv(x,y) combinations into the testing framework. I wonder
>   if anything other than essiv(aes,sha256) makes sense.
> - testing - suggestions welcome on existing testing frameworks for dm-crypt
>   and/or fscrypt
> 
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: Eric Biggers <ebiggers@google.com>
> 
> Ard Biesheuvel (3):
>   crypto: essiv - create a new shash template for IV generation
>   dm crypt: switch to essiv shash
>   fscrypt: switch to ESSIV shash
> 
>  crypto/Kconfig              |   3 +
>  crypto/Makefile             |   1 +
>  crypto/essiv.c              | 275 ++++++++++++++++++++
>  drivers/md/Kconfig          |   1 +
>  drivers/md/dm-crypt.c       | 137 ++--------
>  fs/crypto/Kconfig           |   1 +
>  fs/crypto/crypto.c          |  11 +-
>  fs/crypto/fscrypt_private.h |   4 +-
>  fs/crypto/keyinfo.c         |  64 +----
>  9 files changed, 321 insertions(+), 176 deletions(-)
>  create mode 100644 crypto/essiv.c

I agree that moving away from bare block ciphers is generally a good idea.  For
fscrypt I'm fine with moving ESSIV into the crypto API, though I'm not sure a
shash template is the best approach.  Did you also consider making it a skcipher
template so that users can do e.g. "essiv(cbc(aes),sha256,aes)"?  That would
simplify things much more on the fscrypt side, since then all the ESSIV-related
code would go away entirely except for changing the string "cbc(aes)" to
"essiv(cbc(aes),sha256,aes)".

Either way, for testing the fscrypt change, I recently added tests to xfstests
that verify the on-disk ciphertext in userspace, including for non-default modes
such as the AES-128-CBC-ESSIV in question.  So I'm not too worried about the
fscrypt encryption getting accidentally broken anymore.  If you want to run the
AES-128-CBC-ESSIV test yourself, you should be able to do it by following the
directions at
https://github.com/tytso/xfstests-bld/blob/master/Documentation/kvm-quickstart.md
and running 'kvm-xfstests -c ext4 generic/549'.

As for adding essiv to testmgr, sha256 and aes would be enough for fscrypt.
There aren't any plans to add more ESSIV settings to fscrypt, and
AES-128-CBC-ESSIV was only added in the first place because some people wanted
to use fscrypt on platforms with CBC hardware acceleration but not XTS.

- Eric
