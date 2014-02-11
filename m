From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 4/7] dm mpath: remove process_queued_ios()
Date: Tue, 11 Feb 2014 11:29:18 -0500
Message-ID: <20140211162918.GC27812@redhat.com>
References: <1391511280-29325-1-git-send-email-hare@suse.de>
	<1391511280-29325-5-git-send-email-hare@suse.de>
	<11AF7C027C4C02408624617A498607840105F76A@BPXM12GP.gisp.nec.co.jp>
	<52F0CF91.60302@suse.de> <20140210133046.GA19209@redhat.com>
	<52F9F18A.9000309@suse.de> <20140211155552.GB27812@redhat.com>
	<52FA65E1.7070602@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <52FA65E1.7070602@suse.de>
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

On Tue, Feb 11 2014 at  1:03pm -0500,
Hannes Reinecke <hare@suse.de> wrote:

> On 02/11/2014 04:55 PM, Mike Snitzer wrote:
> >On Tue, Feb 11 2014 at  4:46am -0500,
> >Hannes Reinecke <hare@suse.de> wrote:
> >
> >>On 02/10/2014 02:30 PM, Mike Snitzer wrote:
> >>>
> >>>Just to verify, this seems to be the only outstanding question for this
> >>>patchset?
> >>>
> >>>What value are you using for HZ?  If this portion of the change does
> >>>turn out to be meaningul: Rather than tieing to HZ should we just use an
> >>>explicitly non-zero value for __pg_init_all_paths()'s @min_delay?
> >>>
> >>The actual amount here is irrelevant, as long as it's non-zero.
> >>It's just there to force execution of the work item off the current
> >>thread.
> >
> >I'm aware we just need a non-zero value.  My concern, as originally
> >raised by Junichi in an earlier reply when you had it as HZ/50, is that
> >the value could be 0 if HZ is really small.  While unlikely I see no
> >point allowing the variable nature of HZ compromise passing a non-zero
> >value here.  Best to just be explicit by passing 1 or something.
> >
> >All said, the question of why this is actually needed remains.  I trust
> >you're working on answering that via reproducer (by not forcing the use
> >of workqueue context)?
> >
> Precisely.
> 
> But as this is a bit hard to trigger it might take some time.
> (you'll only be hitting this issue if you have to retry
> scsi_dh_activate, so you'll need to trigger this somehow).

OK.

> I hope to get it done this week.
> Is there any deadline which I might miss with that?

No, that'll be great.  We have some time until the 3.15 merge window
opens.

Thanks,
Mike
