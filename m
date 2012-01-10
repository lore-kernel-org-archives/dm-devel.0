From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: dm thin provision, pool full
Date: Tue, 10 Jan 2012 16:52:01 +0000
Message-ID: <20120110165201.GB4812@agk-dp.fab.redhat.com>
References: <4F0B7A10.9030508@acedatacenter.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4F0B7A10.9030508@acedatacenter.com>
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

On Mon, Jan 09, 2012 at 04:36:48PM -0700, Marcus Sorensen wrote:
> You guys probably already know about this, but I was playing with kernel  
> 3.2.0 and the device mapper thin provisioned snapshots, and it doesn't  
> seem like there is any sort of error implemented when the pool is full.  
> I was running some write tests, and one of them just seemed to go into  
> eternal D state. Checking iostat showed disks were idle. Running a  
> 'dmsetup status' returned the following:
>
> thin: 0 41943040 thin 39832576 41943039
> pool: 0 41943040 thin-pool 0 622/243968 81920/81920 -
>
> that 81920/81920 is reporting data blocks in use/total blocks, correct?

Yes.

(Documentation/device-mapper/thin-provisioning.txt in the kernel source.)

Firstly, if you have a well-managed system you will never run out of space.

You'll anticipate when space is getting short and take appropriate action to
avoid it ever becoming full.  That is the mode in which we expect this code to
be used.

To facilitate that, you specify a 'low water mark' and when the number of free
blocks drops below that threshold, a 'dm event' is triggered which userspace
can detect and react to.

The existing userspace daemon dmeventd is designed to take plugins to handle
these events.  The LVM2 support being developed includes a new plugin that will
automatically extend the volume:

    # 'thin_pool_autoextend_threshold' and 'thin_pool_autoextend_percent' define
    # how to handle automatic pool extension. The former defines when the
    # pool should be extended: when its space usage exceeds this many
    # percent. The latter defines how much extra space should be allocated for
    # the pool, in percent of its current size.
    #
    # For example, if you set thin_pool_autoextend_threshold to 70 and
    # thin_pool_autoextend_percent to 20, whenever a pool exceeds 70% usage,
    # it will be extended by another 20%. For a 1G pool, using up 700M will
    # trigger a resize to 1.2G. When the usage exceeds 840M, the pool will
    # be extended to 1.44G, and so on.
    #
    # Setting thin_pool_autoextend_threshold to 100 disables automatic
    # extensions. The minimum value is 50 (A setting below 50 will be treated
    # as 50).


So our view is that if you do run out of space, something has already
gone wrong.  We could start returning I/O with errors (like the existing
snapshot implementation does).  We could queue I/O until you sort out
the problem (like multipath's queue_if_no_path).  We could be cleverer,
making devices read-only and only rejecting writes.

For now, we picked the second option, queueing.  In future, we hope to
have some sort of read-only support and give the user a choice between
the alternatives.  But the best answer will remain for userspace
monitoring to take pre-emptive action to avoid ever reaching this
situation.

Alasdair
