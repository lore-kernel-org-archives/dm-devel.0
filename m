From: Hannes Reinecke <hare@suse.de>
Subject: Re: EMC CX LUN problem
Date: Wed, 25 Jan 2006 10:35:56 +0100
Message-ID: <43D7467C.6030008@suse.de>
References: <43D69CB0.8020402@theorematica.it>	<1138141690.6009.8.camel@ca-bwong3.trans.corp>
	<43D73F73.4010907@theorematica.it>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <43D73F73.4010907@theorematica.it>
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

Nicola Murino wrote:
> Brian Wong ha scritto:
>>
>> i could be off in the weeds here, but this output looks wrong.  the
>> host:channel:target:lun numbers listed there suggest your cx is indeed
>> surfacing luns 0 and 1, but multipath is grouping them under a single
>> target ID.
>>
>>  =20
> Maybe you are right! I added another LUN and this is multipath output
>=20
> multipath -l
> mail (36006016086f01600e46f567adb8cda11)
> [size=3D150 GB][features=3D"1 queue_if_no_path"][hwhandler=3D"1 emc"]
> \_ round-robin 0 [active]
> \_ 2:0:0:0 sdh 8:112 [active][ready]
> \_ 1:0:0:0 sdb 8:16  [active][ready]
> \_ 1:0:0:1 sdc 8:32  [active][ready]
> \_ 1:0:0:2 sdd 8:48  [active][ready]
> \_ 2:0:0:1 sdi 8:128 [active][ready]
> \_ 2:0:0:2 sdj 8:144 [active][ready]
> \_ round-robin 0 [enabled]
> \_ 1:0:1:0 sde 8:64  [active][ready]
> \_ 1:0:1:1 sdf 8:80  [active][ready]
> \_ 1:0:1:2 sdg 8:96  [active][ready]
> \_ 2:0:1:0 sdk 8:160 [active][ready]
> \_ 2:0:1:1 sdl 8:176 [active][ready]
> \_ 2:0:1:2 sdm 8:192 [active][ready]
>=20
>=20
>> i think emc engineers monitor this list; perhaps they can help.
>>  =20
> maybe the problem is scsi_id that report the same output for all block
> device,
>=20
Ah, the infamous EMC CX. There was some bug in the EMC firmware that
returned a non-standard VPD page 0x83 (pre-spc3 format).
You'll have to check scsi_id, it should have some fixes for it.
Be sure to have the most recent version of scsi_id (resp udev)
installed. It should be called with the option '-p pre-spc3-83'.

Alternatively there is always the possibility of a misconfiguration;
AFAIK EMC has a setting to always return the same information for each
drive; of course this should be switched off ...

Cheers,

Hannes
--=20
Dr. Hannes Reinecke			hare@suse.de
SuSE Linux Products GmbH		S390 & zSeries
Maxfeldstra=DFe 5				+49 911 74053 688
90409 N=FCrnberg				http://www.suse.de
