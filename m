From: Bernd Zeimetz <bernd@bzed.de>
Subject: multipath + evms problems
Date: Sat, 29 Oct 2005 12:48:50 +0200
Message-ID: <200510291248.51290.bernd@bzed.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
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

we have some trouble with runnign an EMC CX400 with multipath and evms.

If we run the machine with systemtype 0x16 (it identifies itself as FSC FC66 
then), Arraycommpath = 0 and Failovermode = 2, failover seems to work well 
(not much tested), and evms uses the dm/multipath devices. The bad thing on 
this way is a trespass of the LUNs every few seconds, which is not the way it 
should work.

Setting the machine to something useful - systemtype=3  (==DGC), 
arraycommpath=1, failovermode=1 - it is recognized by multipath-tools and 
dm-emc as emc-machine. With

zeus-1:/# cat /etc/multipath.conf

defaults {
        path_grouping_policy                    failover
        no_path_retry                           queue
}

multipaths {
        multipath {
                wwid            3600601f2a20c0000fa13caa656b0d711
                alias           LUN_0
        }
[....]
        multipath {
                wwid            3600601f4a20c000099dc229956b0d711
                alias           LUN_7
        }
}


we have some nice devices:
zeus-1:/# ll /dev/mapper/
total 0
brw-------  1 root root 254,  0 Oct 29 12:09 LUN_0
brw-------  1 root root 254,  4 Oct 29 12:09 LUN_0p1
[....]
brw-------  1 root root 254,  2 Oct 29 12:09 LUN_7
brw-------  1 root root 254, 13 Oct 29 12:09 LUN_7p1
crw-rw----  1 root root  10, 63 Oct 29 12:08 control
zeus-1:/#


but evms does not use them, it directly accesses and uses sd*
zeus-1:/# ll /dev/evms
[...]
drwxr-xr-x  2 root root       60 Oct 29 12:09 dm
brw-r-----  1 root disk   8,   0 Oct 29 12:09 sda
brw-r-----  1 root disk   8,  16 Oct 29 12:09 sdb
brw-r-----  1 root disk   8,  32 Oct 29 12:09 sdc
brw-r-----  1 root disk   8,  48 Oct 29 12:09 sdd
brw-r-----  1 root disk   8,  64 Oct 29 12:09 sde
brw-r-----  1 root disk   8,  80 Oct 29 12:09 sdf
brw-r-----  1 root disk   8,  96 Oct 29 12:09 sdg
brw-r-----  1 root disk   8, 112 Oct 29 12:09 sdh

Of course this results in a not working failover - this should work without 
using multipath at all.
After excluding the sd* devices in evms.conf it doesn't find any evms-devices 
at all.


We also have a ton of
multipathd: uevent trigger error
messages in the daemon's log.

Operating system is Debian sarge, but with kernel 2.6.14, the actual git 
version of the multipath-tools, evms 2.5.3, udev 0.070, libdevmapper/dmsetup 
1.01.04.


Since this behaviour seems to depend on the use of the emc-hwhandler/dm-emc 
I'm posting to this list.
Hope you have any ideas how to fix it, or do we run in an evms-only bug here?



Greetings from Darmstadt, Germany


Bernd Zeimetz
Darmstadt University of Technology
