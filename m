From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [dm-devel] WANTED new maintainer for Linux/md (and mdadm)
Date: Fri, 08 Jan 2016 15:28:15 -0500
Message-ID: <wrfj4menizog.fsf@redhat.com>
References: <87k2o849j5.fsf@notabene.neil.brown.name>
	<0AAF8A3C-BE70-4510-A8EA-F64B2F4A0B4D@redhat.com>
	<wrfja8oimyyk.fsf@redhat.com>
	<878u40ak6u.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <878u40ak6u.fsf@notabene.neil.brown.name> (NeilBrown's message of
	"Fri, 08 Jan 2016 13:17:45 +1100")
Sender: linux-kernel-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Brassow Jonathan <jbrassow@redhat.com>, device-mapper development <dm-devel@redhat.com>, linux-raid@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>, Phil Turmel <philip@turmel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Doug Ledford <dledford@redhat.com>, Xiao Ni <xni@redhat.com>
List-Id: dm-devel.ids

NeilBrown <neilb@suse.de> writes:
> On Thu, Jan 07 2016, Jes Sorensen wrote:
>
>> Brassow Jonathan <jbrassow@redhat.com> writes:
>>> Many thanks Neil for all the work you=E2=80=99ve done and the help =
you gave me
>>> while working on the DM/MD interactions bits.  I=E2=80=99m happy yo=
u are
>>> sticking around for the raid1-cluster and raid5-journal bits and I=E2=
=80=99m
>>> interested to see what comes out of those.
>>>
>>> I know there are a number of folks around Red Hat who are capable a=
nd
>>> possibly interested to share the load.  They should be back from PT=
O
>>> soon and we=E2=80=99ll make sure they know about the opportunity.
>>
>> Thanks Neil!
>>
>> I mentioned to Neil last year that I could probably be convinced,
>> bribed, shamed, into maintaining mdadm.
>
> I realise that is somewhat tongue-in-cheek, but I am certainly not
> looking for someone who needs to be convinced, bribed, or shamed.  I'=
m
> hoping for someone who will weigh the pros and cons, decide this is a
> contribution they are willing (and maybe even eager) to make, and wil=
l
> step up and do so.  And I suspect that behind that facade of
> reluctance, that is what you are really offering.  Thanks.
>
> I propose to make one last release of mdadm either next week or the l=
ast
> week of January.  I plan to call it "3.4" in acknowledgment of the ne=
w
> cluster and raid5-journal functionality.
> If you were to take it from there, I would be grateful.

Hi Neil,

I wouldn't have offered to take on mdadm if I hadn't meant it, even if =
I
like making the wording sound silly :) I feel I can do a decent job at
it and the task should be reasonable in scope. If someone is dying to
take it on, I am not going to stand in their way, but I feel mdadm need=
s
a maintainer and it's a worthy effort.

We'll have to figure out the logistics, and I'd like to coordinate with
who takes on drivers/md

Cheers,
Jes

