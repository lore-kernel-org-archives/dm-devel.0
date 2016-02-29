From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH resend] [dm]fix NULL pointer when create dm device
Date: Mon, 29 Feb 2016 16:42:30 -0500
Message-ID: <20160229214230.GA11697@redhat.com>
References: <1454387358-16221-1-git-send-email-dingxiang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1454387358-16221-1-git-send-email-dingxiang@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: DingXiang <dingxiang@huawei.com>
Cc: agk@redhat.com, dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Mon, Feb 01 2016 at 11:29pm -0500,
DingXiang <dingxiang@huawei.com> wrote:

> In some conditions(such as umount fs failed),origin path or origin bdev or both of the two is same
> as cow's.If this happens, origin dev will be freed when get cow dev in function "dm_get_device" ,
> then "s->origin->dev" which used by "dm_exception_store_set_chunk_size" will be a NULL pointer.
> 
> Here is my call trace
...
> Call trace:
> [<ffffffc00060b4d8>] dm_exception_store_set_chunk_size+0x6c/0x124
> [<ffffffc00060b6f8>] dm_exception_store_create+0x168/0x1c4
> [<ffffffc00060a940>] snapshot_ctr+0x168/0x5ec
> [<ffffffc0005f6374>] dm_table_add_target+0x114/0x360
> [<ffffffc0005f98c8>] table_load+0x10c/0x314
> [<ffffffc0005fa480>] ctl_ioctl+0x1f8/0x4bc
> [<ffffffc0005fa754>] dm_ctl_ioctl+0x10/0x20
> [<ffffffc0001ae548>] do_vfs_ioctl+0x360/0x5b4
> [<ffffffc0001ae81c>] SyS_ioctl+0x80/0x98
> 
> And I think the BUG https://bugzilla.redhat.com/show_bug.cgi?id=1195899
> should be the same reason.
> 
> Signed-off-by:Ding Xiang <dingxiang@huawei.com>

Your patch wasn't correct (it couldn't handle device paths like
"253:3", you also didn't check lookup_bdev's return).

But I've staged the following for 4.6:

https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=for-next&id=808e62175f126de041ea1efe94b4e55511c6c119
