From: Christoph Hellwig <hch@lst.de>
Subject: Re: dm-mpath: Handling SCSI-3 PR RELEASE in
	multi-controller	environment
Date: Fri, 14 Oct 2016 16:51:19 +0200
Message-ID: <20161014145119.GA22787@lst.de>
References: <1CD7AA44E04E6942954526708D37BF7B287F89@szxeml509-mbs.china.huawei.com>
	<20161009151622.GA19856@lst.de> <57FF5194.4030402@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <57FF5194.4030402@huawei.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Yibin Wang <wangyibin@huawei.com>
Cc: Jiangyiwen <jiangyiwen@huawei.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, Christoph Hellwig <hch@lst.de>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

Hi Yibin,

>>> 	- For reserve/query/preempt/clear, we should return success once an
>>> 	 iteration returns successfully.
>> That's what the dm_grab_bdev_for_ioctl path does.
>
> If I understand correctly, dm_grab_bdev_for_ioctl() select a working path, 
> and
> pr_*() uses that path to do the actually work.
>
> This works for reserve/query/preempt/clear, but it may not work for 
> release.

You're right - if we had a path mapping change inbetween we might
have a problem with the unregister.  That beeing said we have an even
worse problem if the path we registered on disappeared permanently,
so we'll probably need a slightly more complex loop than the one
we have right now.

> I meant the API that callers from above block layer can use - They can not 
> call
> dm_pr_*() directly. So adding blkdev_pr_ops_{register/reserve/etc}() would 
> be
> great.

Take a look at the pNFS SCSI layout driver under fs/nfs/blocklayout
which is the currently existing in-kernel user of the API, it just
calls the block device methods directly.

What additional work would you place in the ops?  Also can you please
send me a link to your user of the API?

>
>>> 5. Support for multiple targets devices.
>>> An md device might have multiple targets. Current implementation only supports
>>> single target device.
>> That's because it is so far only intended for dm-multipath, which always
>> uses as single target.  I'm not against multi-target support, but we'll
>> need a detailed explanation of the use case.
>
> OK. Fair enough. That's rather a "good-to-have" than a "must-have".

As said I'm fine with adding as an enhancement, especially if you submit
an in-kernel user for it, but a useful opensource application also
would be more than enough of a justification
