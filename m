From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: mirror patches - device failure detection/race
	fix/deadlock fix
Date: Tue, 2 Aug 2005 18:35:43 +0100
Message-ID: <20050802173543.GA5224@agk.surrey.redhat.com>
References: <278411eef6c06676d89c4ab5530cde8e@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <278411eef6c06676d89c4ab5530cde8e@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Tue, Aug 02, 2005 at 11:00:05AM -0500, Jon Brassow wrote:
> The 'race.patch' fixes a couple race conditions that were a result of 
> the __rh_alloc() function releasing and regrabbing a lock when called.

-       read_unlock(&rh->hash_lock);
-       nreg = mempool_alloc(rh->region_pool, GFP_NOIO);
+       nreg = mempool_alloc(rh->region_pool, GFP_ATOMIC);
        nreg->state = rh->log->type->in_sync(rh->log, region, 1) ?

So mempool_alloc is now called while holding a spinlock.
With GFP_ATOMIC, what happens if it returns NULL?
Doesn't it need to be able to sleep to get the benefit of the mempool?

> The 'deadlock.patch' switches all spin_lock calls on the region_lock to 
> spin_lock_irqsave.  Without this patch you machine will hang.
 
I'd prefer it if race.patch used the correct versions (with or without _irq).

Alasdair
-- 
agk@redhat.com
