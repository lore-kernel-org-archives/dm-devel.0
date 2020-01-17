From: Maik Otto <m.otto@phytec.de>
Subject: Re: [RFC PATCH 2/2] dm-crypt: Use any key type which is registered
Date: Fri, 17 Jan 2020 12:52:21 +0100
Message-ID: <97ab8779-1351-0030-7a9f-fababe1f57c2@phytec.de>
References: <1551456599-10603-1-git-send-email-franck.lenormand@nxp.com>
 <1551456599-10603-3-git-send-email-franck.lenormand@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <1551456599-10603-3-git-send-email-franck.lenormand@nxp.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Franck LENORMAND <franck.lenormand@nxp.com>, linux-security-module@vger.kernel.org, keyrings@vger.kernel.org
Cc: horia.geanta@nxp.com, silvano.dininno@nxp.com, agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com, dhowells@redhat.com, jmorris@namei.org, serge@hallyn.com
List-Id: dm-devel.ids

Hi

little bug fix, because this version chrashed with access violation
on an i.MX6Quad with a Mainline Kernel 4.19.88

> There was only 2 key=5Ftype supported by dm-crypt which limits other
> implementations.
>
> This patch allows to use any key=5Ftype which is registered obtaining
> the key=5Ftype from key framework.
>
> This also remove the compilation dependency between dm-crypt and
> key implementations.
>
> Signed-off-by: Franck LENORMAND <franck.lenormand@nxp.com>
> ---
>   drivers/md/dm-crypt.c    | 11 ++++++-----
>   include/linux/key-type.h |  2 ++
>   security/keys/key.c      | 42 ++++++++++++++++++++++++++++++++++++++++++
>   3 files changed, 50 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
> index dd538e6..e25efc2 100644
> --- a/drivers/md/dm-crypt.c
> +++ b/drivers/md/dm-crypt.c
> @@ -35,6 +35,7 @@
>   #include <crypto/authenc.h>
>   #include <linux/rtnetlink.h> /* for struct rtattr and RTA macros only */
>   #include <keys/user-type.h>
> +#include <linux/key-type.h>
>  =20
>   #include <linux/device-mapper.h>
>  =20
> @@ -2010,6 +2011,7 @@ static int crypt=5Fset=5Fkeyring=5Fkey(struct crypt=
=5Fconfig *cc, const char *key=5Fstring
>   	int ret;
>   	struct key *key;
>   	const struct user=5Fkey=5Fpayload *ukp;
> +	struct key=5Ftype *type;
>  =20
>   	/*
>   	 * Reject key=5Fstring with whitespace. dm core currently lacks code f=
or
> @@ -2025,16 +2027,15 @@ static int crypt=5Fset=5Fkeyring=5Fkey(struct cry=
pt=5Fconfig *cc, const char *key=5Fstring
>   	if (!key=5Fdesc || key=5Fdesc =3D=3D key=5Fstring || !strlen(key=5Fdes=
c + 1))
>   		return -EINVAL;
>  =20
> -	if (strncmp(key=5Fstring, "logon:", key=5Fdesc - key=5Fstring + 1) &&
> -	    strncmp(key=5Fstring, "user:", key=5Fdesc - key=5Fstring + 1))
> -		return -EINVAL;
> +	type =3D get=5Fkey=5Ftype(key=5Fstring, key=5Fdesc - key=5Fstring);
> +	if (!type)
> +		return -ENOENT;
>  =20
>   	new=5Fkey=5Fstring =3D kstrdup(key=5Fstring, GFP=5FKERNEL);
>   	if (!new=5Fkey=5Fstring)
>   		return -ENOMEM;
>  =20
> -	key =3D request=5Fkey(key=5Fstring[0] =3D=3D 'l' ? &key=5Ftype=5Flogon =
: &key=5Ftype=5Fuser,
> -			  key=5Fdesc + 1, NULL);
> +	key =3D request=5Fkey(type, key=5Fdesc + 1, NULL);
>   	if (IS=5FERR(key)) {
>   		kzfree(new=5Fkey=5Fstring);
>   		return PTR=5FERR(key);
> diff --git a/include/linux/key-type.h b/include/linux/key-type.h
> index bc9af55..2b2167b 100644
> --- a/include/linux/key-type.h
> +++ b/include/linux/key-type.h
> @@ -176,6 +176,8 @@ extern struct key=5Ftype key=5Ftype=5Fkeyring;
>   extern int register=5Fkey=5Ftype(struct key=5Ftype *ktype);
>   extern void unregister=5Fkey=5Ftype(struct key=5Ftype *ktype);
>  =20
> +extern struct key=5Ftype *get=5Fkey=5Ftype(const char *type=5Fname, size=
=5Ft string=5Fsize);
> +
>   extern int key=5Fpayload=5Freserve(struct key *key, size=5Ft datalen);
>   extern int key=5Finstantiate=5Fand=5Flink(struct key *key,
>   				    const void *data,
> diff --git a/security/keys/key.c b/security/keys/key.c
> index 44a80d6..ef76114 100644
> --- a/security/keys/key.c
> +++ b/security/keys/key.c
> @@ -1156,6 +1156,48 @@ void unregister=5Fkey=5Ftype(struct key=5Ftype *kt=
ype)
>   }
>   EXPORT=5FSYMBOL(unregister=5Fkey=5Ftype);
>  =20
> +/**
> + * get=5Fkey=5Ftype - Get the type of key using its name
> + * @type=5Fname: Name of the key type to get
> + * @string=5Fsize: Size of the string to match
> + *
> + * The functions support null ended string (string=5Fsize =3D=3D 0) as w=
ell as
> + * pointer on a string matching a number of characters (string=5Fsize > =
0)
> + *
> + * Returns a pointer on the key type if successful, -ENOENT if the key t=
ype
> + * is not registered.
> + */
> +struct key=5Ftype *get=5Fkey=5Ftype(const char *type=5Fname, size=5Ft st=
ring=5Fsize)
> +{
> +	struct key=5Ftype *p;
> +	struct key=5Ftype *ktype =3D ERR=5FPTR(-ENOENT);
> +
> +	if (!type=5Fname)
> +		return ktype;
> +
> +	down=5Fwrite(&key=5Ftypes=5Fsem);

down=5Fwrite(&key=5Ftypes=5Fsem);=C2=A0 changed to down=5Fread(&key=5Ftypes=
=5Fsem);

> +
> +	/* Search the key type in the list */
> +	list=5Ffor=5Feach=5Fentry(p, &key=5Ftypes=5Flist, link) {
> +		if (string=5Fsize) {
> +			if (strncmp(p->name, type=5Fname, string=5Fsize) =3D=3D 0) {
> +				ktype =3D p;
> +				break;
> +			}
> +		} else {
> +			if (strcmp(p->name, type=5Fname) =3D=3D 0) {
> +				ktype =3D p;
> +				break;
> +			}
> +		}
> +	}
> +
> +	up=5Fread(&key=5Ftypes=5Fsem);
> +
> +	return ktype;
> +}
> +EXPORT=5FSYMBOL(get=5Fkey=5Ftype);
> +
>   /*
>    * Initialise the key management state.
>    */
>
