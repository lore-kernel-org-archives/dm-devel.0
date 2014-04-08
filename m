From: Eric K <iggiggitoo@gmail.com>
Subject: Correct Routing Setup for Multipath
Date: Tue, 08 Apr 2014 14:29:03 -0400
Message-ID: <53443FEF.5090901@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
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

I am attempting to setup multipath with ISCSI in order to utilize more 
than 1 gigabit connection and someone earlier on the list mentioned that 
the issue may be my routing. Are there any resources out there for 
setting up routing correctly in this situation? I will include my 
routing table below if anyone would like to help in the list.

# route -n
Kernel IP routing table
Destination     Gateway         Genmask         Flags Metric Ref Use Iface
0.0.0.0         1.2.3.1    0.0.0.0         UG    100    0        0 br0
10.1.1.0        0.0.0.0         255.255.255.0   U     0 0        0 br1
10.1.3.0        0.0.0.0         255.255.255.0   U     0 0        0 eth2
10.1.4.0        0.0.0.0         255.255.255.0   U     0 0        0 eth3
10.1.5.0        0.0.0.0         255.255.255.0   U     0 0        0 eth4
10.1.6.0        0.0.0.0         255.255.255.0   U     0 0        0 eth5
10.2.5.0        0.0.0.0         255.255.255.0   U     0 0        0 virbr2
192.168.122.0   0.0.0.0         255.255.255.0   U     0 0        0 virbr0
1.2.3.0    0.0.0.0         255.255.255.0   U     0      0        0 br0

br1(eth1) and eth2-5 are on our storage network where as br0 (eth0) is 
public

-- 
Eric
