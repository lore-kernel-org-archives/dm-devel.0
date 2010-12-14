From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 1/6] dm-stripe: drop kstriped
Date: Tue, 14 Dec 2010 18:59:35 -0500
Message-ID: <20101214235935.GB14227@redhat.com>
References: <1292181055-25696-1-git-send-email-tj@kernel.org>
	<1292181055-25696-2-git-send-email-tj@kernel.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1292181055-25696-2-git-send-email-tj@kernel.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Tejun Heo <tj@kernel.org>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Sun, Dec 12 2010 at  2:10pm -0500,
Tejun Heo <tj@kernel.org> wrote:

> kstriped only serves sc->kstriped_ws which runs dm_table_event().
> This doesn't need to be executed from an ordered workqueue w/ rescuer.
> Drop kstriped and use the system_wq instead.

What might look unnecessary at first glance is a bit more nuanced than
we'd both like...

I'm concerned about switching to using the global system_wq and calling
flush_scheduled_work() when resuming a DM table (calls a DM target's
->dtr() via dm_table_destroy in drivers/md/dm-ioctl.c:do_resume).

This introduces potential for a DM table swap performing a storm of
additional unrelated works.

Definitely needs further review.

Mike
