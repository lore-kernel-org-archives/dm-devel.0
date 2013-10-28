From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 2/2] dm-crypt: Add TCW IV mode for old CBC
 TCRYPT containers.
Date: Mon, 28 Oct 2013 12:08:50 -0400
Message-ID: <20131028160849.GB25212@redhat.com>
References: <1382275000-10660-1-git-send-email-gmazyland@gmail.com>
	<1382275000-10660-2-git-send-email-gmazyland@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1382275000-10660-2-git-send-email-gmazyland@gmail.com>
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
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

The following patch header is confusing given the mix of legacy and
new concepts.  I understand you're trying to establish context for
what's new but to this reader I'm a bit lost in the jargon.  Specifics
below (and please forgive my naive questions).

On Sun, Oct 20 2013 at  9:16am -0400,
Milan Broz <gmazyland@gmail.com> wrote:

> The dmcrypt already can activate TCRYPT (TrueCrypt compatible) containers
> in LRW or XTS block encryption mode.
> 
> TCRYPT containers prior to version 4.1 used CBC mode with some
> additional tweaks.
> 
> This patch adds support for these containers.
> 
> For now, there is no support for chained ciphers, this TCW mode support
> only containers encrypted with one cipher
> (Tested with AES, Twofish, Serpentm CAST5 and TripleDES).

What does TCW mean?  How does it relate to CBC?
- Is TCW mode: "CBC mode with some additional tweaks"?

> While TCRYPT CBC mode is legacy and is known to be vulnerable
> to some watermarking attacks (e.g. revealing of hidden disk
> existence) it can be still useful to mount old containers
> without using 3rd party software or for independent forensic
> analysis of such containers.

Now you're switching back to referring to "TCRYPT CBC mode".  What
happened to "TCW mode"?

> (Both userspace and kernel code is independent implementation
> based on format documentation and completely avoids use of original
> source code.)
> 
> Encryption uses CBC mode with special IV generated from
> additional key, xored with sector number.
> 
> There is also second key used for "whitening" of sectors.
> Whitening key is xored with sector number and mixed using
> CRC32 and resulting value is applied to whole sector.
> (Detailed calculation is in Truecrypt documentation for version < 4.1
> and will be also described on dmcrypt site.)

Can you add a pointer to the Truecrypt documentation for < 4.1?  Or a
pointer to the dmcrypt site documentation?

> IV and whitening key is concatenated with encryption key,
> so kernel receives all these keys as K|IV_key|Whitening_key
> in one string.
> Length of IV key is always the same as IV of selected cipher
> and length of whitening key is fixed to TCW_WHITENING_SIZE,
> so key string can be split properly.
> 
> The experimental support for activation of these containers
> is already present in git devel brach of cryptsetup.

Again, an example that documents a theoretical ctr line (before and
after patch?) would probably go a long way to help clarify what is new
here.
