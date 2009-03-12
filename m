From: Hannes Reinecke <hare@suse.de>
Subject: Re: Multipath architecture.
Date: Thu, 12 Mar 2009 08:33:57 +0100
Message-ID: <49B8BAE5.3000508@suse.de>
References: <1236823104.22679.71.camel@agari.van.xensource.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1236823104.22679.71.camel@agari.van.xensource.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

Hi Daniel,

Daniel Stodden wrote:
> Hi.
>=20
> Can someone spare a little time to help me understand the multipath
> utility and daemon a little better?
>=20
> I read myself through the available documentation. The refbook says tha=
t
> it's multipath who's creating maps, and multipathd responsible for path
> checking.
>=20
Well, yes, in principle.

> Running multipath (at least the version 0.4.7 I've got here), this
> actually doesn't seem to be the case. Unless I'm totally mistaken,
> multipathd actually does create DM maps as paths are discovered. And no=
t
> just fork/exec the utility as many sources (most notably the man page)
> state.
>=20
Indeed, that has changed. The multipath binary is basically obsolete
now, as the daemon is capable of discovering new paths itself.

> No, I'm not asking for general advice on how old documentation relates
> to new code. :)
>=20
> My question here would be rather: Everywhere I've been looking at until
> now there's seems to be a multipath %M:%m being run from udev. In
> addition to the running daemon.
>=20
Not everywhere :-)

What should be done is to have multipathd read uevent from a socket
provided by udev. Then multipathd won't race with udev and will handle
device events directly. The multipath binary itself is then just
used for maintenance and manual configuration changes.

Look on OpenSUSE 11.1 / SLES11 on how it's done.

> Is this redundant or does the run from udevd still add some major value=
?
>=20
Definitely.
multipathd requires a device node for path checkers etc, so it has to wai=
t
until udev has created one. Plus udev runs separate programs (vol_id etc)
which will add additional information to the uevent; some of which can
be used by multipathd.

The end goal here is to remove the scsi_id callout from multipathd and
use the udev provided information. And, indeed, have all information
provided by udev so that multipathd doesn't have to look for it
itself; most of which is already present, so it's only a slight change
to udev to add the remaining information.

Be advised that there are several bugs in the upstream code, so trying
this on a recent kernel with give you an 'interesting' user experience.
I have some (well, for rather large numbers of 'some') patches on my
git tree at

git://git.kernel.org/pub/scm/linux/kernel/git/hare/multipath-tools.git
branch sles11

so you might have a look there. And yes, I'll be posting them here
in the near future. I don't _want_ to keep them private, but somehow
customers insist on sending me new bug descriptions thus preventing
me from cleaning them up and posting them.

Do feel free to comment on them.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
