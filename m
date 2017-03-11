From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 0/5] Updates following recent generic_make_request
 improvement
Date: Sat, 11 Mar 2017 15:32:35 -0700
Message-ID: <3c5e786a-ba42-ada8-c943-17e8b72c63d1@kernel.dk>
References: <148912539296.4002.219258660543808741.stgit@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <148912539296.4002.219258660543808741.stgit@noble>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: linux-block@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>, LKML <linux-kernel@vger.kernel.org>, linux-raid@vger.kernel.org, device-mapper development <dm-devel@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, Pavel Machek <pavel@ucw.cz>, Jack Wang <jinpu.wang@profitbricks.com>, Lars Ellenberg <lars.ellenberg@linbit.com>, Kent Overstreet <kent.overstreet@gmail.com>
List-Id: dm-devel.ids

On 03/09/2017 11:00 PM, NeilBrown wrote:
> This is a rebase of the series I sent earlier, based on the
> very latest from Linus, which included my first patch.
> 
> The first fixes a problem that patch introduced, and so should go to
> Linux promptly.
> The others are more general improvements and can go in the normal
> course of events.
> 
> It is possible that the changes to btrfs and xfs can just be dropped
> as a subsequent patch will be needed to revert them anyway.  They are
> there only to be able to say that "blk: make the bioset
> rescue_workqueue optional." doesn't change any functionality at all.

I have applied the first patch for this series, and added the Fixes
tag. We'll let the rest simmer a bit, then aim for 4.12 for those.

-- 
Jens Axboe

