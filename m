From: David Chinner <dgc@sgi.com>
Subject: Re: [dm-devel] Re: [PATCH] Implement barrier support for single device DM devices
Date: Tue, 19 Feb 2008 09:16:44 +1100
Message-ID: <20080218221644.GN155407@sgi.com>
References: <20080215120821.GA8267@basil.nowhere.org> <20080215122002.GM29914@agk.fab.redhat.com> <47B58EAA.8040405@msgid.tls.msk.ru> <20080215142010.GA29552@one.firstfloor.org> <20080215141229.GB1788@agk.fab.redhat.com> <47B97E87.6040209@emc.com> <47B9870B.8060005@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1761836AbYBRWRT@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <47B9870B.8060005@msgid.tls.msk.ru>
Sender: linux-kernel-owner@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Ric Wheeler <ric@emc.com>, device-mapper development <dm-devel@redhat.com>, Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Mon, Feb 18, 2008 at 04:24:27PM +0300, Michael Tokarev wrote:
> First, I still don't understand why in God's sake barriers are "working"
> while regular cache flushes are not.  Almost no consumer-grade hard drive
> supports write barriers, but they all support regular cache flushes, and
> the latter should be enough (while not the most speed-optimal) to ensure
> data safety.  Why to require write cache disable (like in XFS FAQ) instead
> of going the flush-cache-when-appropriate (as opposed to write-barrier-
> when-appropriate) way?

Devil's advocate:

Why should we need to support multiple different block layer APIs
to do the same thing? Surely any hardware that doesn't support barrier
operations can emulate them with cache flushes when they receive a
barrier I/O from the filesystem....

Also, given that disabling the write cache still allows CTQ/NCQ to
operate effectively and that in most cases WCD+CTQ is as fast as
WCE+barriers, the simplest thing to do is turn off volatile write
caches and not require any extra software kludges for safe
operation.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
