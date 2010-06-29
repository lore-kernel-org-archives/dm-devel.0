From: Christophe Varoqui <christophe.varoqui@gmail.com>
Subject: Re: [PATCH] [RFC] [PATCH] Add alias_prefix to
	get	multipath names based on	storage type
Date: Tue, 29 Jun 2010 07:54:24 +0200
Message-ID: <1277790864.15442.11.camel@Nokia-N900-42-11>
References: <b4d519b4bbc657671382.1277260053@malahal>
	<20100628230737.GA17462@us.ibm.com>
Reply-To: Christophe Varoqui <christophe.varoqui@gmail.com>,
        device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1982515567562081808=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20100628230737.GA17462@us.ibm.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>, Malahal Naineni <malahal@us.ibm.com>
List-Id: dm-devel.ids


--===============1982515567562081808==
Content-Type: multipart/alternative; boundary="=-/IdntoaCQCPCWJsx/CCz"


--=-/IdntoaCQCPCWJsx/CCz
Content-Type: text/plain; charset=utf-8
Content-ID: <1277790864.15442.8.camel@Nokia-N900-42-11>
Content-Transfer-Encoding: quoted-printable
X-MIME-Autoconverted: from 8bit to quoted-printable by mx02.colomx.prod.int.phx2.redhat.com id o5T5spm2027587

I'd rather have others give their feeling on the usefullness of this feat=
ure. My own opinion is that user_friendly_names are for people who don't =
care about naming, alias for those who care. This per-hardware prefix wou=
ld fill a quite narrow gap in-between ... But some may have more enthusia=
st feeling, which will matter.

At least it doesn't change the current behaviour by default.

Best regards,
cvaroqui

----- Message d'origine -----
> Any comments??
>=20
> Malahal Naineni [malahal@us.ibm.com] wrote:
> > The current multipath tools use "mpath" prefix for all LUNs when
> > user_friendly_names is set. It would be nice if the names are generat=
ed
> > based on the storage subsystem. For example, all EMC LUNs would be
> > named emc_a, emc_b, elm_c etc., and all IBM's SVC LUNs would be named
> > svc_a, svc_b, svc_c. This patch attempts to do that using only
> > multipath.conf. Patches can be added to the internal hardware table,
> > if needed.
> >=20
> > Signed-off-by: Malahal Naineni (malahal@us.ibm.com)
> >=20
> > diff -r 49b7dc2c9d46 -r b4d519b4bbc6 libmultipath/alias.c
> > --- a/libmultipath/alias.c=C2=A0=C2=A0=C2=A0 Tue Jun 15 17:23:49 2010=
 -0700
> > +++ b/libmultipath/alias.c=C2=A0=C2=A0=C2=A0 Tue Jun 22 19:25:24 2010=
 -0700
