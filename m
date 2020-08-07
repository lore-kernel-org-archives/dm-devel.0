From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [git pull] device mapper changes for 5.9
Date: Fri, 7 Aug 2020 13:11:38 -0700
Message-ID: <CAHk-=wiC=g-0yZW6QrEXRH53bUVAwEFgYxd05qgOnDLJYdzzcA@mail.gmail.com>
References: <20200807160327.GA977@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20200807160327.GA977@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com, linux-block <linux-block@vger.kernel.org>, Alasdair G Kergon <agk@redhat.com>, Damien Le Moal <damien.lemoal@wdc.com>, Ignat Korchagin <ignat@cloudflare.com>, JeongHyeon Lee <jhs2.lee@samsung.com>, Johannes Thumshirn <johannes.thumshirn@wdc.com>, John Dorminy <jdorminy@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, Ming Lei <ming.lei@redhat.com>, yangerkun <yangerkun@huawei.com>
List-Id: dm-devel.ids

On Fri, Aug 7, 2020 at 9:03 AM Mike Snitzer <snitzer@redhat.com> wrote:
>
> - DM crypt improvement to optionally avoid async processing via
>   workqueues for reads and/or writes -- via "no_read_workqueue" and
>   "no_write_workqueue" features.  This more direct IO processing
>   improves latency and throughput with faster storage.  Avoiding
>   workqueue IO submission for writes (DM_CRYPT_NO_WRITE_WORKQUEUE) is
>   a requirement for adding zoned block device support to DM crypt.

Is there a reason the async workqueue isn't removed entirely if it's not a win?

Or at least made to not be the default.

Now it seems to be just optionally disabled, which seems the wrong way
around to me.

I do not believe async crypto has ever worked or been worth it.
Off-loaded crypto in the IO path, yes. Async using a workqueue? Naah.

Or do I misunderstand?

               Linus
