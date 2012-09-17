From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH v2] dm table: do not allow queue limits
	that	will exceed hardware limits
Date: Mon, 17 Sep 2012 21:24:04 +0100
Message-ID: <20120917202404.GF16447@agk-dp.fab.redhat.com>
References: <20120831150428.GA31566@fury.redhat.com>
	<20120904145843.GA19388@redhat.com>
	<20120912193706.GA17101@redhat.com>
	<20120914204133.GA376@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20120914204133.GA376@redhat.com>
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
Cc: David Jeffery <djeffery@redhat.com>
List-Id: dm-devel.ids

On Fri, Sep 14, 2012 at 04:41:33PM -0400, Mike Snitzer wrote:
> Add a safety net that will establish safe default limits, via
> blk_set_default_limits, in the event that a table temporarily doesn't
> have any component devices.  

Under what circumstances is this a problem?

1) When a table part-way down a stack of devices is reloaded while bios
are already flowing through the upper parts.
- A general problem we're ignoring.

2) When queue_if_no_path is set, i/o is queued, a table is reloaded
with more restrictive limits than the i/o already in the system (that
gets pushed back).

  a) There was not previously a table.
     => Use this patch to fix a better default limit?
        - Needs an explanation why the limit is set in dm rather than block.

  b) There was previously a table.
     => Retain the limits from that previous table as a better estimate
        of what the limits might need to be, on the basis that disappeared
        paths might reappear later.
        - Needs a patch writing to do this.
        - Does userspace need an option to reset this?
          - Does it only apply if there is pushback?
	  - Does it apply in general to all target types if and only if there
            is pushback?
          - Or does it need a userspace flag to control whether or not it happens?

  If queue_if_no_path is NOT set, there is no problem so neither case applies?

Alasdair
