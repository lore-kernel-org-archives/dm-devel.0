From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH 1/3] dm: a basic support for using the	select
	or poll function
Date: Thu, 11 May 2017 21:21:04 +0100
Message-ID: <20170511202103.GG6155@agk-dp.fab.redhat.com>
References: <20170509191028.6898-1-agrover@redhat.com>
	<20170509191028.6898-2-agrover@redhat.com>
	<1494495579.6093.10.camel@suse.com>
	<1494495801.6093.12.camel@suse.com>
	<20170511132134.GA10709@redhat.com>
	<01517603-ba44-bc02-8b70-96feef8050ed@redhat.com>
	<1494532154.6093.30.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1494532154.6093.30.camel@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Wilck <mwilck@suse.com>
Cc: dm-devel@redhat.com, Andy Grover <agrover@redhat.com>, mpatocka@redhat.com, snitzer@redhat.com
List-Id: dm-devel.ids

On Thu, May 11, 2017 at 09:49:14PM +0200, Martin Wilck wrote:
> Here is an idea: the best way to avoid the race mentioned by Mike might
> be to set priv->global_event_nr to the highest event nr reported by the
> DM_LIST_DEVICES ioctl when this ioctl returns. DM_LIST_DEVICES would
> then represent your "separate action", which would fit quite well, and
> the DM_DEV_ARM_POLL ioctl wouldn't be needed. It would be guaranteed
> that if any event had occured after the previous DM_LIST_DEVICES,
> whether or not that had been before or after the poll() call, userspace
> would notice.
 
It's not really good practice to overload operations by adding and
relying upon side-effects.  Yes, you could add a flag to control the
side-effect, but a separate ioctl seems to be a perfectly reasonable
approach in the present case, allowing for flexible use and not forcing
you to generate the list when you don't need it.  We've already got
examples of both other approaches - DM_DEV_WAIT_CMD taking the last
known event_nr as input, and @stats_print_clear reporting and resetting
counters in the same operation.

Alasdair
