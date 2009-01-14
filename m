From: Hannes Reinecke <hare@suse.de>
Subject: Re: /dev/sdaa /dev/sdab ... not recognized as valid paths?
Date: Wed, 14 Jan 2009 08:33:38 +0100
Message-ID: <496D9552.8080202@suse.de>
References: <200901140738.03109.sebastia@l00-bugdead-prods.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <200901140738.03109.sebastia@l00-bugdead-prods.de>
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

Hi Sebastian,

Sebastian Reitenbach wrote:
> Hi,
>=20
> I do present 8 luns to the cluster. For each lun there are 4 ways throu=
gh the =20
> SAN that can be used. Therefore I have devices like /dev/sdaa /dev/sdab=
 and=20
> so on. The output of multipath -ll shows some disks with 4 paths, some =
with=20
> three, some only with two. In the output of multipath -ll only disks wi=
th=20
> three letters are shown e.g. /dev/sda.=20
> when I run e.g. /sbin/scsi_id -g -u -s /block/sdaa, then it outputs one=
 of the=20
> configured ID's that I already have in /etc/multipath.conf.
>=20
> How can I add these disks to the multipath failover?
>=20
> I'm on SLES10 sp2.
>=20
Have you enabled udev?
No, it's not on by default. Don't ask.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
