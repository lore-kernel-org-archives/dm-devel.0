From: "Bruen, Mark" <mbruen@trilegiant.com>
Subject: Re: /dev/dm-N and Veritas?
Date: Tue, 01 Nov 2005 14:04:37 -0500
Message-ID: <4367BC45.7080706@trilegiant.com>
References: <4366702B.1010206@trilegiant.com>
	<1130794019.4041.16.camel@brilong-lnx>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1130794019.4041.16.camel@brilong-lnx>
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

Brian,
    We have a substantial investment in Veritas as well as people who 
know Veritas and multiple platforms to support which all run Veritas. 
There are three reasons driving my device mapper analysis: 1). We've had 
major problems with DMP on EMC Clariion arrays with Linux running 
Veritas Storage Foundation for Oracle Real Application Clusters, I still 
do not have resolution from Symantec (formally Veritas). 2). We use 3PAR 
storage and they say they will not support DMP on RHEL4 but will only be 
supporting DM.  3). I would really like to remove the storage vendor 
dependency on the Array Support Library (ASL) which is required by most 
storage vendors to use DMP. With DM the storage need only to provide the 
LU(s) on multiple paths with the same SCSI serial number. It also allows 
you to have persistent device names when adding or removing LUs and 
rebooting. At some point we may be looking at LVM but not until it can 
perform such functions as point in time snap shots which can be deported 
and then mounted on another host for database replication and other 
functions that we use it for. For consistency which is key to reducing 
labor costs it would also need to run on Solaris,  HPUX and Windows. I'm 
still trying to find a way to use /dev/mapper/<name> devices with Veritas.
Thanks.
    -Mark

Brian Long wrote:

>On Mon, 2005-10-31 at 14:27 -0500, Bruen, Mark wrote:
>  
>
>>Anyone using Veritas to manage their /dev/dm-N devices?
>>    
>>
>
>Mark,
>
>There is no point in using device-mapper multipathing since Veritas has
>their own multi-pathing software built-in.  What would be the point?
>Veritas won't support you unless you use DMP (Dynamic Multi Pathing).
>
>If you're going the Veritas route instead of using LVM2, you should use
>their stuff solely.
>
>We did an in-house Veritas vs. LVM2 show-down on Linux and LVM2 provides
>enough functionality for our needs.  It doesn't provide functionality
>for some of our "wants", but we've decided to go with LVM2 as we deploy
>RHEL 4.
>
>/Brian/
>
>  
>
