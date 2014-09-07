From: Behan Webster <behanw@converseincode.com>
Subject: Re: [PATCH v2] crypto, dm: LLVMLinux: Remove VLAIS usage from dm-crypt
Date: Sat, 06 Sep 2014 19:10:06 -0700
Message-ID: <540BBE7E.2060108@converseincode.com>
References: <1409958138-2727-1-git-send-email-behanw@converseincode.com> <540AC9F7.9000202@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <540AC9F7.9000202@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Milan Broz <gmazyland@gmail.com>, agk@redhat.com, dm-devel@redhat.com, snitzer@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, neilb@suse.de, torvalds@linux-foundation.org, =?UTF-8?B?SmFuLVNpbW9uIE3Dtg==?= =?UTF-8?B?bGxlcg==?= <dl9pf@gmx.de>, pageexec@freemail.hu
List-Id: dm-devel.ids

On 09/06/14 01:46, Milan Broz wrote:
> On 09/06/2014 01:02 AM, behanw@converseincode.com wrote:
>> From: Jan-Simon M=C3=B6ller <dl9pf@gmx.de>
>>
>> The use of variable length arrays in structs (VLAIS) in the Linux Ke=
rnel code
>> precludes the use of compilers which don't implement VLAIS (for inst=
ance the
>> Clang compiler). This patch instead allocates the appropriate amount=
 of memory
>> using an char array.
> Well, if clang (or C99 code) is now preferred for kernel, why not.
>
> Just please commit the patch series en bloc (together with the patche=
s
> removing VLAIS from crypto code you posted to cryptoapi list).
They seemed more separate than that. However, happy to post them as a=20
patch set.

>> -	struct {
>> -		struct shash_desc desc;
>> -		char ctx[crypto_shash_descsize(lmk->hash_tfm)];
>> -	} sdesc;
>> +	char sdesc[sizeof(struct shash_desc) +
>> +		crypto_shash_descsize(lmk->hash_tfm)] CRYPTO_MINALIGN_ATTR;
>> +	struct shash_desc *desc =3D (struct shash_desc *)sdesc;
> TBH, this looks even more uglier that the previous code :-)
I'm not claiming it's prettier. Merely C99. :)

> (But tglx already complained on different patch and I fully agree tha=
t crypto code
> should not use this kind of construction in the first place...
> It would be very nice to introduce at least some macro hiding these c=
razy
> stack allocations later.)
I actually agree with you and tglx. Will fix.

As I said to tglx, we were asked not to hide things with macro magic in=
=20
some of our non-crypto VLAIS removal patches. Happy to use macros in=20
this case.

Thanks,

Behan

--=20
Behan Webster
behanw@converseincode.com
