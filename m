From: Neil Brown <neilb@suse.de>
Subject: Re: Re: [PATCH] Implement barrier support for single
	device DM devices
Date: Thu, 21 Feb 2008 14:29:19 +1100
Message-ID: <18364.61455.517441.304953@notabene.brown>
References: <20080215120821.GA8267@basil.nowhere.org>
	<20080215122002.GM29914@agk.fab.redhat.com>
	<47B58EAA.8040405@msgid.tls.msk.ru>
	<20080215142010.GA29552@one.firstfloor.org>
	<20080215141229.GB1788@agk.fab.redhat.com>
	<47B97E87.6040209@emc.com> <47B9870B.8060005@msgid.tls.msk.ru>
	<20080218221644.GN155407@sgi.com> <20080219071948.GA244758@sgi.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: message from Jeremy Higdon on Monday February 18
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
Cc: Michael Tokarev <mjt@tls.msk.ru>, David Chinner <dgc@sgi.com>, Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Monday February 18, jeremy@sgi.com wrote:
> 
> 
> I'll put it even more strongly.  My experience is that disabling write
> cache plus disabling barriers is often much faster than enabling both
> barriers and write cache enabled, when doing metadata intensive
> operations, as long as you have a drive that is good at CTQ/NCQ.

Doesn't this speed gain come at a correctness cost?  Barriers aren't
only about flushed the write cache.  They are also about preventing
re-ordering, both at the "elevator" layer and inside the device.
If the device does CTQ, it could re-order requests could it not?
Then two writes sent from the fs could make it to media in the wrong
order, and a power failure in between could corrupt your data.

Or am I misunderstanding something ??

(of course this only applies to XFS where disabling barriers means
"hope for the best", as opposed to ext3 where disabling barriers means
"don't trust the device, impose explicit ordering").

NeilBrown
