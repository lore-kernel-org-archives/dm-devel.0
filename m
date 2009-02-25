From: "John A. Sullivan III" <jsullivan@opensourcedevel.com>
Subject: Controlling path priorities in dm-multipath
Date: Wed, 25 Feb 2009 14:43:05 -0500
Message-ID: <1235590985.6568.39.camel@jaspav.missionsit.net.missionsit.net>
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

Hello, all.  Sorry to trouble the list but I have been googling and
reading for the better part of two days.  How does one control path
priorities in dm-multipath?

For example, in our test environment in which we are attempting to learn
dm-multipath, we have a Nexenta opensolaris based iSCSI SAN with ten
Ethernet ports on the SAN network divided equally between two GbE
switches.  We have a Linux server with four Ethernet ports on the SAN.

opensolaris only supports 802.3ad for port bonding which required us to
plug all bonded ports into the same switch. That was an unacceptable
single point of failure for us so we decided to explore dm-multipath for
fault tolerance.

To optimize network throughput, we decided to divide the storage pool
for the server into four LUNs - one per server interface to the SAN
network (the SAN network is subnetted to provide a unique subnet for
each SAN interface).  We then thought we would implement RAID0 across
the four LUNs to stripe across all interfaces simultaneously.  We
assumed this would give us better performance than dm-multipath's
multibus with round robin.

However, we would prefer the traffic stay within the same switch and not
needlessly traverse the switch trunks.  Thus, we really want to lock a
port on the Server to a LUN and use the SAN interface which is on the
same switch as the Server interface.  We also want each Server interface
to be able to access each SAN LUN through either of two interfaces on
the SAN.  The idea is we can thus tolerate a failure of any one switch
and literally all interfaces but one on either the SAN or Server.

This yields 32 SCSI devices (4 interfaces connected via two paths to
four LUNs = 4 * 2 * 4).  Again, we want to lock one interface per LUN as
the top priority interface to ensure we are striping across all
interfaces and we are not crossing switches except in failover mode.
The second priority interface should be a different Server interface on
the same switch.  The third priority should be a different Server
interface on a different switch.

How does one prioritize paths in dm-multipath? I even tried creating a
prio_callout script which did nothing but capture any passed parameters
(so I could try to write a custom handler based upon what was passed
into the script) but the call does not appear to pass in any parameters.
HELP?  Thanks - John
-- 
John A. Sullivan III
Open Source Development Corporation
+1 207-985-7880
jsullivan@opensourcedevel.com

http://www.spiritualoutreach.com
Making Christianity intelligible to secular society
