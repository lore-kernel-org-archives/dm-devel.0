From: Andy <genanr@emsphone.com>
Subject: Re: multipath-tools-0.4.4 on 3par unknown path failure
	issue
Date: Fri, 12 Aug 2005 11:04:07 -0500
Message-ID: <20050812160407.GA24832@thumper2>
References: <42FA7674.4070201@mail.communityconnect.com>
	<20050811195540.GA16665@thumper2>
	<42FBB2CC.2040508@mail.communityconnect.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <42FBB2CC.2040508@mail.communityconnect.com>
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

On Thu, Aug 11, 2005 at 04:19:24PM -0400, Alan Kasindorf wrote:
> 
> >I've had problems like this happen to me on 3par too.  What kernel version
> 
> However, I'd like to know what the exact issue is. I'm not exactly great 
> on eliciting issues with the linux kernel right now. How were you 
> monitoring what events the SAN was sending up through the card? I could 
> use this to at least verify what is happening if/when we lose another 
> mount. None of our servers were being rebooted when this happened though.
> 
My issue was that I was getting I/O errors when other systems were rebooted
(and occasionally other times, reboots consistently would cause a problem),
and those I/O errors would cause the mount to drop.  Somehow I got the idea
that turning off failfast might help and it did.  I have not monitored what
events the SAN was sending the card, all I did was turn on debugging in the
qla2xxx drivers and ask Andrew Vasquez (qlogic developer) about them.

Andy
