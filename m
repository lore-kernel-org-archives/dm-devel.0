From: Peter Rajnoha <prajnoha@redhat.com>
Subject: Re: [PATCH] Disable partitions scan for multipathed
	devices
Date: Wed, 12 Mar 2014 13:46:10 +0100
Message-ID: <53205712.8000200@redhat.com>
References: <1394624936-118530-1-git-send-email-hare@suse.de>
	<20140312122310.GB14017@agk-dp.fab.redhat.com>
	<532052CB.2090605@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <532052CB.2090605@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Christoph Hellwig <hch@infradead.org>, dm-devel@redhat.com
List-Id: dm-devel.ids

On 03/12/2014 01:27 PM, Hannes Reinecke wrote:
> On 03/12/2014 01:23 PM, Alasdair G Kergon wrote:
>> On Wed, Mar 12, 2014 at 12:48:56PM +0100, Hannes Reinecke wrote:
>>> For this I've implemented a new feature 'no_partitions' which
>>> just serves as a notifier to kpartx to _not_ create partitions
>>> on these devices.
>>  
>> This should be covered by the existing cookie flags (which udev rules
>> already use, if you're using udev).  It's not a multipath-specific
>> problem but can apply to other targets too.
>>
> Ah.
> 
> How? To my knowledge the 'cookies' mechanism is to enable
> libdevmapper to wait until udev is done with device creation.
> 

Thing with calling kpartx in udev is that it's only used for mpath
devices at the moment, not for all dm devices in general. We could
add a hook to call kpartx for each dm device, not just limiting it
to the mpath, but there has been no call for this yet...

As for the flags encoded in the cookie - the cookie has two parts -
the lower 16 bits are used for synchronization identifier, the
higher 16 bits are used for passing flags. Out of these 16 'flag bits',
8 bits are common for all DM devices and they're meant to be used for
flagging DM devices in general and the rest 8 bits are meant to be used
for specific DM subsystem use (see also
https://git.fedorahosted.org/cgit/lvm2.git/tree/libdm/libdevmapper.h#n1750)

The flags are set with the dm_set_cookie libdevmapper call.

The mpath already uses some bits from the "common" group and 1 flag from
the subsystem specific group (that is applicable only to mpath). We could
check if there's a combination we could reuse, but I think that in this
case we should just introduce a new mpath subsystem specific flag that
would direct udev rules to skip the kpartx call.

Now the question is whether there is anything else we need to skip besides
the kpartx call so we cover everything we need for the "host/guest" scenario.

-- 
Peter
