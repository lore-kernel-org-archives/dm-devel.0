From: Stefan Bader <Stefan.Bader@de.ibm.com>
Subject: Re: dm-multipath alua assigned path priorities
Date: Mon, 9 Oct 2006 12:49:44 +0200
Message-ID: <OFBFA0D1F1.7F093202-ONC1257202.003A014F-C1257202.003B30F2@de.ibm.com>
References: <6CCEAEDF4D06984A83F427424F47D6E4013D140E@CORPUSMX40A.corp.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <6CCEAEDF4D06984A83F427424F47D6E4013D140E@CORPUSMX40A.corp.emc.com>
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

The values are partially arbitrarily and a bit for reason chosen. The
reason is (or at least was at the time of choosing them, that the
active path group is selected as the one that has the highest priority
count (all priority values of all paths in the group added together).
So if the values 3 to 0 would have been used, 4 suboptimal paths would
be used if only two optimal ones were available (4x2=8 > 2x3=6). At the
time of coding the values I assumed 2 optimal paths should still be better
than the sub-optimal paths. What would be the expectation here?
I guess if the need is there it shouldn't be that hard to add configurable
values as an argument to the command.


Regards,
Stefan Bader

SW Linux on zSeries Development & Services
Stefan.Bader@de.ibm.com
----------------------------------------------------------------------------------
  When all other means of communication fail, try words.

dm-devel-bounces@redhat.com wrote on 04.10.2006 20:24:07:

> Are the relationships between various dm-multipath ALUA assigned path
> priorities (active/optimal=50;active/sub-optimal=10;standby=1;other=0)
> based on the performance characteristics of a particular array or were
> they arbitrarily chosen?  Also, is it reasonable to make these ALUA
> assigned path priorities configurable (particularly the ratio of
> active/optimal to active/sub-optimal priorities) on a per storage system
> basis?
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
