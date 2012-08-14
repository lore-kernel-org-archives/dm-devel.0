From: Tejun Heo <tj@kernel.org>
Subject: Re: workqueues and percpu (was: [PATCH] dm: remake of
 the verity target)
Date: Tue, 14 Aug 2012 10:54:31 -0700
Message-ID: <20120814175431.GR25632@google.com>
References: <1330648393-20692-1-git-send-email-msb@chromium.org>
	<Pine.LNX.4.64.1203031340340.10937@file.rdu.redhat.com>
	<20120306215947.GB27051@google.com>
	<Pine.LNX.4.64.1203081656590.31821@file.rdu.redhat.com>
	<20120308143909.bfc4cb4d.akpm@linux-foundation.org>
	<20120308231521.GA2968@htj.dyndns.org>
	<20120309211512.GL27051@google.com>
	<20120309212049.GD24890@google.com>
	<20120309220623.GM27051@google.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20120309220623.GM27051@google.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mandeep Singh Baines <msb@chromium.org>
Cc: Steffen Klassert <steffen.klassert@secunet.com>, Will Drewry <wad@chromium.org>, Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org, dm-devel@redhat.com, Elly Jones <ellyjones@chromium.org>, Mikulas Patocka <mpatocka@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Olof Johansson <olofj@chromium.org>, Alasdair G Kergon <agk@redhat.com>, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

Hello,

On Fri, Mar 09, 2012 at 02:06:23PM -0800, Mandeep Singh Baines wrote:
> > I think the right thing to do for now is to add cpu hotplug notifier
> > and do flush_work_sync() on the work item.  We can later move that
> > logic into workqueue and remove it from crypto.
> > 
> 
> That seems like the correct solution. I will implement that.

So, I've been looking at it and now am not so sure whether moving it
to workqueue core is necessary.  With the proposed workqueue updates,
workqueue's behavior is now closely aligned with the timer which also
considers the specified affinity overridable (to avoid reentrancy and
during CPU offlining) and I don't think it's reasonable to require
users which need strict affinity to implement proper CPU up/down
notifiers - in many cases, they need them anyway.  I'll try to review
the current users and think more about it.

Thanks.

-- 
tejun
