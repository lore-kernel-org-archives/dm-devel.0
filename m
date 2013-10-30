From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 2/2] dm-crypt: Add TCW IV mode for old CBC
 TCRYPT containers.
Date: Tue, 29 Oct 2013 20:50:38 -0400
Message-ID: <20131030005037.GB3537@redhat.com>
References: <1382275000-10660-1-git-send-email-gmazyland@gmail.com>
	<1382998864-10380-1-git-send-email-gmazyland@gmail.com>
	<1382998864-10380-2-git-send-email-gmazyland@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1382998864-10380-2-git-send-email-gmazyland@gmail.com>
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

On Mon, Oct 28 2013 at  6:21pm -0400,
Milan Broz <gmazyland@gmail.com> wrote:

> The dmcrypt already can activate TCRYPT (TrueCrypt compatible)
> containers in LRW or XTS block encryption mode.
> 
> TCRYPT containers prior to version 4.1 used CBC mode with some
> additional tweaks.
> 
> This patch adds support for these containers.
> 
> The mode is implemented using special IV generator named TCW
> (TrueCrypt IV with whitening).
> 
> TCW IV supports only containers encrypted with one cipher
> (Tested with AES, Twofish, Serpent, CAST5 and TripleDES).
> 
> While this mode is legacy and is known to be vulnerable
> to some watermarking attacks (e.g. revealing of hidden disk
> existence) it can be still useful to mount old containers
> without using 3rd party software or for independent forensic
> analysis of such containers.
> 
> (Both userspace and kernel code is independent implementation
> based on format documentation and completely avoids use of original
> source code.)
> 
> The TCW IV generator uses two additional keys, Kw (whitening
> seed, size is always 16 bytes - TCW_WHITENING_SIZE) and
> Kiv (IV seed, size is always of the IV size of selected cipher).
> These keys are concatenated to main encryption key in mapping table.
> 
> While whitening is completely independent from IV, it is
> implemented inside IV generator for simplification.
> 
> Whitening value is always 16 bytes long and is calculated
> per sector from provided Kw as initial seed, xored with
> sector number and mixed with CRC32 algorithm.
> Resulting value is xored with ciphertext sector content.
> 
> IV is calculated from provided Kiv as initial seed and
> xored with sector number.
> 
> Detailed calculation is in Truecrypt documentation for version < 4.1
> and will be also described on dmcrypt site
> http://code.google.com/p/cryptsetup/wiki/DMCrypt
> 
> The experimental support for activation of these containers
> is already present in git devel brach of cryptsetup.
> 
> Signed-off-by: Milan Broz <gmazyland@gmail.com>

I pushed this to linux-next (for v3.13), see:
https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=for-next&id=8a478f032b40a28a66559a91095d0e0733194389

Tweaked the header and text in dm-crypt.txt and maybe a few other
comments.
