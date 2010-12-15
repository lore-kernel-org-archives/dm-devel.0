From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 1/6] dm-stripe: drop kstriped
Date: Tue, 14 Dec 2010 20:34:58 -0500
Message-ID: <20101215013457.GA16210@redhat.com>
References: <1292181055-25696-1-git-send-email-tj@kernel.org>
	<1292181055-25696-2-git-send-email-tj@kernel.org>
	<20101214235935.GB14227@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20101214235935.GB14227@redhat.com>
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

On Tue, Dec 14 2010 at  6:59pm -0500,
Mike Snitzer <snitzer@redhat.com> wrote:

> On Sun, Dec 12 2010 at  2:10pm -0500,
> Tejun Heo <tj@kernel.org> wrote:
> 
> > kstriped only serves sc->kstriped_ws which runs dm_table_event().
> > This doesn't need to be executed from an ordered workqueue w/ rescuer.
> > Drop kstriped and use the system_wq instead.
>
> I'm concerned about switching to using the global system_wq and calling
> flush_scheduled_work() when resuming a DM table (calls a DM target's
> ->dtr() via dm_table_destroy in drivers/md/dm-ioctl.c:do_resume).

Ah, I just got to 4/6 and see you switched flush_scheduled_work() to:
flush_work_sync(&sc->trigger_event);

Thanks,
Mike
