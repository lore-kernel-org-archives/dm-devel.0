From: "Jeffry Bilder" <jbilder@g2switchworks.com>
Subject: RE: Multipath issues with kernel device errors
Date: Wed, 29 Aug 2007 11:58:14 -0500
Message-ID: <8CED8CEBA23FC0409E1A3009F7F47BE5024711B7@exchange.g2switchworks.com>
References: <8CED8CEBA23FC0409E1A3009F7F47BE502471065@exchange.g2switchworks.com>	<1188333723.12737.7.camel@linuxchandra>	<8CED8CEBA23FC0409E1A3009F7F47BE502471086@exchange.g2switchworks.com><1188338656.12737.18.camel@linuxchandra>
	<46D50ECF.6020701@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <46D50ECF.6020701@suse.de>
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

Are the errors in the kernel log normal:


Aug 28 10:30:15 rac02 kernel: end_request: I/O error, dev sdf, sector 513=
824
Aug 28 10:30:15 rac02 kernel: Buffer I/O error on device sdf, logical blo=
ck 64228
Aug 28 10:30:15 rac02 kernel: Buffer I/O error on device sdf, logical blo=
ck 64229
Aug 28 10:30:15 rac02 kernel: Buffer I/O error on device sdf, logical blo=
ck 64230
Aug 28 10:30:16 rac02 kernel: Buffer I/O error on device sdf, logical blo=
ck 64231
Aug 28 10:30:16 rac02 kernel: Buffer I/O error on device sdf, logical blo=
ck 64232
Aug 28 10:30:16 rac02 kernel: Buffer I/O error on device sdf, logical blo=
ck 64233
Aug 28 10:30:16 rac02 kernel: Buffer I/O error on device sdf, logical blo=
ck 64234
Aug 28 10:30:16 rac02 kernel: Buffer I/O error on device sdf, logical blo=
ck 64235
Aug 28 10:30:16 rac02 kernel: Buffer I/O error on device sdf, logical blo=
ck 64236
Aug 28 10:30:16 rac02 kernel: Buffer I/O error on device sdf, logical blo=
ck 64237
Aug 28 10:30:16 rac02 kernel: Buffer I/O error on device sdf, logical blo=
ck 64238
Aug 28 10:30:16 rac02 kernel: Buffer I/O error on device sdf, logical blo=
ck 64239
Aug 28 10:30:16 rac02 kernel: Buffer I/O error on device sdf, logical blo=
ck 64240
Aug 28 10:30:16 rac02 kernel: Buffer I/O error on device sdf, logical blo=
ck 64241
Aug 28 10:30:16 rac02 kernel: Buffer I/O error on device sdf, logical blo=
ck 64242
Aug 28 10:30:16 rac02 kernel: Buffer I/O error on device sdf, logical blo=
ck 64243
Aug 28 10:30:16 rac02 kernel: Device sdf not ready.
Aug 28 10:30:16 rac02 kernel: end_request: I/O error, dev sdf, sector 513=
824
Aug 28 10:30:16 rac02 kernel: Buffer I/O error on device sdf, logical blo=
ck 64228
Aug 28 10:30:16 rac02 kernel: Device sdf not ready.
Aug 28 10:30:16 rac02 kernel: end_request: I/O error, dev sdf, sector 513=
824
Aug 28 10:30:16 rac02 kernel: Buffer I/O error on device sdf, logical blo=
ck 64228
Aug 28 10:30:16 rac02 kernel: Device sdf not ready.
Aug 28 10:30:16 rac02 kernel: end_request: I/O error, dev sdf, sector 514=
064
Aug 28 10:30:16 rac02 kernel: Buffer I/O error on device sdf, logical blo=
ck 64258
Aug 28 10:30:16 rac02 kernel: Device sdf not ready.
Aug 28 10:30:16 rac02 kernel: end_request: I/O error, dev sdf, sector 513=
680
Aug 28 10:30:16 rac02 kernel: Buffer I/O error on device sdf, logical blo=
ck 64210
Aug 28 10:30:16 rac02 kernel: Buffer I/O error on device sdf, logical blo=
ck 64211
Aug 28 10:30:16 rac02 kernel: Buffer I/O error on device sdf, logical blo=
ck 64212
Aug 28 10:30:16 rac02 kernel: Buffer I/O error on device sdf, logical blo=
ck 64213
Aug 28 10:30:16 rac02 kernel: Buffer I/O error on device sdf, logical blo=
ck 64214
Aug 28 10:30:16 rac02 kernel: Buffer I/O error on device sdf, logical blo=
ck 64215
Aug 28 10:30:16 rac02 kernel: Buffer I/O error on device sdf, logical blo=
ck 64216
Aug 28 10:30:16 rac02 kernel: Buffer I/O error on device sdf, logical blo=
ck 64217
Aug 28 10:30:16 rac02 kernel: Buffer I/O error on device sdf, logical blo=
ck 64218
Aug 28 10:30:16 rac02 kernel: Buffer I/O error on device sdf, logical blo=
ck 64219
Aug 28 10:30:16 rac02 kernel: Buffer I/O error on device sdf, logical blo=
ck 64220
Aug 28 10:30:16 rac02 kernel: Buffer I/O error on device sdf, logical blo=
ck 64221
Aug 28 10:30:16 rac02 kernel: Buffer I/O error on device sdf, logical blo=
ck 64222
Aug 28 10:30:16 rac02 kernel: Buffer I/O error on device sdf, logical blo=
ck 64223
Aug 28 10:30:16 rac02 kernel: Buffer I/O error on device sdf, logical blo=
ck 64224
Aug 28 10:30:16 rac02 kernel: Buffer I/O error on device sdf, logical blo=
ck 64225
Aug 28 10:30:16 rac02 kernel: Device sdf not ready.


Thanks,

JB


-----Original Message-----
From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com] On=
 Behalf Of Hannes Reinecke
Sent: Wednesday, August 29, 2007 1:15 AM
To: device-mapper development
Subject: Re: [dm-devel] Multipath issues with kernel device errors

Chandra Seetharaman wrote:
> You do not have the latest table.=20
> Try with the table below (converted from 0.4.8 version's hwtable.c)
> devices {
> 	device {
> 		vendor 		"COMPAQ"
> 		product		"MSA1000"
> 		path_grouping_policy	group_by_prio
> 		path_checker	tur
> 		prio_callout	"/sbin/mpath_prio_alua /dev/%n"
> 		getuid_callout	"/sbin/scsi_id -g -u -s /block/%n"
> 		failback	immediate
> 	}
> }
>=20
Errm. Not quite. My sources indicate that this machine
runs the older active/passive firmware, which requires
the 'hp_sw' hardware handler to run properly.

So better use this:
devices {
	device {
		vendor 		"COMPAQ"
		product		"MSA1000"
		hardware_handler	"1 hp_sw"
		path_grouping_policy	group_by_prio
		path_checker	hp_sw
 		prio_callout	"/sbin/mpath_prio_hp_sw /dev/%n"
 		getuid_callout	"/sbin/scsi_id -g -u -s /block/%n"
 		failback	manual
 	}
}

if mpath_prio_hp_sw is missing complain to Ben Marzinski :-)
Alternatively you can use

path_grouping_policy	failover

and omit the prio_callout altogether. But then only one path
per SP are used.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
