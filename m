From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 1/3] dm: a basic support for using the select
 or poll function
Date: Thu, 11 May 2017 09:21:34 -0400
Message-ID: <20170511132134.GA10709@redhat.com>
References: <20170509191028.6898-1-agrover@redhat.com>
	<20170509191028.6898-2-agrover@redhat.com>
	<1494495579.6093.10.camel@suse.com>
	<1494495801.6093.12.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1494495801.6093.12.camel@suse.com>
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
Cc: dm-devel@redhat.com, Andy Grover <agrover@redhat.com>, mpatocka@redhat.com
List-Id: dm-devel.ids

On Thu, May 11 2017 at  5:43am -0400,
Martin Wilck <mwilck@suse.com> wrote:

> On Thu, 2017-05-11 at 11:39 +0200, Martin Wilck wrote:
> > On Tue, 2017-05-09 at 12:10 -0700, Andy Grover wrote:
> > > From: Mikulas Patocka <mpatocka@redhat.com>
> > > =A0
> > > This is the very simple patch for polling on the
> > > /dev/mapper/control
> > > device. The select or poll function waits until any event happens
> > > on
> > > any
> > > dm device since opening the /dev/mapper/control device. When select
> > > or
> > > poll returns the device as readable, we must close and reopen the
> > > device
> > > to wait for new dm events.
> > =

> > Why have you done it that way? Couldn't you just save the
> > dm_global_event_nr at the time poll() is called?
> =

> I should have read your patch 2/3 before posting ... but I'm still
> missing why the counter can't simply be set at poll() time.

If you did that then you would have a race where:

1) userspace has recorded events prior to poll()
2) an event triggers an increment of dm_global_event_nr before userspace
calls poll()
3) then userspace calls poll() -- only to find that after poll() returns
multiple events have occurred.

Which implies missed handling of events.

But if I'm wrong I'm sure Andy or Mikulas will correct me.

Thanks,
Mike
