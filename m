From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 1/3] Send KOBJ_ADD event after dm resume
	ioctl.
Date: Fri, 19 Mar 2010 11:55:42 -0400
Message-ID: <20100319155541.GA24051@redhat.com>
References: <1268920694-10960-1-git-send-email-mbroz@redhat.com>
	<ac3eb2511003180913t5f69e0bs29ff3dcfd1209c60@mail.gmail.com>
	<4BA29CA4.9070000@redhat.com>
	<ac3eb2511003190127n1aa2dda5pbd4e0841a46830bc@mail.gmail.com>
	<20100319090656.GR6379@soda.linbit>
	<ac3eb2511003190224u1eb19e4lfeda36bbab18939@mail.gmail.com>
	<4BA37B06.1040107@redhat.com>
	<ac3eb2511003190643u32a8e702l4e7774e7ec924a12@mail.gmail.com>
	<7b13a0f81003190658i78664328ocb94aa0048054a17@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <7b13a0f81003190658i78664328ocb94aa0048054a17@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

Hi David,

On Fri, Mar 19 2010 at  9:58am -0400,
David Zeuthen <zeuthen@gmail.com> wrote:

> Hey Kay,
> 
> On Fri, Mar 19, 2010 at 9:43 AM, Kay Sievers <kay.sievers@vrfy.org> wrote:
> 
> > On Fri, Mar 19, 2010 at 14:24, Peter Rajnoha <prajnoha@redhat.com> wrote:
> > > On 03/19/2010 10:24 AM, Kay Sievers wrote:
> > >> No, that's what "change" is for, and we already have these "change"
> > >> events for dm. Udev does not care if the device is ready or not, it
> > >> synchronizes /sys and /dev, and that works just fine with "change"
> > >> events.
> > >
> > > CHANGE events, not quite... We can't even rely on these.
> > >
> > > Just to mention, there's also a CHANGE event generated when
> > > read-only flag is set for a device (this is not managed by
> > > device-mapper of course). This one is generated even before
> > > the actual CHANGE event that is generated when DM device is
> > > ready to be used.
> >
> > Sure, but as mentioned earlier, these events are just expected to
> > fail, and update the current udev state, if they can't retrieve the
> > needed information or find out that the device in not usable.
> >
> 
> I think the problem is the that fact that 3rd party user space
> opens the device before it is ready (e.g. just after ADD but before
> the first CHANGE) makes things fall over.
> 
> This short-coming is what needs to get fixed, I think - it's very
> fragile this way and since any random user / package can add
> rules to open the device on add events, said user / package can
> make device-mapper fail. Which doesn't exactly strike me
> as robust behavior.

When I first read this response I thought we had a major break-through,
namely: udev allowing udev rules to race with the tool that is making
the device usable was not "robust behavior".

But your 2nd mail in this thread established that I had wishful thinking
on that so-called break-through.

At least we agree that these uevents are causing DM to race against
arbitrary udev rules; which leads to sporadic failures.

I think I understand udev's utopian intent to have all udev rules be
able to do as they wish with any device: said access should "fail
gracefully" on devices that aren't ready.

Thing is, this isn't scalable at all.  Having all these arbitrary rules
issuing IOs to devices that aren't usable is a complete waste of time.
On enterprise systems that have 100s (*shudder* 1000s) of LUNs, this
udev rules' freedom to access such unusable devices is really working
against us (if the goal is to activate devices as quickly and reliably
as possible).

We at least need a way to _reliably_ allow DM to do its work of managing
its devices.  What if udev were to offer a per device "udev rules lock"
(exposed via sysfs?) that allows subsystems (e.g. DM) to know they can't
yet proceed with exclussively accessing the device they are tasked with
managing?

This per device "udev rules lock" would at least allow DM to cope with
the racey nature of udev rules.  Not ideal as it still allows
inefficient (and unecessary) access to devices that shouldn't be touched
but it would at least be a means to an end (or so I'd think).

Mike
