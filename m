From: Hannes Reinecke <hare@suse.de>
Subject: Re: Supporto for EVA3000?
Date: Thu, 08 Nov 2007 08:22:58 +0100
Message-ID: <4732B952.2030500@suse.de>
References: <000101c82065$6e410600$cf42e3c1@pitagora.it>
	<20071107180321.GE28113@ether.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20071107180321.GE28113@ether.msp.redhat.com>
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

Benjamin Marzinski wrote:
> On Tue, Nov 06, 2007 at 12:08:59PM +0100, Domenico Viggiani wrote:
>> Good morning,
>> does anyone know if the old HP EVA3000 (HSV100) disk-array is supporte=
d with
>> dm-multipath shipped with Red Hat 4?
>=20
> If the product name comes up as HSV100, then this version of the
> firmware needs the storageworks hardware handler module to function opt=
imally.
> This is not available on the RHEL4 kernel. I have never actually used
> one of these disk-arrays, but I believe that there is a firmware update=
 for the
> EVA3000 that solves this problem. You should see the product name chang=
e to
> HSV110, and the device will be properly autoconfigured in RHEL4.
>=20
> If for some reason you cannot update the firmware, I believe that you
> can still use multipath with the device at a performance penalty. I
> don't recall the best configuration for that scenario off the top of my
> head.
>=20
No, you can't. The ominous 'Storageworks handler' Ben referred to is
actually the hp_sw hardware handler available in later versions.
This firmware requires a 'START STOP UNIT' command to be send to the
inactive path; the firmware will then activate it (and deactivate the
old path).
Hence you're pretty much stuck without it.
So a firmware update would be your best option here.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
