From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm: fix AB-BA deadlock in __dm_destroy()
Date: Thu, 1 Oct 2015 16:45:00 -0400
Message-ID: <20151001204500.GA29966@redhat.com>
References: <20151001083149.GA13075@xzibit.linux.bs1.fc.nec.co.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20151001083149.GA13075@xzibit.linux.bs1.fc.nec.co.jp>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Junichi Nomura <j-nomura@ce.jp.nec.com>
Cc: device-mapper development <dm-devel@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

On Thu, Oct 01 2015 at  4:31am -0400,
Junichi Nomura <j-nomura@ce.jp.nec.com> wrote:

> __dm_destroy() takes io_barrier SRCU lock (dm_get_live_table) and
> suspend_lock in reverse order. That can cause AB-BA deadlock:
> 
> Example:
> 
>   __dm_destroy                    dm_swap_table
>   ---------------------------------------------------
>                                   mutex_lock(suspend_lock)
>   dm_get_live_table()
>     srcu_read_lock(io_barrier)
>                                   dm_sync_table()
>                                     synchronize_srcu(io_barrier)
>                                       .. waiting for dm_put_live_table()
>   mutex_lock(suspend_lock)
>     .. waiting for suspend_lock
> 
> This patch fixes the lock ordering.
> 
> Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
> Fixes: ab7c7bb6f4ab ("dm: hold suspend_lock while suspending device during device deletion")
> Cc: Mikulas Patocka <mpatocka@redhat.com>

> ---
> The problem could be reproduced with this script but it might take long.
> (In my environment, it took more than 10 minutes)

Hi,

Thanks for fixing this.  What prompted you to chase this down?  Was it
the work you were doing to reproduce Bart's blk-mq mpath failure that
exposed this issue?

FYI, interestingly, your fix looks to be applicable to this issue too:
https://bugzilla.redhat.com/show_bug.cgi?id=1267650

Thanks again,
Mike
