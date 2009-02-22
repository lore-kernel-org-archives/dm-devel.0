From: Michael Keller <MKELLER@il.ibm.com>
Subject: Re: Device-mapper for write monitoring
Date: Sun, 22 Feb 2009 15:28:14 +0200
Message-ID: <OF5493481C.49A47F3B-ONC2257565.00492A79-C2257565.0049FF48@il.ibm.com>
References: <OF2FA15171.EBB61656-ONC2257562.00256C52-C2257562.002C88F5@il.ibm.com>
	<20090219144918.GC3962@agk.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090219144918.GC3962@agk.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

dm-devel-bounces@redhat.com wrote on 19/02/2009 16:49:18:
> Re: [dm-devel] Device-mapper for write monitoring
> Alasdair G Kergon
> to:
> device-mapper development
> 19/02/2009 16:50
> Cc:
> Mikulas Patocka
>
> On Thu, Feb 19, 2009 at 10:06:26AM +0200, Michael Keller wrote:
> > For our block-based incremental backup software we need to monitor all
> > writes to a device, and report them to our user mode application for
> > further processing.
>
> Sounds like a variant of dm snapshot code.
> What precisely do you need?
> Notification of every block every time it is changed?
> Or just a list of all the blocks that changed within a defined period
(i.e.
> since the last backup)?

Our application is historically designed such that the bitmap is kept in
(and accessed only by) user mode.

If there is any general behavior in this (which would be worth including
into dm...) it would be a kind of "user-intercept": let a user application
register with the device, and get signaled (complete a pending read) for
each write (or read) to the device. The user then decides what to do about
it, and informs the kernel (e.g., filter, proceed, read-before-write, ...)

> > 3. Are the interfaces of the device mapper relatively stable? (Assume
that
> > our target is not general enough to be included into mainline, and
we'll
> > have to do the API chasing ourselves.)
>
> If integrated nicely into dm, it'll go upstream.

I'd wish. But as I said, I find it hard to see anything general in what
we're doing. If you have ideas, let me know!

Thanks,
Michael

>
> Alasdair
> --
> agk@redhat.com
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