> > @@ -180,34 +180,35 @@ fail:
> > }
> >=20
> > static int
> > -format_devname(char *name, int id, int len)
> > +format_devname(char *name, int id, int len, char *prefix)
> > {
> > =C2=A0=C2=A0=C2=A0 int pos;
> > +=C2=A0=C2=A0=C2=A0 int prefix_len =3D strlen(prefix);
> >=20
> > =C2=A0=C2=A0=C2=A0 memset(name,0, len);
> > -=C2=A0=C2=A0=C2=A0 strcpy(name,"mpath");
> > -=C2=A0=C2=A0=C2=A0 for (pos =3D len - 1; pos >=3D 5; pos--) {
> > +=C2=A0=C2=A0=C2=A0 strcpy(name, prefix);
> > +=C2=A0=C2=A0=C2=A0 for (pos =3D len - 1; pos >=3D prefix_len; pos--)=
 {
> > =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 name[pos] =3D 'a' + id % 26;
> > =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 if (id < 26)
> > =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 break;
> > =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 id /=3D 26;
> > =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 id--;
> > =C2=A0=C2=A0=C2=A0 }
> > -=C2=A0=C2=A0=C2=A0 memmove(name + 5, name + pos, len - pos);
> > -=C2=A0=C2=A0=C2=A0 name[5 + len - pos] =3D '\0';
> > -=C2=A0=C2=A0=C2=A0 return (5 + len - pos);
> > +=C2=A0=C2=A0=C2=A0 memmove(name + prefix_len, name + pos, len - pos)=
;
> > +=C2=A0=C2=A0=C2=A0 name[prefix_len + len - pos] =3D '\0';
> > +=C2=A0=C2=A0=C2=A0 return (prefix_len + len - pos);
> > }
> >=20
> > static int
> > -scan_devname(char *alias)
> > +scan_devname(char *alias, char *prefix)
> > {
> > =C2=A0=C2=A0=C2=A0 char *c;
> > =C2=A0=C2=A0=C2=A0 int i, n =3D 0;
> >=20
> > -=C2=A0=C2=A0=C2=A0 if (strncmp(alias, "mpath", 5))
> > +=C2=A0=C2=A0=C2=A0 if (!prefix || strncmp(alias, prefix, strlen(pref=
ix)))
> > =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 return -1;
> >=20
> > -=C2=A0=C2=A0=C2=A0 c =3D alias + 5;
> > +=C2=A0=C2=A0=C2=A0 c =3D alias + strlen(prefix);
> > =C2=A0=C2=A0=C2=A0 while (*c !=3D '\0' && *c !=3D ' ' && *c !=3D '\t'=
) {
> > =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 i =3D *c - 'a';
> > =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 n =3D ( n * 26 ) + i;
> > @@ -221,7 +222,7 @@ scan_devname(char *alias)
> > }
> >=20
> > static int
> > -lookup_binding(FILE *f, char *map_wwid, char **map_alias)
> > +lookup_binding(FILE *f, char *map_wwid, char **map_alias, char
> > *prefix) {
> > =C2=A0=C2=A0=C2=A0 char buf[LINE_MAX];
> > =C2=A0=C2=A0=C2=A0 unsigned int line_nr =3D 0;
> > @@ -240,7 +241,7 @@ lookup_binding(FILE *f, char *map_wwid,=20
> > =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 alias =3D strtok(buf, " \t");
> > =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 if (!alias) /* blank line */
> > =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 continue;
> > -=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 curr_id =3D scan_devname(alias=
);
> > +=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 curr_id =3D scan_devname(alias=
, prefix);
> > =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 if (curr_id >=3D id)
> > =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 id =3D curr_=
id + 1;
> > =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 wwid =3D strtok(NULL, "");
> > @@ -284,7 +285,7 @@ rlookup_binding(FILE *f, char **map_wwid
> > =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 alias =3D strtok(buf, " \t");
> > =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 if (!alias) /* blank line */
> > =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 continue;
> > -=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 curr_id =3D scan_devname(alias=
);
> > +=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 curr_id =3D scan_devname(alias=
, NULL); /* TBD: Why this call? */
> > =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 if (curr_id >=3D id)
> > =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 id =3D curr_=
id + 1;
> > =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 wwid =3D strtok(NULL, " \t");
> > @@ -309,7 +310,7 @@ rlookup_binding(FILE *f, char **map_wwid
> > }
> >=20
> > static char *
> > -allocate_binding(int fd, char *wwid, int id)
> > +allocate_binding(int fd, char *wwid, int id, char *prefix)
> > {
> > =C2=A0=C2=A0=C2=A0 char buf[LINE_MAX];
> > =C2=A0=C2=A0=C2=A0 off_t offset;
> > @@ -321,7 +322,7 @@ allocate_binding(int fd, char *wwid, int
> > =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 return NULL;
> > =C2=A0=C2=A0=C2=A0 }
> >=20
> > -=C2=A0=C2=A0=C2=A0 i =3D format_devname(buf, id, LINE_MAX);
> > +=C2=A0=C2=A0=C2=A0 i =3D format_devname(buf, id, LINE_MAX, prefix);
> > =C2=A0=C2=A0=C2=A0 c =3D buf + i;
> > =C2=A0=C2=A0=C2=A0 snprintf(c,LINE_MAX - i, " %s\n", wwid);
> > =C2=A0=C2=A0=C2=A0 buf[LINE_MAX - 1] =3D '\0';
> > @@ -352,7 +353,7 @@ allocate_binding(int fd, char *wwid, int
> > }
> >=20
> > char *
> > -get_user_friendly_alias(char *wwid, char *file)
> > +get_user_friendly_alias(char *wwid, char *file, char *prefix)
> > {
> > =C2=A0=C2=A0=C2=A0 char *alias;
> > =C2=A0=C2=A0=C2=A0 int fd, scan_fd, id;
> > @@ -385,7 +386,7 @@ get_user_friendly_alias(char *wwid, char
> > =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 return NULL;
> > =C2=A0=C2=A0=C2=A0 }
> >=20
> > -=C2=A0=C2=A0=C2=A0 id =3D lookup_binding(f, wwid, &alias);
> > +=C2=A0=C2=A0=C2=A0 id =3D lookup_binding(f, wwid, &alias, prefix);
> > =C2=A0=C2=A0=C2=A0 if (id < 0) {
> > =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 fclose(f);
> > =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 close(scan_fd);
> > @@ -394,7 +395,7 @@ get_user_friendly_alias(char *wwid, char
> > =C2=A0=C2=A0=C2=A0 }
> >=20
> > =C2=A0=C2=A0=C2=A0 if (!alias && can_write)
> > -=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 alias =3D allocate_binding(fd,=
 wwid, id);
> > +=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 alias =3D allocate_binding(fd,=
 wwid, id, prefix);
> >=20
> > =C2=A0=C2=A0=C2=A0 fclose(f);
> > =C2=A0=C2=A0=C2=A0 close(scan_fd);
> > diff -r 49b7dc2c9d46 -r b4d519b4bbc6 libmultipath/alias.h
> > --- a/libmultipath/alias.h=C2=A0=C2=A0=C2=A0 Tue Jun 15 17:23:49 2010=
 -0700
> > +++ b/libmultipath/alias.h=C2=A0=C2=A0=C2=A0 Tue Jun 22 19:25:24 2010=
 -0700
> > @@ -8,5 +8,5 @@
> > "# alias wwid\n" \
> > "#\n"
> >=20
> > -char *get_user_friendly_alias(char *wwid, char *file);
> > +char *get_user_friendly_alias(char *wwid, char *file, char *prefix);
> > char *get_user_friendly_wwid(char *alias, char *file);
> > diff -r 49b7dc2c9d46 -r b4d519b4bbc6 libmultipath/config.c
> > --- a/libmultipath/config.c=C2=A0=C2=A0=C2=A0 Tue Jun 15 17:23:49 201=
0 -0700
> > +++ b/libmultipath/config.c=C2=A0=C2=A0=C2=A0 Tue Jun 22 19:25:24 201=
0 -0700
> > @@ -158,6 +158,9 @@ free_hwe (struct hwentry * hwe)
> > =C2=A0=C2=A0=C2=A0 if (hwe->prio_args)
> > =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 FREE(hwe->prio_args);
> >=20
> > +=C2=A0=C2=A0=C2=A0 if (hwe->alias_prefix)
> > +=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 FREE(hwe->alias_prefix);
> > +
> > =C2=A0=C2=A0=C2=A0 if (hwe->bl_product)
> > =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 FREE(hwe->bl_product);
> >=20
> > @@ -282,6 +285,7 @@ merge_hwe (struct hwentry * hwe1, struct
> > =C2=A0=C2=A0=C2=A0 merge_str(checker_name);
> > =C2=A0=C2=A0=C2=A0 merge_str(prio_name);
> > =C2=A0=C2=A0=C2=A0 merge_str(prio_args);
> > +=C2=A0=C2=A0=C2=A0 merge_str(alias_prefix);
> > =C2=A0=C2=A0=C2=A0 merge_str(bl_product);
> > =C2=A0=C2=A0=C2=A0 merge_num(pgpolicy);
> > =C2=A0=C2=A0=C2=A0 merge_num(pgfailback);
> > @@ -333,6 +337,9 @@ store_hwe (vector hwtable, struct hwentr
> > =C2=A0=C2=A0=C2=A0 if (dhwe->prio_args && !(hwe->prio_args =3D
> > set_param_str(dhwe->prio_args)))=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=
 goto out;
> >=20
> > +=C2=A0=C2=A0=C2=A0 if (dhwe->alias_prefix && !(hwe->alias_prefix =3D
> > set_param_str(dhwe->alias_prefix))) +=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=
=A0 goto out;
> > +
> > =C2=A0=C2=A0=C2=A0 hwe->pgpolicy =3D dhwe->pgpolicy;
> > =C2=A0=C2=A0=C2=A0 hwe->pgfailback =3D dhwe->pgfailback;
> > =C2=A0=C2=A0=C2=A0 hwe->rr_weight =3D dhwe->rr_weight;
> > @@ -409,6 +416,9 @@ free_config (struct config * conf)
> > =C2=A0=C2=A0=C2=A0 if (conf->prio_name)
> > =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 FREE(conf->prio_name);
> >=20
> > +=C2=A0=C2=A0=C2=A0 if (conf->alias_prefix)
> > +=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 FREE(conf->alias_prefix);
> > +
> > =C2=A0=C2=A0=C2=A0 if (conf->prio_args)
> > =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 FREE(conf->prio_args);
> >=20
> > diff -r 49b7dc2c9d46 -r b4d519b4bbc6 libmultipath/config.h
> > --- a/libmultipath/config.h=C2=A0=C2=A0=C2=A0 Tue Jun 15 17:23:49 201=
0 -0700
> > +++ b/libmultipath/config.h=C2=A0=C2=A0=C2=A0 Tue Jun 22 19:25:24 201=
0 -0700
> > @@ -25,6 +25,7 @@ struct hwentry {
> > =C2=A0=C2=A0=C2=A0 char * checker_name;
> > =C2=A0=C2=A0=C2=A0 char * prio_name;
> > =C2=A0=C2=A0=C2=A0 char * prio_args;
> > +=C2=A0=C2=A0=C2=A0 char * alias_prefix;
> >=20
> > =C2=A0=C2=A0=C2=A0 int pgpolicy;
> > =C2=A0=C2=A0=C2=A0 int pgfailback;
> > @@ -99,6 +100,7 @@ struct config {
> > =C2=A0=C2=A0=C2=A0 char * prio_name;
> > =C2=A0=C2=A0=C2=A0 char * prio_args;
> > =C2=A0=C2=A0=C2=A0 char * checker_name;
> > +=C2=A0=C2=A0=C2=A0 char * alias_prefix;
> >=20
> > =C2=A0=C2=A0=C2=A0 vector keywords;
> > =C2=A0=C2=A0=C2=A0 vector mptable;
> > diff -r 49b7dc2c9d46 -r b4d519b4bbc6 libmultipath/defaults.h
> > --- a/libmultipath/defaults.h=C2=A0=C2=A0=C2=A0 Tue Jun 15 17:23:49 2=
010 -0700
> > +++ b/libmultipath/defaults.h=C2=A0=C2=A0=C2=A0 Tue Jun 22 19:25:24 2=
010 -0700
> > @@ -2,6 +2,7 @@
> > #define DEFAULT_UDEVDIR=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 "/dev"
> > #define DEFAULT_MULTIPATHDIR=C2=A0=C2=A0=C2=A0 "/" LIB_STRING "/multi=
path"
> > #define DEFAULT_SELECTOR=C2=A0=C2=A0=C2=A0 "round-robin 0"
> > +#define DEFAULT_ALIAS_PREFIX=C2=A0=C2=A0=C2=A0 "mpath"
> > #define DEFAULT_FEATURES=C2=A0=C2=A0=C2=A0 "0"
> > #define DEFAULT_HWHANDLER=C2=A0=C2=A0=C2=A0 "0"
> > #define DEFAULT_MINIO=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 1000
> > diff -r 49b7dc2c9d46 -r b4d519b4bbc6 libmultipath/dict.c
> > --- a/libmultipath/dict.c=C2=A0=C2=A0=C2=A0 Tue Jun 15 17:23:49 2010 =
-0700
> > +++ b/libmultipath/dict.c=C2=A0=C2=A0=C2=A0 Tue Jun 22 19:25:24 2010 =
-0700
> > @@ -148,6 +148,17 @@ def_prio_handler(vector strvec)
> > }
> >=20
> > static int
> > +def_alias_prefix_handler(vector strvec)
> > +{
> > +=C2=A0=C2=A0=C2=A0 conf->alias_prefix =3D set_value(strvec);
> > +
> > +=C2=A0=C2=A0=C2=A0 if (!conf->alias_prefix)
> > +=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 return 1;
> > +
> > +=C2=A0=C2=A0=C2=A0 return 0;
> > +}
> > +
> > +static int
> > def_prio_args_handler(vector strvec)
> > {
> > =C2=A0=C2=A0=C2=A0 conf->prio_args =3D set_value(strvec);
> > @@ -831,6 +842,22 @@ hw_prio_handler(vector strvec)
> > }
> >=20
> > static int
> > +hw_alias_prefix_handler(vector strvec)
> > +{
> > +=C2=A0=C2=A0=C2=A0 struct hwentry * hwe =3D VECTOR_LAST_SLOT(conf->h=
wtable);
> > +
> > +=C2=A0=C2=A0=C2=A0 if (!hwe)
> > +=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 return 1;
> > +
> > +=C2=A0=C2=A0=C2=A0 hwe->alias_prefix =3D set_value(strvec);
> > +
> > +=C2=A0=C2=A0=C2=A0 if (!hwe->alias_prefix)
> > +=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 return 1;
> > +
> > +=C2=A0=C2=A0=C2=A0 return 0;
> > +}
> > +
> > +static int
> > hw_prio_args_handler(vector strvec)
> > {
> > =C2=A0=C2=A0=C2=A0 struct hwentry * hwe =3D VECTOR_LAST_SLOT(conf->hw=
table);
> > @@ -1580,6 +1607,19 @@ snprint_hw_prio (char * buff, int len, v
> > }
> >=20
> > static int
> > +snprint_hw_alias_prefix (char * buff, int len, void * data)
> > +{
> > +=C2=A0=C2=A0=C2=A0 struct hwentry * hwe =3D (struct hwentry *)data;
> > +
> > +=C2=A0=C2=A0=C2=A0 if (!hwe->alias_prefix || (strlen(hwe->alias_pref=
ix) =3D=3D 0))
> > +=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 return 0;
> > +=C2=A0=C2=A0=C2=A0 if (conf->alias_prefix && !strcmp(hwe->alias_pref=
ix,
> > conf->alias_prefix)) +=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 return 0;
> > +
> > +=C2=A0=C2=A0=C2=A0 return snprintf(buff, len, "%s", hwe->alias_prefi=
x);
> > +}
> > +
> > +static int
> > snprint_hw_prio_args (char * buff, int len, void * data)
> > {
> > =C2=A0=C2=A0=C2=A0 struct hwentry * hwe =3D (struct hwentry *)data;
> > @@ -2076,6 +2116,16 @@ snprint_def_user_friendly_names (char *=20
> > }
> >=20
> > static int
> > +snprint_def_alias_prefix (char * buff, int len, void * data)
> > +{
> > +=C2=A0=C2=A0=C2=A0 if (!conf->alias_prefix)
> > +=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 return 0;
> > +=C2=A0=C2=A0=C2=A0 if (!strcmp(conf->alias_prefix, DEFAULT_ALIAS_PRE=
FIX))
> > +=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 return 0;
> > +=C2=A0=C2=A0=C2=A0 return snprintf(buff, len, conf->alias_prefix);
> > +}
> > +
> > +static int
> > snprint_ble_simple (char * buff, int len, void * data)
> > {
> > =C2=A0=C2=A0=C2=A0 struct blentry * ble =3D (struct blentry *)data;
> > @@ -2117,6 +2167,7 @@ init_keywords(void)
> > =C2=A0=C2=A0=C2=A0 install_keyword("features", &def_features_handler,
> > &snprint_def_features);=C2=A0=C2=A0=C2=A0 install_keyword("path_check=
er",
> > &def_path_checker_handler, &snprint_def_path_checker);
> > =C2=A0=C2=A0=C2=A0 install_keyword("checker", &def_path_checker_handl=
er,
> > &snprint_def_path_checker); +=C2=A0=C2=A0=C2=A0 install_keyword("alia=
s_prefix",
> > &def_alias_prefix_handler, &snprint_def_alias_prefix);
> > =C2=A0=C2=A0=C2=A0 install_keyword("failback", &default_failback_hand=
ler,
> > &snprint_def_failback);=C2=A0=C2=A0=C2=A0 install_keyword("rr_min_io"=
,
> > &def_minio_handler, &snprint_def_rr_min_io);
> > =C2=A0=C2=A0=C2=A0 install_keyword("max_fds", &max_fds_handler, &snpr=
int_max_fds); @@
> > -2176,6 +2227,7 @@ init_keywords(void)
> > =C2=A0=C2=A0=C2=A0 install_keyword("path_selector", &hw_selector_hand=
ler,
> > &snprint_hw_selector);=C2=A0=C2=A0=C2=A0 install_keyword("path_checke=
r",
> > &hw_path_checker_handler, &snprint_hw_path_checker);
> > =C2=A0=C2=A0=C2=A0 install_keyword("checker", &hw_path_checker_handle=
r,
> > &snprint_hw_path_checker); +=C2=A0=C2=A0=C2=A0 install_keyword("alias=
_prefix",
> > &hw_alias_prefix_handler, &snprint_hw_alias_prefix);
> > =C2=A0=C2=A0=C2=A0 install_keyword("features", &hw_features_handler,
> > &snprint_hw_features);=C2=A0=C2=A0=C2=A0 install_keyword("hardware_ha=
ndler",
> > &hw_handler_handler, &snprint_hw_hardware_handler);
> > =C2=A0=C2=A0=C2=A0 install_keyword("prio", &hw_prio_handler, &snprint=
_hw_prio); diff -r
> > 49b7dc2c9d46 -r b4d519b4bbc6 libmultipath/propsel.c ---
> > a/libmultipath/propsel.c=C2=A0=C2=A0=C2=A0 Tue Jun 15 17:23:49 2010 -=
0700 +++
> > b/libmultipath/propsel.c=C2=A0=C2=A0=C2=A0 Tue Jun 22 19:25:24 2010 -=
0700 @@ -215,6
> > +215,26 @@ select_selector (struct multipath * mp)=C2=A0=C2=A0=C2=A0 =
return 0; }
> >=20
> > +static void
> > +select_alias_prefix (struct multipath * mp)
> > +{
> > +=C2=A0=C2=A0=C2=A0 if (mp->hwe && mp->hwe->alias_prefix) {
> > +=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 mp->alias_prefix =3D mp->hwe->=
alias_prefix;
> > +=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 condlog(3, "%s: alias_prefix =3D=
 %s (controller setting)",
> > +=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 mp->wwid, m=
p->alias_prefix);
> > +=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 return;
> > +=C2=A0=C2=A0=C2=A0 }
> > +=C2=A0=C2=A0=C2=A0 if (conf->alias_prefix) {
> > +=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 mp->alias_prefix =3D conf->ali=
as_prefix;
> > +=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 condlog(3, "%s: alias_prefix =3D=
 %s (config file default)",
> > +=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 mp->wwid, m=
p->alias_prefix);
> > +=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 return;
> > +=C2=A0=C2=A0=C2=A0 }
> > +=C2=A0=C2=A0=C2=A0 mp->alias_prefix =3D set_default(DEFAULT_ALIAS_PR=
EFIX);
> > +=C2=A0=C2=A0=C2=A0 condlog(3, "%s: alias_prefix =3D %s (internal def=
ault)",
> > +=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 mp->wwid, mp->alias_prefix);
> > +}
> > +
> > extern int
> > select_alias (struct multipath * mp)
> > {
> > @@ -222,9 +242,11 @@ select_alias (struct multipath * mp)
> > =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 mp->alias =3D mp->mpe->alias;
> > =C2=A0=C2=A0=C2=A0 else {
> > =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 mp->alias =3D NULL;
> > -=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 if (conf->user_friendly_names)
> > +=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 if (conf->user_friendly_names)=
 {
> > +=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 select_alia=
s_prefix(mp);
> > =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 mp->alias =3D=
 get_user_friendly_alias(mp->wwid,
> > -=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=
=C2=A0 =C2=A0=C2=A0=C2=A0 conf->bindings_file);
> > +=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=
=C2=A0 =C2=A0=C2=A0=C2=A0 conf->bindings_file, mp->alias_prefix);
> > +=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 }
> > =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 if (mp->alias =3D=3D NULL){
> > =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 char *alias;
> > =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 if ((alias =3D=
 MALLOC(WWID_SIZE)) !=3D NULL){
> > diff -r 49b7dc2c9d46 -r b4d519b4bbc6 libmultipath/structs.h
> > --- a/libmultipath/structs.h=C2=A0=C2=A0=C2=A0 Tue Jun 15 17:23:49 20=
10 -0700
> > +++ b/libmultipath/structs.h=C2=A0=C2=A0=C2=A0 Tue Jun 22 19:25:24 20=
10 -0700
> > @@ -186,6 +186,7 @@ struct multipath {
> >=20
> > =C2=A0=C2=A0=C2=A0 /* configlet pointers */
> > =C2=A0=C2=A0=C2=A0 char * alias;
> > +=C2=A0=C2=A0=C2=A0 char * alias_prefix;
> > =C2=A0=C2=A0=C2=A0 char * selector;
> > =C2=A0=C2=A0=C2=A0 char * features;
> > =C2=A0=C2=A0=C2=A0 char * hwhandler;
> >=20
> > --
> > dm-devel mailing list
> > dm-devel@redhat.com
> > https://www.redhat.com/mailman/listinfo/dm-devel
>=20
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel


--=-/IdntoaCQCPCWJsx/CCz
Content-Type: text/html; charset=utf-8
Content-ID: <1277790864.15442.10.camel@Nokia-N900-42-11>
Content-Transfer-Encoding: 7bit

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html><head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <meta name="generator" content="Osso Notes">
    <title></title></head>
<body>
<p>I'd rather have others give their feeling on the usefullness of this feature. My own opinion is that user_friendly_names are for people who don't care about naming, alias for those who care. This per-hardware prefix would fill a quite narrow gap in-between ... But some may have more enthusiast feeling, which will matter.
<br>
<br>At least it doesn't change the current behaviour by default.
<br>
<br>Best regards,
<br>cvaroqui
<br>
<br>----- Message d'origine -----
<br>&gt; Any comments??
<br>&gt; 
<br>&gt; Malahal Naineni [<a href="mailto:malahal@us.ibm.com">malahal@us.ibm.com</a>] wrote:
<br>&gt; &gt; The current multipath tools use "mpath" prefix for all LUNs when
<br>&gt; &gt; user_friendly_names is set. It would be nice if the names are generated
<br>&gt; &gt; based on the storage subsystem. For example, all EMC LUNs would be
<br>&gt; &gt; named emc_a, emc_b, elm_c etc., and all IBM's SVC LUNs would be named
<br>&gt; &gt; svc_a, svc_b, svc_c. This patch attempts to do that using only
<br>&gt; &gt; multipath.conf. Patches can be added to the internal hardware table,
<br>&gt; &gt; if needed.
<br>&gt; &gt; 
<br>&gt; &gt; Signed-off-by: Malahal Naineni (<a href="mailto:malahal@us.ibm.com">malahal@us.ibm.com</a>)
<br>&gt; &gt; 
<br>&gt; &gt; diff -r 49b7dc2c9d46 -r b4d519b4bbc6 libmultipath/alias.c
<br>&gt; &gt; --- a/libmultipath/alias.c&nbsp;&nbsp;&nbsp; Tue Jun 15 17:23:49 2010 -0700
<br>&gt; &gt; +++ b/libmultipath/alias.c&nbsp;&nbsp;&nbsp; Tue Jun 22 19:25:24 2010 -0700
<br>&gt; &gt; @@ -180,34 +180,35 @@ fail:
<br>&gt; &gt; }
<br>&gt; &gt; 
<br>&gt; &gt; static int
<br>&gt; &gt; -format_devname(char *name, int id, int len)
<br>&gt; &gt; +format_devname(char *name, int id, int len, char *prefix)
<br>&gt; &gt; {
<br>&gt; &gt; &nbsp;&nbsp;&nbsp; int pos;
<br>&gt; &gt; +&nbsp;&nbsp;&nbsp; int prefix_len = strlen(prefix);
<br>&gt; &gt; 
<br>&gt; &gt; &nbsp;&nbsp;&nbsp; memset(name,0, len);
<br>&gt; &gt; -&nbsp;&nbsp;&nbsp; strcpy(name,"mpath");
<br>&gt; &gt; -&nbsp;&nbsp;&nbsp; for (pos = len - 1; pos &gt;= 5; pos--) {
<br>&gt; &gt; +&nbsp;&nbsp;&nbsp; strcpy(name, prefix);
<br>&gt; &gt; +&nbsp;&nbsp;&nbsp; for (pos = len - 1; pos &gt;= prefix_len; pos--) {
<br>&gt; &gt; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; name[pos] = 'a' + id % 26;
<br>&gt; &gt; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; if (id &lt; 26)
<br>&gt; &gt; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; break;
<br>&gt; &gt; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; id /= 26;
<br>&gt; &gt; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; id--;
<br>&gt; &gt; &nbsp;&nbsp;&nbsp; }
<br>&gt; &gt; -&nbsp;&nbsp;&nbsp; memmove(name + 5, name + pos, len - pos);
<br>&gt; &gt; -&nbsp;&nbsp;&nbsp; name[5 + len - pos] = '\0';
<br>&gt; &gt; -&nbsp;&nbsp;&nbsp; return (5 + len - pos);
<br>&gt; &gt; +&nbsp;&nbsp;&nbsp; memmove(name + prefix_len, name + pos, len - pos);
<br>&gt; &gt; +&nbsp;&nbsp;&nbsp; name[prefix_len + len - pos] = '\0';
<br>&gt; &gt; +&nbsp;&nbsp;&nbsp; return (prefix_len + len - pos);
<br>&gt; &gt; }
<br>&gt; &gt; 
<br>&gt; &gt; static int
<br>&gt; &gt; -scan_devname(char *alias)
<br>&gt; &gt; +scan_devname(char *alias, char *prefix)
<br>&gt; &gt; {
<br>&gt; &gt; &nbsp;&nbsp;&nbsp; char *c;
<br>&gt; &gt; &nbsp;&nbsp;&nbsp; int i, n = 0;
<br>&gt; &gt; 
<br>&gt; &gt; -&nbsp;&nbsp;&nbsp; if (strncmp(alias, "mpath", 5))
<br>&gt; &gt; +&nbsp;&nbsp;&nbsp; if (!prefix || strncmp(alias, prefix, strlen(prefix)))
<br>&gt; &gt; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; return -1;
<br>&gt; &gt; 
<br>&gt; &gt; -&nbsp;&nbsp;&nbsp; c = alias + 5;
<br>&gt; &gt; +&nbsp;&nbsp;&nbsp; c = alias + strlen(prefix);
<br>&gt; &gt; &nbsp;&nbsp;&nbsp; while (*c != '\0' &amp;&amp; *c != ' ' &amp;&amp; *c != '\t') {
<br>&gt; &gt; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; i = *c - 'a';
<br>&gt; &gt; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; n = ( n * 26 ) + i;
<br>&gt; &gt; @@ -221,7 +222,7 @@ scan_devname(char *alias)
<br>&gt; &gt; }
<br>&gt; &gt; 
<br>&gt; &gt; static int
<br>&gt; &gt; -lookup_binding(FILE *f, char *map_wwid, char **map_alias)
<br>&gt; &gt; +lookup_binding(FILE *f, char *map_wwid, char **map_alias, char
<br>&gt; &gt; *prefix) {
<br>&gt; &gt; &nbsp;&nbsp;&nbsp; char buf[LINE_MAX];
<br>&gt; &gt; &nbsp;&nbsp;&nbsp; unsigned int line_nr = 0;
<br>&gt; &gt; @@ -240,7 +241,7 @@ lookup_binding(FILE *f, char *map_wwid, 
<br>&gt; &gt; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; alias = strtok(buf, " \t");
<br>&gt; &gt; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; if (!alias) /* blank line */
<br>&gt; &gt; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; continue;
<br>&gt; &gt; -&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; curr_id = scan_devname(alias);
<br>&gt; &gt; +&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; curr_id = scan_devname(alias, prefix);
<br>&gt; &gt; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; if (curr_id &gt;= id)
<br>&gt; &gt; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; id = curr_id + 1;
<br>&gt; &gt; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; wwid = strtok(NULL, "");
<br>&gt; &gt; @@ -284,7 +285,7 @@ rlookup_binding(FILE *f, char **map_wwid
<br>&gt; &gt; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; alias = strtok(buf, " \t");
<br>&gt; &gt; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; if (!alias) /* blank line */
<br>&gt; &gt; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; continue;
<br>&gt; &gt; -&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; curr_id = scan_devname(alias);
<br>&gt; &gt; +&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; curr_id = scan_devname(alias, NULL); /* TBD: Why this call? */
<br>&gt; &gt; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; if (curr_id &gt;= id)
<br>&gt; &gt; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; id = curr_id + 1;
<br>&gt; &gt; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; wwid = strtok(NULL, " \t");
<br>&gt; &gt; @@ -309,7 +310,7 @@ rlookup_binding(FILE *f, char **map_wwid
<br>&gt; &gt; }
<br>&gt; &gt; 
<br>&gt; &gt; static char *
<br>&gt; &gt; -allocate_binding(int fd, char *wwid, int id)
<br>&gt; &gt; +allocate_binding(int fd, char *wwid, int id, char *prefix)
<br>&gt; &gt; {
<br>&gt; &gt; &nbsp;&nbsp;&nbsp; char buf[LINE_MAX];
<br>&gt; &gt; &nbsp;&nbsp;&nbsp; off_t offset;
<br>&gt; &gt; @@ -321,7 +322,7 @@ allocate_binding(int fd, char *wwid, int
<br>&gt; &gt; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; return NULL;
<br>&gt; &gt; &nbsp;&nbsp;&nbsp; }
<br>&gt; &gt; 
<br>&gt; &gt; -&nbsp;&nbsp;&nbsp; i = format_devname(buf, id, LINE_MAX);
<br>&gt; &gt; +&nbsp;&nbsp;&nbsp; i = format_devname(buf, id, LINE_MAX, prefix);
<br>&gt; &gt; &nbsp;&nbsp;&nbsp; c = buf + i;
<br>&gt; &gt; &nbsp;&nbsp;&nbsp; snprintf(c,LINE_MAX - i, " %s\n", wwid);
<br>&gt; &gt; &nbsp;&nbsp;&nbsp; buf[LINE_MAX - 1] = '\0';
<br>&gt; &gt; @@ -352,7 +353,7 @@ allocate_binding(int fd, char *wwid, int
<br>&gt; &gt; }
<br>&gt; &gt; 
<br>&gt; &gt; char *
<br>&gt; &gt; -get_user_friendly_alias(char *wwid, char *file)
<br>&gt; &gt; +get_user_friendly_alias(char *wwid, char *file, char *prefix)
<br>&gt; &gt; {
<br>&gt; &gt; &nbsp;&nbsp;&nbsp; char *alias;
<br>&gt; &gt; &nbsp;&nbsp;&nbsp; int fd, scan_fd, id;
<br>&gt; &gt; @@ -385,7 +386,7 @@ get_user_friendly_alias(char *wwid, char
<br>&gt; &gt; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; return NULL;
<br>&gt; &gt; &nbsp;&nbsp;&nbsp; }
<br>&gt; &gt; 
<br>&gt; &gt; -&nbsp;&nbsp;&nbsp; id = lookup_binding(f, wwid, &amp;alias);
<br>&gt; &gt; +&nbsp;&nbsp;&nbsp; id = lookup_binding(f, wwid, &amp;alias, prefix);
<br>&gt; &gt; &nbsp;&nbsp;&nbsp; if (id &lt; 0) {
<br>&gt; &gt; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; fclose(f);
<br>&gt; &gt; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; close(scan_fd);
<br>&gt; &gt; @@ -394,7 +395,7 @@ get_user_friendly_alias(char *wwid, char
<br>&gt; &gt; &nbsp;&nbsp;&nbsp; }
<br>&gt; &gt; 
<br>&gt; &gt; &nbsp;&nbsp;&nbsp; if (!alias &amp;&amp; can_write)
<br>&gt; &gt; -&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; alias = allocate_binding(fd, wwid, id);
<br>&gt; &gt; +&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; alias = allocate_binding(fd, wwid, id, prefix);
<br>&gt; &gt; 
<br>&gt; &gt; &nbsp;&nbsp;&nbsp; fclose(f);
<br>&gt; &gt; &nbsp;&nbsp;&nbsp; close(scan_fd);
<br>&gt; &gt; diff -r 49b7dc2c9d46 -r b4d519b4bbc6 libmultipath/alias.h
<br>&gt; &gt; --- a/libmultipath/alias.h&nbsp;&nbsp;&nbsp; Tue Jun 15 17:23:49 2010 -0700
<br>&gt; &gt; +++ b/libmultipath/alias.h&nbsp;&nbsp;&nbsp; Tue Jun 22 19:25:24 2010 -0700
<br>&gt; &gt; @@ -8,5 +8,5 @@
<br>&gt; &gt; "# alias wwid\n" \
<br>&gt; &gt; "#\n"
<br>&gt; &gt; 
<br>&gt; &gt; -char *get_user_friendly_alias(char *wwid, char *file);
<br>&gt; &gt; +char *get_user_friendly_alias(char *wwid, char *file, char *prefix);
<br>&gt; &gt; char *get_user_friendly_wwid(char *alias, char *file);
<br>&gt; &gt; diff -r 49b7dc2c9d46 -r b4d519b4bbc6 libmultipath/config.c
<br>&gt; &gt; --- a/libmultipath/config.c&nbsp;&nbsp;&nbsp; Tue Jun 15 17:23:49 2010 -0700
<br>&gt; &gt; +++ b/libmultipath/config.c&nbsp;&nbsp;&nbsp; Tue Jun 22 19:25:24 2010 -0700
<br>&gt; &gt; @@ -158,6 +158,9 @@ free_hwe (struct hwentry * hwe)
<br>&gt; &gt; &nbsp;&nbsp;&nbsp; if (hwe-&gt;prio_args)
<br>&gt; &gt; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; FREE(hwe-&gt;prio_args);
<br>&gt; &gt; 
<br>&gt; &gt; +&nbsp;&nbsp;&nbsp; if (hwe-&gt;alias_prefix)
<br>&gt; &gt; +&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; FREE(hwe-&gt;alias_prefix);
<br>&gt; &gt; +
<br>&gt; &gt; &nbsp;&nbsp;&nbsp; if (hwe-&gt;bl_product)
<br>&gt; &gt; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; FREE(hwe-&gt;bl_product);
<br>&gt; &gt; 
<br>&gt; &gt; @@ -282,6 +285,7 @@ merge_hwe (struct hwentry * hwe1, struct
<br>&gt; &gt; &nbsp;&nbsp;&nbsp; merge_str(checker_name);
<br>&gt; &gt; &nbsp;&nbsp;&nbsp; merge_str(prio_name);
<br>&gt; &gt; &nbsp;&nbsp;&nbsp; merge_str(prio_args);
<br>&gt; &gt; +&nbsp;&nbsp;&nbsp; merge_str(alias_prefix);
<br>&gt; &gt; &nbsp;&nbsp;&nbsp; merge_str(bl_product);
<br>&gt; &gt; &nbsp;&nbsp;&nbsp; merge_num(pgpolicy);
<br>&gt; &gt; &nbsp;&nbsp;&nbsp; merge_num(pgfailback);
<br>&gt; &gt; @@ -333,6 +337,9 @@ store_hwe (vector hwtable, struct hwentr
<br>&gt; &gt; &nbsp;&nbsp;&nbsp; if (dhwe-&gt;prio_args &amp;&amp; !(hwe-&gt;prio_args =
<br>&gt; &gt; set_param_str(dhwe-&gt;prio_args)))&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; goto out;
<br>&gt; &gt; 
<br>&gt; &gt; +&nbsp;&nbsp;&nbsp; if (dhwe-&gt;alias_prefix &amp;&amp; !(hwe-&gt;alias_prefix =
<br>&gt; &gt; set_param_str(dhwe-&gt;alias_prefix))) +&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; goto out;
<br>&gt; &gt; +
<br>&gt; &gt; &nbsp;&nbsp;&nbsp; hwe-&gt;pgpolicy = dhwe-&gt;pgpolicy;
<br>&gt; &gt; &nbsp;&nbsp;&nbsp; hwe-&gt;pgfailback = dhwe-&gt;pgfailback;
<br>&gt; &gt; &nbsp;&nbsp;&nbsp; hwe-&gt;rr_weight = dhwe-&gt;rr_weight;
<br>&gt; &gt; @@ -409,6 +416,9 @@ free_config (struct config * conf)
<br>&gt; &gt; &nbsp;&nbsp;&nbsp; if (conf-&gt;prio_name)
<br>&gt; &gt; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; FREE(conf-&gt;prio_name);
<br>&gt; &gt; 
<br>&gt; &gt; +&nbsp;&nbsp;&nbsp; if (conf-&gt;alias_prefix)
<br>&gt; &gt; +&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; FREE(conf-&gt;alias_prefix);
<br>&gt; &gt; +
<br>&gt; &gt; &nbsp;&nbsp;&nbsp; if (conf-&gt;prio_args)
<br>&gt; &gt; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; FREE(conf-&gt;prio_args);
<br>&gt; &gt; 
<br>&gt; &gt; diff -r 49b7dc2c9d46 -r b4d519b4bbc6 libmultipath/config.h
<br>&gt; &gt; --- a/libmultipath/config.h&nbsp;&nbsp;&nbsp; Tue Jun 15 17:23:49 2010 -0700
<br>&gt; &gt; +++ b/libmultipath/config.h&nbsp;&nbsp;&nbsp; Tue Jun 22 19:25:24 2010 -0700
<br>&gt; &gt; @@ -25,6 +25,7 @@ struct hwentry {
<br>&gt; &gt; &nbsp;&nbsp;&nbsp; char * checker_name;
<br>&gt; &gt; &nbsp;&nbsp;&nbsp; char * prio_name;
<br>&gt; &gt; &nbsp;&nbsp;&nbsp; char * prio_args;
<br>&gt; &gt; +&nbsp;&nbsp;&nbsp; char * alias_prefix;
<br>&gt; &gt; 
<br>&gt; &gt; &nbsp;&nbsp;&nbsp; int pgpolicy;
<br>&gt; &gt; &nbsp;&nbsp;&nbsp; int pgfailback;
<br>&gt; &gt; @@ -99,6 +100,7 @@ struct config {
<br>&gt; &gt; &nbsp;&nbsp;&nbsp; char * prio_name;
<br>&gt; &gt; &nbsp;&nbsp;&nbsp; char * prio_args;
<br>&gt; &gt; &nbsp;&nbsp;&nbsp; char * checker_name;
<br>&gt; &gt; +&nbsp;&nbsp;&nbsp; char * alias_prefix;
<br>&gt; &gt; 
<br>&gt; &gt; &nbsp;&nbsp;&nbsp; vector keywords;
<br>&gt; &gt; &nbsp;&nbsp;&nbsp; vector mptable;
<br>&gt; &gt; diff -r 49b7dc2c9d46 -r b4d519b4bbc6 libmultipath/defaults.h
<br>&gt; &gt; --- a/libmultipath/defaults.h&nbsp;&nbsp;&nbsp; Tue Jun 15 17:23:49 2010 -0700
<br>&gt; &gt; +++ b/libmultipath/defaults.h&nbsp;&nbsp;&nbsp; Tue Jun 22 19:25:24 2010 -0700
<br>&gt; &gt; @@ -2,6 +2,7 @@
<br>&gt; &gt; #define DEFAULT_UDEVDIR&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; "/dev"
<br>&gt; &gt; #define DEFAULT_MULTIPATHDIR&nbsp;&nbsp;&nbsp; "/" LIB_STRING "/multipath"
<br>&gt; &gt; #define DEFAULT_SELECTOR&nbsp;&nbsp;&nbsp; "round-robin 0"
<br>&gt; &gt; +#define DEFAULT_ALIAS_PREFIX&nbsp;&nbsp;&nbsp; "mpath"
<br>&gt; &gt; #define DEFAULT_FEATURES&nbsp;&nbsp;&nbsp; "0"
<br>&gt; &gt; #define DEFAULT_HWHANDLER&nbsp;&nbsp;&nbsp; "0"
<br>&gt; &gt; #define DEFAULT_MINIO&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; 1000
<br>&gt; &gt; diff -r 49b7dc2c9d46 -r b4d519b4bbc6 libmultipath/dict.c
<br>&gt; &gt; --- a/libmultipath/dict.c&nbsp;&nbsp;&nbsp; Tue Jun 15 17:23:49 2010 -0700
<br>&gt; &gt; +++ b/libmultipath/dict.c&nbsp;&nbsp;&nbsp; Tue Jun 22 19:25:24 2010 -0700
<br>&gt; &gt; @@ -148,6 +148,17 @@ def_prio_handler(vector strvec)
<br>&gt; &gt; }
<br>&gt; &gt; 
<br>&gt; &gt; static int
<br>&gt; &gt; +def_alias_prefix_handler(vector strvec)
<br>&gt; &gt; +{
<br>&gt; &gt; +&nbsp;&nbsp;&nbsp; conf-&gt;alias_prefix = set_value(strvec);
<br>&gt; &gt; +
<br>&gt; &gt; +&nbsp;&nbsp;&nbsp; if (!conf-&gt;alias_prefix)
<br>&gt; &gt; +&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; return 1;
<br>&gt; &gt; +
<br>&gt; &gt; +&nbsp;&nbsp;&nbsp; return 0;
<br>&gt; &gt; +}
<br>&gt; &gt; +
<br>&gt; &gt; +static int
<br>&gt; &gt; def_prio_args_handler(vector strvec)
<br>&gt; &gt; {
<br>&gt; &gt; &nbsp;&nbsp;&nbsp; conf-&gt;prio_args = set_value(strvec);
<br>&gt; &gt; @@ -831,6 +842,22 @@ hw_prio_handler(vector strvec)
<br>&gt; &gt; }
<br>&gt; &gt; 
<br>&gt; &gt; static int
<br>&gt; &gt; +hw_alias_prefix_handler(vector strvec)
<br>&gt; &gt; +{
<br>&gt; &gt; +&nbsp;&nbsp;&nbsp; struct hwentry * hwe = VECTOR_LAST_SLOT(conf-&gt;hwtable);
<br>&gt; &gt; +
<br>&gt; &gt; +&nbsp;&nbsp;&nbsp; if (!hwe)
<br>&gt; &gt; +&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; return 1;
<br>&gt; &gt; +
<br>&gt; &gt; +&nbsp;&nbsp;&nbsp; hwe-&gt;alias_prefix = set_value(strvec);
<br>&gt; &gt; +
<br>&gt; &gt; +&nbsp;&nbsp;&nbsp; if (!hwe-&gt;alias_prefix)
<br>&gt; &gt; +&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; return 1;
<br>&gt; &gt; +
<br>&gt; &gt; +&nbsp;&nbsp;&nbsp; return 0;
<br>&gt; &gt; +}
<br>&gt; &gt; +
<br>&gt; &gt; +static int
<br>&gt; &gt; hw_prio_args_handler(vector strvec)
<br>&gt; &gt; {
<br>&gt; &gt; &nbsp;&nbsp;&nbsp; struct hwentry * hwe = VECTOR_LAST_SLOT(conf-&gt;hwtable);
<br>&gt; &gt; @@ -1580,6 +1607,19 @@ snprint_hw_prio (char * buff, int len, v
<br>&gt; &gt; }
<br>&gt; &gt; 
<br>&gt; &gt; static int
<br>&gt; &gt; +snprint_hw_alias_prefix (char * buff, int len, void * data)
<br>&gt; &gt; +{
<br>&gt; &gt; +&nbsp;&nbsp;&nbsp; struct hwentry * hwe = (struct hwentry *)data;
<br>&gt; &gt; +
<br>&gt; &gt; +&nbsp;&nbsp;&nbsp; if (!hwe-&gt;alias_prefix || (strlen(hwe-&gt;alias_prefix) == 0))
<br>&gt; &gt; +&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; return 0;
<br>&gt; &gt; +&nbsp;&nbsp;&nbsp; if (conf-&gt;alias_prefix &amp;&amp; !strcmp(hwe-&gt;alias_prefix,
<br>&gt; &gt; conf-&gt;alias_prefix)) +&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; return 0;
<br>&gt; &gt; +
<br>&gt; &gt; +&nbsp;&nbsp;&nbsp; return snprintf(buff, len, "%s", hwe-&gt;alias_prefix);
<br>&gt; &gt; +}
<br>&gt; &gt; +
<br>&gt; &gt; +static int
<br>&gt; &gt; snprint_hw_prio_args (char * buff, int len, void * data)
<br>&gt; &gt; {
<br>&gt; &gt; &nbsp;&nbsp;&nbsp; struct hwentry * hwe = (struct hwentry *)data;
<br>&gt; &gt; @@ -2076,6 +2116,16 @@ snprint_def_user_friendly_names (char * 
<br>&gt; &gt; }
<br>&gt; &gt; 
<br>&gt; &gt; static int
<br>&gt; &gt; +snprint_def_alias_prefix (char * buff, int len, void * data)
<br>&gt; &gt; +{
<br>&gt; &gt; +&nbsp;&nbsp;&nbsp; if (!conf-&gt;alias_prefix)
<br>&gt; &gt; +&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; return 0;
<br>&gt; &gt; +&nbsp;&nbsp;&nbsp; if (!strcmp(conf-&gt;alias_prefix, DEFAULT_ALIAS_PREFIX))
<br>&gt; &gt; +&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; return 0;
<br>&gt; &gt; +&nbsp;&nbsp;&nbsp; return snprintf(buff, len, conf-&gt;alias_prefix);
<br>&gt; &gt; +}
<br>&gt; &gt; +
<br>&gt; &gt; +static int
<br>&gt; &gt; snprint_ble_simple (char * buff, int len, void * data)
<br>&gt; &gt; {
<br>&gt; &gt; &nbsp;&nbsp;&nbsp; struct blentry * ble = (struct blentry *)data;
<br>&gt; &gt; @@ -2117,6 +2167,7 @@ init_keywords(void)
<br>&gt; &gt; &nbsp;&nbsp;&nbsp; install_keyword("features", &amp;def_features_handler,
<br>&gt; &gt; &amp;snprint_def_features);&nbsp;&nbsp;&nbsp; install_keyword("path_checker",
<br>&gt; &gt; &amp;def_path_checker_handler, &amp;snprint_def_path_checker);
<br>&gt; &gt; &nbsp;&nbsp;&nbsp; install_keyword("checker", &amp;def_path_checker_handler,
<br>&gt; &gt; &amp;snprint_def_path_checker); +&nbsp;&nbsp;&nbsp; install_keyword("alias_prefix",
<br>&gt; &gt; &amp;def_alias_prefix_handler, &amp;snprint_def_alias_prefix);
<br>&gt; &gt; &nbsp;&nbsp;&nbsp; install_keyword("failback", &amp;default_failback_handler,
<br>&gt; &gt; &amp;snprint_def_failback);&nbsp;&nbsp;&nbsp; install_keyword("rr_min_io",
<br>&gt; &gt; &amp;def_minio_handler, &amp;snprint_def_rr_min_io);
<br>&gt; &gt; &nbsp;&nbsp;&nbsp; install_keyword("max_fds", &amp;max_fds_handler, &amp;snprint_max_fds); @@
<br>&gt; &gt; -2176,6 +2227,7 @@ init_keywords(void)
<br>&gt; &gt; &nbsp;&nbsp;&nbsp; install_keyword("path_selector", &amp;hw_selector_handler,
<br>&gt; &gt; &amp;snprint_hw_selector);&nbsp;&nbsp;&nbsp; install_keyword("path_checker",
<br>&gt; &gt; &amp;hw_path_checker_handler, &amp;snprint_hw_path_checker);
<br>&gt; &gt; &nbsp;&nbsp;&nbsp; install_keyword("checker", &amp;hw_path_checker_handler,
<br>&gt; &gt; &amp;snprint_hw_path_checker); +&nbsp;&nbsp;&nbsp; install_keyword("alias_prefix",
<br>&gt; &gt; &amp;hw_alias_prefix_handler, &amp;snprint_hw_alias_prefix);
<br>&gt; &gt; &nbsp;&nbsp;&nbsp; install_keyword("features", &amp;hw_features_handler,
<br>&gt; &gt; &amp;snprint_hw_features);&nbsp;&nbsp;&nbsp; install_keyword("hardware_handler",
<br>&gt; &gt; &amp;hw_handler_handler, &amp;snprint_hw_hardware_handler);
<br>&gt; &gt; &nbsp;&nbsp;&nbsp; install_keyword("prio", &amp;hw_prio_handler, &amp;snprint_hw_prio); diff -r
<br>&gt; &gt; 49b7dc2c9d46 -r b4d519b4bbc6 libmultipath/propsel.c ---
<br>&gt; &gt; a/libmultipath/propsel.c&nbsp;&nbsp;&nbsp; Tue Jun 15 17:23:49 2010 -0700 +++
<br>&gt; &gt; b/libmultipath/propsel.c&nbsp;&nbsp;&nbsp; Tue Jun 22 19:25:24 2010 -0700 @@ -215,6
<br>&gt; &gt; +215,26 @@ select_selector (struct multipath * mp)&nbsp;&nbsp;&nbsp; return 0; }
<br>&gt; &gt; 
<br>&gt; &gt; +static void
<br>&gt; &gt; +select_alias_prefix (struct multipath * mp)
<br>&gt; &gt; +{
<br>&gt; &gt; +&nbsp;&nbsp;&nbsp; if (mp-&gt;hwe &amp;&amp; mp-&gt;hwe-&gt;alias_prefix) {
<br>&gt; &gt; +&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; mp-&gt;alias_prefix = mp-&gt;hwe-&gt;alias_prefix;
<br>&gt; &gt; +&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; condlog(3, "%s: alias_prefix = %s (controller setting)",
<br>&gt; &gt; +&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; mp-&gt;wwid, mp-&gt;alias_prefix);
<br>&gt; &gt; +&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; return;
<br>&gt; &gt; +&nbsp;&nbsp;&nbsp; }
<br>&gt; &gt; +&nbsp;&nbsp;&nbsp; if (conf-&gt;alias_prefix) {
<br>&gt; &gt; +&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; mp-&gt;alias_prefix = conf-&gt;alias_prefix;
<br>&gt; &gt; +&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; condlog(3, "%s: alias_prefix = %s (config file default)",
<br>&gt; &gt; +&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; mp-&gt;wwid, mp-&gt;alias_prefix);
<br>&gt; &gt; +&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; return;
<br>&gt; &gt; +&nbsp;&nbsp;&nbsp; }
<br>&gt; &gt; +&nbsp;&nbsp;&nbsp; mp-&gt;alias_prefix = set_default(DEFAULT_ALIAS_PREFIX);
<br>&gt; &gt; +&nbsp;&nbsp;&nbsp; condlog(3, "%s: alias_prefix = %s (internal default)",
<br>&gt; &gt; +&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; mp-&gt;wwid, mp-&gt;alias_prefix);
<br>&gt; &gt; +}
<br>&gt; &gt; +
<br>&gt; &gt; extern int
<br>&gt; &gt; select_alias (struct multipath * mp)
<br>&gt; &gt; {
<br>&gt; &gt; @@ -222,9 +242,11 @@ select_alias (struct multipath * mp)
<br>&gt; &gt; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; mp-&gt;alias = mp-&gt;mpe-&gt;alias;
<br>&gt; &gt; &nbsp;&nbsp;&nbsp; else {
<br>&gt; &gt; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; mp-&gt;alias = NULL;
<br>&gt; &gt; -&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; if (conf-&gt;user_friendly_names)
<br>&gt; &gt; +&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; if (conf-&gt;user_friendly_names) {
<br>&gt; &gt; +&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; select_alias_prefix(mp);
<br>&gt; &gt; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; mp-&gt;alias = get_user_friendly_alias(mp-&gt;wwid,
<br>&gt; &gt; -&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; conf-&gt;bindings_file);
<br>&gt; &gt; +&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; conf-&gt;bindings_file, mp-&gt;alias_prefix);
<br>&gt; &gt; +&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; }
<br>&gt; &gt; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; if (mp-&gt;alias == NULL){
<br>&gt; &gt; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; char *alias;
<br>&gt; &gt; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; if ((alias = MALLOC(WWID_SIZE)) != NULL){
<br>&gt; &gt; diff -r 49b7dc2c9d46 -r b4d519b4bbc6 libmultipath/structs.h
<br>&gt; &gt; --- a/libmultipath/structs.h&nbsp;&nbsp;&nbsp; Tue Jun 15 17:23:49 2010 -0700
<br>&gt; &gt; +++ b/libmultipath/structs.h&nbsp;&nbsp;&nbsp; Tue Jun 22 19:25:24 2010 -0700
<br>&gt; &gt; @@ -186,6 +186,7 @@ struct multipath {
<br>&gt; &gt; 
<br>&gt; &gt; &nbsp;&nbsp;&nbsp; /* configlet pointers */
<br>&gt; &gt; &nbsp;&nbsp;&nbsp; char * alias;
<br>&gt; &gt; +&nbsp;&nbsp;&nbsp; char * alias_prefix;
<br>&gt; &gt; &nbsp;&nbsp;&nbsp; char * selector;
<br>&gt; &gt; &nbsp;&nbsp;&nbsp; char * features;
<br>&gt; &gt; &nbsp;&nbsp;&nbsp; char * hwhandler;
<br>&gt; &gt; 
<br>&gt; &gt; --
<br>&gt; &gt; dm-devel mailing list
<br>&gt; &gt; <a href="mailto:dm-devel@redhat.com">dm-devel@redhat.com</a>
<br>&gt; &gt; <a href="https://www.redhat.com/mailman/listinfo/dm-devel">https://www.redhat.com/mailman/listinfo/dm-devel</a>
<br>&gt; 
<br>&gt; --
<br>&gt; dm-devel mailing list
<br>&gt; <a href="mailto:dm-devel@redhat.com">dm-devel@redhat.com</a>
<br>&gt; <a href="https://www.redhat.com/mailman/listinfo/dm-devel">https://www.redhat.com/mailman/listinfo/dm-devel</a>
<br><br></p>
</body>
</html>

--=-/IdntoaCQCPCWJsx/CCz--


--===============1982515567562081808==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 7bit


--===============1982515567562081808==--
