From: NeilBrown <neilb@suse.de>
Subject: Re: [dm-devel] WANTED new maintainer for Linux/md (and mdadm)
Date: Fri, 08 Jan 2016 13:17:45 +1100
Message-ID: <878u40ak6u.fsf@notabene.neil.brown.name>
References: <87k2o849j5.fsf@notabene.neil.brown.name> <0AAF8A3C-BE70-4510-A8EA-F64B2F4A0B4D@redhat.com> <wrfja8oimyyk.fsf@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <wrfja8oimyyk.fsf@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jes Sorensen <Jes.Sorensen@redhat.com>, Brassow Jonathan <jbrassow@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, linux-raid@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>, Phil Turmel <philip@turmel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Doug Ledford <dledford@redhat.com>, Xiao Ni <xni@redhat.com>
List-Id: dm-devel.ids

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 07 2016, Jes Sorensen wrote:

> Brassow Jonathan <jbrassow@redhat.com> writes:
>> Many thanks Neil for all the work you=E2=80=99ve done and the help you g=
ave me
>> while working on the DM/MD interactions bits.  I=E2=80=99m happy you are
>> sticking around for the raid1-cluster and raid5-journal bits and I=E2=80=
=99m
>> interested to see what comes out of those.
>>
>> I know there are a number of folks around Red Hat who are capable and
>> possibly interested to share the load.  They should be back from PTO
>> soon and we=E2=80=99ll make sure they know about the opportunity.
>
> Thanks Neil!
>
> I mentioned to Neil last year that I could probably be convinced,
> bribed, shamed, into maintaining mdadm.

I realise that is somewhat tongue-in-cheek, but I am certainly not
looking for someone who needs to be convinced, bribed, or shamed.
I'm hoping for someone who will weigh the pros and cons, decide this is
a contribution they are willing (and maybe even eager) to make, and will
step up and do so.
And I suspect that behind that facade of reluctance, that is what you
are really offering.  Thanks.

I propose to make one last release of mdadm either next week or the last
week of January.  I plan to call it "3.4" in acknowledgment of the new
cluster and raid5-journal functionality.
If you were to take it from there, I would be grateful.

Thanks,
NeilBrown

