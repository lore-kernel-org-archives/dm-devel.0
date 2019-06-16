From: Eric Biggers <ebiggers@kernel.org>
Subject: Re: [RFC PATCH 0/3] crypto: switch to shash for ESSIV
 generation
Date: Sun, 16 Jun 2019 14:09:03 -0700
Message-ID: <20190616210903.GF923@sol.localdomain>
References: <20190614083404.20514-1-ard.biesheuvel@linaro.org>
	<9cd635ec-970b-bd1b-59f4-1a07395e69a0@gmail.com>
	<CAKv+Gu88tYOmO=8mi7yP2oj=x_SOB_o7D9jo6v_3xfbUxY2R1A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu88tYOmO=8mi7yP2oj=x_SOB_o7D9jo6v_3xfbUxY2R1A@mail.gmail.com>
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
Cc: Mike Snitzer <msnitzer@redhat.com>, Herbert Xu <herbert@gondor.apana.org.au>, device-mapper development <dm-devel@redhat.com>, linux-fscrypt@vger.kernel.org, "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" <linux-crypto@vger.kernel.org>, Milan Broz <gmazyland@gmail.com>
List-Id: dm-devel.ids

[+Cc linux-fscrypt]

On Sun, Jun 16, 2019 at 09:13:01PM +0200, Ard Biesheuvel wrote:
> >
> >  - ESSIV is useful only for CBC mode. I wish we move to some better mode
> > in the future instead of cementing CBC use... But if it helps people
> > to actually use unpredictable IV for CBC, it is the right approach.
> > (yes, I know XTS has own problems as well... but IMO that should be the default
> > for sector/fs-block encryption these days :)
> >
> 
> I agree that XTS should be preferred. But for some reason, the
> kernel's XTS implementation does not support ciphertext stealing (as
> opposed to, e.g., OpenSSL), and so CBC ended up being used for
> encrypting the filenames in fscrypt.
> 

Actually, for fscrypt CTS-CBC was also chosen because all filenames in each
directory use the same IV, in order to efficiently support all the possible
filesystem operations and to support filenames up to NAME_MAX.  So there was a
desire for there to be some propagation across ciphertext blocks rather than use
XTS which would effectively be ECB in this case.

Neither solution is great though, since CBC-CTS still has the common prefix
problem.  Long-term we're planning to switch to an AES-based wide block mode
such as AES-HEH or AES-HCTR for filenames encryption.  This is already solved
for Adiantum users since Adiantum is a wide-block mode, but there should be a
pure AES solution too to go along with AES contents encryption.

- Eric
