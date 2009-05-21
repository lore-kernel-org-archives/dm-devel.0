From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: [RFC PATCH] dm-csum: A new device mapper target that checks data
	integrity
Date: Thu, 21 May 2009 14:17:58 -0400
Message-ID: <87f94c370905211117y13758f72i2ea113c9c6771061@mail.gmail.com>
References: <20090521161317.GU1376@blitiri.com.ar>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090521161317.GU1376@blitiri.com.ar>
Sender: linux-raid-owner@vger.kernel.org
To: Alberto Bertogli <albertito@blitiri.com.ar>
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, agk@redhat.com, neilb@suse.de
List-Id: dm-devel.ids

On Thu, May 21, 2009 at 12:13 PM, Alberto Bertogli
<albertito@blitiri.com.ar> wrote:
>
> Hi!
>
> I'm writing this device mapper target that stores checksums on writes=
 and
> verifies them on reads.
>
> It's not widely tested, but you can run mke2fs on it and do basic fil=
e
> operations. The to-do list is still large, and most of it can be foun=
d within
> the code.
>
> To test it, you will need to format the device using the (very rough)=
 attached
> tool, and then create the dm device with something like:
>
> =A0 =A0 =A0 =A0echo 0 $SIZE csum $REALDEVICE 0 | dmsetup create $NAME
>
>
> I think it can be useful for people who want to detect data corruptio=
n and are
> either using the block layer directly or a filesystem that doesn't ch=
eck data
> integrity (which are most, if not all, of the popular ones today). Ma=
ybe it
> could also be used for testing the bio-integrity extensions, although=
 at the
> moment it's completely independent and I haven't looked much, but it'=
s on my
> to-do list.
>
> It does NOT pretend to be useful for consistency checks for security =
purposes.
> Use something else if you do not want someone evil tampering with you=
r data.
>
>
> Comments are obviously welcome. There are also some questions embedde=
d in the
> code, if anyone cares to answer any of them, I'd really appreciate it=
=2E
>
> Thanks a lot,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0Alberto

I have not looked at your patch, but does this tie into the integrity
logic that was added to mainline a few months ago?

I'm not sure if it should or not, but I am curious how it ties in.

Greg
--=20
Greg Freemyer
Head of EDD Tape Extraction and Processing team
Litigation Triage Solutions Specialist
http://www.linkedin.com/in/gregfreemyer
=46irst 99 Days Litigation White Paper -
http://www.norcrossgroup.com/forms/whitepapers/99%20Days%20whitepaper.p=
df

The Norcross Group
The Intersection of Evidence & Technology
http://www.norcrossgroup.com
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
