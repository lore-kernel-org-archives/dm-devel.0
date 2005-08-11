From: Andy <genanr@emsphone.com>
Subject: Re: multipath-tools-0.4.4 on 3par unknown path failure
	issue
Date: Thu, 11 Aug 2005 14:55:40 -0500
Message-ID: <20050811195540.GA16665@thumper2>
References: <42FA7674.4070201@mail.communityconnect.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <42FA7674.4070201@mail.communityconnect.com>
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
List-Id: dm-devel.ids

On Wed, Aug 10, 2005 at 05:49:40PM -0400, Alan Kasindorf wrote:
> Hey,
> 
> 
> At some random point in time today, one of the machines lost one of its 
> four 3par mounts. All other mounts worked fine. This has happened once 
> or twice before as well, but we rebooted before I had time to inspect 
> the issue.
> 
> Is this known at all? Is there anything else I can provide so that we 
> can figure out why this happened? I had been running multipath tools for 
> two months on a test box and never encounterred this problem. It's only 
> snuck up as we've started deploying it on more machines for 
>
I've had problems like this happen to me on 3par too.  What kernel version
are you using?  It almost always happened when the SAN got a RSCN (using
when another server was rebooted) I found that, at least in kernel 2.6.11.7,
that if I changed the line

bio->bi_rw != (1 << BIO_RW_FAILFAST); to
bio->bi_rw != (0 << BIO_RW_FAILFAST); 

in drivers/md/dm_mpath.c

the problem went away.  Now, in the newest kernels, after there was a big
change to the qla drivers (2.6.12-rc? and beyond, I believe) I did not need
to do the above change, but I now get aborts sometimes (these aborts
apparently come from the qlogic card).  The aborts recover, but I have been
unable to determine why I am getting them.

Andy
