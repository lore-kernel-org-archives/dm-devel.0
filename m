From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 0/6] dm: restrict conflicting table loads and
 improve queue initialization
Date: Mon, 24 May 2010 13:24:49 -0400
Message-ID: <20100524172449.GB32389@redhat.com>
References: <1274651101-9784-1-git-send-email-snitzer@redhat.com>
	<4BFA4E4A.6060404@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4BFA4E4A.6060404@ct.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Cc: dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Mon, May 24 2010 at  6:00am -0400,
Kiyoshi Ueda <k-ueda@ct.jp.nec.com> wrote:

> Hi Mike,
> 
> On 05/24/2010 06:44 AM +0900, Mike Snitzer wrote:

> > But this new series eliminates v7's locking between table_load() and
> > do_resume() -- fixed md->type made this possible.  So these changes
> > may be more desirable overall (adds some clearer exclusion and state
> > transitions that I feel help DM without being too restrictive).
> 
> Yes, I think it's reasonable.

OK.

> > This work has expanded in scope somewhat (based on Mikulas' suggestion
> > that I pursue more constrained table/device type switching to avoid
> > Kiyoshi's locking concerns).  A mapped_device now has a specific type
> > (md->type) that is managed in table_{load,clear} (see patch 3/6).
>  
> Cancelling the type by table_clear() keeps the code/model complex
> even after changing model.
> I think the feature to cancel the type is not required any userspace
> tools nor admins at least for now.  So dropping the feature and
> completely fixing the type at the first table loading time may be
> a good meeting point to make the kernel code simple.

I initially thought it best to keep table_clear() more "friendly".. so
as not to impose a user explicitly delete a DM device just to switch
from bio-based to request-based tables (or vice-versa).

But I think I've come full-circle:

- I'm not against imposing your suggestion (never reset md->type).
  Certainly keeps the DM code simpler! :)

- We don't know all existing userspace code -- people could be using
  DM's clear ioctl and we'd break their assumptions; but do we _really_
  care?  They'll adapt (they'd have to do a device delete, device
  create, table load).

> I had only a quick look, so I may find some more comments.  But I'd
> like to have more review after we reach an agreement about the basic
> implementation design above.

Yes, wish I had the restraint to avoid making dm_clear_md_type() work ;)

But pulling out that support will be easy and will also simplify other
code:
- will eliminate concern for "rq -> bio -> rq" in
  dm_init_request_based_queue()
- can remove dm_clear_request_based_queue()
- maybe more...

Thanks,
Mike
