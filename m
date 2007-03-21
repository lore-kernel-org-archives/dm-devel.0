From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH 0/3] Fix SMP races in dm-crypt
Date: Wed, 21 Mar 2007 10:03:12 +0000
Message-ID: <20070321100312.GF27600@agk.surrey.redhat.com>
References: <200703210806.30499.okir@lst.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <200703210806.30499.okir@lst.de>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Olaf Kirch <okir@lst.de>
Cc: dm-devel@redhat.com, Andrew Morton <akpm@linux-foundation.org>
List-Id: dm-devel.ids

On Wed, Mar 21, 2007 at 08:06:29AM +0100, Olaf Kirch wrote:
> (I'm resending this, because it seems mailman ate this posting
> the first time around - apologies if you're seeing this twice).
 
The first emails got trapped for moderation.

The 3rd patch was hit by line-wrap and needed fixing up.

> I investigated kernel Bug 5948 (Oops when accessing SATA with device mapper on
> AMD 64 X2) to help cut down on the number of open bugs.
 
Thanks for your detective work on this!  The patches look good and I've
added them to
  http://www.kernel.org/pub/linux/kernel/people/agk/patches/2.6/editing/
(with prefix dm-crypt-fix) and will review them in full in the next
couple of days.

Alasdair
-- 
agk@redhat.com
