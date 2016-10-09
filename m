From: wangyibin <wangyibin@huawei.com>
Subject: Re: dm-mpath: Handling SCSI-3 PR RELEASE in
 multi-controller environment
Date: Sun, 9 Oct 2016 13:12:41 +0000
Message-ID: <1CD7AA44E04E6942954526708D37BF7B287F89@szxeml509-mbs.china.huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: zh-CN
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christoph Hellwig <hch@lst.de>, Jiangyiwen <jiangyiwen@huawei.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

Hello Christoph,

There are several issues with current PR implementation:

1. Improper dm_pr_ops implementation.
The dm_pr_ops functions, except register/unregister, all result in
infinite loop by recursively calling themselves, which will definitely cause
stack overflow. In fact, they should be implemented the same way as
register/unregister by calling iterate_devices().

2. Multipath device iteration policy is needed.
Iteration policy should be added to multipath for PR operations.
	- For unregister, we should iterate on all devices.
	- For regisetr, we should stop iteration on failure, and followed by a
	 non-stopping unregister operation.
	- For reserve/query/preempt/clear, we should return success once an
	 iteration returns successfully.
	- For release, we should stop iteraton on failure.

3. Lack of query function.
Sometimes we need to query the reservation key or registered keys.

4. Lack of kernel space API.
Currently there's only API for ioctl, which is meant to be called by user space
utils. I know we can still call them anyway in kernel space via the help of
{set,get}_fs(), but it looks ugly and unnatrual in every aspect.

5. Support for multiple targets devices.
An md device might have multiple targets. Current implementation only supports
single target device.

Please comment on the issues I have written above. We have cooked some patches
for evaluation purposes. And if anyone is interested in the patches, we can post 
them in the mailing list for review.

Thanks,
	Yibin

On Sep 27, 2016 at 00:03, Christoph Hellwig Wrote:
>On Thu, Sep 22, 2016 at 04:14:50PM +0800, jiangyiwen wrote:
>> I briefly reviewed the PR API. If I understand correctly, a bunch of 
>> PR dedicated operations (pr_ops) are defined in 
>> block_device_operations, which includes register, reserve, release, 
>> preempt and clear operations. But among these operations, only 
>> register() calls dm_call_pr(), which in turns iterates over the device for each path and does the registeration.
>
>Register and unregister in fact, but they both multiple throught the same method.
>
>> My point is, we also need to do this in release operation, so that we 
>> can eliminate the possibility of trying to release the reservation on 
>> the wrong controller and get a fake success.
>
>dm_grab_bdev_for_ioctl ensures that we have a working path.  At least that's the theory and my testing confirms it.  If you know a case where the release doesn't work using this path we'll need to fix.
