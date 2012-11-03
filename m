From: Milan Broz <mbroz@redhat.com>
Subject: Re: [PATCH] Remove VLAIS usage from dm-crypt
Date: Sat, 03 Nov 2012 20:30:08 +0100
Message-ID: <509570C0.30208@redhat.com>
References: <1351620956-17583-1-git-send-email-behanw@converseincode.com> <1351620956-17583-2-git-send-email-behanw@converseincode.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1351620956-17583-2-git-send-email-behanw@converseincode.com>
Sender: linux-raid-owner@vger.kernel.org
To: Behan Webster <behanw@converseincode.com>
Cc: agk@redhat.com, dm-devel@redhat.com, linux-raid@vger.kernel.org, =?UTF-8?B?SmFuLVNpbW9uIE3DtmxsZXI=?= <dl9pf@gmx.de>, pageexec@freemail.hu
List-Id: dm-devel.ids

On 10/30/2012 07:15 PM, Behan Webster wrote:
> From: Jan-Simon M=C3=B6ller <dl9pf@gmx.de>
>=20
> The use of variable length arrays in structs (VLAIS) in the Linux Ker=
nel code
> precludes the use of compilers which don't implement VLAIS (for insta=
nce the
> Clang compiler). This patch instead allocates the appropriate amount =
of memory
> using an char array.

The dmcrypt code should use the same code practices as crypto API.

Apparently, your approach was not accepted there

http://article.gmane.org/gmane.linux.kernel/1386451
http://article.gmane.org/gmane.linux.kernel.cryptoapi/7993

> +	char sdesc[sizeof(struct shash_desc)
> +		+ crypto_shash_descsize(lmk->hash_tfm)
> +		+ CRYPTO_MINALIGN] CRYPTO_MINALIGN_ATTR;
> +	struct shash_desc *desc =3D (struct shash_desc *)sdesc;

I would like to see kenrel compilable by Clang but obfuscating the code
this way is perhaps not the ideal way.

Until it is accepted in crypto layer, NACK.

Milan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
