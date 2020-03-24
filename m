From: Bob Liu <bob.liu@oracle.com>
Subject: Re: [RFC PATCH v2 0/3] dm zoned: extend the way of exposing zoned
 block device
Date: Tue, 24 Mar 2020 21:12:32 +0800
Message-ID: <f1cc2096-21f6-59e7-174f-e5e51c492b6b@oracle.com>
References: <20200324110255.8385-1-bob.liu@oracle.com>
 <e2bef18e-f363-47c4-dd38-971a60ec1eca@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <e2bef18e-f363-47c4-dd38-971a60ec1eca@suse.de>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, dm-devel@redhat.com
Cc: Damien.LeMoal@wdc.com, linux-block@vger.kernel.org, Dmitry.Fomichev@wdc.com
List-Id: dm-devel.ids

On 3/24/20 7:52 PM, Hannes Reinecke wrote:
> On 3/24/20 12:02 PM, Bob Liu wrote:
>> Motivation:
>> dm-zoned exposes a zoned block device(ZBC) as a regular block device by storing
>> metadata and buffering random writes in its conventional zones.
>> This way is not flexible, there must be enough conventional zones and the
>> performance may be constrained.
>>
>> This patchset split the metadata from zoned device to an extra regular device,
>> with aim to increase the flexibility and potential performance.
>> For example, now we can store metadata in a faster device like persistent memory.
>> Also random writes can go to the regular devices in this version.
>>
>> Usage(will send user space patches later):
>>> dmzadm --format $zoned_dev --regular=$regu_dev --force
>>> echo "0 $size zoned $regu_dev $zoned_dev" | dmsetup create $dm-zoned-name
>>
>> v2:
>>   * emulate regular device zone info
>>   * support write both metadata and random writes to regular dev
>>
>> Bob Liu (3):
>>    dm zoned: rename dev name to zoned_dev
>>    dm zoned: introduce regular device to dm-zoned-target
>>    dm zoned: add regular device info to metadata
>>
>>   drivers/md/dm-zoned-metadata.c | 205 +++++++++++++++++++++++++++--------------
>>   drivers/md/dm-zoned-target.c   | 205 +++++++++++++++++++++++------------------
>>   drivers/md/dm-zoned.h          |  53 ++++++++++-
>>   3 files changed, 299 insertions(+), 164 deletions(-)
>>
> Well, surprise, surprise, both our patchsets are largely identical ...
> 

You may missed my first rfc.
https://www.redhat.com/archives/dm-devel/2020-January/msg00024.html

> So how to proceed? I guess if you were using 'cdev' instead of 'regu_dm_dev' we should be having an overlap of about 90 percent.
> 
> The main difference between our implementation is that I didn't move the metadata to the cache/regulard device, seeing that dmzadm will only write metadata onto the zoned device.

I also patched dmzadm(will sent out soon) a lot, now my implementation can compatible with original usage.

It supports two different usage:
- Original zoned device only:
#: dmzadm --format $zoned_dev
#: echo "0 $size zoned $zoned_dev" | dmsetup create $dm-zoned-name
(All data in zoned device)

- With regular device：
dmzadm --format $zoned_dev --regular=$regu_dev
echo "0 $size zoned $regu_dev $zoned_dev" | dmsetup create $dm-zoned-name
(Metadata in regular device, other data spread in both regular device and zoned device.)

I haven't thought about store metadata in zoned dev while other data in both cache/regular device and zoned dev.
Actually in my first rfc I just plan to split metadata to a fast device, so as to get performance improvement.

> I would rather keep it that way (ie storing metadata on the zoned device, too, if possible) as we would be keeping backwards compability with that.
> And we could always move metadata to the cache/regular device in a later patch; for doing it properly we'll need to update the metadata anyway as we need to introduce UUIDs to stitch those devices together.

Sure.

> Remember, one my have more than one zoned device and regular device...
> 
> Should I try to merge both patchsets and send them out as an RFC?
> 

Fine to me, just please keep my signed-off-by.

Thanks,
Bob
