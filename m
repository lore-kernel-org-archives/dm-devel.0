From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [git pull] device mapper changes for 5.9
Date: Fri, 7 Aug 2020 12:20:21 -0400
Message-ID: <20200807162021.GA1065@redhat.com>
References: <20200807160327.GA977@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200807160327.GA977@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-block@vger.kernel.org, Alasdair G Kergon <agk@redhat.com>, Damien Le Moal <damien.lemoal@wdc.com>, Ignat Korchagin <ignat@cloudflare.com>, JeongHyeon Lee <jhs2.lee@samsung.com>, Johannes Thumshirn <johannes.thumshirn@wdc.com>, John Dorminy <jdorminy@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, Ming Lei <ming.lei@redhat.com>, yangerkun <yangerkun@huawei.com>
List-Id: dm-devel.ids

On Fri, Aug 07 2020 at 12:03pm -0400,
Mike Snitzer <snitzer@redhat.com> wrote:

> Hi Linus,
> 
> The following changes since commit 11ba468877bb23f28956a35e896356252d63c983:
> 
>   Linux 5.8-rc5 (2020-07-12 16:34:50 -0700)
> 
> are available in the Git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-5.9/dm-changes
> 
> for you to fetch changes up to a9cb9f4148ef6bb8fabbdaa85c42b2171fbd5a0d:
> 
>   dm: don't call report zones for more than the user requested (2020-08-04 16:31:12 -0400)
> 
> Please pull, thanks!
> Mike
> 
> ----------------------------------------------------------------
> - DM multipath locking fixes around m->flags tests and improvements to
>   bio-based code so that it follows patterns established by
>   request-based code.
> 
> - Request-based DM core improvement to eliminate unnecessary call to
>   blk_mq_queue_stopped().
> 
> - Add "panic_on_corruption" error handling mode to DM verity target.
> 
> - DM bufio fix to to perform buffer cleanup from a workqueue rather
>   than wait for IO in reclaim context from shrinker.
> 
> - DM crypt improvement to optionally avoid async processing via
>   workqueues for reads and/or writes -- via "no_read_workqueue" and
>   "no_write_workqueue" features.  This more direct IO processing
>   improves latency and throughput with faster storage.  Avoiding
>   workqueue IO submission for writes (DM_CRYPT_NO_WRITE_WORKQUEUE) is
>   a requirement for adding zoned block device support to DM crypt.

I forgot to note that you'll get a trivial merge conflict in dm-crypt.c
due to commit ed00aabd5eb9f (" block: rename generic_make_request to
submit_bio_noacct").

Mike
