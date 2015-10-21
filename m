From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH 04/18] retrigger uevents to try and get the
 uid through udev
Date: Wed, 21 Oct 2015 17:20:50 -0500
Message-ID: <20151021222050.GX2872@octiron.msp.redhat.com>
References: <1444333491-16265-1-git-send-email-bmarzins@redhat.com>
	<1444333491-16265-5-git-send-email-bmarzins@redhat.com>
	<561B55EA.1090205@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <561B55EA.1090205@suse.de>
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

On Mon, Oct 12, 2015 at 08:40:42AM +0200, Hannes Reinecke wrote:
> On 10/08/2015 09:44 PM, Benjamin Marzinski wrote:
> > Ideally, udev will be able to grab the wwid when a path device is
> > discovered, but sometimes this isn't possible. In these cases, the
> > best thing that could happen would be for udev to actually get the
> > information, and add it to its database. This patch makes multipath
> > retrigger uevents a limited number of times before giving up and
> > trying to get the information itself.
> > =

> > There are two configurables that control how it does this,
> > "retrigger_tries" and "retrigger_delay". The first sets the number of
> > times it will try to retrigger a uevent to get the wwid, the second
> > sets the amount of time to wait between retriggers.
> > =

> > This patch currently only tries reinitializing the path on change events
> > after multipathd has triggered a change event, and it only tries once
> > per triggered change event.  Now, its possible that other change events
> > could occur on the device without multipathd tirggering them.  As the
> > patch stands now, it won't try to initialize the device on those.  It w=
ill,
> > however still try in the checkerloop, but only after it has finished
> > retriggering the uevents. We could be much more aggressive here, and as=
sume
> > that devices that simply won't have a WWID should already be taken care=
 of
> > by the blacklists, so it would be always a good idea to recheck devices=
 on
> > change events. What would be ideal is if udev would let us know when it=
 had
> > problems or timed out when processing a uevent, so we would know if
> > retriggering the uevent would be useful.
> > =

> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > ---
> Hmm. Yes, this 'udev killing worker after a certain time' is a major
> pain. And we've tried to work around it, too.
> With various degrees of success.
> But I'm not sure if retriggering is a good idea here; we simply have
> no idea if the failure is legit or not.
> =

> Can't we work with the udev/systemd folks to add a variable telling
> us that udev killed the worker?

If we can get a variable to know when retriggering is a good idea, I'd
be happy to use it, like I said above. But as it stands, I don't have a
better way to solve this right now, and it's causing real issues right
now. If you have a better idea, please post it.

-Ben

> =

> Cheers,
> =

> Hannes
> -- =

> Dr. Hannes Reinecke		               zSeries & Storage
> hare@suse.de			               +49 911 74053 688
> SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
> GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
> HRB 21284 (AG N=FCrnberg)
> =

> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
