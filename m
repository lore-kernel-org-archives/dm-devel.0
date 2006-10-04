From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: patch for handling clariion I/O to
Date: Thu, 05 Oct 2006 00:09:13 +0200
Message-ID: <1159999754.15916.20.camel@localhost.localdomain>
References: <6CCEAEDF4D06984A83F427424F47D6E4013D1412@CORPUSMX40A.corp.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <6CCEAEDF4D06984A83F427424F47D6E4013D1412@CORPUSMX40A.corp.emc.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Edward Goggin <egoggin@emc.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Le mercredi 04 octobre 2006 =C3=A0 16:01 -0400, Edward Goggin a =C3=A9cri=
t :
> Christophe,
>=20
> This patch attempts to prevent an I/O hang which can occur with host I/=
O
> to an "in-active" CLARiiON snapshot LU.  While the snapshot LU is
> presented to the host, inquiry, TUR, and read capacity commands succeed=
,
> but read and write commands are failed.
>=20
> The patch is not entirely CLARiiON specific since I've added a field to
> the multipath structure (failallpaths) and I've modified the interface
> of the sg_read function in libcheckers/readsector0.c.  If you prefer
> that I do this with a solution which is entirely isolated to the
> CLARiiON, I can do that instead.
>=20

I don't see you ever reseting "allfailpaths". Isn't it a problem ?

If "failallpaths" usage is limited to "emc_clariion.c", I would rather
see it added to the "struct emc_clariion_checker_context" instead of
"struct multipath" :

- no need to include libmultipath headers in checkers
- no need to declare (and use) the "container_of" macro ;)


The sg_read() change looks opportune indeed. I'll apply it as soon as we
have the other pieces sorted out.

Thanks,
cvaroqui



> diff --git a/libcheckers/emc_clariion.c b/libcheckers/emc_clariion.c
> index a883e3d..e4004a7 100644
> --- a/libcheckers/emc_clariion.c
> +++ b/libcheckers/emc_clariion.c
> @@ -3,6 +3,7 @@
>   */
>  #include <stdio.h>
>  #include <stdlib.h>
> +#include <stddef.h>
>  #include <string.h>
>  #include <sys/types.h>
>  #include <sys/stat.h>
> @@ -14,6 +15,14 @@
>  #include "checkers.h"
> =20
>  #include "../libmultipath/sg_include.h"
> +#include "../libmultipath/vector.h"
> +#include "../libmultipath/structs.h"
> +
> +#define container_of(ptr, type, member) ({			\
> +        const typeof( ((type *)0)->member ) *__mptr =3D (ptr);	\
> +        (type *)( (char *)__mptr - offsetof(type,member) );})
> +
> +int sg_read (int sg_fd, unsigned char * buff, unsigned char *
> senseBuff);
> =20
>  #define INQUIRY_CMD     0x12
>  #define INQUIRY_CMDLEN  6
> @@ -40,13 +49,18 @@ void emc_clariion_free (struct checker *
> =20
>  int emc_clariion(struct checker * c)
>  {
> -	unsigned char sense_buffer[256] =3D { 0, };
> +	unsigned char sense_buffer[256] =3D { 0, }, *sbb;
>  	unsigned char sb[128] =3D { 0, };
>  	unsigned char inqCmdBlk[INQUIRY_CMDLEN] =3D {INQUIRY_CMD, 1, 0xC0,
> 0,
>  						sizeof(sb), 0};
>  	struct sg_io_hdr io_hdr;
>  	struct emc_clariion_checker_context * ct =3D
>  		(struct emc_clariion_checker_context *)c->context;
> +	struct path *p;
> +	int ret;
> +
> +	p =3D container_of(c, struct path, checker);
> +
> =20
>  	memset(&io_hdr, 0, sizeof (struct sg_io_hdr));
>  	io_hdr.interface_id =3D 'S';
> @@ -110,7 +124,27 @@ int emc_clariion(struct checker * c)
>  		ct->wwn_set =3D 1;
>  	}
>  =09
> -=09
> -	MSG(c, "emc_clariion_checker: Path healthy");
> -        return PATH_UP;
> +	if (p->mpp && p->mpp->failallpaths) {
> +		ret =3D PATH_DOWN;
> +		MSG(c, "emc_clariion_checker: Path to inactive
> snapshot.");
> +	}
> +	else {
> +		unsigned char buf[512];
> +
> +		ret =3D sg_read(c->fd, &buf[0], sbb =3D &sense_buffer[0]);
> +
> +		if (((sbb[2]&0xf) =3D=3D 5) && (sbb[12] =3D=3D 0x25) &&
> (sbb[13]=3D=3D1)) {
> +			if (p->mpp)
> +				p->mpp->failallpaths =3D 1;
> +			MSG(c, "emc_clariion_checker: Path to inactive
> snapshot.");
> +			ret =3D PATH_DOWN;
> +		}
> +		else if (((sbb[2]&0xf)=3D=3D2) && (sbb[12]=3D=3D4) &&
> (sbb[13]=3D=3D3)) {
> +			MSG(c, "emc_clariion_checker: Passive path is
> healthy.");
> +			ret =3D PATH_UP;	/* not ghost */
> +		}
> +		else
> +			MSG(c, "emc_clariion_checker: Active path is
> healthy.");
> +	}
> +	return ret;
>  }
> diff --git a/libcheckers/readsector0.c b/libcheckers/readsector0.c
> index b0acec9..dd18528 100644
> --- a/libcheckers/readsector0.c
> +++ b/libcheckers/readsector0.c
> @@ -34,8 +34,8 @@ void readsector0_free (struct checker *=20
>  	return;
>  }
> =20
> -static int
> -sg_read (int sg_fd, unsigned char * buff)
> +int
> +sg_read (int sg_fd, unsigned char * buff, unsigned char * senseBuff)
>  {
>  	/* defaults */
>  	int blocks =3D 1;
> @@ -45,7 +45,6 @@ sg_read (int sg_fd, unsigned char * buff
>  	int * diop =3D NULL;
> =20
>  	unsigned char rdCmd[cdbsz];
> -	unsigned char senseBuff[SENSE_BUFF_LEN];
>  	struct sg_io_hdr io_hdr;
>  	int res;
>  	int rd_opcode[] =3D {0x8, 0x28, 0xa8, 0x88};
> @@ -97,9 +96,10 @@ extern int
>  readsector0 (struct checker * c)
>  {
>  	unsigned char buf[512];
> +	unsigned char sbuf[SENSE_BUFF_LEN];
>  	int ret;
> =20
> -	ret =3D sg_read(c->fd, &buf[0]);
> +	ret =3D sg_read(c->fd, &buf[0], &sbuf[0]);
> =20
>  	switch (ret)
>  	{
> diff --git a/libmultipath/structs.h b/libmultipath/structs.h
> index faa2b8f..049c82b 100644
> --- a/libmultipath/structs.h
> +++ b/libmultipath/structs.h
> @@ -127,6 +127,7 @@ struct multipath {
>  	int no_path_retry; /* number of retries after all paths are down
> */
>  	int retry_tick;    /* remaining times for retries */
>  	int minio;
> +	int failallpaths;
>  	unsigned long long size;
>  	vector paths;
>  	vector pg;
>=20
>=20
>=20
