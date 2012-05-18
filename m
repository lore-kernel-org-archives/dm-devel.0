From: Alan Cox <alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>
Subject: Re: [Bcache v13 07/16] Closures
Date: Fri, 18 May 2012 11:02:47 +0100
Message-ID: <20120518110247.08696cec@pyramind.ukuu.org.uk>
References: <cover.1336619038.git.koverstreet@google.com>
	<82f00ebb4ee0404788c5bd7fbfa1fe4969f28ba1.1336619038.git.koverstreet@google.com>
	<20120515224137.GA15386@google.com>
	<20120518062948.GA21163@dhcp-172-18-216-138.mtv.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120518062948.GA21163-RcKxWJ4Cfj3IzGYXcIpNmNLIRw13R84JkQQo+JxHRPFibQn6LdNjmg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: dm-devel.ids

> Well, I can definitely understand your reservations about the code; it's
> strange and foreign and complicated. But having beaten my head against
> the various problems and difficulties inherent in asynchronous
> programming for years - well, having found a way to make it sane to me
> it'd be madness to go back.

I think its more of a different paradigm than complicated. The big
question I'd have to ask is how does it fit with hard real time. That is
a big issue given the gradual merging and getting of "hard" real time
into the kernel proper.

In some ways it's not that strange either. A look at what happens on some
of our kref handling in drivers is very similar but hardcoded.

Is the handling of priority inversion within closures a well understood
and solved problem ?

Alan
