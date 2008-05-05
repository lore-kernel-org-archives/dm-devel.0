From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Subject: Re: PROBLEM: powertop reports 8000 spurious interrupts/s from USB
 disk
Date: Mon, 5 May 2008 10:32:42 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0805051030080.2435-100000@iolanthe.rowland.org>
References: <54b33ccd0805042014j3773db72s3843c76f01fd0e54@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54b33ccd0805042014j3773db72s3843c76f01fd0e54-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Marti Raudsepp <marti-HlJQ7cSfIDjYtjvyW6yDsg@public.gmane.org>
Cc: Matthew Dharm <mdharm-usb-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org>, David Brownell <dbrownell-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, Linux USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux USB storage list <usb-storage-ijkIwGHArpdIPJnuZ7Njw4oP9KaGy4wf@public.gmane.org>, device-mapper list <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: dm-devel.ids

On Mon, 5 May 2008, Marti Raudsepp wrote:

> On Mon, May 5, 2008 at 3:13 AM, Matthew Dharm
> <mdharm-usb-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org> wrote:
> >  If there is no actual activity, then this is likely not a usb-storage
> >  problem.  It may very well be an HCD problem, however.
> >
> >  You may want to turn on CONFIG_USB_STORAGE_DEBUG and verify that there is,
> >  in fact, no activity to the drive during these events.
> 
> Indeed, I enabled USB_DEBUG and USB_STORAGE_DEBUG; there are no kernel
> messages at the time of the interrupt flood.
> 
> Any ideas how to proceed to get this problem resolved? I added David
> Brownell (the EHCI maintainer) to recipients.

One thing you can do is to mount a debugfs filesystem, and under it go
to the EHCI directory corresponding to the controller your drive is 
plugged into.  The contents of the "registers" and "async" files would 
be interesting -- particularly if you get them while the disk is idle.

You might even try looking at "registers" several times in a row, since 
its contents may change over time.

Alan Stern

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
