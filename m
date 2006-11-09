From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 0/3] HP HSV200 update
Date: Thu, 09 Nov 2006 11:28:22 +0100
Message-ID: <455302C6.9090207@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: christophe varoqui <christophe.varoqui@free.fr>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

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
