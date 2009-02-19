From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: Device-mapper for write monitoring
Date: Thu, 19 Feb 2009 14:49:18 +0000
Message-ID: <20090219144918.GC3962@agk.fab.redhat.com>
References: <OF2FA15171.EBB61656-ONC2257562.00256C52-C2257562.002C88F5@il.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <OF2FA15171.EBB61656-ONC2257562.00256C52-C2257562.002C88F5@il.ibm.com>
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
Cc: Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

On Thu, Feb 19, 2009 at 10:06:26AM +0200, Michael Keller wrote:
> For our block-based incremental backup software we need to monitor all
> writes to a device, and report them to our user mode application for
> further processing. 

Sounds like a variant of dm snapshot code.
What precisely do you need?
Notification of every block every time it is changed?
Or just a list of all the blocks that changed within a defined period (i.e.
since the last backup)?

> 3. Are the interfaces of the device mapper relatively stable? (Assume that
> our target is not general enough to be included into mainline, and we'll
> have to do the API chasing ourselves.)

If integrated nicely into dm, it'll go upstream.
 
Alasdair
-- 
agk@redhat.com
