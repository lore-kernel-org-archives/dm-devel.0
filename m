From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: [RFC] 2 features for mptools 0.4.8
Date: Wed, 05 Apr 2006 00:22:45 +0200
Message-ID: <4432F1B5.3080905@free.fr>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
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

Hello,

multipath-tools path checking framework has a well-known (nonetheless 
serious) design hole : a blocked check can hang the whole daemon.

Consensus was to export to userspace a sort of FAILFAST flag checkers 
could use.

I'm more than willing to get that problem straight in the tools, but 
what's the status on the kernel side of this work ?

We can also debate other ways to work-around this, if some emerge.


On a related note, is there still interest in a physical path-based 
checking, rather than the current logical path-based one ?

The recent fc_host sysfs class normalisation brings a simple way to 
identify physical local endpoint with FC transport :

local endpoint :     /sys/class/fc_host/host1/port_name
remote endpoint : /sys/class/fc_transport/target1:0:2/port_name
logical paths on this phy :

[root@s64p17bic44 ~]# file 
/sys/class/fc_transport/target1\:0\:2/device/1\:0\:2\:*/block
/sys/class/fc_transport/target1:0:2/device/1:0:2:0/block:   symbolic 
link to `../../../../../../../../block/sdaa'
/sys/class/fc_transport/target1:0:2/device/1:0:2:512/block: symbolic 
link to `../../../../../../../../block/sdab'
/sys/class/fc_transport/target1:0:2/device/1:0:2:513/block: symbolic 
link to `../../../../../../../../block/sdac'
/sys/class/fc_transport/target1:0:2/device/1:0:2:514/block: symbolic 
link to `../../../../../../../../block/sdad'
/sys/class/fc_transport/target1:0:2/device/1:0:2:515/block: symbolic 
link to `../../../../../../../../block/sdae'
/sys/class/fc_transport/target1:0:2/device/1:0:2:516/block: symbolic 
link to `../../../../../../../../block/sdaf'
/sys/class/fc_transport/target1:0:2/device/1:0:2:517/block: symbolic 
link to `../../../../../../../../block/sdag'
/sys/class/fc_transport/target1:0:2/device/1:0:2:518/block: symbolic 
link to `../../../../../../../../block/sdah'

Implementing this idea would mean in this example that checker status 
for sdaa applies to sda[bcdefgh].

Arguments in favor of this approach are :

1) less checking work
2) lower failure-to-reaction latency : batched reactions upon phy path 
failure.
3) lessen the checking time drift : setup interval is I, but the real 
interval is "I+(checker loop time)"
4) each path check involves I/O, thus quite a high latency. Less checks 
means higher efficiency.

I'm open for comments.

Regards,
cvaroqui
