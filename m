From: Milan Broz <gmazyland@gmail.com>
Subject: Re: [PATCH v2] crypto, dm: LLVMLinux: Remove VLAIS usage from dm-crypt
Date: Sat, 06 Sep 2014 10:46:47 +0200
Message-ID: <540AC9F7.9000202@gmail.com>
References: <1409958138-2727-1-git-send-email-behanw@converseincode.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1409958138-2727-1-git-send-email-behanw@converseincode.com>
Sender: linux-kernel-owner@vger.kernel.org
To: behanw@converseincode.com, agk@redhat.com, dm-devel@redhat.com, snitzer@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, neilb@suse.de, torvalds@linux-foundation.org, =?UTF-8?B?SmFuLVNpbW9uIE3Dtg==?= =?UTF-8?B?bGxlcg==?= <dl9pf@gmx.de>, pageexec@freemail.hu
List-Id: dm-devel.ids

On 09/06/2014 01:02 AM, behanw@converseincode.com wrote:
> From: Jan-Simon M=C3=B6ller <dl9pf@gmx.de>
>=20
> The use of variable length arrays in structs (VLAIS) in the Linux Ker=
nel code
> precludes the use of compilers which don't implement VLAIS (for insta=
nce the
> Clang compiler). This patch instead allocates the appropriate amount =
of memory
> using an char array.

Well, if clang (or C99 code) is now preferred for kernel, why not.

Just please commit the patch series en bloc (together with the patches
removing VLAIS from crypto code you posted to cryptoapi list).

Dmcrypt should always use the same coding practices as crypto part of t=
he kernel
so we should not divert here.

> -	struct {
> -		struct shash_desc desc;
> -		char ctx[crypto_shash_descsize(lmk->hash_tfm)];
> -	} sdesc;
> +	char sdesc[sizeof(struct shash_desc) +
> +		crypto_shash_descsize(lmk->hash_tfm)] CRYPTO_MINALIGN_ATTR;
> +	struct shash_desc *desc =3D (struct shash_desc *)sdesc;

TBH, this looks even more uglier that the previous code :-)

(But tglx already complained on different patch and I fully agree that =
crypto code
should not use this kind of construction in the first place...
It would be very nice to introduce at least some macro hiding these cra=
zy
stack allocations later.)

Thanks,
Milan
