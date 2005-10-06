From: Stefan Bader <Stefan.Bader@de.ibm.com>
Subject: Re: Multipath tools 0.4.5 & round-robin
Date: Thu, 6 Oct 2005 19:23:15 +0200
Message-ID: <OFFAE143BD.EC13476A-ONC1257092.005F4D85-C1257092.005F622F@de.ibm.com>
References: <1128617484.29838.1.camel@dhcpc226.office.pivotlink.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1128617484.29838.1.camel@dhcpc226.office.pivotlink.com>
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

If is working. Not exactly load-balancing because the path is changed 
after a certain
number of requests to the next path, but it works. What you need to do 
(and your hard-
ware has to support that), is to put all paths into the same 
priority-group.

Stefan Bader

SW Linux on zSeries Development & Services
Stefan.Bader@de.ibm.com
----------------------------------------------------------------------------------
  When all other means of communication fail, try words.



Brad Dameron <brad@seatab.com> 
Sent by: dm-devel-bounces@redhat.com
06.10.2005 18:51
Please respond to
device-mapper development


To
device-mapper development <dm-devel@redhat.com>
cc

Subject
[dm-devel] Multipath tools 0.4.5 & round-robin






I asked this question before but got no response. Is the load balancing
(round-robin) feature not functioning? If not anyone know how to use 2
fiber connections shared from one machine?

Thank you,
Brad Dameron
SeaTab Software
www.seatab.com

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
