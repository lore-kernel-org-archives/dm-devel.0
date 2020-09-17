From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH 3/3] libmultipath: add ignore_udev_uid option
Date: Thu, 17 Sep 2020 18:36:31 -0500
Message-ID: <20200917233631.GS11108@octiron.msp.redhat.com>
References: <1600206312-6497-1-git-send-email-bmarzins@redhat.com>
	<1600206312-6497-4-git-send-email-bmarzins@redhat.com>
	<6442fa8e24eaa44a5487d16de95a712ed9d76125.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <6442fa8e24eaa44a5487d16de95a712ed9d76125.camel@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Content-Disposition: inline
To: Martin Wilck <martin.wilck@suse.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Wed, Sep 16, 2020 at 02:46:18PM +0000, Martin Wilck wrote:
> Hi Ben,
>=20
> On Tue, 2020-09-15 at 16:45 -0500, Benjamin Marzinski wrote:
> > Setting this option to yes will force multipath to get the uid by
> > using
> > the fallback sysfs methods, instead of getting it from udev. This
> > will
> > cause devices that can't get their uid from the standard locations to
> > not get a uid. It will also disable uevent merging.
> >=20
> > It will not stop uevents from being resent for device that failed to
> > get a WWID, although I'm on the fence about the benefit of this.
> >=20
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
>=20
> Can you explain how this differs from setting uid_attribute to the
> empty string (and leaving uid_attrs at the default, empty)?
>=20
> The patch is alright, but the configuration of WWID determination is
> already sooo complicated... I'm not too happy about adding yet another
> option which complicates matters further. IMO we should rather attempt
> to make this easier for users (meaning less options, less combinations
> thereof, and less "x supersedes y but only if z is not set" kind of
> logic). This is not a nack, I just want to understand.

Ummm... Actually, I hadn't thought of using

overrides {
=09uid_attribute ""
}

to test SID.  That works, so this patch is unnecessary. I hope you don't
object to me changing the code to log at level 3 if uid_attribute is
configured to "". In this case, using the fallback methods is
expected, so I don't see a need to log at a higher priority.

-Ben
=20
> Regards
> Martin
>=20
> --
> Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
> SUSE  Software Solutions Germany GmbH
> HRB 36809, AG N=FCrnberg GF: Felix
> Imend=F6rffer
>=20
