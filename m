From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: Re: [PATCH] Implement barrier support for single
	device DM devices
Date: Tue, 19 Feb 2008 02:56:43 +0000
Message-ID: <20080219025643.GD4066@agk.fab.redhat.com>
References: <20080215120821.GA8267@basil.nowhere.org>
	<20080215122002.GM29914@agk.fab.redhat.com>
	<47B58EAA.8040405@msgid.tls.msk.ru>
	<20080215142010.GA29552@one.firstfloor.org>
	<20080215141229.GB1788@agk.fab.redhat.com>
	<47B97E87.6040209@emc.com> <47B9870B.8060005@msgid.tls.msk.ru>
	<20080218221644.GN155407@sgi.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20080218221644.GN155407@sgi.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: David Chinner <dgc@sgi.com>
Cc: device-mapper development <dm-devel@redhat.com>, Andi Kleen <andi@firstfloor.org>, Michael Tokarev <mjt@tls.msk.ru>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Tue, Feb 19, 2008 at 09:16:44AM +1100, David Chinner wrote:
> Surely any hardware that doesn't support barrier
> operations can emulate them with cache flushes when they receive a
> barrier I/O from the filesystem....
 
My complaint about having to support them within dm when more than one
device is involved is because any efficiencies disappear: you can't send
further I/O to any one device until all the other devices have completed
their barrier (or else later I/O to that device could overtake the
barrier on another device).  And then I argue that it would be better
for the filesystem to have the information that these are not hardware
barriers so it has the opportunity of tuning its behaviour (e.g.
flushing less often because it's a more expensive operation).

Alasdair
-- 
agk@redhat.com
