From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: path priority group and path state
Date: Thu, 17 Feb 2005 21:25:33 +0100
Message-ID: <4214FDBD.7040609@free.fr>
References: <EA4DC661A6353747A2E5C0DE8792DDDE07CA9912@orsmsx404.amr.corp.intel.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <EA4DC661A6353747A2E5C0DE8792DDDE07CA9912@orsmsx404.amr.corp.intel.com>
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

Caushik, Ramesh wrote:

>Given that some of the problems I am noticing in my testing relates to
>mismatch between the path state recorded by the driver and the daemon, I
>thought I will chime in with my questions / observations.
>   
>My setup consists of a dual port qla2312 controller connected to a JBOD
>through a FC switch thus creating 2 paths A & B to the drive. I have all
>the paths in one PG using round-robin selector and "queue if no path"
>set. I run a bonnie++ transfer to the mounted drive, and then pull out
>the path A connection. When the transfer switches to path B I reinsert A
>and then after a little while pull out B and repeat this a few times.
>Sometimes the transfer just hangs and the log messages indicate the
>driver is queueing the i/o (both paths are marked faulty). This is what
>seems to happen. When the cable on path  A is pulled out the controller
>receives a "LOOP DOWN" on that port and ALSO a "LIP RESET" on path B.
>This causes i/o on both paths to return SCSI error and so both paths are
>set faulty (some of the in-flight i/o on path B fails as a result of the
>LIP RESET). However when the daemon checker loop wakes up and tests the
>path (via checkfn) path B returns OK, and since the daemon will
>reconfigure the paths only if newstate != oldstate it does not
>reconfigure the path. As a result, we end up with a situation where the
>driver marks path B as faulty due to i/o error in the path, and waits
>for the daemon to reconfigure the path, while the daemon does not
>reconfigure path B because the checkfn does not detect a state change.
>First of all please tell me if this analyses is correct. If it is then
>my suggestion is for the daemon checker loop to reinstate the path
>anytime the there is a mismatch between the path state in the driver and
>that returned by the checkfn, and not just based on the newstate !=
>oldstate check. I am in the process of coding this up to see if it will
>fix the problem. Meanwhile I would much appreciate any comments or
>suggestions on this. Thanks,
>
>Ramesh.
>
> 
>
Actualy, I'd rather see the DM move to the netlink generic event model 
anf catch fail path events from the daemon.
Those messages would be more explicit and contain the path mjor/minor 
info, which would enable the daemon to set the path' state to fail upon 
arrival. That should close the design hole more elegantly.

Alasdair, al, care to comment about this DM evolution ?

Regards,
cvaroqui

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
