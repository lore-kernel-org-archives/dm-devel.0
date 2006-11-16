From: "Reilly, Stephen (MRO)" <Steve.Reilly@hp.com>
Subject: RE: [PATCH 4/4] [libmultipath] Update hardware
	table	forHPHSV200
Date: Thu, 16 Nov 2006 08:42:55 -0500
Message-ID: <0E766B4D32E1BC4A877197B95A04A25A9F56A4@tayexc14.americas.cpqcorp.net>
References: <455B0CE9.8040103@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <455B0CE9.8040103@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids



-----Original Message-----
From: Hannes Reinecke [mailto:hare@suse.de]=20
Sent: Wednesday, November 15, 2006 7:50 AM
To: Reilly, Stephen (MRO)
Cc: device-mapper development
Subject: Re: [dm-devel] [PATCH 4/4] [libmultipath] Update hardware table =
forHPHSV200

Reilly, Stephen (MRO) wrote:
[ Quoting appears to be a lost art ... ]
>=20
> Hannes Reinecke wrote:
 >> Reilly, Stephen (MRO) wrote:
>>> The product name does change if the firmware uses 'START_STOP_UNIT' o=
r
>>> ALUA... so why are we adding the revision?
>>
>> Ah, that's news to me.
>> How does the product name change?
 >
> The firmware will change the name
 >
Oh, that's nice.

>> My contacts at HP Boeblingen said that the revision number indicated t=
he=20
>> behaviour.
>> What are the names of the fw using START_STOP_UNIT?
> HSV100 and HSV110 EVA3000/5000
EVA is the name of the machine; HSV is the SCSI model name, right?
[Reilly, Stephen (MRO)] Correct, presented both for reference

>> And what are those for using ALUA?
> HSV101, HSV111, HSV200 and HSV210 EVA 3000/5000  EVA4000/6000/8000
>=20
What about the old MSA ones? Is there a firmware upgrade available?
If so, will the name change there, too?

			 Vendor Id: 		Product Id:=20
MSA1500 A-A -      "HP      "		      "MSA VOLUME      "

MSA1000 A-P - 	 "COMPAQ  "			"MSA1000 VOLUME  "
MSA1500 A-P -      "COMPAQ  "			"MSA1000 VOLUME  "


>> And irrespective of this I think matching by revision is still a valid=
=20
>> addition to the hardware table mechanism.
> However I would not use it determine the START_STOP_UNIT or ALUA implem=
entation
>=20
I was under the impression that the name would stay the same. If that's=20
not the case then of course we should match onto the name.

Please check the attached patch if it updates the hwtables correctly.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke			hare@suse.de
SuSE Linux Products GmbH		S390 & zSeries
Maxfeldstra=DFe 5				+49 911 74053 688
90409 N=FCrnberg				http://www.suse.de
