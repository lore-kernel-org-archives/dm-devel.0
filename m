From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: DMF_FREEING flag checking
Date: Mon, 10 Mar 2008 12:29:46 +0000
Message-ID: <20080310122946.GC1788@agk.fab.redhat.com>
References: <746615.15795.qm@web31715.mail.mud.yahoo.com>
	<20080310121800.GB1788@agk.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20080310121800.GB1788@agk.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mai N <thumai9999@yahoo.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Mon, Mar 10, 2008 at 12:18:00PM +0000, Alasdair G Kergon wrote:
> The question is, are there any
> *actual* code paths which could lead to that happening, where existing
> locking/serialisation is inadequate?
  
The final dm_put that triggers the deletion (md->holders dropping to 0)
is in __hash_remove() while holding _hash_lock - so I don't think the dm_get()
calls you mention can run in parallel.

There are other dm_get() calls outside _hash_lock, but I think the
argument is that the code paths containing them can't be reached
if the final dm_put() has started - they all require something to have
the device open.

Alasdair
-- 
agk@redhat.com
