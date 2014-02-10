From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 4/7] dm mpath: remove process_queued_ios()
Date: Mon, 10 Feb 2014 08:30:47 -0500
Message-ID: <20140210133046.GA19209@redhat.com>
References: <1391511280-29325-1-git-send-email-hare@suse.de>
	<1391511280-29325-5-git-send-email-hare@suse.de>
	<11AF7C027C4C02408624617A498607840105F76A@BPXM12GP.gisp.nec.co.jp>
	<52F0CF91.60302@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <52F0CF91.60302@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: Junichi Nomura <j-nomura@ce.jp.nec.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Tue, Feb 04 2014 at  6:31am -0500,
Hannes Reinecke <hare@suse.de> wrote:

> On 02/04/2014 12:26 PM, Junichi Nomura wrote:
> > On 02/04/14 19:54, Hannes Reinecke wrote:
> >> We only need to take care to add a small delay when calling
> >> __pg_init_all_paths() to move processing off to a workqueue; otherwise
> >> pg_init_done() might end up calling scsi_dh_activate() directly, which
> >> might use non-atomic memory allocations or issue I/O.
> > 
> > Hi Hannes,
> > 
> > could you tell me how "might end up calling scsi_dh_active()" happens?
> > 
> >   queue_delayed_work()
> >     queue_delayed_work_on()
> >       __queue_delayed_work()
> >         if (!delay)
> >           __queue_work()
> >             get_work_pool()
> >             insert_work()
> >               set_work_pwq()
> >               get_pwq()
> >               if (__need_more_worker())
> >                 wake_up_worker()
> > 
> > queue_work() doesn't execute the work itself.
> > 
> > What am I missing?
> > 
> As mentioned, I stumbled across the same issue when developing the
> asynchronous SCSI aborts. I'll see to have it recreated with this
> patchset.

Just to verify, this seems to be the only outstanding question for this
patchset?

What value are you using for HZ?  If this portion of the change does
turn out to be meaningul: Rather than tieing to HZ should we just use an
explicitly non-zero value for __pg_init_all_paths()'s @min_delay?
