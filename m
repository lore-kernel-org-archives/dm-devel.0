From: Hannes Reinecke <hare@suse.de>
Subject: Re: Multipath on boot and root partition with Redhat5.0
Date: Thu, 11 Oct 2007 08:26:10 +0200
Message-ID: <470DC202.2050906@suse.de>
References: <470CB061.5000902@univ-tln.fr>
	<1D80D4F6D179BD4D869FE807A5BF8336018C68D8@EXCNYSM0A1AN.nysemail.nyenet>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1D80D4F6D179BD4D869FE807A5BF8336018C68D8@EXCNYSM0A1AN.nysemail.nyenet>
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

Romanowski, John (OFT) wrote:
> I use multipath boot (/boot) and root (/) on SLES9 kernel 2.6.5 on IBM
> mainframe Linux with scsi LUNs. I'm not familiar with redhat5 or HP, bu=
t
> from your post I guess it's newer kernel and newer multipath-tools than
> my SLES9.
> I did a howto for SLES9
> http://www.linuxvm.org/Info/HOWTOs/root-on-multipath.html
> but probably won't help you other than hinting at a way; many
> differences in our two linux systems.
>=20
Yeah, I know. Thanks for the script btw.
Yes, in principle we can do root on multipath for SLES9. However,
as YaST is not aware of udev in SLES9 we cannot say we support it.
Sad, but true.

> SLES 10 (kernel 2.6.16?) says it supports root-on-multipath (not boot
> though), may be a common feature with redhat 5 too?
>=20

(I knew people would get this wrong. They always do. Sigh)

_Booting_ as something which is provided by the BIOS. And as I haven't
seen _any_ BIOS yet which allows for truly multipathed booting we
_cannot_ boot from multipath. The kernel and the initrd will _always_
be loaded from a single path by the BIOS. So in that sense we don't
support boot from multipath as the BIOS doesn't support it.
Once the kernel and the initrd is loaded into memory then of course
we'll be doing multipathing.
Right from the start. With udev and everything.

And please file a bugzilla or drop me a note if it doesn't work.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
