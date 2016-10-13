From: Yibin Wang <wangyibin@huawei.com>
Subject: Re: dm-mpath: Handling SCSI-3 PR RELEASE in
 multi-controller environment
Date: Thu, 13 Oct 2016 17:19:16 +0800
Message-ID: <57FF5194.4030402@huawei.com>
References: <1CD7AA44E04E6942954526708D37BF7B287F89@szxeml509-mbs.china.huawei.com>
	<20161009151622.GA19856@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20161009151622.GA19856@lst.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christoph Hellwig <hch@lst.de>
Cc: Jiangyiwen <jiangyiwen@huawei.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

Hi Christoph,

Thanks for your reply. Comments inline...

On 2016/10/9 23:16, Christoph Hellwig wrote:
> Hi Yibin,
>
> On Sun, Oct 09, 2016 at 01:12:41PM +0000, wangyibin wrote:
>> 1. Improper dm_pr_ops implementation.
>> The dm_pr_ops functions, except register/unregister, all result in
>> infinite loop by recursively calling themselves, which will definitely cause
>> stack overflow. In fact, they should be implemented the same way as
>> register/unregister by calling iterate_devices().
> How do they recurse into themselves?  All of them do indeed call
> another method of the same name, but that only happens after
> the target ->prepare_ioctl ioctl method redirected them to a different
> device.
>
> If you can reproduce a deadlock please post the exact table setup,
> as this should not happen.

Sorry, the dead lock was caused by incomplete backport of patches. So 
this is not
an issue any more.

>> 2. Multipath device iteration policy is needed.
>> Iteration policy should be added to multipath for PR operations.
>> 	- For unregister, we should iterate on all devices.
> That's what we do.
>
>> 	- For regisetr, we should stop iteration on failure, and followed by a
>> 	 non-stopping unregister operation.
> What do you mean with "non-stopping"?  Currently once register failed
> for a path we then ungerigster all paths, and ignore failures (e.g. due
> to a down path or an not already registered path).

That's exactly what I meant - do not stop on failures while doing 
unregistration.

>
>> 	- For reserve/query/preempt/clear, we should return success once an
>> 	 iteration returns successfully.
> That's what the dm_grab_bdev_for_ioctl path does.

If I understand correctly, dm_grab_bdev_for_ioctl() select a working 
path, and
pr_*() uses that path to do the actually work.

This works for reserve/query/preempt/clear, but it may not work for 
release.

For example, if we have a device (/dev/dm-2) that is connected to two
controllers, and we have one path for each controller, we got the 
following with
"multipath -ll":

3690b11c000283cd00000112557e1b3c2 dm-2 .....
size=10G features='1 queue_if_no_path' hwhandler='0' wp=rw
`-+- policy='service-time 0' prio=1 status=active
   |- 5:0:0:2 sda 8:112 active ready running
     `- 6:0:0:2 sdb 8:208 active ready running

Suppose we have registered the same keys (because all paths are on the same
host) on all available paths.  And then we reserved the device on path 
/dev/sda.

Now if we want to release the reservation, dm_pr_release() will grab one 
of the
paths according to path selection policy. And the grabbed path _COULD_ be
/dev/sdb. In this case, sd_pr_release() would be called on /dev/sdb 
which will
return 0  since the there's no reservation on this path. So this gives 
up the
illusion that the reservation is released while it's still placed on path
/dev/sda.

So, for dm_pr_release(), we need to use .iterate_devices() - and only 
returns 0
if one of the paths returns 0.

>
>> 3. Lack of query function.
>> Sometimes we need to query the reservation key or registered keys.
> If you have a use case for it feel free to add it.  My current user
> doesn't need it.
>
>> 4. Lack of kernel space API.
>> Currently there's only API for ioctl, which is meant to be called by user space
>> utils. I know we can still call them anyway in kernel space via the help of
>> {set,get}_fs(), but it looks ugly and unnatrual in every aspect.
> The API is currently used from kernel space, that's why I added it.
> If you point me to the code that you plan to submit which wants to use
> it I'd be happy to help you in using it.

I meant the API that callers from above block layer can use - They can 
not call
dm_pr_*() directly. So adding blkdev_pr_ops_{register/reserve/etc}() 
would be
great.

>> 5. Support for multiple targets devices.
>> An md device might have multiple targets. Current implementation only supports
>> single target device.
> That's because it is so far only intended for dm-multipath, which always
> uses as single target.  I'm not against multi-target support, but we'll
> need a detailed explanation of the use case.

OK. Fair enough. That's rather a "good-to-have" than a "must-have".

Thanks again for your reply!

Best regards,
Yibin
