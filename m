From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: Re: [PATCH 0/6] dm: restrict conflicting table loads and
 improve queue initialization
Date: Mon, 24 May 2010 19:00:42 +0900
Message-ID: <4BFA4E4A.6060404@ct.jp.nec.com>
References: <1274651101-9784-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1274651101-9784-1-git-send-email-snitzer@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Hi Mike,

On 05/24/2010 06:44 AM +0900, Mike Snitzer wrote:
> It should be noted that patch 4/6 is labeled "v8".  I still believe
> v7's locking strategy is _not_ prone to problematic deadlock, as I
> detailed/questioned here: http://lkml.org/lkml/2010/5/21/175
> v7 is still available for viewing here:
> https://patchwork.kernel.org/patch/101270/

As I replied to another thread, the problematic deadlock is possible.

 
> But this new series eliminates v7's locking between table_load() and
> do_resume() -- fixed md->type made this possible.  So these changes
> may be more desirable overall (adds some clearer exclusion and state
> transitions that I feel help DM without being too restrictive).

Yes, I think it's reasonable.


> This work has expanded in scope somewhat (based on Mikulas' suggestion
> that I pursue more constrained table/device type switching to avoid
> Kiyoshi's locking concerns).  A mapped_device now has a specific type
> (md->type) that is managed in table_{load,clear} (see patch 3/6).
 
Cancelling the type by table_clear() keeps the code/model complex
even after changing model.
I think the feature to cancel the type is not required any userspace
tools nor admins at least for now.  So dropping the feature and
completely fixing the type at the first table loading time may be
a good meeting point to make the kernel code simple.


I had only a quick look, so I may find some more comments.  But I'd
like to have more review after we reach an agreement about the basic
implementation design above.

Thanks,
Kiyoshi Ueda
