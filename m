From: David Brownell <david-b-yBeKhBN/0LDR7s880joybQ@public.gmane.org>
Subject: Re: PROBLEM: powertop reports 8000 spurious interrupts/s from USB disk
Date: Tue, 6 May 2008 11:19:19 -0700
Message-ID: <200805061119.20495.david-b@pacbell.net>
References: <Pine.LNX.4.44L0.0805051030080.2435-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Pine.LNX.4.44L0.0805051030080.2435-100000-IYeN2dnnYyZXsRXLowluHWD2FQJk+8+b@public.gmane.org>
Content-Disposition: inline
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>, Marti Raudsepp <marti-HlJQ7cSfIDjYtjvyW6yDsg@public.gmane.org>
Cc: Matthew Dharm <mdharm-usb-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org>, Linux USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux USB storage list <usb-storage-ijkIwGHArpdIPJnuZ7Njw4oP9KaGy4wf@public.gmane.org>, device-mapper list <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: dm-devel.ids

I've never observed such absurd IRQ rates myself.

Now, "8000" is an interesting number since there are 1000 USB frames
per second, and 8 microframes per frame ... so you might be able to
make this better by "modprobe ehci-hcd log2_irq_thresh=3D3" to change
the IRQ latency from 1 microframe to 8.


On Monday 05 May 2008, Alan Stern wrote:
> One thing you can do is to mount a debugfs filesystem, and under it g=
o
> to the EHCI directory corresponding to the controller your drive is=20
> plugged into. =A0The contents of the "registers" and "async" files wo=
uld=20
> be interesting -- particularly if you get them while the disk is idle=
=2E
>=20
> You might even try looking at "registers" several times in a row, sin=
ce=20
> its contents may change over time.

Exactly.
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
