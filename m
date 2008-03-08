From: Daniel Phillips <phillips@phunq.net>
Subject: Re: [RFC] An alternative interface to device mapper
Date: Sat, 8 Mar 2008 04:06:15 -0800
Message-ID: <200803080406.16305.phillips@phunq.net>
References: <200803050129.43172.phillips@phunq.net> <20080308113803.GB4016@ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754935AbYCHMG3@vger.kernel.org>
In-Reply-To: <20080308113803.GB4016@ucw.cz>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

Hi Pavel,

On Saturday 08 March 2008 03:38, Pavel Machek wrote:
> > Unlike a pipe, there is no waiting for input on a ddlink: if there is 
> > nothing to read then the read returns immediately with zero length.  If 
> > some other behavior is desired it can be obtained using poll.
> 
> That's kind of strange, no?

It doesn't feel strange in practice.  The ddlink framework itself does
not implement this, the module does (e.g. ddsetup).  So you can put a
poll wait in your read method if that suits your interface.  It just
does not seem to be useful for ddsetup, which does not produce any
data of the kind that needs an application to sit in a loop waiting for
something to arrive.  If there is an application like that, it would
probably want to poll the ddlink anyway, to avoid having a whole thread
dedicated to just that.

Maybe the reason it does not feel strange to omit the wait is, reading
from proc never waits.  A ddlink fd is more like proc than like a pipe.
It was Trond who started called his thing a "pipefs", blame him ;-)
 
> Should not description of interface go to Doc* somewhere?

Yes, will fix.

Daniel
