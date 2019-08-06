From: Milan Broz <gmazyland@gmail.com>
Subject: Re: [RFC PATCH 2/2] md/dm-crypt - switch to AES library
	for EBOIV
Date: Tue, 6 Aug 2019 12:43:33 +0200
Message-ID: <22f5bfd5-7563-b85b-925e-6d46e7584966@gmail.com>
References: <20190806080234.27998-1-ard.biesheuvel@linaro.org>
	<20190806080234.27998-3-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190806080234.27998-3-ard.biesheuvel@linaro.org>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-crypto@vger.kernel.org
Cc: ebiggers@kernel.org, snitzer@redhat.com, dm-devel@redhat.com, herbert@gondor.apana.org.au, agk@redhat.com
List-Id: dm-devel.ids

On 06/08/2019 10:02, Ard Biesheuvel wrote:
> The EBOIV IV mode reuses the same AES encryption key that is used for
> encrypting the data, and uses it to perform a single block encryption
> of the byte offset to produce the IV.
> 
> Since table-based AES is known to be susceptible to known-plaintext
> attacks on the key, and given that the same key is used to encrypt
> the byte offset (which is known to an attacker), we should be
> careful not to permit arbitrary instantiations where the allocated
> AES cipher is provided by aes-generic or other table-based drivers
> that are known to be time variant and thus susceptible to this kind
> of attack.
> 
> Instead, let's switch to the new AES library, which has a D-cache
> footprint that is only 1/32th of the generic AES driver, and which
> contains some mitigations to reduce the timing variance even further.

NACK.

We discussed here that we will not limit combinations inside dm-crypt.
For generic crypto API, this policy should be different, but I really
do not want these IVs to be visible outside of dm-crypt.

Allowing arbitrary combinations of a cipher, mode, and IV is how dm-crypt
works since the beginning, and I really do not see the reason to change it.

This IV mode is intended to be used for accessing old BitLocker images,
so I do not care about performance much.

Thanks,
Milan
