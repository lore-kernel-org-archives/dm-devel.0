From: =?ISO-8859-1?Q?=C5ke?= Sandgren <ake.sandgren@hpc2n.umu.se>
Subject: Found a bug that probably is in dm-multipath
Date: Fri, 14 Oct 2005 15:58:55 +0200
Message-ID: <1129298336.5606.171.camel@y-boda.hpc2n.umu.se>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi!
I found a lockup bug that to me looks like it is in the dm-multipath
module.

This lockup happens when multipathd is started.

When it gets triggered the system locks up and the NMI watchdog is
activated.

This only happens when the kernel is configure with both
CONFIG_PREEMPT and CONFIG_REGPARM.
2.6.12.6 and 2.6.13.4 both have the same problem.

I have 2 qla2300 controllers on this system.
If the qla module is loaded during initramfs everything is ok but if i
remove them from initramfs and let hotplug load them later during
startup (still before multipathd is started) the system hangs as
multipathd is started.

What exact info would you like to get either to debug this yourself or
what more should i do to try to find te exact cause?

-- 
Ake Sandgren, HPC2N, Umea University, S-90187 Umea, Sweden
Internet: ake@hpc2n.umu.se   Phone: +46 90 7866134 Fax: +46 90 7866126
Mobile: +46 70 7716134 WWW: http://www.hpc2n.umu.se
