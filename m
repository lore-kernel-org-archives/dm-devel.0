From: Joe Thornber <thornber@redhat.com>
Subject: Re: [PATCH] Add a set_era_counter config key to the
 dm-cache era policy shim
Date: Thu, 7 Nov 2013 15:51:23 +0000
Message-ID: <20131107155123.GA520@debian>
References: <33A0129EBFD46748804DE81B354CA1B21C028E44@SACEXCMBX06-PRD.hq.netapp.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <33A0129EBFD46748804DE81B354CA1B21C028E44@SACEXCMBX06-PRD.hq.netapp.com>
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

On Wed, Nov 06, 2013 at 08:59:38PM +0000, Mears, Morgan wrote:
> Add the ability to set the era counter maintained by the dm-cache era
> policy shim to an arbitrary 32-bit value, to allow era rollback after
> the underlying device is restored from a snapshot.

I wonder if we should pass in the old value, and have the call fail if
the old value is incorrect.  This would allow applications to spot if
they were competing to set the era.  Some thing like:

     set_era_counter <old value>:<new value>

> +	era->era_counter = new_era_counter;
> +	smp_wmb();

Please stop using smp_rmb() and smp_wmb().  Every time I see it used I
find bugs (and this is no exception).  Use higher level locking
abstractions (eg, spin locks), and only optimise if we have a
performance issue.

In general alarm bells ring if you use one of smp_*() without the
other.  See linux/Documentation/memory-barriers.txt for lots of
discussion.

- Joe
