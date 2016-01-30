From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2] dm pref-path: provides preferred path load balance
 policy
Date: Sat, 30 Jan 2016 09:32:53 +0100
Message-ID: <56AC7535.2090401@suse.de>
References: <1453469502-15606-1-git-send-email-ravikanth.nalla@hpe.com>
 <56A231C8.90602@suse.de> <20160122165932.GA28761@redhat.com>
 <49D617FA63152941907AADE32CF072F12FD72905@G4W3202.americas.hpqcorp.net>
 <20160129175059.GB24960@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160129175059.GB24960@octiron.msp.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Benjamin Marzinski <bmarzins@redhat.com>, "Nalla, Ravikanth" <ravikanth.nalla@hpe.com>
Cc: Mike Snitzer <snitzer@redhat.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "corbet@lwn.net" <corbet@lwn.net>
List-Id: dm-devel.ids

On 01/29/2016 06:50 PM, Benjamin Marzinski wrote:
> On Fri, Jan 29, 2016 at 02:10:52PM +0000, Nalla, Ravikanth wrote:
>> Hi Mike, Hannes, Ben
>>> This seems like a problem that has already been solved with path gr=
oups.
>>> If the path(s) in your preferred path group are there, multipath wi=
ll
 >>> use them.  If not, then it will use your less preferred path(s), a=
nd
 >>> load balance across them > how ever you choose with the path_selec=
tors.
>>>
>>> I admit that we don't have a path prioritizer that does a good job =
of
 >>> allowing users to manually pick a specific path to prefer.  But it=
=20
seems
 >>> to me that there is > >where we should be solving the issue.
>>>
>> Yes as  mentioned , it appears that we will be able to achieve the s=
ame
 >> result using the above multipath{...} configuration. However as you
 >> mentioned I felt that it is not that user friendly in specify the p=
ath
 >> to prefer. So when you mentioned about solving the problem there, c=
ould
 >> you please clarify on what you had in mind and is there anything=20
specific
 >> from our implementation that can be used there ?
>>
>
> There are two changes that I'm working on.
>
> 1. I'm adding an option for the alua prioritizer so that setting the
> ALUA TPG Preferred Bit will cause the alau prioritizer to put that pa=
th
> in a group by itself (with the highest priority). Currently if the
> preferred bit is set for an active/optimized path, and there are othe=
r
> active/optimized paths, they are all grouped together, and there is n=
o
> way to change that. So, for people with ALUA enabled hardware, they c=
an
> just enable the option, and set the Preferred Bit.
>
Hmm? I was under the distinct impression that it's exactly the other wa=
y=20
round; at least in my code I have this:

                 switch(aas) {
                         case AAS_OPTIMIZED:
                                 rc =3D 50;
                                 break;
                         case AAS_NON_OPTIMIZED:
                                 rc =3D 10;
                                 break;
                         case AAS_LBA_DEPENDENT:
                                 rc =3D 5;
                                 break;
                         case AAS_STANDBY:
                                 rc =3D 1;
                                 break;
                         default:
                                 rc =3D 0;
                 }
                 if (priopath && aas !=3D AAS_OPTIMIZED)
                         rc +=3D 80;

ie any path with the 'prio' bit set will be getting a differen priority=
=20
than those without. Consequently they'll be grouped into different=20
priority groups.
I'd be surprised if your code is different, but what do I know ...

> 2. For people that need to be able to control the exact priority, I'm
> redoing the weighted handler to allow better ways to specify the path=
s
> in a presistent manner.  It won't be as simple as the alua method, bu=
t
> it will be actually usable, unlike it's current state.
>
That, however, is greatly appreciated :-)

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
