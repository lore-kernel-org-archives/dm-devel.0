From: Hannes Reinecke <hare@suse.de>
Subject: Re: Losing paths
Date: Tue, 22 Jul 2008 16:55:27 +0200
Message-ID: <4885F4DF.8010000@suse.de>
References: <E6D1DDD48426A44EB25DF27F5AAE7A6505B96797@KL1010XG.cs.ad.klmcorp.net>
	<1D80D4F6D179BD4D869FE807A5BF833602D8B683@EXCNYSM0A1AN.nysemail.nyenet>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1D80D4F6D179BD4D869FE807A5BF833602D8B683@EXCNYSM0A1AN.nysemail.nyenet>
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

Hi John,

Romanowski, John (OFT) wrote:
> Hi,
> We had similar problem last year using sles9 and SVC 4.2.0.2,  as you d=
escribe: adding/deleting a LUN causes
> brief path failures for the host's remaining, unaffected LUNs.
>=20
> We were using tur checker and it turned out that while adding/deleting =
a LUN (and some other admin tasks)
> the SVC does not respond well to test-unit-ready tur requests; but it r=
esponds perfectly well to normal read
> commands. I opened IBM PMR 43118 on that if you want to ask the SVC fol=
ks about it. =20
>=20
> Workaround for us was to use readsector0 instead of  tur as multipath p=
ath checker.=20
> =20
> Recent post here (see July 8, 2008)  said multipath-tools is deprecatin=
g readsector0, and to use directio as
> path checker, but directio was said to be much slower than tur, implyin=
g tur was better replacement than
> directio for readsector0.=20
>
Only for those cases where no actual read-access is necessary.
=20
> Not sure what deprecating readsector0 means for us SVC users. =20
>=20
It means you should be using directio there.

Thanks for the information, I'll see to have it included in SLES10.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
