From: Hannes Reinecke <hare@suse.de>
Subject: Re: multipath.rules placement
Date: Wed, 9 Nov 2016 08:52:02 +0100
Message-ID: <1496f8ec-b795-bdfa-6eaa-a21816fd8896@suse.de>
References: <20161108195625.GQ1972@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; Format="flowed"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20161108195625.GQ1972@octiron.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On 11/08/2016 08:56 PM, Benjamin Marzinski wrote:
> I'm looking through the multipath udev rules again to see if we can come
> closer to one consistent set, or at least understand why we need to
> agree to disagree and right now I'm trying to figure out why it's
> important for SUSE to have 56-multipath.rules run before
> 60-persistent-storage.rules.
>
> We use 62-multipath.rules in RHEL for two main reasons. First, scsi_id
> is run in 60-persistent-storage.rules, which is what sets ID_SERIAL, so
> if multipath.rules is run before that, we'll never be able to get our
> information from udev. I know that you've added code to cope with this,
> assuming the standard uid_attribute, but it seems better to me to just
> wait for udev to fill in these values itself.
>
> Second, 60-persistent-storage.rules runs blkid, which should set
> ID_FS_TYPE.  Setting it in 56-multipath.rules just means that
> 60-persistent-storage.rules will overwrite it.
>
> So, what do we gain by running multipath.rules before
> 60-persistent-storage.rules?
>
Yeah, it's slightly inconsistent.

Actually we are using the rules from sg3_utils (55-scsi-sg_id.rules and =

58-scsi-sg3_symlink.rules), which will set ID_SERIAL prior to calling =

56-multipath.rules.
Hence it works for us :-)

The main idea here is to deprecate scsi_id, with the goal of eventually =

dropping it from systemd/udev.

However, the idea of this particular placement is precisely that we do =

_not_ call scsi_id and blkid in 60-persistent-storage.rules for any =

devices which are found to be part of a multipath device.
Doing so would not only give pointless information, but also there's a =

fair chance that it wouldn't get you any information whatsoever in the =

case of standby paths or during failover.
Or even stall the entire rule as it's stuck doing I/O.

My plan is to split off the call to 'scsi_id' from =

60-persistent-storage.rules, (eg to 56-scsi-scsi_id.rules), and my =

multipath to 57.
Then we would have:

55-scsi-sg_id.rules
56-scsi-scsi_id.rules
-> ID_SERIAL is set from this point on
57-multipath.rules
58-sg3_symlink.rules
60-persistent-storage.rules

and then everything would be far more consistent.

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
