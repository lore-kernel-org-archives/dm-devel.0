From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH 1/7] multipath: fix tur checker locking
Date: Thu, 8 Feb 2018 18:19:32 +0000
Message-ID: <1518113970.3611.58.camel@wdc.com>
References: <1518043787-7066-1-git-send-email-bmarzins@redhat.com>
	<1518043787-7066-2-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1518043787-7066-2-git-send-email-bmarzins@redhat.com>
Content-Language: en-US
Content-ID: <24B8B0D25C461B4BAD6F1A93D2BAB9AB@namprd04.prod.outlook.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "bmarzins@redhat.com" <bmarzins@redhat.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>
Cc: "mwilck@suse.com" <mwilck@suse.com>
List-Id: dm-devel.ids

On Wed, 2018-02-07 at 16:49 -0600, Benjamin Marzinski wrote:
> Commit 6e2423fd fixed a bug where the tur checker could cancel a
> detached thread after it had exitted. However in fixing this, the new
> code grabbed a mutex (to call condlog) while holding a spin_lock. To
> deal with that, and to try to keep with the maixim "lock data, not
> code", I've changed how the tur checker synchronizes with its thread.
> 
> Now, the tur checker creates joinable threads, and detaches them when
> the thread is finished or has timed out. To track the state of the
> threads, I've added a new variable to the checker context, ct->attached.
> When a thread starts, attached is set to 1. When the thread finishes, it
> saves the value of attached, and then zeros it out, while locked. If
> attached was set, it detaches itself.
> 
> When the tur checker gives up on a thread, it also saves and decrements
> ct->attached, while locked. At the same time it saves the value of
> ct->thread.  If attached was set, it cancels the thread, and then
> detaches it.
> 
> So the values that are protected by the spin lock are now ct->holders,
> ct->thread, and ct->attached. There are cases where the tur checker just
> wants to know if the thread is running. If so, its safe to simply read
> ct->thread without locking.  Also, if it knows that the thread isn't
> running, it can freely access all of these variables. I've left the
> locking in-place in these cases to make the static analyzers happy.
> However I have added comments stating when the locking isn't actually
> necessary.

Hello Ben,

Have you considered to move the condlog() statements out of the spinlock
section? I think that would lead to a much smaller and less contrived change
than the patch you posted.

Thanks,

Bart.
