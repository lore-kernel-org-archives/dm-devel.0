From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 1/6] dm-stripe: drop kstriped
Date: Sat, 8 Jan 2011 12:16:47 -0500
Message-ID: <20110108171647.GE13269@mtj.dyndns.org>
References: <1292181055-25696-1-git-send-email-tj@kernel.org>
	<1292181055-25696-2-git-send-email-tj@kernel.org>
	<20101214235935.GB14227@redhat.com>
	<20101215013457.GA16210@redhat.com>
	<20110107230231.GO5910@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20110107230231.GO5910@agk-dp.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

Hello,

On Fri, Jan 07, 2011 at 11:02:31PM +0000, Alasdair G Kergon wrote:
> On Tue, Dec 14, 2010 at 08:34:58PM -0500, Mike Snitzer wrote:
> > On Tue, Dec 14 2010 at  6:59pm -0500,
> > Mike Snitzer <snitzer@redhat.com> wrote:
> > > I'm concerned about switching to using the global system_wq and calling
> > > flush_scheduled_work() when resuming a DM table (calls a DM target's
> > > ->dtr() via dm_table_destroy in drivers/md/dm-ioctl.c:do_resume).
>  
> Absolutely.
> 
> I'm not taking patch 1 in its current form - it introduces a problem
> that was not present before.  Probably part of patch 4 needs moving
> into patch 1.

I can just combine 1 and 4 then or reorder them such that
flush_work_sync() conversion happens first and then the dedicated wq
is dropped.  Which one would you prefer?

Thanks.

-- 
tejun
