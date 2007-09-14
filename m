From: Hannes Reinecke <hare@suse.de>
Subject: Re: rdac mode on SLES10SP1
Date: Fri, 14 Sep 2007 09:06:22 +0200
Message-ID: <46EA32EE.8060102@suse.de>
References: <OF7370E75F.A98D07BF-ONC1257353.002B4C4D-C1257353.002B6A87@amadeus.com>
	<46E64DDE.7040705@linpro.no>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <46E64DDE.7040705@linpro.no>
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

Tore Anderson wrote:
> * Kirill Cherkashin
>=20
>> Could you advise me on next matter.
>> We have DS4800 connected to SLES10&9. At the moment we're using 'nativ=
e'
>> IBM  rdac driver but we're going to soon jump to Linux mpio.
>> According to Novell's support site in SP1(with kernel 2.6.16)  MPIO
>> would be supported by in rdac mode.
>>
>>
>> However, here I found  that it should happened only with 2.6.23 kernel=
.
>=20
>   The RDAC hardware handler is included (in a usable form) in the
>  kernel.org kernels starting from 2.6.23-rc4, if I recall correctly.
>=20
>   I assume SuSE has simply backported it to their 2.6.16 kernel.  I kno=
w
>  Red Hat has done the same for RHEL5.1, at least.
>=20
This is the case. RDAC mode work with SP1.

Occasionally documentation is correct :-)

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: Markus Rex, HRB 16746 (AG N=C3=BCrnberg)
