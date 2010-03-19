From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1/3] Send KOBJ_ADD event after dm resume
	ioctl.
Date: Fri, 19 Mar 2010 10:42:58 +0100
Message-ID: <4BA34722.9030306@suse.de>
References: <1268920694-10960-1-git-send-email-mbroz@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1268920694-10960-1-git-send-email-mbroz@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

Milan Broz wrote:
> Block layer sends ADD uevent when new device is initialised.
> =

> But the device-mapper block devices are more complex,
> initialisation consists of allocating underlying device and
> loading mapping table.
> =

> Because from the userspace all block devices should behave
> the same, patch defines new flag indicating that ADD event
> should be suppressed in block layer.
> =

> If the flag is set, caller then take full responsibility
> for enabling and sending events later when device is ready
> to use.
> =


Please. DONT.

driver core sends out 'ADD' uevents whenever a device
is added (ie made visible) in /sys.
There is _no_ guarantee that a device is usable at this
point, hence there is is 'CHANGE' event which those device
afflicted by this sent out to signal to userspace the
device is now ready for use.

You are not alone here, S/390 DASD and qeth driver
behave the same.

And udev (and multipath :-) are pretty much aware of
the fact. And so should other userspace tools.

No need to fiddle around with events here. It'll
just serve to confuse userspace.

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
