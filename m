From: "Philip R. Auld" <pauld@egenera.com>
Subject: Re: [RFC] 2 features for mptools 0.4.8
Date: Wed, 5 Apr 2006 09:19:05 -0400
Message-ID: <20060405131905.GM5783@vienna.egenera.com>
References: <4432F1B5.3080905@free.fr>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4432F1B5.3080905@free.fr>
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

Hi,

Rumor has it that on Wed, Apr 05, 2006 at 12:22:45AM +0200 Christophe Varoqui said:
> Hello,
> 
...

> 
> On a related note, is there still interest in a physical path-based 
> checking, rather than the current logical path-based one ?
> 
> The recent fc_host sysfs class normalisation brings a simple way to 
> identify physical local endpoint with FC transport :
> 

Is this FC transport specific or would it work for, say, iSCSI devices?


> local endpoint :     /sys/class/fc_host/host1/port_name
> remote endpoint : /sys/class/fc_transport/target1:0:2/port_name
> logical paths on this phy :
> 
> [root@s64p17bic44 ~]# file 
> /sys/class/fc_transport/target1\:0\:2/device/1\:0\:2\:*/block
> /sys/class/fc_transport/target1:0:2/device/1:0:2:0/block:   symbolic 
> link to `../../../../../../../../block/sdaa'
> /sys/class/fc_transport/target1:0:2/device/1:0:2:512/block: symbolic 
> link to `../../../../../../../../block/sdab'
> /sys/class/fc_transport/target1:0:2/device/1:0:2:513/block: symbolic 
> link to `../../../../../../../../block/sdac'
> /sys/class/fc_transport/target1:0:2/device/1:0:2:514/block: symbolic 
> link to `../../../../../../../../block/sdad'
> /sys/class/fc_transport/target1:0:2/device/1:0:2:515/block: symbolic 
> link to `../../../../../../../../block/sdae'
> /sys/class/fc_transport/target1:0:2/device/1:0:2:516/block: symbolic 
> link to `../../../../../../../../block/sdaf'
> /sys/class/fc_transport/target1:0:2/device/1:0:2:517/block: symbolic 
> link to `../../../../../../../../block/sdag'
> /sys/class/fc_transport/target1:0:2/device/1:0:2:518/block: symbolic 
> link to `../../../../../../../../block/sdah'
> 
> Implementing this idea would mean in this example that checker status 
> for sdaa applies to sda[bcdefgh].

Seems to me you may need a hybrid of both approaches. I agree that if 
the target (sdaa) fails it's pretty safe to assume the LUs behind it
are gone. But just because sdaa is back does not mean the LUs are
definitely reachable again. Until sdaa comes back though there is not
much point in checking for the LUs. 

It may also be useful to have it be a configuration option.

This and the fix for FASTFAIL will make the tools dependent on 
specific kernel revs. How well do they handle running on slightly 
older kernels?
 

Cheers,


Phil

> 
> Arguments in favor of this approach are :
> 
> 1) less checking work
> 2) lower failure-to-reaction latency : batched reactions upon phy path 
> failure.
> 3) lessen the checking time drift : setup interval is I, but the real 
> interval is "I+(checker loop time)"
> 4) each path check involves I/O, thus quite a high latency. Less checks 
> means higher efficiency.
> 
> I'm open for comments.
> 
> Regards,
> cvaroqui
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel

-- 
Philip R. Auld, Ph.D.  	        	       Egenera, Inc.    
Software Architect                            165 Forest St.
(508) 858-2628                            Marlboro, MA 01752
