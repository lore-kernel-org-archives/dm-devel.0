From: Pasi =?iso-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>
Subject: Re: Status of resizing/growing dm-multipath devices on the
	fly
Date: Thu, 7 Aug 2008 10:45:25 +0300
Message-ID: <20080807074525.GR3771@edu.joroinen.fi>
References: <20080806125355.GM3771@edu.joroinen.fi>
	<Pine.LNX.4.64.0808061432330.13407@mrwacky.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0808061432330.13407@mrwacky.com>
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

On Wed, Aug 06, 2008 at 02:46:57PM -0700, Sharif Nassar wrote:
> On Wed, 6 Aug 2008, Pasi K=E4rkk=E4inen wrote:
>=20
> >Hello!
> >
> >Is it possible to resize (grow) dm-multipath devices on the fly nowada=
ys?=20
> >
> >I googled and found some discussions about the subject, but the conclu=
sion
> >seemed to be it's not possible.. that was a while ago, so I was wonder=
ing=20
> >if
> >this has been fixed/implemented..=20
> >
> >Using LVM and adding another new LUN/PV is not an option always.. it's=
 a=20
> >lot
> >easier to manage the whole thing if it's possible to resize/grow exist=
ing
> >LUNs on the fly.
>=20
>=20
> Sure it is, but it's not pretty.  Don't believe the naysayers.
> We seem to have a working method for resizing multipath luns from our=20
> NetApp filers.  It works on CentOS 4 & 5, for us, and our NetApps.
> (2 HBA, times 2 paths on each makes for four SCSI LUN to resize)
>=20
> The poorly formatted, unpolished, YMMV, no warranty recipe is:
>=20

Thanks a lot!=20

Better to have a workaround than nothing :)=20

-- Pasi
