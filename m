From: Muneendra Kumar M <muneendra.kumar@broadcom.com>
Subject: Re: [PATCH 04/19] Revert "multipath-tools: discard
	san_path_err_XXX feature"
Date: Fri, 28 Dec 2018 17:49:17 +0530
Message-ID: <bc0c771862af01b03162992a636ed962@mail.gmail.com>
References: <20181218231931.10762-1-mwilck@suse.com>		
	<20181218231931.10762-5-mwilck@suse.com>
	<70906b6af0249c06e324e83ebb4f1549@mail.gmail.com>		
	<7b211887febc05788f740c7055621ff92af4821c.camel@suse.com>
	<b6344e8ee048341d345a2b5fb87fd765@mail.gmail.com>	
	<547efee2e83192f8225068daeb18c7e1c514d51d.camel@suse.com>
	<d4dea3fd25817b278358297d9e654ef6@mail.gmail.com>
	<0dc3cffd35eae6f28389195308f9a5ae00a5bcb7.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <0dc3cffd35eae6f28389195308f9a5ae00a5bcb7.camel@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Wilck <mwilck@suse.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>, mwilck+gmail@suse.de
Cc: Guan Junxiong <guanjunxiong@huawei.com>, M Muneendra Kumar <mmandala@brocade.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

Hi Martin,
Please find my replies below.

>Hi Muneedra,

> The san_path_err_XX feature was added by me and pushed to the
> upstream.
> And this feature was driven from Brocade Customer Feedback.
>
> And the below link will give  the history of this where couple of
> discussions went before we started this feature.
>
> https://www.redhat.com/archives/dm-devel/2017-January/msg00025.html

>I'm aware that you authored the feature. I was not aware of that post you
>quoted, thanks for the link. Anyway, you mentioned in that post that the
>interested customers were using RHEL, have you made them upgrade their
>multipath-tools to >recent upstream to use the san_path_err and/or
>marginal_path features?


>>>> I will get back to u with the details.


> Our requirement was simple
> For example If there are two paths on a dm-1 say sda and sdb as below.
>
>  #  multipath -ll
>  mpathd (3600110d001ee7f0102050001cc0b6751) dm-1 SANBlaze,VLUN MyLun
> size=8.0M features='0' hwhandler='0' wp=rw
>  `-+- policy='round-robin 0' prio=50 status=active
>    |- 8:0:1:0  sda 8:48 active ready  running
>    `- 9:0:1:0  sdb 8:64 active ready  running
>
>  And on sda if iam seeing lot of errors due to which the sda path is
> fluctuating from failed state to active state and vicevera.
>
>  The  requirement was something like this  if sda is failed(moved from
> active to failed state) for more than X  times in a Y duration ,then I
> want to keep the sda in failed state for Z duration

>Thanks for clarifying what you meant with "is failed". I'd been wondering
>if it meant "good"->"failed" transitions, as you just confirmed, or overall
>"failed" state count.

>  And the data should travel only through sdb path for Z hrs.
>
>
>  From the configuration point of view
>
>  san_path_err_threshold: The number of times the sda has been moved
> from active to failed (from the above example it is X)
>  san_path_err_forget_rate: Watch window (within this time frame if the
> path failures (sda moving from active to failed ) are more than err
> threshold then don't reinstate the path) (from the above example it is
> Y)

>The "watch window" analogy fits if you have a stable path (no or only very
>rare failures over extended periods of time) which suddenly starts
>fluctuating. More precisely, a "background" failure rate clearly below
>"san_path_err_forget_rate", >interchanging with problematic periods in
>which the failure rate is significantly higher than
>"san_path_err_forget_rate". And that's is the situation the algorithm was
>made for, right?

>In general, the "time" (in ticks) to reach the treshold is

  >t = T / max(1/R - 1/F, 0)

>Where T is san_path_err_threshold, R is the average time (in ticks) between
>"good"->"failed" transitions of the path, and F is san_path_err_forget_rate
>(aka the time in ticks after which "path_failures" is decremented by 1).

>If R >= F, t is infinite; the "path_failures" count effectively stays 0. If
>R is much smaller than F, t ~ T * R. If R is only a little bit smaller than
>F, t is finite but (possibly much) larger than T * R.
>That's why I sloppily called F the "maximum tolerable failure rate" in my
>previous post.

>>>> Yes.

......


Regards,
Muneendra.
