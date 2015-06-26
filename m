From: Junichi Nomura <j-nomura@ce.jp.nec.com>
Subject: Re: [GIT PULL] Core block IO bits for 4.2
Date: Fri, 26 Jun 2015 08:05:35 +0000
Message-ID: <20150626080533.GA16471@xzibit.linux.bs1.fc.nec.co.jp>
References: <20150625143716.GA13739@kernel.dk>
 <20150626061510.GA15036@xzibit.linux.bs1.fc.nec.co.jp>
 <CA+55aFzke6FF6j+1_cDZbCtM4YEF+1vy==JD72LxbKWzxBkWJA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+55aFzke6FF6j+1_cDZbCtM4YEF+1vy==JD72LxbKWzxBkWJA@mail.gmail.com>
Content-Language: ja-JP
Content-ID: <C8037C5C4E90C84981EAE5207684D434@gisp.nec.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, Christoph Hellwig <hch@lst.de>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Mike Snitzer <snitzer@redhat.com>, Jens Axboe <axboe@fb.com>
List-Id: dm-devel.ids

On 06/26/15 15:41, Linus Torvalds wrote:
> On Jun 25, 2015 23:17, "Junichi Nomura" <j-nomura@ce.jp.nec.com <mailto:j-nomura@ce.jp.nec.com>> wrote:
>> On 06/25/15 23:37, Jens Axboe wrote:
>> >       block, dm: don't copy bios for request clones
>>
>> this change should not be pushed to mainline yet.
> 
> Hmm. I merged all of Jens' pull requests today, so it's now in my tree. What do?

Then I think following 3 commits should be reverted.

2d76fff dm: cleanup methods that requeue requests
cbc4e3c dm: do not allocate any mempools for blk-mq request-based DM
5f1b670 block, dm: don't copy bios for request clones

Reverting 5f1b670 involves conflicts in drvers/md/dm.c for
these 2 hunks due to diff contexts difference.
It's ok to revert those changes ignoring the contexts.

  @@ -1089,8 +1038,6 @@ static void free_rq_clone(struct request *clone, bool must_be_mapped)
   
          WARN_ON_ONCE(must_be_mapped && !clone->q);
   
  -       blk_rq_unprep_clone(clone);
  -
          if (md->type == DM_TYPE_MQ_REQUEST_BASED)
                  /* stacked on blk-mq queue(s) */
                  tio->ti->type->release_clone_rq(clone);

  @@ -1973,11 +1889,7 @@ static int map_request(struct dm_rq_target_io *tio, struct request *rq,
                  }
                  if (IS_ERR(clone))
                          return DM_MAPIO_REQUEUE;
  -               if (setup_clone(clone, rq, tio, GFP_ATOMIC)) {
  -                       /* -ENOMEM */
  -                       ti->type->release_clone_rq(clone);
  -                       return DM_MAPIO_REQUEUE;
  -               }
  +               setup_clone(clone, rq, tio);
          }
   
          switch (r) {

-- 
Jun'ichi Nomura, NEC Corporation