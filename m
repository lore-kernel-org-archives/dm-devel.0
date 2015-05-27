From: Junichi Nomura <j-nomura@ce.jp.nec.com>
Subject: Re: [PATCH for-4.2 2/3] block,
 dm: don't copy bios for request clones
Date: Wed, 27 May 2015 09:50:18 +0000
Message-ID: <5565935A.4060408@ce.jp.nec.com>
References: <1432300445-9543-1-git-send-email-snitzer@redhat.com>
	<1432300445-9543-2-git-send-email-snitzer@redhat.com>
	<556410BB.3000103@ce.jp.nec.com> <20150527082157.GA25993@lst.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20150527082157.GA25993@lst.de>
Content-Language: ja-JP
Content-ID: <2613AD08A20F684D94747C1BD5B5DA04@gisp.nec.co.jp>
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

On 05/27/15 17:21, Christoph Hellwig wrote:
> On Tue, May 26, 2015 at 06:20:43AM +0000, Junichi Nomura wrote:
>> Not completing bios is not sufficient.
>> If you advance the bi_iter to the end, you need to somehow rewind it
>> or the re-submission will be incomplete, that would end up as a data
>> corruption...
> 
> Can you explain which particular case you're worried about?

General path failure case.

On retrying, another clone is created but bios it points to
are already advanced to the end with your patch.
So they look like bios with no remaining segments.
Lower driver may successfully completes such a resubmitted
clone *without doing actual I/O*.
Then written data will be lost / read data will be bogus.

Can you test this scenario with your patch?
  1. Set up a multipath device with fail-over mode
  2. Write something to the multipath device.
     After the clone request is sent to the primary path
     and before the data goes to the disk, 
     down the primary path
     (e.g. echo offline > /sys/block/sdXX/device/state)
  3. (dm-mpath will retry from the secondary path and
      the write will eventually succeed)
  4. Verify if the written data is really on the disk

-- 
Jun'ichi Nomura, NEC Corporation
