From: Arsene Gschwind <arsene.gschwind@unibas.ch>
Subject: Re: multipath disk size
Date: Thu, 13 Apr 2006 18:41:39 +0200
Message-ID: <443E7F43.9060907@unibas.ch>
References: <4436271F.1090509@unibas.ch> <4436E844.2090301@free.fr>
	<443C098D.1090604@unibas.ch> <443CF049.40003@unibas.ch>
	<443D58CA.8080301@free.fr>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <443D58CA.8080301@free.fr>
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

Hello Christophe,

I've applied the patchs editing by hand.
Doing tests after applied the first Patch results in an empty serial=20
printout, but the volume size returned is korrekt and the multipath=20
driver works fine.
Doing tests after applied the second Patch results with a correct serial=20
printout and correct volume size.
It seems that this 2 patches resolved my issue, thanks a lot.

Are you going to release a new tarball version which includes this 2=20
patches?

Thanks a lot et "Joyeuse P=E2ques" avec beaucoup de chocolat :-)
Ars=E8ne

Christophe Varoqui wrote:

> Arsene Gschwind a =E9crit :
>
>> I've found something strange, 2 declaration of SERIAL_SIZE with=20
>> different sizes
>> libmultipath/structs.h:#define SERIAL_SIZE              17
>> path_priority/pp_balance_units/pp_balance_units.c:#define SERIAL_SIZE=20
>> 255
>>
>> In my case the first buffer size is to small because pp->serial has a=20
>> size of 17 chars and when you look at my output it has 40 chars.
>> By setting libmultipath/structs.h:#define SERIAL_SIZE    to 255 it=20
>> works for me and the returned volume size is correct.
>> I'm not sure if this is the right solution, it would be great if=20
>> someone could verify that issue.
>>
>> Thanks a lot for your work
>> Ars=E8ne
>>
>>
> Very good catch.
> get_serial() was happily overflowing.
> Sorry for your being the first with a long-serial-hardware :)
>
>
> Please try the following 2 patchs, with testing between to 2, please.
>
> =3D=3D=3D 1=3D=3D=3D
> diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
> --- a/libmultipath/discovery.c
> +++ b/libmultipath/discovery.c
> @@ -339,24 +339,26 @@ do_inq(int sg_fd, int cmddt, int evpd, u
>         return -1;
> }
>
> -int
> -get_serial (char * str, int fd)
> +static int
> +get_serial (char * str, int maxlen, int fd)
> {
>         int len =3D 0;
>         char buff[MX_ALLOC_LEN + 1] =3D {0};
>
>        if (fd < 0)
> -                return 0;
> +                return 1;
>
>        if (0 =3D=3D do_inq(fd, 0, 1, 0x80, buff, MX_ALLOC_LEN, 0)) {
>                len =3D buff[3];
> +               if (len >=3D maxlen)
> +                       return 1;
>                if (len > 0) {
>                        memcpy(str, buff + 4, len);
>                        str[len] =3D '\0';
>                }
> -               return 1;
> +               return 0;
>        }
> -        return 0;
> +        return 1;
> }
>
> static int
> @@ -597,7 +599,7 @@ static int
> scsi_ioctl_pathinfo (struct path * pp, int mask)
> {
>        if (mask & DI_SERIAL) {
> -               get_serial(pp->serial, pp->fd);
> +               get_serial(pp->serial, SERIAL_SIZE, pp->fd);
>                condlog(3, "%s: serial =3D %s", pp->dev, pp->serial);
>        }
>
> diff --git a/libmultipath/discovery.h b/libmultipath/discovery.h
> --- a/libmultipath/discovery.h
> +++ b/libmultipath/discovery.h
> @@ -30,7 +30,6 @@ int sysfs_get_size (char * sysfs_path, c
> int path_discovery (vector pathvec, struct config * conf, int flag);
>
> void basename (char *, char *);
> -int get_serial (char * buff, int fd);
> int do_tur (char *);
> int devt2devname (char *, char *);
> int pathinfo (struct path *, vector hwtable, int mask);
> diff --git a/path_priority/pp_balance_units/pp_balance_units.c=20
> b/path_priority/pp_balance_units/pp_balance_units.c
> --- a/path_priority/pp_balance_units/pp_balance_units.c
> +++ b/path_priority/pp_balance_units/pp_balance_units.c
> @@ -172,7 +172,7 @@ do_inq(int sg_fd, int cmddt, int evpd, u
> }
>
> static int
> -get_serial (char * str, char * devt)
> +get_serial (char * str, int maxlen, char * devt)
> {
>        int fd;
>         int len;
> @@ -181,20 +181,22 @@ get_serial (char * str, char * devt)
>        fd =3D opennode(devt, O_RDONLY);
>
>        if (fd < 0)
> -                return 0;
> +                return 1;
>
>        if (0 =3D=3D do_inq(fd, 0, 1, 0x80, buff, MX_ALLOC_LEN, 0)) {
>                len =3D buff[3];
> +               if (len >=3D maxlen)
> +                       return 1;
>                if (len > 0) {
>                        memcpy(str, buff + 4, len);
>                        buff[len] =3D '\0';
>                }
>                close(fd);
> -               return 1;
> +               return 0;
>        }
>
>        closenode(devt, fd);
> -        return 0;
> +        return 1;
> }
>
> static void *
> @@ -358,7 +360,7 @@ get_paths (vector pathvec)
>                        if (pos =3D=3D BEFOREPG)
>                                pos =3D INPG;
>
> -                       get_serial(pp->serial, pp->dev_t);
> +                       get_serial(pp->serial, SERIAL_SIZE, pp->dev_t);
>                        vector_alloc_slot(pathvec);
>                        vector_set_slot(pathvec, pp);
>                        debug("store %s [%s]",
> @@ -449,7 +451,7 @@ main (int argc, char **argv)
>        if (optind<argc)
>                strncpy(ref_path->dev_t, argv[optind], WORD_SIZE);
>
> -       get_serial(ref_path->serial, ref_path->dev_t);
> +       get_serial(ref_path->serial, SERIAL_SIZE, ref_path->dev_t);
>
>        if (!ref_path->serial || !strlen(ref_path->serial))
>                exit_tool(0);
>
>
> =3D=3D=3D=3D 2 =3D=3D=3D=3D
> diff --git a/libmultipath/structs.h b/libmultipath/structs.h
> --- a/libmultipath/structs.h
> +++ b/libmultipath/structs.h
> @@ -2,7 +2,7 @@
> #define _STRUCTS_H
>
> #define WWID_SIZE              64
> -#define SERIAL_SIZE            17
> +#define SERIAL_SIZE            64
> #define NODE_NAME_SIZE         19
> #define PATH_STR_SIZE                  16
> #define PARAMS_SIZE            1024
>
>
>
> --=20
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel


--=20
***********************************************************
Gschwind Arsene		=09
Universitaet Rechenzentrum (URZ)
Klingelbergstrasse 70
CH-4056 Basel
SWITZERLAND

Languages : F/E/D
WWW:  <http://www.urz.unibas.ch>
Mail: <Arsene DOT Gschwind AT unibas DOT ch>
************************************************************
