From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH 1/3] dm: a basic support for using the select
 or poll function
Date: Fri, 12 May 2017 11:52:09 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1705121148250.20442@file01.intranet.prod.int.rdu2.redhat.com>
References: <20170509191028.6898-1-agrover@redhat.com>
	<20170509191028.6898-2-agrover@redhat.com>
	<1494495579.6093.10.camel@suse.com>
	<1494495801.6093.12.camel@suse.com>
	<20170511132134.GA10709@redhat.com>
	<1494531043.6093.27.camel@suse.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="185206533-119495577-1494604329=:20442"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1494531043.6093.27.camel@suse.com>
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
Cc: dm-devel@redhat.com, Andy Grover <agrover@redhat.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--185206533-119495577-1494604329=:20442
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT



On Thu, 11 May 2017, Martin Wilck wrote:

> On Thu, 2017-05-11 at 09:21 -0400, Mike Snitzer wrote:
> > On Thu, May 11 2017 at  5:43am -0400,
> > Martin Wilck <mwilck@suse.com> wrote:
> > 
> > > On Thu, 2017-05-11 at 11:39 +0200, Martin Wilck wrote:
> > > > On Tue, 2017-05-09 at 12:10 -0700, Andy Grover wrote:
> > > > > From: Mikulas Patocka <mpatocka@redhat.com>
> > > > >  
> > > > > This is the very simple patch for polling on the
> > > > > /dev/mapper/control
> > > > > device. The select or poll function waits until any event
> > > > > happens
> > > > > on
> > > > > any
> > > > > dm device since opening the /dev/mapper/control device. When
> > > > > select
> > > > > or
> > > > > poll returns the device as readable, we must close and reopen
> > > > > the
> > > > > device
> > > > > to wait for new dm events.
> > > > 
> > > > Why have you done it that way? Couldn't you just save the
> > > > dm_global_event_nr at the time poll() is called?
> > > 
> > > I should have read your patch 2/3 before posting ... but I'm still
> > > missing why the counter can't simply be set at poll() time.
> > 
> > If you did that then you would have a race where:
> > 
> > 1) userspace has recorded events prior to poll()
> > 2) an event triggers an increment of dm_global_event_nr before
> > userspace
> > calls poll()
> > 3) then userspace calls poll() -- only to find that after poll()
> > returns
> > multiple events have occurred.
> > 
> > Which implies missed handling of events.
> 
> I see - but I don't see yet how the ioctl approach (or the
> close()/open() based one, for that matter) would avoid this race.
> 
>  1) application processes event N
>  2) event N+1 arrives in the kernel
>  3) user space issues ioctl or close()/open() sequence, N+1 is recorded
>     in priv->global_event_nr
>  4) user space runs poll()
>  5) event N+2 arrives 4 weeks later and poll returns
> 
> ... meaning that event N+1 has been left unprocessed for 4 weeks.
> Or what I am missing?

The proper sequence is:
1) open /dev/mapper/control
2) check if the event we are waiting for already happened
3) call poll()

- if you call poll immediatelly after opening, it is incorrect use and 
there is a possibility for a race condition.

> > > > Why have you done it that way? Couldn't you just save the
> > > > dm_global_event_nr at the time poll() is called?

- if we did it this way, the race condition would be unavoidable.

Mikulas

> AFAICS, the only way for user space to make sure it misses no events
> would be passing the number of the last processed event down the kernel
> in the ioctl call (and the kernel would use that value, rather than its
> internal counter, for initializing priv->global_event_nr).
> 
> Regards
> Martin
> 
> 
> 
> > But if I'm wrong I'm sure Andy or Mikulas will correct me.
> > 
> > Thanks,
> > Mike
> > 
> 
> -- 
> Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
> SUSE Linux GmbH, GF: Felix Imendörffer, Jane Smithard, Graham Norton
> HRB 21284 (AG Nürnberg)
> 
--185206533-119495577-1494604329=:20442
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--185206533-119495577-1494604329=:20442--
