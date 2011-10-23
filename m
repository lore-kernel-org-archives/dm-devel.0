From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: Bisected: Massive memory leak in dm-snapshot in 3.1
	development introduced
Date: Sun, 23 Oct 2011 14:44:49 +0100
Message-ID: <20111023134449.GA13703@agk-dp.fab.redhat.com>
References: <20111023112140.37fd8b3d@xenia.leun.net> <CA+55aFzfFpnEc+Eerdi9SfMw4o17ONfYCHksJkD1O6AS5U2DoQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CA+55aFzfFpnEc+Eerdi9SfMw4o17ONfYCHksJkD1O6AS5U2DoQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>, Michael Leun <ml@newton.leun.net>
Cc: Alasdair G Kergon <agk@redhat.com>, LKML <linux-kernel@vger.kernel.org>, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

On Sun, Oct 23, 2011 at 12:52:06PM +0300, Linus Torvalds wrote:
> Mikulas, Alasdair? I see the mempool_free() for the "master job", what
> about everything else? Does the dm_kcopyd_prepare_callback() perhaps
> need to do a
> 
>     job->master_job = job;
> 
> or similar?

If you look at the other place that performs that mempool_alloc, it's indeed
present there.

Michael - can you test if this solves the problem?

Alasdair

--- a/drivers/md/dm-kcopyd.c
+++ b/drivers/md/dm-kcopyd.c
@@ -628,6 +628,7 @@ void *dm_kcopyd_prepare_callback(struct dm_kcopyd_client *kc,
 	job->kc = kc;
 	job->fn = fn;
 	job->context = context;
+	job->master_job = job;
 
 	atomic_inc(&kc->nr_jobs);
 
