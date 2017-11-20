From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 00/13] block: assorted cleanup for bio splitting and cloning.
Date: Mon, 20 Nov 2017 11:43:44 -0500
Message-ID: <CAMM=eLf9Vu-z1ZEsGtRoSkhpaaQXAdr8TsUYUCSmAjqrqo=W-w@mail.gmail.com>
References: <149776047907.23258.8058071140236879834.stgit@noble>
 <20170618184143.GA10920@kernel.dk> <87poe13rmm.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <87poe13rmm.fsf@notabene.neil.brown.name>
Sender: linux-block-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Sun, Jun 18, 2017 at 5:36 PM, NeilBrown <neilb@suse.com> wrote:
> On Sun, Jun 18 2017, Jens Axboe wrote:
>
>> On Sun, Jun 18 2017, NeilBrown wrote:
>>> This is a resend of my series of patches working
>>> towards removing the bioset work queues.
>>>
>>> This set is based on for-4.13/block.
>>>
>>> It incorporates the revised versions of all the patches that were
>>> resent following feedback on the last set.
>>>
>>> It also includes a minor grammatic improvement to a comment, and
>>> simple changes to compensate for a couple of changes to the block tree
>>> since the last posting.
>>>
>>> I hope to eventually get rid of the new BIOSET_NEED_RESCUER flag,
>>> but that needs work in dm and probably bcache first.
>>
>> Thanks Neil, applied.
>
> Thanks a lot Jens.

I missed this line of work until now.  Not quite sure why I wasn't
cc'd or my review/ack required for the DM changes in this patchset.

But I've now queued this patch for once Linus gets back (reverts DM
changes from commit 47e0fb461f):
https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=for-next&id=c9fdc42ba23eabd1ba7aef199fb9bb4b4fe5c545

As is, it is my understanding that DM has no need for a bio_set's
rescue_workqueue.  So its removal would appear to only be gated by
bcache?

But I could be mistaken, moving forward please let me know what you
feel needs doing in DM to make it a better citizen.

Thanks,
Mike
