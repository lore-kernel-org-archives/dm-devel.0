From: "Jeffry Bilder" <jbilder@g2switchworks.com>
Subject: RE: Multipath issues with kernel device errors
Date: Wed, 29 Aug 2007 08:29:51 -0500
Message-ID: <8CED8CEBA23FC0409E1A3009F7F47BE5024710E0@exchange.g2switchworks.com>
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

Thank you!!  mpath_prio_hp_sw was certainly missing, so I just used the f=
ailover option and commented it out.  Those errors are gone now!  Thanks =
so much for your help!

- JB

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
