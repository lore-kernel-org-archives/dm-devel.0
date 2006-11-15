From: "Reilly, Stephen (MRO)" <Steve.Reilly@hp.com>
Subject: RE: [PATCH 4/4] [libmultipath] Update hardware table
	forHPHSV200
Date: Wed, 15 Nov 2006 07:10:53 -0500
Message-ID: <0E766B4D32E1BC4A877197B95A04A25A9F4FBF@tayexc14.americas.cpqcorp.net>
References: <45596E68.30901@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <45596E68.30901@suse.de>
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



-----Original Message-----
From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com] On=
 Behalf Of Hannes Reinecke
Sent: Tuesday, November 14, 2006 2:21 AM
To: device-mapper development
Subject: Re: [dm-devel] [PATCH 4/4] [libmultipath] Update hardware table =
forHPHSV200

Reilly, Stephen (MRO) wrote:
> The product name does change if the firmware uses 'START_STOP_UNIT' or
> ALUA... so why are we adding the revision?
>=20
Ah, that's news to me.
How does the product name change?
>> The firmware will change the name
My contacts at HP Boeblingen said that the revision number indicated the=20
behaviour.
What are the names of the fw using START_STOP_UNIT?
>> HSV100 and HSV110 EVA3000/5000
And what are those for using ALUA?
>> HSV101, HSV111, HSV200 and HSV210 EVA 3000/5000  EVA4000/6000/8000

And irrespective of this I think matching by revision is still a valid=20
addition to the hardware table mechanism.
>> However I would not use it determine the START_STOP_UNIT or ALUA imple=
mentation

Cheers,

Hannes
--=20
Dr. Hannes Reinecke			hare@suse.de
SuSE Linux Products GmbH		S390 & zSeries
Maxfeldstra=DFe 5				+49 911 74053 688
90409 N=FCrnberg				http://www.suse.de

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
