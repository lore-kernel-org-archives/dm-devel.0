From: Hannes Reinecke <hare@suse.de>
Subject: Re: [RFC PATCH v2 0/3] dm zoned: extend the way of exposing zoned
 block device
Date: Tue, 24 Mar 2020 12:52:54 +0100
Message-ID: <e2bef18e-f363-47c4-dd38-971a60ec1eca@suse.de>
References: <20200324110255.8385-1-bob.liu@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20200324110255.8385-1-bob.liu@oracle.com>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Bob Liu <bob.liu@oracle.com>, dm-devel@redhat.com
Cc: Damien.LeMoal@wdc.com, linux-block@vger.kernel.org, Dmitry.Fomichev@wdc.com
List-Id: dm-devel.ids

On 3/24/20 12:02 PM, Bob Liu wrote:
> Motivation:
> dm-zoned exposes a zoned block device(ZBC) as a regular block device by storing
> metadata and buffering random writes in its conventional zones.
> This way is not flexible, there must be enough conventional zones and the
> performance may be constrained.
> 
> This patchset split the metadata from zoned device to an extra regular device,
> with aim to increase the flexibility and potential performance.
> For example, now we can store metadata in a faster device like persistent memory.
> Also random writes can go to the regular devices in this version.
> 
> Usage(will send user space patches later):
>> dmzadm --format $zoned_dev --regular=$regu_dev --force
>> echo "0 $size zoned $regu_dev $zoned_dev" | dmsetup create $dm-zoned-name
> 
> v2:
>   * emulate regular device zone info
>   * support write both metadata and random writes to regular dev
> 
> Bob Liu (3):
>    dm zoned: rename dev name to zoned_dev
>    dm zoned: introduce regular device to dm-zoned-target
>    dm zoned: add regular device info to metadata
> 
>   drivers/md/dm-zoned-metadata.c | 205 +++++++++++++++++++++++++++--------------
>   drivers/md/dm-zoned-target.c   | 205 +++++++++++++++++++++++------------------
>   drivers/md/dm-zoned.h          |  53 ++++++++++-
>   3 files changed, 299 insertions(+), 164 deletions(-)
> 
Well, surprise, surprise, both our patchsets are largely identical ...

So how to proceed? I guess if you were using 'cdev' instead of 
'regu_dm_dev' we should be having an overlap of about 90 percent.

The main difference between our implementation is that I didn't move the 
metadata to the cache/regulard device, seeing that dmzadm will only 
write metadata onto the zoned device.
I would rather keep it that way (ie storing metadata on the zoned 
device, too, if possible) as we would be keeping backwards compability 
with that.
And we could always move metadata to the cache/regular device in a later 
patch; for doing it properly we'll need to update the metadata anyway as 
we need to introduce UUIDs to stitch those devices together.
Remember, one my have more than one zoned device and regular device...

Should I try to merge both patchsets and send them out as an RFC?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
