From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: thinp zeroing
Date: Wed, 22 Feb 2012 21:49:18 -0500
Message-ID: <20120223024918.GA25353@redhat.com>
References: <20120222141442.GA28145@ubuntu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20120222141442.GA28145@ubuntu>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Joe Thornber <thornber@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Nice write-up.  It is concerning that we have to go to such lengths but
I don't see a way around it without limiting who can consume thinp.

On Wed, Feb 22 2012 at  9:14am -0500,
Joe Thornber <thornber@redhat.com> wrote:

> ** Discards
> 
>    DISCARDs *must* result in data being zeroed.  Some devices set the
>    discard_zeroes_data flag.  This is not good enough; you cannot use
>    this flag as a guarantee that the data no longer exists on the
>    disk.  So real zeroing must occur.  I suggest we write a separate
>    target that zeroes data just before discarding it, and stack it
>    under the thin-pool.  The performance impact of this will be
>    significant; to the point that we may wish to turn discard within
>    the fs off; instead doing periodic tidy-ups.

...

> ** Summary of work items [0/5]
> 
>    - [ ] Implement the discard-really-zeroes target [1 month]

I don't think it'll take a month.  Probably a focused week to 2 weeks.

I can develop this target before jumping in to the HSM target (unless
you'd rather I start in on HSM asap).
