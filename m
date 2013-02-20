From: Ed Cashin <ecashin@coraid.com>
Subject: Re: [PATCH 09/27] block: Use bio_sectors() more consistently
Date: Wed, 20 Feb 2013 16:43:34 +0000
Message-ID: <DFE3B626E00A3346A98511AD95B78358065785@DAGN05A-E6.exg6.exghost.com>
References: <1361319761-23873-1-git-send-email-koverstreet@google.com>
 <1361319761-23873-10-git-send-email-koverstreet@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1361319761-23873-10-git-send-email-koverstreet@google.com>
Content-Language: en-US
Content-ID: <6F6B8818A28CAA4BB4EEEEA2E244E335@exg6.exghost.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kent Overstreet <koverstreet@google.com>
Cc: "<linux-kernel@vger.kernel.org>" <linux-kernel@vger.kernel.org>, "<axboe@kernel.dk>" <axboe@kernel.dk>, Nick Piggin <npiggin@kernel.dk>, Jiri Kosina <jkosina@suse.cz>, Jim Paris <jim@jtan.com>, Geoff Levand <geoff@infradead.org>, Alasdair Kergon <agk@redhat.com>, "<dm-devel@redhat.com>" <dm-devel@redhat.com>, Neil Brown <neilb@suse.de>, Steven Rostedt <rostedt@goodmis.org>
List-Id: dm-devel.ids

That looks OK to me.

(I notice that while back in October it included changes to aoe, the current patch does not, which is fine.)

On Feb 19, 2013, at 7:22 PM, Kent Overstreet wrote:

> Bunch of places in the code weren't using it where they could be -
> this'll reduce the size of the patch that puts bi_sector/bi_size/bi_idx
> into a struct bvec_iter.
> 
> Signed-off-by: Kent Overstreet <koverstreet@google.com>
> CC: Jens Axboe <axboe@kernel.dk>
> CC: "Ed L. Cashin" <ecashin@coraid.com>
> CC: Nick Piggin <npiggin@kernel.dk>
> CC: Jiri Kosina <jkosina@suse.cz>
> CC: Jim Paris <jim@jtan.com>
> CC: Geoff Levand <geoff@infradead.org>
> CC: Alasdair Kergon <agk@redhat.com>
> CC: dm-devel@redhat.com
> CC: Neil Brown <neilb@suse.de>
> CC: Steven Rostedt <rostedt@goodmis.org>
> Acked-by: Ed Cashin <ecashin@coraid.com>
> ---
> drivers/block/pktcdvd.c      |  2 +-
> drivers/md/dm-raid1.c        |  2 +-
> drivers/md/raid0.c           |  6 +++---
> drivers/md/raid1.c           | 17 ++++++++---------
> drivers/md/raid10.c          | 24 +++++++++++-------------
> drivers/md/raid5.c           |  8 ++++----
> fs/btrfs/volumes.c           |  2 +-
> include/trace/events/block.h | 12 ++++++------
> 8 files changed, 35 insertions(+), 38 deletions(-)
...

-- 
  Ed Cashin
  ecashin@coraid.com
