From: David Strand <dpstrand@gmail.com>
Subject: Re: multipathd segfault
Date: Fri, 27 Mar 2009 10:08:14 -0700
Message-ID: <448b15030903271008u3ff803cem3252be01adcd313f@mail.gmail.com>
References: <448b15030903261725x1fc4c02dx594c6df7b8daa11e@mail.gmail.com>
	<49CC8546.9080500@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <49CC8546.9080500@suse.de>
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

Yep, that was exactly it.

2009/3/27 Hannes Reinecke <hare@suse.de>:
> David Strand wrote:
>>
>> I am getting a multipathd segfault when I have more than 26 devices,
>> and the device names become 4 characters. (i.e. /dev/sdz is consumed
>> and the next device is /dev/sdaa).
>>
>> I was trying to hook gdb to a core dump, but it keeps complaining that
>> it needs device-mapper-libs-debuginfo, which I can not find. Can
>> anyone point me to this?
>>
>> I built multipathd with -g turned on and did not strip it. Here is the
>> last few lines of output when I run it as multipathd -v9 -d:
>>
>> Jul 04 05:01:26 | alpa-0x000080: discover
>> Jul 04 05:01:26 | libdevmapper: ioctl/libdm-iface.c(1606): dm table
>> alpa-0x000080 =C2=A0NF =C2=A0 [16384]
>> Jul 04 05:01:26 | *word =3D 0, len =3D 1
>> Jul 04 05:01:26 | *word =3D 0, len =3D 1
>> Jul 04 05:01:26 | *word =3D 1, len =3D 1
>> Jul 04 05:01:26 | *word =3D 1, len =3D 1
>> Jul 04 05:01:26 | *word =3D 1, len =3D 1
>> Jul 04 05:01:26 | *word =3D 1, len =3D 1
>> Jul 04 05:01:26 | *word =3D 65:160, len =3D 6
>> Jul 04 05:01:26 | *word =3D 1000, len =3D 4
>> Jul 04 05:01:26 | libdevmapper: ioctl/libdm-iface.c(1606): dm status
>> alpa-0x000080 =C2=A0NF =C2=A0 [16384]
>> Jul 04 05:01:26 | *word =3D 2, len =3D 1
>> Jul 04 05:01:26 | *word =3D 0, len =3D 1
>> Jul 04 05:01:26 | *word =3D 0, len =3D 1
>> Jul 04 05:01:26 | *word =3D 1, len =3D 1
>> Jul 04 05:01:26 | *word =3D E, len =3D 1
>> Jul 04 05:01:26 | *word =3D 1, len =3D 1
>> Jul 04 05:01:26 | *word =3D 0, len =3D 1
>> Jul 04 05:01:26 | *word =3D A, len =3D 1
>> Jul 04 05:01:26 | *word =3D 0, len =3D 1
>> Jul 04 05:01:26 | alpa-0x000080: rr_weight =3D 1 (internal default)
>> Jul 04 05:01:26 | alpa-0x000080: pgfailback =3D -2 (config file defaul=
t)
>> Jul 04 05:01:26 | alpa-0x000080: no_path_retry =3D 3 (config file defa=
ult)
>> Jul 04 05:01:26 | libdevmapper: ioctl/libdm-iface.c(1606): dm message
>> alpa-0x000080 =C2=A0NF =C2=A0queue_if_no_path
>> =C2=A0[16384]
>> Jul 04 05:01:26 | pg_timeout =3D NONE (internal default)
>> Jul 04 05:01:26 | alpa-0x000080: event checker started
>> Jul 04 05:01:26 | sdaa path added to devmap alpa-0x000080
>> Jul 04 05:01:26 | discard event on /block/sdaa/sdaa1
>> Segmentation fault
>>
> Oh, that one.
>
> Fixed by the attached path.
>
> Christophe, care to apply?
>
> Cheers,
>
> Hannes
> --
> Dr. Hannes Reinecke =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 zSeries & Storage
> hare@suse.de =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0+49 911 74053 688
> SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
> GF: Markus Rex, HRB 16746 (AG N=C3=BCrnberg)
>
> commit 223885b66311bbb47e439557eced066b3324ad8e
> Author: Hannes Reinecke <hare@suse.de>
> Date: =C2=A0 Tue Mar 10 08:57:18 2009 +0100
>
> =C2=A0 =C2=A0Stack overflow in uev_trigger()
>
> =C2=A0 =C2=A0uev_discard uses sscanf to write a 10 byte string into an =
array,
> =C2=A0 =C2=A0but I forgot to take the trailing NULL byte into account.
>
> =C2=A0 =C2=A0References: bnc#476540
>
> =C2=A0 =C2=A0Signed-off-by: Hannes Reinecke <hare@suse.de>
>
> diff --git a/multipathd/main.c b/multipathd/main.c
> index 7c995b6..1d8ff5a 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -652,7 +652,7 @@ uxsock_trigger (char * str, char ** reply, int * le=
n,
> void * trigger_data)
> =C2=A0static int
> =C2=A0uev_discard(char * devpath)
> =C2=A0{
> - =C2=A0 =C2=A0 =C2=A0 char a[10], b[10], *c;
> + =C2=A0 =C2=A0 =C2=A0 char a[11], b[11], *c;
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0/*
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 * keep only block devices, discard partitio=
ns
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>
