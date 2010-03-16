From: brem belguebli <brem.belguebli@gmail.com>
Subject: DM-MP looping
Date: Tue, 16 Mar 2010 02:42:50 +0100
Message-ID: <1268703770.26490.41.camel@localhost>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi,

I'm having a SAN problem causing some of my linux machines to become
unresponsive.

However, when trying to reproduce the problem, I did some experiments
that lead me to think I have hit a bug in dm-mp.

I have 2 multipathed devices from HP EVA8100 arrays, each device seeing
8 paths.

when I issue a blocked to one of the paths of one of the mpath devices
"echo blocked > /sys/bus/scsi/devices/0:0:2:4/state" while stracing
multipathd, any multipath command on any of the mpath devs (multipath
-l ) gets stuck on all the devices never returning.

the multipathd strace output shows the following :

[pid 29060] poll([{fd=198, events=POLLIN}], 1, 5000) = 0 (Timeout)
[pid 29060] poll([{fd=198, events=POLLIN}], 1, 5000) = 0 (Timeout)
[pid 29060] poll([{fd=198, events=POLLIN}], 1, 5000) = 0 (Timeout)
[pid 29060] poll([{fd=198, events=POLLIN}], 1, 5000) = 0 (Timeout)
[pid 29060] poll([{fd=198, events=POLLIN}], 1, 5000) = 0 (Timeout)
[pid 29060] poll([{fd=198, events=POLLIN}], 1, 5000) = 0 (Timeout)
[pid 29060] poll([{fd=198, events=POLLIN}], 1, 5000) = 0 (Timeout)
[pid 29060] poll([{fd=198, events=POLLIN}], 1, 5000) = 0 (Timeout)
[pid 29060] poll([{fd=198, events=POLLIN}], 1, 5000) = 0 (Timeout)
[pid 29060] poll([{fd=198, events=POLLIN}], 1, 5000) = 0 (Timeout)
[pid 29060] poll([{fd=198, events=POLLIN}], 1, 5000) = 0 (Timeout)
[pid 29060] poll([{fd=198, events=POLLIN}], 1, 5000) = 0 (Timeout)
....
I can see in the processes list several scsi_id commands stuck on the
path I've blocked. The load average of my test machine going high very
fast (from 0.5 to 15 in a few minutes on a dual xeon 5560)

Issuing scsi_id -p 0x80 on the 7 remaining paths is ok.

When reactivating the path "echo running
> /sys/bus/scsi/devices/0:0:2:4/state" everything returns to normal.

Below an extract of my /etc/multipath.conf

defaults { 
	polling_interval 10 
	path_grouping_policy multibus  
	getuid_callout "/sbin/scsi_id -g -u -s /block/%n" 
	no_path_retry fail 
} 
blacklist { 
	devnode "^(ram|raw|loop|fd|md|dm-|sr|scd|st)[0-9]*" 
	devnode "^hd[a-z]" 
}
devices { 
	device { 
		vendor "HP" product "HSV2[10]0" 
		getuid_callout "/sbin/scsi_id -g -u -s /block/%n" 
	} 
}

The SAN problem I'm having is that some DWDM FC services switch from
their nominal path to the protected one (dwdm loop with built-in
failover) in less than a few tens of millisecs, that I'm suspecting it
may be causing some paths to go to blocked state, but i couldn't verify
it yet, and last time it happened the machines were already at very high
load >80, the guys here were unable to do anythng except to reset them.

Running Rhel 5.3 with shipped dm-mp version 
