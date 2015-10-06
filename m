From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [dm-devel] block: flush queued bios when the process blocks
Date: Tue, 6 Oct 2015 14:17:03 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1510061410450.27916@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1405271059190.27492@file01.intranet.prod.int.rdu2.redhat.com> <5384AA79.4010206@kernel.dk> <alpine.LRH.2.02.1405271120390.31404@file01.intranet.prod.int.rdu2.redhat.com> <5384B26D.1000703@kernel.dk>
 <alpine.LRH.2.02.1405271222150.8745@file01.intranet.prod.int.rdu2.redhat.com> <5384CE82.90601@kernel.dk> <alpine.LRH.2.02.1405291944090.22123@file01.intranet.prod.int.rdu2.redhat.com> <20151005205943.GB25762@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151005205943.GB25762@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Kent Overstreet <kmo@daterainc.com>, dm-devel@redhat.com, linux-kernel@vger.kernel.org, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids



On Mon, 5 Oct 2015, Mike Snitzer wrote:

> FYI, I've put rebased versions of your 2 patches in my wip branch, see:
> http://git.kernel.org/cgit/linux/kernel/git/snitzer/linux.git/log/?h=wip

I found a bug in the first patch 
(http://git.kernel.org/cgit/linux/kernel/git/snitzer/linux.git/commit/?h=wip&id=2e90df2e9cf482f45be4230152535fdab525fbd8)

There is this piece of code:

	spin_lock(&bs->rescue_lock);
	bio_list_add(&bs->rescue_list, bio);
	spin_unlock(&bs->rescue_lock);
	queue_work(bs->rescue_workqueue, &bs->rescue_work);

It is possible that after spin_unlock and before queue_work the bio is 
finished by previous workqueue invocation. When the bio is finished, it is 
possible that the block device is unloaded and queue_work accesses freed 
memory.

Change the code so that queue_work is executed inside the spinlock:
	spin_lock(&bs->rescue_lock);
	bio_list_add(&bs->rescue_list, bio);
	queue_work(bs->rescue_workqueue, &bs->rescue_work);
	spin_unlock(&bs->rescue_lock);

Mikulas