>
> The kernel MD stack I think really needs a team to run it. There is just
> too much internal knowledge sitting in Neil's head and I personally am a
> little scared of taking on that. Shaohua Li would be a good candidate
> for that team IMHO.
>
> Cheers,
> Jes
>
>
>> thanks,
>>  brassow
>>
>>> On Dec 21, 2015, at 12:10 AM, NeilBrown <neilb@suse.com> wrote:
>>>=20
>>>=20
>>> hi,
>>> I became maintainer for md (Linux Software RAID) in late 2001 and on
>>> the whole it has been fun and a valuable experience.  But I have been
>>> losing interest in recent years (https://lwn.net/Articles/511073/) and
>>> as was mentioned at the kernel summit, I would like to resign.  Some
>>> years ago I managed to hand over nfsd to the excellent Bruce Fields,
>>> but I do not seem to have the gift that Linus has of attracting
>>> maintainers.  While there are a number of people who know quite a bit
>>> about md and/or have contributed to development, there is no obvious
>>> candidate for replacement maintainer - no one who has already been
>>> doing significant parts of the maintainer role.
>>>=20
>>> So I have decided to fall back on the mechanism by which I ended up
>>> being maintainer in the first place.  I will create a vacuum and hope
>>> someone fills it (yes: I was sucked-in....).  So as of 1st February
>>> 2016 I will be resigning.
>>>=20
>>> At the kernel summit in October Linus talked about the value of
>>> maintainership teams (https://lwn.net/Articles/662979/).  I think it
>>> would be great if a (small) team formed to continue to oversee md
>>> rather than just a single individual (or maybe the dm team could extend
>>> to include md??).  If I had managed to be part of a team rather than
>>> "going it alone" for so long, I might feel less tired of the whole
>>> thing now.
>>>=20
>>> I don't see it as my place to appoint that team or any individuals, or
>>> even to nominate any candidates.  A very important attribute of a
>>> maintainer is that they need to care about the code and the subsystem
>>> and I cannot tell other people to care (or even know if they do).  It
>>> is really up to individuals to volunteer.  A few people have been
>>> mentioned to me in earlier less-public conversations.  Any of them may
>>> well be suitable, but I would rather they named themselves if
>>> interested.
>>>=20
>>> So I'm hoping to get one or more volunteers to be maintainer:
>>>   - to gather and manage patches and outstanding issues,
>>>   - to review patches or get them reviewed
>>>   - to follow up bug reports and get them resolved
>>>   - to feed patches upstream, maybe directly to Linus,
>>>     maybe through some other maintainer, depending on what
>>>     relationships already exist or can be formed,
>>>   - to guide the longer term direction (saying "no" is important
>>>     sometimes),
>>>   - to care,
>>> but also to be aware that maintainership takes real effort and time, as
>>> does anything that is really worthwhile.
>>>=20
>>> This all applies to mdadm as well as md (except you would ultimately
>>> *be* upstream for mdadm, not needing to send it anywhere).  Even if a
>>> clear team doesn't form it would be great if different people
>>> maintained mdadm and md.
>>>=20
>>> One part of the job that I have put a lot of time in to is following
>>> the linux-raid@vger.kernel.org list and providing support.  This makes
>>> people feel good about md and so more adventurous in using it.
>>> Consequently I tend to hear about bugs and usability issues nice and
>>> early (well before paying customers hit them in most cases) and that is
>>> a big win.
>>> In recent times I've been doing less of this and have been absolutely
>>> thrilled that the gap has been more than filled by other very competent
>>> community members.  Not developers particular but a number of md users
>>> have been providing excellent support.  I'd particularly like to
>>> high-light Phil Turmel who is very forthcoming with excellent advice,
>>> but he is certainly not the only one who deserves a lot of thanks.
>>> So "Thank you" to everyone who answers questions on linux-raid.
>>>=20
>>> This would be a good place for any future maintainer to hang out to
>>> receive wisdom as well as to provide support.
>>>=20
>>> I will still be around.  I can certainly help out in some sort of
>>> mentor role, and can probably be convinced to review patches and
>>> comment on designs.  But I really want to head towards spending less
>>> time on md (there are so many other interesting things to learn about).
>>>=20
>>> So: if anyone is interested - please announce yourself, ask questions
>>> and start doing things.  I have no clear idea about how a transition
>>> will happen.  That is really up to you (plural). Take the bull by the
>>> horns and start *being* a maintainer(team).  I won't get in your way
>>> and I'll help where I can.
>>>=20
>>> Thanks,
>>> NeilBrown
>>>=20
>>> P.S. I'm committed to continue to work with the raid5-journal effort
>>> From Facebook and the raid1-cluster effort from SUSE and the
>>> line-in-the-sand of 1st February won't affect my support for those.
>>> --
>>> dm-devel mailing list
>>> dm-devel@redhat.com
>>> https://www.redhat.com/mailman/listinfo/dm-devel
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWjxxJAAoJEDnsnt1WYoG53EwP/A5LX9kqaQ9M/YXcnPg8pVbU
0OOdhXVI/NlpqWsCpgapLXTz+JcoCPLly27ugTD/JyboXq8fXfwQ0GI0EzwdR/tu
PDWbPgOJuNQXDUCYeHYVXyMyhbAisfLRWb1fONJ9aR//k8bRDEItmf0hYGbB7mwq
ODmNAmuDF+73yaN4lneoiZqsBXpXUeVi0L9EsL4XnttpJ5lIhCNuHmI3+D+xHJQ1
sY1pGQQoBUSqO1jW98GPXAfcs8ET0qMnlVKypqDy39sV2DPsClcnt6s8+ahuOewL
ZJTBsbcmChaswP3vZHXAEh2AGwtgI2VC1OGlZ9m9iQyHareVat5cmP3JMwc09+Xe
tFxnhxu0r7p2yce6RqK3AZWYWYTh8d9H94OLmyXY7ulENDYyxSBY3csCVoZaFfLM
xmO9Aq6+6smbx2H/bZk3bnjbLiLk37ybcd5B+DvMbr1uJfogJFuBXzWRTui9hsyA
V7O/qmRLfuxgtINk270W5tfD6VdUHeIc214rdBd3ghsJgVWVl9cB7m/+Gd0SdRkK
1jiVE7e+LGXbdK0mHmbaGiEFOeE4+4aEgxmA+PJFLkgVeqJoMERpQ41zG3qPMqKX
u1rhkfY+Asw8CfswIcrppqzAKQiZhjStzyWSac7rQQ7VqrjKKFXgjA2UsoNTatAA
iQVkKn/i7BM8MC1kRGzh
=BC7F
-----END PGP SIGNATURE-----
--=-=-=--
