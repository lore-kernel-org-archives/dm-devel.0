From: Christoph Hellwig <hch@lst.de>
Subject: Re: dm-mpath: Handling SCSI-3 PR RELEASE in
	multi-controller	environment
Date: Mon, 26 Sep 2016 18:03:17 +0200
Message-ID: <20160926160317.GA17796@lst.de>
References: <57E24F7E.4030103@huawei.com> <20160921150427.GB9748@redhat.com>
	<57E392FA.3080006@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <57E392FA.3080006@huawei.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: jiangyiwen <jiangyiwen@huawei.com>
Cc: wangyibin@huawei.com, dm-devel@redhat.com, hch@lst.de, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

On Thu, Sep 22, 2016 at 04:14:50PM +0800, jiangyiwen wrote:
> I briefly reviewed the PR API. If I understand correctly, a bunch of PR
> dedicated operations (pr_ops) are defined in block_device_operations, which
> includes register, reserve, release, preempt and clear operations. But among
> these operations, only register() calls dm_call_pr(), which in turns iterates
> over the device for each path and does the registeration.

Register and unregister in fact, but they both multiple throught the
same method.

> My point is, we also need to do this in release operation, so that we can
> eliminate the possibility of trying to release the reservation on the wrong
> controller and get a fake success.

dm_grab_bdev_for_ioctl ensures that we have a working path.  At least
that's the theory and my testing confirms it.  If you know a case where
the release doesn't work using this path we'll need to fix.
