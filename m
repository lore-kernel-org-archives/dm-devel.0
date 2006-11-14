From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 4/4] [libmultipath] Update hardware table for
	HPHSV200
Date: Tue, 14 Nov 2006 08:21:12 +0100
Message-ID: <45596E68.30901@suse.de>
References: <0E766B4D32E1BC4A877197B95A04A25A9B31A6@tayexc14.americas.cpqcorp.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <0E766B4D32E1BC4A877197B95A04A25A9B31A6@tayexc14.americas.cpqcorp.net>
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

Reilly, Stephen (MRO) wrote:
> The product name does change if the firmware uses 'START_STOP_UNIT' or
> ALUA... so why are we adding the revision?
>=20
Ah, that's news to me.
How does the product name change?
My contacts at HP Boeblingen said that the revision number indicated the=20
behaviour.
What are the names of the fw using START_STOP_UNIT?
And what are those for using ALUA?

And irrespective of this I think matching by revision is still a valid=20
addition to the hardware table mechanism.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke			hare@suse.de
SuSE Linux Products GmbH		S390 & zSeries
Maxfeldstra=DFe 5				+49 911 74053 688
90409 N=FCrnberg				http://www.suse.de
