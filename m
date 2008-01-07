From: "Urs Golla" <urs.golla@gmail.com>
Subject: boot from san & lvm
Date: Mon, 7 Jan 2008 16:36:21 +0100
Message-ID: <64e30f320801070736o62ec8b42q9db45f616f076a17@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi

I would like to boot RHEL5 from SAN. If I install with the "mpath"
parameter I can see the mapper/mpath0 device and the installation
completes without any errors.

It boots from SAN and everything looks ok (well, lets say its
working). If i add this lines to /etc/lvm/lvm.conf

types = [ "device-mapper", 1]
"filter = [ "a/dev/mpath/.*/", "r/.*/" ]"

and remove the blacklist lines from /etc/multipath.conf as described
in the "Native Multipath Failover Based on DM-MPIO for v2.6.x Linux
Kernel and EMC(R) Storage Arrays" manual the pvscan command returns
with " No matching physical volumes found". Why?

If I remove the filter line from lvm.conf the pvscan & pvdisplay
command returns:

(...)
PV Name               /dev/mapper/mpath0p2
(...)

Why is it using mpath0p2 and not mpath0? /dev/mapper/mpath0 does exist
and points to the right disks, because "multipath -ll" gives me
something like that:

mpath0 () dm-0 EMC,SYMMETRIX
[size=17G][features=0][hwhandler=0]
\_ round-robin 0 [prio=9][active]
 \_ 2:0:0:67    sda 8:0   [active][ready]
 \_ 2:0:0:33795 sdc 8:32  [active][ready]
 \_ 2:0:0:33811 sdd 8:48  [active][ready]
 \_ 2:0:0:37891 sde 8:64  [active][ready]
 \_ 2:0:0:37907 sdf 8:80  [active][ready]
 \_ 2:0:0:41987 sdg 8:96  [active][ready]
 \_ 2:0:0:42003 sdh 8:112 [active][ready]
 \_ 2:0:0:46083 sdi 8:128 [active][ready]
 \_ 2:0:0:46099 sdj 8:144 [active][ready]


Any help would be most welcome!

cheers
Urs
