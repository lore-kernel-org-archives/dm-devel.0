From: Lan <transter@gmail.com>
Subject: Re: path priority group and path state
Date: Thu, 3 Mar 2005 10:16:52 -0800
Message-ID: <ac71172a050303101648f08579@mail.gmail.com>
References: <20050221170006.F1A087364A@hormel.redhat.com>
Reply-To: Lan <transter@gmail.com>,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
In-Reply-To: <20050221170006.F1A087364A@hormel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@free.fr>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

While testing failover/faiback with multipath-tools-0.4.2 and IBM ESS
2105800 and 2105E20 storage, I was also seeing problems with failback
not working because recovered paths were not getting reclaimed
correctly. I have tried using multipath-tools-0.4.3-pre3.tar.bz2, and
now failback is working!   :)

I was using a dual-port QLA2342 HBA connected to ESS 2105800 and ESS
2105E20 storage through a FC switch, so 4 paths per LUN. Use dd to run
I/O on all 4 paths to a LUN. Disable a port on the switch, wait for
I/O to failover to remaining 2 paths (which works fine!), reenable the
port, and  immediately paths are reclaimed and I/O resumes on all 4
paths. it's great! thanks!

Configlet used: (similar for the 2105800)
devices {
        device {
                vendor "IBM "
                product "2105E20 "
                path_grouping_policy group_by_serial
                features        "1 queue_if_no_path"
                getuid_callout "/sbin/scsi_id -g -s /block/%n"
                path_checker tur
        }
}


lan

> Date: Sun, 20 Feb 2005 23:45:11 +0100
> From: Christophe Varoqui <christophe.varoqui@free.fr>
> Subject: Re: [dm-devel] path priority group and path state
> To: ramesh.caushik@intel.com
> Cc: device-mapper development <dm-devel@redhat.com>
> Message-ID: <421912F7.5000305@free.fr>
> Content-Type: text/plain; charset=ISO-8859-1; format=flowed
> 
> Please test
> http://christophe.varoqui.free.fr/multipath-tools/multipath-tools-0.4.3-pre3.tar.bz2
> It should close the design hole you noted here.
> 
> regards,
> cvaroqui
> 
> Caushik, Ramesh wrote:
> 
> >Given that some of the problems I am noticing in my testing relates to
> >mismatch between the path state recorded by the driver and the daemon, I
> >thought I will chime in with my questions / observations.
> >
> >My setup consists of a dual port qla2312 controller connected to a JBOD
> >through a FC switch thus creating 2 paths A & B to the drive. I have all
> >the paths in one PG using round-robin selector and "queue if no path"
> >set. I run a bonnie++ transfer to the mounted drive, and then pull out
> >the path A connection. When the transfer switches to path B I reinsert A
> >and then after a little while pull out B and repeat this a few times.
> >Sometimes the transfer just hangs and the log messages indicate the
> >driver is queueing the i/o (both paths are marked faulty). This is what
> >seems to happen. When the cable on path  A is pulled out the controller
> >receives a "LOOP DOWN" on that port and ALSO a "LIP RESET" on path B.
> >This causes i/o on both paths to return SCSI error and so both paths are
> >set faulty (some of the in-flight i/o on path B fails as a result of the
> >LIP RESET). However when the daemon checker loop wakes up and tests the
> >path (via checkfn) path B returns OK, and since the daemon will
> >reconfigure the paths only if newstate != oldstate it does not
> >reconfigure the path. As a result, we end up with a situation where the
> >driver marks path B as faulty due to i/o error in the path, and waits
> >for the daemon to reconfigure the path, while the daemon does not
> >reconfigure path B because the checkfn does not detect a state change.
> >First of all please tell me if this analyses is correct. If it is then
> >my suggestion is for the daemon checker loop to reinstate the path
> >anytime the there is a mismatch between the path state in the driver and
> >that returned by the checkfn, and not just based on the newstate !=
> >oldstate check. I am in the process of coding this up to see if it will
> >fix the problem. Meanwhile I would much appreciate any comments or
> >suggestions on this. Thanks,
> >
> >
