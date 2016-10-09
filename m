From: Christoph Hellwig <hch@lst.de>
Subject: Re: dm-mpath: Handling SCSI-3 PR RELEASE in
	multi-controller	environment
Date: Sun, 9 Oct 2016 17:16:22 +0200
Message-ID: <20161009151622.GA19856@lst.de>
References: <1CD7AA44E04E6942954526708D37BF7B287F89@szxeml509-mbs.china.huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1CD7AA44E04E6942954526708D37BF7B287F89@szxeml509-mbs.china.huawei.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: wangyibin <wangyibin@huawei.com>
Cc: Jiangyiwen <jiangyiwen@huawei.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, Christoph Hellwig <hch@lst.de>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

Hi Yibin,

On Sun, Oct 09, 2016 at 01:12:41PM +0000, wangyibin wrote:
> 1. Improper dm_pr_ops implementation.
> The dm_pr_ops functions, except register/unregister, all result in
> infinite loop by recursively calling themselves, which will definitely cause
> stack overflow. In fact, they should be implemented the same way as
> register/unregister by calling iterate_devices().

How do they recurse into themselves?  All of them do indeed call
another method of the same name, but that only happens after
the target ->prepare_ioctl ioctl method redirected them to a different
device.

If you can reproduce a deadlock please post the exact table setup,
as this should not happen.

> 
> 2. Multipath device iteration policy is needed.
> Iteration policy should be added to multipath for PR operations.
> 	- For unregister, we should iterate on all devices.

That's what we do.

> 	- For regisetr, we should stop iteration on failure, and followed by a
> 	 non-stopping unregister operation.

What do you mean with "non-stopping"?  Currently once register failed
for a path we then ungerigster all paths, and ignore failures (e.g. due
to a down path or an not already registered path).

> 	- For reserve/query/preempt/clear, we should return success once an
> 	 iteration returns successfully.

That's what the dm_grab_bdev_for_ioctl path does.

> 3. Lack of query function.
> Sometimes we need to query the reservation key or registered keys.

If you have a use case for it feel free to add it.  My current user
doesn't need it.

> 4. Lack of kernel space API.
> Currently there's only API for ioctl, which is meant to be called by user space
> utils. I know we can still call them anyway in kernel space via the help of
> {set,get}_fs(), but it looks ugly and unnatrual in every aspect.

The API is currently used from kernel space, that's why I added it.
If you point me to the code that you plan to submit which wants to use
it I'd be happy to help you in using it.

> 5. Support for multiple targets devices.
> An md device might have multiple targets. Current implementation only supports
> single target device.

That's because it is so far only intended for dm-multipath, which always
uses as single target.  I'm not against multi-target support, but we'll
need a detailed explanation of the use case.
