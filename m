From: John Ruemker <jruemker@redhat.com>
Subject: Re: multipath failover & rhcs
Date: Mon, 25 Apr 2011 13:29:21 -0400
Message-ID: <4DB5AF71.6060808@redhat.com>
References: <4DB5A901.9040102@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4DB5A901.9040102@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Dave Sullivan <dsulliva@redhat.com>
Cc: lvm-team@redhat.com, dm-devel@redhat.com, Lon Hohberger <lhh@redhat.com>
List-Id: dm-devel.ids

On 04/25/2011 01:01 PM, Dave Sullivan wrote:
> Hi Guys,
>
> It seems recently that we have just run into this problem where we 
> don't fully understand the timeouts that drive multipath fail-over.
>
> We did thorough testing of pulling fibre/failing hbas manualling and 
> multipath handled things perfectly.
>
> Recently we enountered SCSI Block errors, where the multipath 
> fail-over did not occur before the qdisk timeout.
>
> This was attributed to the scsi block errors and the scsi lun timeout 
> of 60 seconds which is set by default.
>
> I added a comment to the first link below that discusses a situation 
> that would cause this to occur.  We think that this was due to a 
> defective HBA under high I/O load.
>
> Once we get the HBA in question we will run some tests to validate 
> that modifying the scsi block timeouts in fact allows multipath to 
> fail-over in time to beat the qdisk timeout.
>
> I'm getting ready to to take a look at the code to see if I can 
> validate these theories.  The area that is still somewhat gray is the 
> true definition for multipath timings for failover.
>
> I don't think there is a true definition of a multipath timeout, per 
> see.  I see it as the following:
>
> multipath check   = every 20 seconds for no failed paths
> multipath check (if failed paths)  = every 5 seconds on failed paths only
>
> multipath failover occurs  =  driver timeout attribute met ( Emulex 
> lpfc_devloss_tmo value)
>       --capture pulling fibre
>       --capture disabling hba
>
> or (for other types of failures)
>
> multipath failover occurs =scsi block timeout + driver timeout (not 
> sure if the driver timeout attribute is a added)
>
> https://access.redhat.com/kb/docs/DOC-2881
> https://docspace.corp.redhat.com/docs/DOC-32822
>
> Hmm, just found out that there was new fix in rhel5u5 for this it 
> looks like from this case in salesforce 00085953.
>
> -Dave
>

Hi Dave,
These are issues we have recently been working to resolve with this and 
other qdisk articles.  The problem is as you described it: we don't have 
an accurate definition of how long it will take multipath to fail a path 
in all scenarios.  The formula used in the article is basically wrong, 
and we're working to fix it, but coming up with a formula for a path 
timeout has been difficult.  This calculation should not be based on 
no_path_retry at all, as we are really only concerned in the amount of 
time it takes for the scsi layer to return an error, allowing qdisk's 
I/O operation to be sent down an alternate path.

Regarding the formula you posted:

 >> multipath check   = every 20 seconds for no failed paths
 >> multipath check (if failed paths)  = every 5 seconds on failed paths 
only

Just to clarify, the polling interval doubles after each successful path 
check, up to 4 times the original.  So you're correct, that for a 
healthy path you should see it checking every 20s after the first few 
checks.  Likewise, your second statement is also accurate in that after 
a failed check, it drops back to the configured polling interval until 
the path returns to active status.

Regarding case 00085953, I was actually the owner of that one.  There 
was a change that went into 5.5 which lowered the default 
tur/readsector0 SCSI I/O timeout down from 300 to the checker_timeout 
value (which defaults to the timeout value in 
/sys/block/sdX/device/timeout).

I am very interested in any information you come up with on the 
calculation of how long a path failure will take.  We will integrate 
that into this article if you can come up with anything.

Let me know if you have any questions.

-- 
John Ruemker, RHCA
Technical Account Manager
Global Support Services
Red Hat, Inc.
Office: 919-754-4941
Cell: 919-793-8549
