From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: multipath affinity to SCSI
Date: Wed, 27 Apr 2005 15:10:55 -0500
Message-ID: <20050427201055.GF31255@phlogiston.msp.redhat.com>
References: <C2EEB4E538D3DC48BF57F391F422779321A94C@SRMANNING.eng.emc.com>
	<20050427171133.GV4431@marowsky-bree.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20050427171133.GV4431@marowsky-bree.de>
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

On Wed, Apr 27, 2005 at 07:11:33PM +0200, Lars Marowsky-Bree wrote:
> On 2005-04-27T13:00:51, "goggin, edward" <egoggin@emc.com> wrote:
>=20
> > Has anyone tried multipathing to non-SCSI target devices, e.g., LOOP,
> > NBD, USB?  While the architecture looks fully capable of supporting
> > such, it looks like both the kernel and user implementation would hav=
e
> > some problems due to some SCSI affinity.
>=20
> Well, I can see the user-space not auto-detecting the paths right now
> (probably because simply noone has added those features yet ;-), but th=
e
> kernel shouldn't have any issues with it. I've played with it over loop
> devices for testing.
>=20
> Which SCSI affinity are you referring to?

The multipath tools are SCSI-centric.  sysfs_devinfo() is a glaring examp=
le.

-Ben
=20
>=20
> Sincerely,
>     Lars Marowsky-Br=E9e <lmb@suse.de>
>=20
> --=20
> High Availability & Clustering
> SUSE Labs, Research and Development
> SUSE LINUX Products GmbH - A Novell Business
>=20
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
