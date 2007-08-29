From: Tore Anderson <tore@linpro.no>
Subject: Re: dm-rdac not working?
Date: Wed, 29 Aug 2007 09:10:03 +0200
Message-ID: <46D51BCB.6070006@linpro.no>
References: <46D2E298.1020702@linpro.no>	
	<1188236026.9504.10.camel@linuxchandra>
	<46D3188A.3090405@linpro.no>	
	<1188245328.9504.41.camel@linuxchandra>
	<46D33BAA.8090807@linpro.no>	
	<1188249965.9504.45.camel@linuxchandra>
	<46D3C099.7080504@linpro.no>
	<1188326877.12737.1.camel@linuxchandra>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1188326877.12737.1.camel@linuxchandra>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: sekharan@us.ibm.com
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

* Chandra Seetharaman

> Do you see multiple failures like shown below during the device probe
> time ?

  Yes, on all paths to the passive controller I get numerous I/O errors,
 which happens when the kernel attempts to read in the partition table,
 when LVM wants to look for PV signatures, and so on.  This is the
 behaviour I expect when using RDAC mode.

> Hmm. In my storage it is enabled. That is why I do not see that issue.
> May be multipath tools should read and ignore the stderr.

  If AVT is enabled in your storage, you shouldn't need the RDAC
 hardware handler.  When dm-multipath switches pg and starts sending I/O
 to the passive paths they should go live automatically, at least they
 do so for me...

  Bad thing about AVT is of course that when node X in a cluster boots,
 the partition table scanning will transfer the volume, making the
 active controller that e.g. nodes Y and Z was using heavily go passive,
 disrupting I/O and making everything wobbly until node X has finished
 its bootup procedure.

Regards
-- 
Tore Anderson
