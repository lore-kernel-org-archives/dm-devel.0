From: Martin Wilck <martin.wilck@suse.com>
Subject: Re: [RFC PATCH v2 0/3] add library to check if device is
 a valid path
Date: Fri, 25 Sep 2020 10:01:01 +0000
Message-ID: <2151af2280728eeeea5404bcda3cd6411a7173f5.camel@suse.com>
References: <1600923569-17412-1-git-send-email-bmarzins@redhat.com>
	<01ce499f8c7a7248f560066054ba4dd922bbc338.camel@suse.com>
	<20200924163007.GG11108@octiron.msp.redhat.com>
	<53ad2ea2f8457030eac247420fcc564bd5608ab8.camel@suse.com>
	<20200925010846.GL11108@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200925010846.GL11108@octiron.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Content-Language: en-US
Content-ID: <FD44D69170761A4B95EA32AABF90F001@eurprd04.prod.outlook.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Thu, 2020-09-24 at 20:08 -0500, Benjamin Marzinski wrote:
> On Thu, Sep 24, 2020 at 07:22:21PM +0000, Martin Wilck wrote:
> >=20
> > So, SID will call into libmultipath via libmpathvalid, udev will
> > obtain
> > the properties from SID, and multipathd will fetch them from udev
> > in
> > turn? Or will multipathd talk directly to SID? I seem to be missing
> > the
> > overall picture.
>=20
> Yeah. SID will populate the udev database with the necessary udev
> properties, and multipathd will get those udev properties just like
> it
> always does.=20

But then I'm not getting how you'll get along with a SID-specific
configuration for libmultipath's behavior. You want get_uid() to use
direct sysfs access for SID, and use udev for multipath(d). How else
would you achieve that?

More generally, I'm not quite convinced of the the design yet. The
information flow kernel -> (sysfs or ioctl) -> libmultipath(sid mode)=20
-> libmpathvalid -> SID -> udev -> udev db -> libudev -> libmultipath
(udev mode) -> multipathd is more complex than it needs to be. It might
actually increase the lags experienced by multipathd, which will still
have to wait for uevent workers to finish until it can be certain about
device properties. Not to mention that SID must be rock stable and
always available during boot, initrd processing, etc.

Why don't we rather write a common library for determining WWIDs and
the "should be multipathed" predicate, to be used by udev (with a
plugin), multipath-tools, SID, and possibly other tools like systemd
and LVM, with common, simple configuration, guaranteed to always
provide the same results? I mean, libmultipath already has all the
"intelligence" built-in to do this. We'd "just" need to cut down
configuration options drastically to get more reprocucible results, and
refactor things to obtain a minimalistic API. Unlike the current
libmpathvalid design, this wouldn't be built on top of current
libmultipath, rather vice-versa. multipath-tools would also benefit a
lot from such work.

Regards
Martin

--=20
Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
SUSE  Software Solutions Germany GmbH
HRB 36809, AG N=FCrnberg GF: Felix
Imend=F6rffer
