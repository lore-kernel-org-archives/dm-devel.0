From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 0/5] Update scsi_dh infrastructure
Date: Thu, 08 May 2008 16:40:20 +0200
Message-ID: <482310D4.2050801@suse.de>
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
To: Alasdair G Kergon <agk@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi all,

this patchset updates the scsi_dh infrastructure as posted by Chandra See=
tharman
recently.

Main changes are to switch to a single notifier callback instead of a per=
-handler
one and adding a sysfs attribute which allow to control the device handle=
r
manually. Quite useful for testing.

I've converted all handlers for the new infrastructure; in addition I've =
updated
all handlers (except RDAC, Hi Chandra!) to refuse to attach to a device w=
hich
does _not_ support the appropriate method.
Except hp_sw, that is, as I didn't found a way of reliably detect this.

And I've added a generic SPC-3 ALUA handler.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
