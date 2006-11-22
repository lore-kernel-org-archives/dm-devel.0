From: Hannes Reinecke <hare@suse.de>
Subject: Re: multipath-tools with STK FLEXLINE 380
Date: Wed, 22 Nov 2006 16:29:16 +0100
Message-ID: <45646CCC.3070601@suse.de>
References: <1164132148.2066.19.camel@localhost.localdomain>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1164132148.2066.19.camel@localhost.localdomain>
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
Cc: tony.lapointe@connexim.ca, daniel.milani@connexim.ca
List-Id: dm-devel.ids

Tony Lapointe wrote:
>                 Do not use 'rr_weight=3Dpriorities'. The priorities
>                 handling is currently buggered; or, put it the other wa=
y
>                 round, you will need at least my latest fix to get it
>                 working. Just remove that line and stay with the
>                 defaults. That should work.
>                =20
>                 And as a sidenote: Using 'group_by_prio' and
>                 'rr_weight=3Dpriorities' is completely pointless, even =
if
>                 'rr_weight=3Dpriorities' should be working.'group_by_pr=
io'
>                 will lump all devices with the same priority into one
>                 group. And 'rr_weight=3Dpriorities' will then modify th=
e
>                 'minio' based on the priority. So you can as well
>                 directly modify the 'minio'
>                 parameter.'rr_weight=3Dpriorities' only makes sense if =
you
>                 have path with different priorities in one group, ie
>                 when using 'multibus' or 'group_by_serial'.
>                 Cheers,
>                =20
>                 Hannes
>                 --
>                 Dr. Hannes Reinecke			hare suse de
>                 SuSE Linux Products GmbH		S390 & zSeries
>                 Maxfeldstra=DFe 5				+49 911 74053 688
>                 90409 N=FCrnberg				http://www.suse.de
>=20
>=20
>=20
>=20
> Hi Hannes,
>=20
> thanks for the reply.
>=20
> I've tried without "rr_weight=3Dpriorities" in my multipath.conf but  i=
t does
 > not work either.
> The only difference it makes is that "multipath -v3" now output :=20
 > "rr_weight =3D 1 (internal default)"
> instead of "rr_weight =3D 2 (config file default)".
>=20
> I was thinking that "group_by_prio" is use to group together devices wi=
th
 > differents priorities, with the one with the highest priority first,=20
is it wrong?
>=20
Yes. It groups devices with _identical_ priorities together.

> The output of "multipath -d -v2" seems to reflect this :
>=20
[ .. ]

The output is correct. You have two paths to each disk, and each path=20
has a different priority. So the multipath topology is correct.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke			hare@suse.de
SuSE Linux Products GmbH		S390 & zSeries
Maxfeldstra=DFe 5				+49 911 74053 688
90409 N=FCrnberg				http://www.suse.de
