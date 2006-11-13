From: "Reilly, Stephen (MRO)" <Steve.Reilly@hp.com>
Subject: RE: [PATCH 0/3] HP HSV200 update
Date: Mon, 13 Nov 2006 11:11:27 -0500
Message-ID: <0E766B4D32E1BC4A877197B95A04A25A9B2F8E@tayexc14.americas.cpqcorp.net>
References: <455302C6.9090207@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <455302C6.9090207@suse.de>
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

You might want to check this because the product name does change dependi=
ng on which firmware is loaded with either the START_STOP_UNIT or ALUA. =20

-----Original Message-----
From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com] On=
 Behalf Of Hannes Reinecke
Sent: Thursday, November 09, 2006 5:28 AM
To: christophe varoqui
Cc: device-mapper development
Subject: [dm-devel] [PATCH 0/3] HP HSV200 update

Hi Christophe,

this patchset implements a new field 'revision' for the hardware table,=20
which is filled with the 'revision' field from the SCSI Inquiry. The=20
reason for this is that HP switched the behaviour during a firmware=20
update (ie from using START_STOP_UNIT to ALUA). And to support this=20
properly we'll have to match against the 'revision' field, too.

In doing so I've found a bug in load_config(). Currently, we're loading
the default hardware table with comparing via regex. However, as the=20
default table also contains regexp we'll end up comparing _two_ regexps,
the outcome of which is a quite peculiar to say the least. We should=20
rather be using a simple string match to avoid this pitfall.

So, this patchset does
- Correct load_config() to compare entries via string match
- Implements matching against the revision field
- Updates the hardware table for HP HSV200 support.

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
