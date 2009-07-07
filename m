From: Andy <genanr@emsphone.com>
Subject: prio ignored in multipath.conf
Date: Tue, 7 Jul 2009 09:41:55 -0500
Message-ID: <20090707144155.GA16220@thumper2>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
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

I am trying to change the path priorities on QLA2432 HBAs to a 3PAR array.
The kernel is 2.6.31-rc1 and multipath tools v0.4.9

I created a small C program to change priorities (right now it just prints
some info).  But, when I run multipath the verbose information keeps saying
prio = const (controller setting), even though I have "prio  allant" (allant
is the name of my prioritizer).  If I have "prio alllant" a global default
it will run the code for the non-QLA2432/3PAR device, but not the devices
that are under the control of the QLA2432.  It always sets prio to const and
the QLA2432 paths.  This use to work at some point with older
multipath/kernel versions.

Thanks, 

Andy 
