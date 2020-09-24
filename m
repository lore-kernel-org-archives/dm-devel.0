From: Martin Wilck <martin.wilck@suse.com>
Subject: Re: [RFC PATCH v2 0/3] add library to check if device is
 a valid path
Date: Thu, 24 Sep 2020 19:22:21 +0000
Message-ID: <53ad2ea2f8457030eac247420fcc564bd5608ab8.camel@suse.com>
References: <1600923569-17412-1-git-send-email-bmarzins@redhat.com>
	<01ce499f8c7a7248f560066054ba4dd922bbc338.camel@suse.com>
	<20200924163007.GG11108@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200924163007.GG11108@octiron.msp.redhat.com>
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
Content-ID: <C2F8931456399F47BD648CD6C6BE8A31@eurprd04.prod.outlook.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Thu, 2020-09-24 at 11:30 -0500, Benjamin Marzinski wrote:
> On Thu, Sep 24, 2020 at 08:18:02AM +0000, Martin Wilck wrote:
> > On Wed, 2020-09-23 at 23:59 -0500, Benjamin Marzinski wrote:
> > >=20
> > > The second patch adds get_uid fallback code for dasd devices. The
> > > third
> > > patch just changes the get_uid log level for devices configured
> > > with
> > > uid_attribute "". This is because it is currently necessary to
> > > configure
> > > multipath with
> > >=20
> > > overrides {
> > >         uid_attribute ""
> > > }
> > >=20
> > > to claim multipath devices with SID (instead of using
> > > multipath.rules),
> > > since SID doesn't currently get the UID information itself, and
> > > it is
> > > called by udev before this information is added to the udev
> > > database.
> > >=20
> >=20
> > This makes me wonder how SID and multipathd are supposed to
> > coexist.
> > We wouldn't want this overrides directive for multipathd itself,
> > would
> > we?
>=20
> Don't we need it to be used by everything?  We certainly don't want
> multipathd to get a different value for the wwid than SID has. It
> seems
> like all programs that access the multipath devices should use the
> same
> method to get the WWIDs.

Well, as soon as SID is authoritative for the question whether or not a
device should be multipathed, this is certainly true.

That would mean, then, that multipath-tools would abandon the current
philosophy of relying on udev, and attempt to derive device properties
directly from sysfs instead. That makes a certain amount of sense to
me, even though it's contrary to what we've been doing the last years.
Relying on udev is not without issues, as we both know. uevents being
delayed or never delivered is one problem, the other is the fact that
udev rules can be customized without limits, leading to a
profliferation of variables and configuration options. All this has
historical reasons, today we could very well obtain almost all device
attributes we need directly from sysfs.

... but I gather that this is a temporary scenario ...=20

> The long term solution is that SID will call out to the devices, and
> grab these uid attributes, just like udev currently does. It already
> does this for the blkid values. When SID is running, these udev rules
> will be disabled, and SID will provide udev with this data. So
> eventually, multipath won't need any configuration changes to work
> with
> SID. setting this overrides line is just a stop-gap, so that people
> can
> test SID and multipath now.

So, SID will call into libmultipath via libmpathvalid, udev will obtain
the properties from SID, and multipathd will fetch them from udev in
turn? Or will multipathd talk directly to SID? I seem to be missing the
overall picture.

Anyway, if you can live with simply adding an "overrides" statement to
multipath.conf for SID at the current stage, fine with me.

Forgot to say: ACK for this series from me, with the exception of the
minor nit I had on #3.

Regards,
Martin

--=20
Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
SUSE  Software Solutions Germany GmbH
HRB 36809, AG N=FCrnberg GF: Felix
Imend=F6rffer
