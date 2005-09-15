From: Piotr Kral <piotr.kral@coig.katowice.pl>
Subject: Cluster dilemas...
Date: Thu, 15 Sep 2005 18:29:14 +0200
Message-ID: <4329A15A.50500@coig.katowice.pl>
Reply-To: linux clustering <linux-cluster@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-cluster-bounces@redhat.com>
List-Unsubscribe: <http://www.redhat.com/mailman/listinfo/linux-cluster>,
	<mailto:linux-cluster-request@redhat.com?subject=unsubscribe>
List-Archive: <http://redhat.com/archives/linux-cluster>
List-Post: <mailto:linux-cluster@redhat.com>
List-Help: <mailto:linux-cluster-request@redhat.com?subject=help>
List-Subscribe: <http://www.redhat.com/mailman/listinfo/linux-cluster>,
	<mailto:linux-cluster-request@redhat.com?subject=subscribe>
Sender: linux-cluster-bounces@redhat.com
Errors-To: linux-cluster-bounces@redhat.com
To: linux-cluster@redhat.com, dm-devel@redhat.com
List-Id: dm-devel.ids

	Hi
I have IBM Blade Center connected to IBM DS 4300 (former FASTt 600) disk 
system. The blades are diksless machines and they are connected to 
storage via fc switches, so I have 4 physical patchs to each disk. My 
dilemma is as follows: I wont to run Red Hat cluster suite on at least 
two servers and since I'm building systems from the beginning I'd rather 
use RHEL4 since it's newer, faster, more reliable (add more marketing 
bullshit here) etc. But HBA drivers that support multipath fail over are 
only in RHEL3 on RHEL4 there is something called dm + 
device-mapper-multipath but it is in beta stage :( So I'd like to ask 
You three things:
1. Is Red Hat cluster suite much different in RHEL3 then in RHEL4. 
Because if there is no big difference maybay it's not worth to fight 
with RHEL4 HBA drivers and just install RHEL3, and when RHEL4 will have 
proper drivers just upgrade?
2. Do You have any experience with "dm + device-mapper-multipath". To be 
sure this "beta stage" worries me a lot. But maybay You have some 
information when it will be in official release of RHEL4 (U2??), and 
most important: is it stable solution, and can it work in "production 
sewers"
3. What do You think of solution RHEL4 without multipath failover (so 
I'll see 4 paths, and in case of primary path failure at least one node 
will crush) + Red Hat cluster suite? I'm thinking off it in case 
problems with HBA drivers and some new functionality in Red Hat cluster 
suite in RHEL4

Kind Regards
Piotr
