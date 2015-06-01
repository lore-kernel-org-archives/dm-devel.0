From: Junichi Nomura <j-nomura@ce.jp.nec.com>
Subject: Re: [PATCH for-4.2 2/3] block,
 dm: don't copy bios for request clones
Date: Mon, 1 Jun 2015 01:19:13 +0000
Message-ID: <556BB311.7050505@ce.jp.nec.com>
References: <1432300445-9543-1-git-send-email-snitzer@redhat.com>
	<1432300445-9543-2-git-send-email-snitzer@redhat.com>
	<556410BB.3000103@ce.jp.nec.com> <20150527082157.GA25993@lst.de>
	<5565935A.4060408@ce.jp.nec.com> <20150529165545.GB2682@lst.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20150529165545.GB2682@lst.de>
Content-Language: ja-JP
Content-ID: <F6B8B2CDDB45B9428FD175B225C8C933@gisp.nec.co.jp>
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
Cc: Jens Axboe <axboe@kernel.dk>, device-mapper development <dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

On 05/30/15 01:55, Christoph Hellwig wrote:
> On Wed, May 27, 2015 at 09:50:18AM +0000, Junichi Nomura wrote:
>> Can you test this scenario with your patch?
>>   1. Set up a multipath device with fail-over mode
>>   2. Write something to the multipath device.
>>      After the clone request is sent to the primary path
>>      and before the data goes to the disk, 
>>      down the primary path
>>      (e.g. echo offline > /sys/block/sdXX/device/state)
>>   3. (dm-mpath will retry from the secondary path and
>>       the write will eventually succeed)
>>   4. Verify if the written data is really on the disk
> 
> Verified as not working correctly.  The patch below fixes it,
> but it needs more testing and some comments:

Thanks. But just skipping bio_advance() is not good.

For example, blk_update_request() does this:

>         while (req->bio) {
>                 struct bio *bio = req->bio;
>                 unsigned bio_bytes = min(bio->bi_iter.bi_size, nr_bytes);
> 
>                 if (bio_bytes == bio->bi_iter.bi_size)
>                         req->bio = bio->bi_next;

if bi_iter.bi_size is not correct, we possibly fail
to move the req->bio pointer.

So other test case could be:

1. Create a bio with 1MB size
2. Submit a request with the bio
3. From lower driver,
   firstly partial complete 512KB with error,
   secondly partial complete 512KB without error
4. The I/O should complete successfully.

And yet another test:

1. Create 4 READ bios with each 4KB
2. Submit a request with the 4 bios
3. From lower driver,
   partial complete 8KB without error,
   partial complete 4KB with error (emulate medium error),
   partial complete 4KB without error
4. Verify the read data.
   Only the 3rd 4KB should be failed.
   Others should have correct contents.

-- 
Jun'ichi Nomura, NEC Corporation
