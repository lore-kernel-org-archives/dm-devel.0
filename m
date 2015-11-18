From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 1/2] dm mpath: fix infinite recursion in
 ioctl when no paths and queue_if_no_path is not set
Date: Wed, 18 Nov 2015 14:52:52 -0800
Message-ID: <564D0144.4000202@sandisk.com>
References: <20151117093654.GA13022@xzibit.linux.bs1.fc.nec.co.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20151117093654.GA13022@xzibit.linux.bs1.fc.nec.co.jp>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>, Christoph Hellwig <hch@lst.de>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

On 11/17/2015 01:36 AM, Junichi Nomura wrote:
> In multipath_prepare_ioctl(),
>    - pgpath is a path selected from available paths
>    - m->queue_io is true if we cannot send a request immediately to
>      paths, either because:
>        * there is no available path
>        * the path group needs activation (pg_init)
>            - pg_init is not started
>            - pg_init is still running
>    - m->queue_if_no_path is true if the device is configured to queue
>      I/O if there is no available path
>
> If !pgpath && !m->queue_if_no_path, the handler should return -EIO.
> However in the course of refactoring the condition check has broken
> and returns success in that case.  Since bdev points to the dm device
> itself, dm_blk_ioctl() calls __blk_dev_driver_ioctl() for itself and
> recurses until crash.
>
> You could reproduce the problem like this:
>
>    # dmsetup create mp --table '0 1024 multipath 0 0 0 0'
>    # sg_inq /dev/mapper/mp
>    <crash>
>    [  172.648615] BUG: unable to handle kernel paging request at fffffffc81b10268
>    [  172.662843] PGD 19dd067 PUD 0
>    [  172.666269] Thread overran stack, or stack corrupted
>    [  172.671808] Oops: 0000 [#1] SMP
>    ...
>
> This patch fixes the condition check with some clarifications.
>
> Fixes: e56f81e0b01e ("dm: refactor ioctl handling")
> Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Mike Snitzer <snitzer@redhat.com>

Since I was able to reproduce this crash and since I haven't seen that 
crash anymore after I had applied this patch,

Tested-by: Bart Van Assche <bart.vanassche@sandisk.com>
