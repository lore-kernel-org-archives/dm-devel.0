From: Jon Smirl <jonsmirl@gmail.com>
Subject: Re: [PATCH] Drop 80-character limit in checkpatch.pl
Date: Sun, 27 Dec 2009 12:15:00 -0500
Message-ID: <9e4733910912270915k6299f6f4pc2bb81685eef29c6@mail.gmail.com>
References: <Pine.LNX.4.64.0912151656010.29183@hs20-bc2-1.build.redhat.com>
	 <200912171618.32882.bzolnier@gmail.com>
	 <alpine.LRH.2.00.0912181400130.21496@twin.jikos.cz>
	 <200912181455.34664.bzolnier@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1752566AbZL0RPF@vger.kernel.org>
In-Reply-To: <200912181455.34664.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Linus Torvalds <torvalds@linux-foundation.org>, =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>, Mikulas Patocka <mpatocka@redhat.com>, linux-kernel@vger.kernel.org, Alasdair G Kergon <agk@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Fri, Dec 18, 2009 at 8:55 AM, Bartlomiej Zolnierkiewicz
<bzolnier@gmail.com> wrote:
> On Friday 18 December 2009 02:04:37 pm Jiri Kosina wrote:
>> On Thu, 17 Dec 2009, Bartlomiej Zolnierkiewicz wrote:
>>
>> > > > I like this patch, this is actually what I wanted to do.
>> > >
>> > > I have nothing against a switch, but it had better default to of=
f.
>> > >
>> > > The whole 80-char limit is insane. It results in insane "fixes".=
 Just
>> > > about every time somebody "improves" a patch due to the warning,=
 the
>> > > result is worse than the original patch.
>> >
>> > Examples? :)
>>
>> balance_leaf() in fs/reiserfs/do_balan.c
>>
>> Example picked totally at random:
>>
>> =A0 =A0 =A0 set_le_ih_k_offset(ih,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0le_ih_k_offset(ih=
) +
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(tb->
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 lbytes <<
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (is_indirect_le_=
ih
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(ih) ? tb->tb=
_sb->
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0s_blocksize_b=
its -
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0UNFM_P_SHIFT =
:
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A00)));
>>
>> See how everything is nicely aligned to 80 cols?
>
> I see but the above code is an utter crap anyway.
>
> Firstly what kind of a function parameter is that:
>
> =A0 le_ih_k_offset(ih) + (tb->lbytes << (is_indirect_le_ih(ih) ? tb->=
tb_sb->s_blocksize_bits - UNFM_P_SHIFT : 0))
>
> ?
>
> [ BTW 'tb->tb_sb->s_blocksize_bits - UNFM_P_SHIFT' construct is used =
five
> =A0times in balance_leaf() and is a likely candidate for helper / mac=
ro. ]
>
> More importantly the whole balance_leaf() function is almost 1400 LOC=
 (!)
> big and impossible to read: code for handling particular 'switch' blo=
cks
> should be factored out into separate functions etc.
>
> The point I was making is that the once we remove the limit we don't =
have
> other tool to _automatically_ point suspicious code areas (yes, I wou=
ld
> also prefer intelligent static code checker over dumb limit but it si=
mply

A static code checker (like sparse) could do much more intelligent
wrapping analysis.  Maybe someone will take this up as a thesis
project and provide a replacement for indent. Post example
reformattings to LKML until the formatting gods are satisfied.

The problem I see is that C statements that over over 50 chars or so
should be flagged if they aren't declarations or strings. That's an
independent problem from excessive nesting. Tools like ident aren't
smart enough to separate these problems and flags the combination of
statement length and nesting.

I'd be a lot happier if someone simply patched out all of the trailing
whitespace that has gotten in to the kernel tree over the years.
jonsmirl@terra:~/fs$ grep -rI [[:space:]]$ * | wc
  47804  231898 2888009

> not here as things are today and dumb limit works surprisingly well m=
ost
> of the time -- please note how that the structural problem with the c=
ode
> example given is immediately visible with the current limit).
>
>> Generally, don't look at this function after having a good lunch you=
 want
>> to keep. You have been warned.
>
> No worries, I visit dark places (ide, staging, ..) and come back aliv=
e.. ;)
>
> --
> Bartlomiej Zolnierkiewicz
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kerne=
l" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at =A0http://www.tux.org/lkml/
>



--=20
Jon Smirl
jonsmirl@gmail.com
