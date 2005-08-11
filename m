From: Alan Kasindorf <akasindorf@mail.communityconnect.com>
Subject: Re: multipath-tools-0.4.4 on 3par unknown path failure
	issue
Date: Thu, 11 Aug 2005 16:19:24 -0400
Message-ID: <42FBB2CC.2040508@mail.communityconnect.com>
References: <42FA7674.4070201@mail.communityconnect.com>
	<20050811195540.GA16665@thumper2>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20050811195540.GA16665@thumper2>
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


> I've had problems like this happen to me on 3par too.  What kernel version
> are you using?  It almost always happened when the SAN got a RSCN (using
> when another server was rebooted) I found that, at least in kernel 2.6.11.7,
> that if I changed the line
> 
> bio->bi_rw != (1 << BIO_RW_FAILFAST); to
> bio->bi_rw != (0 << BIO_RW_FAILFAST); 
> 
> in drivers/md/dm_mpath.c
> 
> the problem went away.  Now, in the newest kernels, after there was a big
> change to the qla drivers (2.6.12-rc? and beyond, I believe) I did not need
> to do the above change, but I now get aborts sometimes (these aborts
> apparently come from the qlogic card).  The aborts recover, but I have been
> unable to determine why I am getting them.
> 
> Andy

We're running 2.6.9-11.ELsmp, off of redhat ES 4.1. I don't exactly have 
the entire list of redhat patches on hand, so I can't say for sure. Nor 
can I actually modify our kernel without losing support to the box. If 
this is fixed with a kernel upgrade, we can open a support ticket from 
redhat and scream/yell until they apply the patch.

However, I'd like to know what the exact issue is. I'm not exactly great 
on eliciting issues with the linux kernel right now. How were you 
monitoring what events the SAN was sending up through the card? I could 
use this to at least verify what is happening if/when we lose another 
mount. None of our servers were being rebooted when this happened though.

-Alan
