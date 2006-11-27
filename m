From: Edward Goggin <egoggin@emc.com>
Subject: RE: [Bug 217014] Setting "user_friendly_names" to "yes"
	causesdm-mp to occasionally miss a mpath device during configuration
Date: Mon, 27 Nov 2006 17:32:44 -0500
Message-ID: <6CCEAEDF4D06984A83F427424F47D6E4013D158C@CORPUSMX40A.corp.emc.com>
References: <1164665396.25061.104.camel@localhost.localdomain>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <1164665396.25061.104.camel@localhost.localdomain>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: christophe.varoqui@free.fr
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Sorry, but I didn't send it to you directly since I mistakenly
thought you had already merged in the fix after I had
initially sent out this patch to the dm-devel list on 7/17.=20

> -----Original Message-----
> From: Christophe Varoqui [mailto:christophe.varoqui@free.fr]=20
> Sent: Monday, November 27, 2006 5:10 PM
> To: goggin, edward
> Cc: device-mapper development
> Subject: Re: [Bug 217014] Setting "user_friendly_names" to=20
> "yes" causesdm-mp to occasionally miss a mpath device during=20
> configuration
>=20
> Nice fix, thank you.
> Merged.
>=20
> Le lundi 27 novembre 2006 =E0 11:30 -0500, bugzilla@redhat.com a =E9cri=
t :
> > Please do not reply directly to this email. All additional
> > comments should be made in the comments box of this bug report.
> >=20
> > Summary: Setting "user_friendly_names" to "yes" causes=20
> dm-mp to occasionally miss a mpath device during configuration
> >=20
> >=20
> > https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=3D217014
> >=20
> >=20
> >=20
> >=20
> >=20
> > ------- Additional Comments From egoggin@emc.com =20
> 2006-11-27 11:29 EST -------
> > The posix file byte range locks used to provide atomicity=20
> for accessing the=20
> > entries in the multipath bindings file get released from=20
> whenever __any__=20
> > descriptor or FILE structure for that file is closed.  This=20
> patch delays the=20
> > fclose() for the FILE structures used within lookup_binding() and=20
> > rlookup_binding() until there is no more need for the atomicity.
> >=20
> > Without this patch I could fairly easily get two multipath=20
> mpath0 entries=20
> > in /var/lib/multipath/bindings by running 8 concurrent=20
> instances of multipath
> > (8) while with the patch I cannot get this problem to occur.
> >=20
> > diff --git a/libmultipath/alias.c b/libmultipath/alias.c
> > index 6d103d7..86cae9b 100644
> > --- a/libmultipath/alias.c
> > +++ b/libmultipath/alias.c
> > @@ -166,28 +166,14 @@ fail:
> > =20
> >=20
> >  static int
> > -lookup_binding(int fd, char *map_wwid, char **map_alias)
> > +lookup_binding(FILE *f, char *map_wwid, char **map_alias)
> >  {
> >  	char buf[LINE_MAX];
> > -	FILE *f;
> >  	unsigned int line_nr =3D 0;
> > -	int scan_fd;
> >  	int id =3D 0;
> > =20
> >  	*map_alias =3D NULL;
> > -	scan_fd =3D dup(fd);
> > -	if (scan_fd < 0) {
> > -		condlog(0, "Cannot dup bindings file descriptor : %s",
> > -			strerror(errno));
> > -		return -1;
> > -	}
> > -	f =3D fdopen(scan_fd, "r");
> > -	if (!f) {
> > -		condlog(0, "cannot fdopen on bindings file=20
> descriptor : %s",
> > -			strerror(errno));
> > -		close(scan_fd);
> > -		return -1;
> > -	}
> > +
> >  	while (fgets(buf, LINE_MAX, f)) {
> >  		char *c, *alias, *wwid;
> >  		int curr_id;
> > @@ -215,38 +201,22 @@ lookup_binding(int fd, char *map_wwid, c
> >  			if (*map_alias =3D=3D NULL)
> >  				condlog(0, "Cannot copy alias=20
> from bindings "
> >  					"file : %s", strerror(errno));
> > -			fclose(f);
> >  			return id;
> >  		}
> >  	}
> >  	condlog(3, "No matching wwid [%s] in bindings file.", map_wwid);
> > -	fclose(f);
> >  	return id;
> >  }=09
> > =20
> >  static int
> > -rlookup_binding(int fd, char **map_wwid, char *map_alias)
> > +rlookup_binding(FILE *f, char **map_wwid, char *map_alias)
> >  {
> >  	char buf[LINE_MAX];
> > -	FILE *f;
> >  	unsigned int line_nr =3D 0;
> > -	int scan_fd;
> >  	int id =3D 0;
> > =20
> >  	*map_wwid =3D NULL;
> > -	scan_fd =3D dup(fd);
> > -	if (scan_fd < 0) {
> > -		condlog(0, "Cannot dup bindings file descriptor : %s",
> > -			strerror(errno));
> > -		return -1;
> > -	}
> > -	f =3D fdopen(scan_fd, "r");
> > -	if (!f) {
> > -		condlog(0, "cannot fdopen on bindings file=20
> descriptor : %s",
> > -			strerror(errno));
> > -		close(scan_fd);
> > -		return -1;
> > -	}
> > +
> >  	while (fgets(buf, LINE_MAX, f)) {
> >  		char *c, *alias, *wwid;
> >  		int curr_id;
> > @@ -274,12 +244,10 @@ rlookup_binding(int fd, char **map_wwid,
> >  			if (*map_wwid =3D=3D NULL)
> >  				condlog(0, "Cannot copy alias=20
> from bindings "
> >  					"file : %s", strerror(errno));
> > -			fclose(f);
> >  			return id;
> >  		}
> >  	}
> >  	condlog(3, "No matching alias [%s] in bindings file.",=20
> map_alias);
> > -	fclose(f);
> >  	return id;
> >  }=09
> > =20
> > @@ -327,7 +295,8 @@ char *
> >  get_user_friendly_alias(char *wwid, char *file)
> >  {
> >  	char *alias;
> > -	int fd, id;
> > +	int fd, scan_fd, id;
> > +	FILE *f;
> > =20
> >  	if (!wwid || *wwid =3D=3D '\0') {
> >  		condlog(3, "Cannot find binding for empty WWID");
> > @@ -337,14 +306,37 @@ get_user_friendly_alias(char *wwid, char
> >  	fd =3D open_bindings_file(file);
> >  	if (fd < 0)
> >  		return NULL;
> > -	id =3D lookup_binding(fd, wwid, &alias);
> > +
> > +	scan_fd =3D dup(fd);
> > +	if (scan_fd < 0) {
> > +		condlog(0, "Cannot dup bindings file descriptor : %s",
> > +			strerror(errno));
> > +		close(fd);
> > +		return NULL;
> > +	}
> > +
> > +	f =3D fdopen(scan_fd, "r");
> > +	if (!f) {
> > +		condlog(0, "cannot fdopen on bindings file=20
> descriptor : %s",
> > +			strerror(errno));
> > +		close(scan_fd);
> > +		close(fd);
> > +		return NULL;
> > +	}
> > +
> > +	id =3D lookup_binding(f, wwid, &alias);
> >  	if (id < 0) {
> > +		fclose(f);
> > +		close(scan_fd);
> >  		close(fd);
> >  		return NULL;
> >  	}
> > +
> >  	if (!alias)
> >  		alias =3D allocate_binding(fd, wwid, id);
> > =20
> > +	fclose(f);
> > +	close(scan_fd);
> >  	close(fd);
> >  	return alias;
> >  }
> > @@ -353,7 +345,8 @@ char *
> >  get_user_friendly_wwid(char *alias, char *file)
> >  {
> >  	char *wwid;
> > -	int fd, id;
> > +	int fd, scan_fd, id;
> > +	FILE *f;
> > =20
> >  	if (!alias || *alias =3D=3D '\0') {
> >  		condlog(3, "Cannot find binding for empty alias");
> > @@ -363,12 +356,34 @@ get_user_friendly_wwid(char *alias, char
> >  	fd =3D open_bindings_file(file);
> >  	if (fd < 0)
> >  		return NULL;
> > -	id =3D rlookup_binding(fd, &wwid, alias);
> > +
> > +	scan_fd =3D dup(fd);
> > +	if (scan_fd < 0) {
> > +		condlog(0, "Cannot dup bindings file descriptor : %s",
> > +			strerror(errno));
> > +		close(fd);
> > +		return NULL;
> > +	}
> > +
> > +	f =3D fdopen(scan_fd, "r");
> > +	if (!f) {
> > +		condlog(0, "cannot fdopen on bindings file=20
> descriptor : %s",
> > +			strerror(errno));
> > +		close(scan_fd);
> > +		close(fd);
> > +		return NULL;
> > +	}
> > +
> > +	id =3D rlookup_binding(f, &wwid, alias);
> >  	if (id < 0) {
> > +		fclose(f);
> > +		close(scan_fd);
> >  		close(fd);
> >  		return NULL;
> >  	}
> > =20
> > +	fclose(f);
> > +	close(scan_fd);
> >  	close(fd);
> >  	return wwid;
> >  }
> >=20
>=20
>=20
>=20
