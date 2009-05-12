From: christophe.varoqui@free.fr
Subject: Re: Memory leak in multipathd.
Date: Tue, 12 May 2009 23:05:08 +0200 (CEST)
Message-ID: <1917933616.7020651242162308936.JavaMail.root@zimbra16-e3.priv.proxad.net>
References: <4F2CC79CDB05B844AEEA72F36255835403FD4EC3@bunker.inside.abhaisystems.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4F2CC79CDB05B844AEEA72F36255835403FD4EC3@bunker.inside.abhaisystems.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Harikrishnan Padidakul <hpadidakul@inmage.net>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Ok, to my knowledge Konrad plugged this one in December upstream :

commit d0d98bc348b69d873841b10dd9a1c73af305f0fd
Author: Konrad Rzeszutek <konrad@virtualiron.com>
Date:   Wed Dec 17 23:19:19 2008 +0100

Thank you for the report Hari. But know that there are very few tarball r=
eleases, so upstream is really the git HEAD. This is what you should chec=
k and see if the bugs you report are already fixed.

Best regards,
cvaroqui

----- Mail Original -----
De: "Harikrishnan Padidakul" <hpadidakul@inmage.net>
=C3=80: "christophe varoqui" <christophe.varoqui@free.fr>
Cc: dm-devel@redhat.com
Envoy=C3=A9: Mardi 12 Mai 2009 07h42:36 GMT +01:00 Amsterdam / Berlin / B=
erne / Rome / Stockholm / Vienne
Objet: RE: Memory leak in multipathd.



I am reporting memory leak for the code multipath-tools-0.4.7.rhel5.13 do=
wnloaded from rhel and multipath-tools-0.4.8.=20
vector_free() will not free the mpp's allocated by dm_get_maps(). Here we=
 need to call free_multipath()=20
Below is by fix:=20

dm_get_name(char *uuid, char *type, char *name)=20
{=20
vector vec;=20
struct multipath *mpp;=20
int ret;=20
int i;=20
vec =3D vector_alloc();=20
if (!vec)=20
return 0;=20
if (dm_get_maps(vec, type)) {=20
vector_free(vec);=20
return 0;=20
}=20
vector_foreach_slot(vec, mpp, i) {=20
if (!strcmp(uuid, mpp->wwid)) {=20
strcpy(name, mpp->alias);=20
ret =3D 1;=20
goto found;=20
}=20
}=20
ret =3D 0;=20
found:=20
vector_foreach_slot(vec, mpp, i) {=20
free_multipath(mpp, KEEP_PATHS);=20
}=20
vector_free(vec);=20
return ret;=20
}=20

Thanks,=20
Hari=20





From: christophe.varoqui@free.fr [mailto:christophe.varoqui@free.fr]=20
Sent: Tue 5/12/2009 3:13 AM=20
To: Harikrishnan Padidakul=20
Cc: dm-devel@redhat.com=20
Subject: Re: Memory leak in multipathd.=20




> I was testing multipath with more than 3000paths, I found multipathd us=
ing around 2.3GB of memory.=20
> After closely digging the code, I found In function dm_get_name() we ar=
e calling dm_get_maps() which will allocate memory for mmp.=20
> But we are not freeing the same after search is done.=20
> I have made a fix by calling free_multipath() ,w ith this fix multipath=
d is using less than 200MB of memory.=20

Hi Hari,=20

are you reporting on the upstream multipath-tools code ? I already see mu=
ltipath vector freeing there ...=20
