From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: RHEL 6: Missing /dev/mpath directory
Date: Sat, 7 May 2011 08:25:58 -0400
Message-ID: <20110507122558.GB4122@redhat.com>
References: <BANLkTimUvQu8zhLSyxiO3TP-uVV9Z4NEvQ@mail.gmail.com>
	<20110506174745.GA26776@redhat.com>
	<BANLkTi=+m2+SEONX7HMXoOF-TmonTeedJA@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <BANLkTi=+m2+SEONX7HMXoOF-TmonTeedJA@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Sat, May 07 2011 at  5:54am -0400,
Gianluca Cecchi <gianluca.cecchi@gmail.com> wrote:

> On Fri, May 6, 2011 at 7:47 PM, Mike Snitzer <snitzer@redhat.com> wrote:
> =

> >> In my host I am seeing the devices only as /dev/dm-n and /dev/mapper/m=
pathx
> =

> >
> > Seems we need to update the RHEL6 docs you referenced.
> >
> > /dev/mpath/ namespace is no longer maintained (afaik it was a "feature"
> > of a udev rule. =A0But I could be mistaken. =A0Ben and/or others could
> > correct me if I'm wrong).
> >
> > /dev/mapper/mpath* was always the preferred method of access (even when
> > /dev/mpath/* did exist) -- reason is it was always available regardless
> > of udev.
> >
> =

> Am I correct to say that /dev/dm-* should be used only internally by
> device-mapper and not referred to by user programs?
> At least I remember I read something similar...

Yes, that is correct.
