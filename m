From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [RFC Patch 2/3] libmultipath: make
 sysfs_is_multipathed able to return wwid
Date: Tue, 31 Mar 2020 10:39:34 -0500
Message-ID: <20200331153934.GH17313@octiron.msp.redhat.com>
References: <1585620055-27112-1-git-send-email-bmarzins@redhat.com>
	<1585620055-27112-3-git-send-email-bmarzins@redhat.com>
	<5a85f7b0c9ef459ea8a7308dda4f21af8da687f5.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <5a85f7b0c9ef459ea8a7308dda4f21af8da687f5.camel@suse.com>
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
To: Martin Wilck <Martin.Wilck@suse.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Tue, Mar 31, 2020 at 01:06:01PM +0000, Martin Wilck wrote:
> On Mon, 2020-03-30 at 21:00 -0500, Benjamin Marzinski wrote:
> > @@ -342,9 +342,25 @@ bool sysfs_is_multipathed(const struct path *pp)
> >  =09=09if (nr =3D=3D sizeof(uuid) && !memcmp(uuid, "mpath-",
> > sizeof(uuid)))
> >  =09=09=09found =3D true;
> >  =09=09else if (nr < 0) {
> > -=09=09=09condlog(1, "%s: error reading from %s: %s",
> > -=09=09=09=09__func__, pathbuf, strerror(errno));
> > +=09=09=09condlog(1, "%s: error reading from %s: %m",
> > +=09=09=09=09__func__, pathbuf);
> >  =09=09}
> > +=09=09if (found && set_wwid) {
> > +=09=09=09nr =3D read(fd, pp->wwid, WWID_SIZE);
>=20
> I'd rather read the whole UUID in a single syscall (i.e. merge this
> with the previous read() that fetched the first 6 chars).

Sure.

-Ben

> Regards,
> Martin
>=20
>=20
> --=20
> Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
> SUSE  Software Solutions Germany GmbH
> HRB 36809, AG N=FCrnberg GF: Felix
> Imend=F6rffer
>=20
