From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: Re: [PATCH 2/2] dm-mpath: Add element for suspended state.
Date: Fri, 20 Nov 2009 16:19:49 +0900
Message-ID: <4B064315.5050105@ct.jp.nec.com>
References: <20091116073819.4070.40173.stgit@localhost.localdomain>	<20091116073829.4070.45194.stgit@localhost.localdomain>
	<20091116135430.GB11886@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20091116135430.GB11886@agk-dp.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Anderson <andmike@linux.vnet.ibm.com>, Alasdair Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi Alasdair, Mike,

On 11/16/2009 10:54 PM +0900, Alasdair G Kergon wrote:
> On Sun, Nov 15, 2009 at 11:38:29PM -0800, Mike Anderson wrote:
>> Add element to multipath structure for indication of suspended state.
>  
> Is there a way to avoid this?
> It seems redundant for a target to need to track whether or not
> it is suspended.  Core dm should be capable of that.
> 
> dm_suspend has:
>         dm_table_postsuspend_targets(map);
> 
>         set_bit(DMF_SUSPENDED, &md->flags);
> 
> Can we reorder those two?

For multipath and dm-core, yes.
I'm not sure whether other targets care about the ordering.

But from semantics point of view, is it confusing if dm_suspended()
returns true but a target is doing something in postsuspend()?

If we take the approach instead of this patch, the patch-set is like:
    1/4: http://patchwork.kernel.org/patch/61588/
    2/4: http://patchwork.kernel.org/patch/61589/
    3/4: http://patchwork.kernel.org/patch/61594/
    4/4: http://patchwork.kernel.org/patch/61595/

Please review.


> What about dm_resume?
>         clear_bit(DMF_SUSPENDED, &md->flags);
> Can that move a little higher up the function?
> - preresume, clear DMF_SUSPENDED, resume perhaps?

I think we shouldn't move the clear_bit in resume.

It doesn't make sense to clear the flag before I/Os start flowing.
If targets want to do any preparation before I/Os flowing through,
it can do in the resume() callback.

Thanks,
Kiyoshi Ueda