>
> Thanks,
> NeilBrown
>
>>
>> The kernel MD stack I think really needs a team to run it. There is =
just
>> too much internal knowledge sitting in Neil's head and I personally =
am a
>> little scared of taking on that. Shaohua Li would be a good candidat=
e
>> for that team IMHO.
>>
>> Cheers,
>> Jes
>>
>>
>>> thanks,
>>>  brassow
>>>
>>>> On Dec 21, 2015, at 12:10 AM, NeilBrown <neilb@suse.com> wrote:
>>>>=20
>>>>=20
>>>> hi,
>>>> I became maintainer for md (Linux Software RAID) in late 2001 and =
on
>>>> the whole it has been fun and a valuable experience.  But I have b=
een
>>>> losing interest in recent years (https://lwn.net/Articles/511073/)=
 and
>>>> as was mentioned at the kernel summit, I would like to resign.  So=
me
>>>> years ago I managed to hand over nfsd to the excellent Bruce Field=
s,
>>>> but I do not seem to have the gift that Linus has of attracting
>>>> maintainers.  While there are a number of people who know quite a =
bit
>>>> about md and/or have contributed to development, there is no obvio=
us
>>>> candidate for replacement maintainer - no one who has already been
>>>> doing significant parts of the maintainer role.
>>>>=20
>>>> So I have decided to fall back on the mechanism by which I ended u=
p
>>>> being maintainer in the first place.  I will create a vacuum and h=
ope
>>>> someone fills it (yes: I was sucked-in....).  So as of 1st Februar=
y
>>>> 2016 I will be resigning.
>>>>=20
>>>> At the kernel summit in October Linus talked about the value of
>>>> maintainership teams (https://lwn.net/Articles/662979/).  I think =
it
>>>> would be great if a (small) team formed to continue to oversee md
>>>> rather than just a single individual (or maybe the dm team could e=
xtend
>>>> to include md??).  If I had managed to be part of a team rather th=
an
>>>> "going it alone" for so long, I might feel less tired of the whole
>>>> thing now.
>>>>=20
>>>> I don't see it as my place to appoint that team or any individuals=
, or
>>>> even to nominate any candidates.  A very important attribute of a
>>>> maintainer is that they need to care about the code and the subsys=
tem
>>>> and I cannot tell other people to care (or even know if they do). =
 It
>>>> is really up to individuals to volunteer.  A few people have been
>>>> mentioned to me in earlier less-public conversations.  Any of them=
 may
>>>> well be suitable, but I would rather they named themselves if
>>>> interested.
>>>>=20
>>>> So I'm hoping to get one or more volunteers to be maintainer:
>>>>   - to gather and manage patches and outstanding issues,
>>>>   - to review patches or get them reviewed
>>>>   - to follow up bug reports and get them resolved
>>>>   - to feed patches upstream, maybe directly to Linus,
>>>>     maybe through some other maintainer, depending on what
>>>>     relationships already exist or can be formed,
>>>>   - to guide the longer term direction (saying "no" is important
>>>>     sometimes),
>>>>   - to care,
>>>> but also to be aware that maintainership takes real effort and tim=
e, as
>>>> does anything that is really worthwhile.
>>>>=20
>>>> This all applies to mdadm as well as md (except you would ultimate=
ly
>>>> *be* upstream for mdadm, not needing to send it anywhere).  Even i=
f a
>>>> clear team doesn't form it would be great if different people
>>>> maintained mdadm and md.
>>>>=20
>>>> One part of the job that I have put a lot of time in to is followi=
ng
>>>> the linux-raid@vger.kernel.org list and providing support.  This m=
akes
>>>> people feel good about md and so more adventurous in using it.
>>>> Consequently I tend to hear about bugs and usability issues nice a=
nd
>>>> early (well before paying customers hit them in most cases) and th=
at is
>>>> a big win.
>>>> In recent times I've been doing less of this and have been absolut=
ely
>>>> thrilled that the gap has been more than filled by other very comp=
etent
>>>> community members.  Not developers particular but a number of md u=
sers
>>>> have been providing excellent support.  I'd particularly like to
>>>> high-light Phil Turmel who is very forthcoming with excellent advi=
ce,
>>>> but he is certainly not the only one who deserves a lot of thanks.
>>>> So "Thank you" to everyone who answers questions on linux-raid.
>>>>=20
>>>> This would be a good place for any future maintainer to hang out t=
o
>>>> receive wisdom as well as to provide support.
>>>>=20
>>>> I will still be around.  I can certainly help out in some sort of
>>>> mentor role, and can probably be convinced to review patches and
>>>> comment on designs.  But I really want to head towards spending le=
ss
>>>> time on md (there are so many other interesting things to learn ab=
out).
>>>>=20
>>>> So: if anyone is interested - please announce yourself, ask questi=
ons
>>>> and start doing things.  I have no clear idea about how a transiti=
on
>>>> will happen.  That is really up to you (plural). Take the bull by =
the
>>>> horns and start *being* a maintainer(team).  I won't get in your w=
ay
>>>> and I'll help where I can.
>>>>=20
>>>> Thanks,
>>>> NeilBrown
>>>>=20
>>>> P.S. I'm committed to continue to work with the raid5-journal effo=
rt
>>>> From Facebook and the raid1-cluster effort from SUSE and the
>>>> line-in-the-sand of 1st February won't affect my support for those=
=2E
>>>> --
>>>> dm-devel mailing list
>>>> dm-devel@redhat.com
>>>> https://www.redhat.com/mailman/listinfo/dm-devel
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-rai=
d" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
