From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [RFC PATCH v2 0/3] add library to check if device is
	a valid path
Date: Thu, 24 Sep 2020 11:30:07 -0500
Message-ID: <20200924163007.GG11108@octiron.msp.redhat.com>
References: <1600923569-17412-1-git-send-email-bmarzins@redhat.com>
	<01ce499f8c7a7248f560066054ba4dd922bbc338.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <01ce499f8c7a7248f560066054ba4dd922bbc338.camel@suse.com>
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

On Thu, Sep 24, 2020 at 08:18:02AM +0000, Martin Wilck wrote:
> On Wed, 2020-09-23 at 23:59 -0500, Benjamin Marzinski wrote:
> > The main part of the this patchset is the first patch, which adds a
> > new library interface to check whether devices are valid paths. This
> > was designed for use in the Storage Instantiation Daemon (SID).
> >=20
> > https://github.com/sid-project
> >=20
> > Hopefully, I've removed all the controvertial bits from the last time
> > I
> > proposed this library.
> >=20
> > The second patch adds get_uid fallback code for dasd devices. The
> > third
> > patch just changes the get_uid log level for devices configured with
> > uid_attribute "". This is because it is currently necessary to
> > configure
> > multipath with
> >=20
> > overrides {
> >         uid_attribute ""
> > }
> >=20
> > to claim multipath devices with SID (instead of using
> > multipath.rules),
> > since SID doesn't currently get the UID information itself, and it is
> > called by udev before this information is added to the udev database.
> >=20
>=20
> This makes me wonder how SID and multipathd are supposed to coexist.
> We wouldn't want this overrides directive for multipathd itself, would
> we?

Don't we need it to be used by everything?  We certainly don't want
multipathd to get a different value for the wwid than SID has. It seems
like all programs that access the multipath devices should use the same
method to get the WWIDs.

The long term solution is that SID will call out to the devices, and
grab these uid attributes, just like udev currently does. It already
does this for the blkid values. When SID is running, these udev rules
will be disabled, and SID will provide udev with this data. So
eventually, multipath won't need any configuration changes to work with
SID. setting this overrides line is just a stop-gap, so that people can
test SID and multipath now.=20

-Ben
=20
> Actually that "overrides" begs for allowing a custom configuration file
> for libmultipath to be used with SID. OTOH, that would allow the
> configurations to diverge, which might cause issues, too (in particular
> if blacklisting options were different).
>=20
> I think what we should do is allow applications to set overrides like
> this at runtime, modifying the configuration. Perhaps we could support
> an application-specific, additional config_dir, from which items like
> the above could be read in addition to the regular configuration files.
> This additional configuration would not be used by multipathd and
> multipath. Does that make sense?
>=20
> Regards
> Martin
>=20
> --=20
> Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
> SUSE  Software Solutions Germany GmbH
> HRB 36809, AG N=FCrnberg GF: Felix
> Imend=F6rffer
>=20
