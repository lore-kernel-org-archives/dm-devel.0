From: SandeepKsinha <sandeepksinha@gmail.com>
Subject: Re: [RFC PATCH] dm-csum: A new device mapper target that checks data
	integrity
Date: Fri, 26 Jun 2009 14:20:32 +0530
Message-ID: <37d33d830906260150i3550db27lde3ef50c5a8aee58@mail.gmail.com>
References: <20090521161317.GU1376@blitiri.com.ar>
	 <87my91qsn4.fsf@frosties.localdomain>
	 <20090525174630.GI1376@blitiri.com.ar>
	 <8763fop31e.fsf@frosties.localdomain>
	 <20090526125252.GL1376@blitiri.com.ar>
	 <878wkhyqj3.fsf@frosties.localdomain>
	 <37d33d830906260026t60ae1c71h981b6f3bc0165053@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <37d33d830906260026t60ae1c71h981b6f3bc0165053@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Goswin von Brederlow <goswin-v-b@web.de>
Cc: Alberto Bertogli <albertito@blitiri.com.ar>, linux-kernel@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, agk@redhat.com, neilb@suse.de
List-Id: dm-devel.ids

Hi,

I meant sectors and not blocks.

On Fri, Jun 26, 2009 at 12:56 PM, SandeepKsinha<sandeepksinha@gmail.com=
> wrote:
> Hi Alberto,
>
> + * TODO: would it be better to have M1 and M2 apart, to improve the =
chances of
> + * recovery in case of a failure?
> + *
>
> How do you guarantee consistency in case of any lost writes? Your
> checksum might hold an updated value while your data block might be
> lost or written to a wrong destination?
>

sector in place of block.

> When implementing such integrity solutions, IMO, it is always
> advisable to handle such error conditions else this might lead to
> issues. Since, checksums =A0are very tightly coupled with the data an=
d
> any misleading can be quite dangerous unlike parity which can be
> recovered.
>
> Calculate the data's CRC, and compare it to the one found in M1. If t=
hey
> + * =A0 =A0match, the reading is successful. If not, compare it to th=
e one found in
> + * =A0 =A0M2. If they match, the reading is successful;
>
> Also, I hope by M1 and M2 you refer to the entry for a particular
> block in the respective IMD sector. What kind of mechanism do you use
> to determine which is younger?
> Is it the timestamp or some generation count?
>

for a particular sector and not block.

> I assume information is per_block_entry in the IMD sectors. Which I
> don't see in your implementation?
> =A0*
> + * The imd structure consists of:
> + * =A0 - 16 bit CRC (CCITT) (big endian)
> + * =A0 - 16 bit flags (big endian)
> + * =A0 - 32 bit tag
>
> Correct me If I am missing something.
>
> On Fri, May 29, 2009 at 12:59 AM, Goswin von Brederlow<goswin-v-b@web=
=2Ede> wrote:
>> Now I need to get a new harddisk so I can test this without risking
>> live data. :)
>>
>> MfG
>> =A0 =A0 =A0 =A0Goswin
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>>
>
>
>
> --
> Regards,
> Sandeep.
>
>
>
>
>
>
> =93To learn is to change. Education is a process that changes the lea=
rner.=94
>



--=20
Regards,
Sandeep.





 =09
=93To learn is to change. Education is a process that changes the learn=
er.=94
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
