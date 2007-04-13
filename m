From: Harald Milz <hm@seneca.muc.de>
Subject: SLES9 DM-Multipath strange behaviour
Date: Fri, 13 Apr 2007 11:35:32 +0200
Message-ID: <20070413093532.GA15359@seneca.muc.de>
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

... or maybe it isn't that strange, and it's just a feature. 

Until recently, we using a single 200GB SAN volume with our heartbeat
cluster. The SAN ist a (yuck) Datacor SANsymphony Windows-based crap, but
so be it. Everything was working fine. Multipath just rocked. The volume is
seen twice, and dm-0 was nicely created. 

Later, a second 50GB volume was added from the same SAN controller -
everything worked OK. 

After that, 3 TB sized volumes were added from a Nexsan controller. These
were handled fine but the first 2 Datacor volumes were gone, i.e. no dm-X
was created! Identical behaviour on both machines in the cluster. No
changes whatsoever in any config file compared to the original setup
(single volume). 

Analysis revealed that the /dev/sdX block devices were still present (sdb -
sde, respectively) but all 4 devices had the same UUID! As soon as I
removed one of the volumes, the remaining volume worked just fine. We even
assigned the second volume to a different controller port, thus forcing a
different WWN for the volume, but the UUID (scsi_id -gus <device>) remained
the same. 

What can be wrong here? 

I assume dm-multipath refuses to work with what looks like the same device
(by UUID) but 2 different sizes. 

But why is the same UUID calculated (how?) for 2 apparently different
volumes? 


Strangely, another HB cluster with 3 Datacor SAN volumes has no such
problems. 


Appreciate any help :-) TIA!


-- 
Fortune's Law of the Week (this week, from Kentucky):
	No female shall appear in a bathing suit at any airport in this
State unless she is escorted by two officers or unless she is armed
with a club.  The provisions of this statute shall not apply to females
weighing less than 90 pounds nor exceeding 200 pounds, nor shall it
apply to female horses.
