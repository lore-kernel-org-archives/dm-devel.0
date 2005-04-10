From: Dave Olien <dmo@osdl.org>
Subject: Re: New -udm?
Date: Sun, 10 Apr 2005 16:36:09 -0700
Message-ID: <20050410233609.GA3712@osdl.org>
References: <20050410192934.GP12752@marowsky-bree.de>
	<1113164717.8372.2.camel@zezette>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1113164717.8372.2.camel@zezette>
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
Cc: Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids


Sadly, that implementation uses a depcreated ioctl.
I'll re-write it this week in the same manner the dm-emc.c
is coded.  Target to have it in the mail Friday.

On Sun, Apr 10, 2005 at 10:25:17PM +0200, christophe varoqui wrote:
> On dim, 2005-04-10 at 21:29 +0200, Lars Marowsky-Bree wrote:
> > Hi Alasdair,
> >=20
> > I'm resync'ing against -udm and would like to pull all recent fixes i=
f
> > possible. Do you have anything more recent than the 2.6.11-rc3-udm2?
> >=20
> >=20
> > Sincerely,
> >     Lars Marowsky-Br=E9e <lmb@suse.de>
> >=20
> There is this hwhandler from Dave Olien, that needs auditing, but is a
> must-have for StorageWorks and FSC FibreCat users.
>=20
> http://christophe.varoqui.free.fr/multipath-tools/dm-scsi-start.patch
>=20
> Would be good to have in an enterprise distro ...
>=20
> Regards,
> --=20
> christophe varoqui <christophe.varoqui@free.fr>
>=20
>=20
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
