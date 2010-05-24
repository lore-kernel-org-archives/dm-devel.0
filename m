From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 2/6] dm ioctl: interlock resume and table
	clear
Date: Mon, 24 May 2010 13:08:33 -0400
Message-ID: <20100524170832.GA32389@redhat.com>
References: <1274651101-9784-1-git-send-email-snitzer@redhat.com>
	<1274651101-9784-3-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1274651101-9784-3-git-send-email-snitzer@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Sun, May 23 2010 at  5:44pm -0400,
Mike Snitzer <snitzer@redhat.com> wrote:

> When resuming an inactive table there is a lack of testable state during
> its transition to being live (hc->new_map is NULL and md->map isn't
> set).  Interlock allows table_clear() to _know_ there isn't a live table
> yet.
> 
> This interlock also has the side-effect of serializing N resumes to the
> _same_ mapped_device (more coarsely than the suspend_lock provides).
> 
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> ---
>  drivers/md/dm-ioctl.c |   34 +++++++++++++++++++++++++++++++---
>  drivers/md/dm.c       |   17 +++++++++++++++++
>  drivers/md/dm.h       |    3 +++
>  3 files changed, 51 insertions(+), 3 deletions(-)
> 
> Index: linux-2.6/drivers/md/dm-ioctl.c
> ===================================================================
> --- linux-2.6.orig/drivers/md/dm-ioctl.c
> +++ linux-2.6/drivers/md/dm-ioctl.c
> @@ -871,6 +871,17 @@ static int do_resume(struct dm_ioctl *pa
>  	}
>  
>  	md = hc->md;
> +	up_write(&_hash_lock);
> +
> +	dm_lock_resume(md);
> +
> +	down_write(&_hash_lock);

I'm missing the 'hc = dm_get_mdptr(md);' here.  Patch 5/6 fixed this up
so that is why I didn't notice this in testing.

> +	if (!hc || hc->md != md) {
> +		DMWARN("device has been removed from the dev hash table.");
> +		up_write(&_hash_lock);
> +		r = -ENXIO;
> +		goto out;
> +	}
>  
>  	new_map = hc->new_map;
>  	hc->new_map = NULL;

I'll hold off on reposting the patches just for the above fix though.
Especially given that we still need to answer the following 2 questions
(we also need to answer the more basic question that Kiyoshi asked in
response to patch 0/6; the answer to that may trump the following):

1)
What benefit is there with having do_resume() be reentrant for the
_same_ mapped_device?

I'm asserting that there is no benefit.  We likely just got that
reentrancy "for free" by needing do_resume() to be reentrant for
_different_ mapped_device(s). 

2)
The more important, but related, question:
How can we reliably _know_ that a DM device has a live table?

**see my p.s. footnote below**

If we can't reliably test for whether a DM device has a live table then
we can't impose the new table_load() constraint (as implemented in patch
3/6): A DM device must only ever have a single immutable type once an
"inactive" table is staged to become "live".

I'm looking to solve this #2 with patch 2/6 (but it fixes #1 in the
process).

I'm open to other suggestions for how to implement a fix for #2 (I
believe any solution for #2 will "fix" #1 as a side-effect).

Mike


p.s.
We currently have a state diagram gap where we have no way to know that
an "inactive" table (hc->new_map) is transitioning to be "live"
(md->map).

We haven't had a need for precise understanding of the state transitions
a DM device has while making an "inactive" table "live":
* do_resume() destages hc->new_map (and sets it to NULL) under _hash_lock
* "inactive" table is becoming "live", but AFAIK we have nothing to test
  that will tell us this.
* do_resume()'s dm_swap_table() will later set md->map under _hash_lock

I explored an alternative implementation for solving #2 but it was
significantly more complex:
1) still have do_resume() not be reentrant for the _same_ mapped_device
   - AFAIK, still requires a 'md->resume_lock'
2) introduce DMF_RESUMING flag (for md->flags) and set/clear/test it
   while holding 'md->resume_lock'
3) do_resume() sets and then clears DMF_RESUMING while holding
   'md->resume_lock'
4) table_clear() tests for DMF_RESUMING (if !hc->new_map && !md->map)
   while holding 'md->resume_lock'.

So in the end I dispensed with all the DMF_RESUMING business and just
kept the do_resume() and table_clear() interlock as it fixed #2 (and
#1).
