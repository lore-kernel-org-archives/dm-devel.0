From: Dan Gregory <dan.gregory@mci.com>
Subject: Multipathing to a LUN through brocade switch
Date: Mon, 09 Jan 2006 14:49:14 -0500
Message-ID: <43C2BE3A.8030309@mci.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
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

Hullo,

I know this list has handle many issues of users not knowing how to
setup multipathing, but I've read all of them and Christophe's wiki and
I can't get my system to talk to my storage array.

OS: RHEL 4.2, device-mapper-multipath-0.4.5-6.0.RHEL4

Configuration:  I have a SunFire 4100 with one 2 port qla hba pci card
dual connected to a single 16 port brocade silkworm which in turn in
dual connected to a Sun StorEdge 3511.  Interestingly, I get 4
/dev/sd[c-f] associated with the same LUN.  I presume that each device
can see the LUN through each of the 2 connections from the switch to the
3511.

I know that mapper is working because there are 2 devices that the LVM
creates, one for / and one for swap, but the LUNs don't show up.
multipath -v2  does not give any output, but -v3 gives information on
all 6 of the sd[a-f] devices.  The only differences in the output of
sd[c-f] are dev_t and h:b:t:l fields (see below).  I've tried to add
entries into the multipath.conf file, but nothing changes the output and
I never get any more devices in /dev/mapper.

What am I doing wrong?


Thanks,
Dan



(I diffed the sections in the multipath -v3 output)

< ===== path sdc =====
---
> ===== path sdf =====
3c3
< dev_t = 8:32
---
> dev_t = 8:80
8c8
< h:b:t:l = 1:0:0:0
---
> h:b:t:l = 2:0:1:0
17,18c17
< path sdd not found in pathvec
<
---
> path sdg not found in pathvec
