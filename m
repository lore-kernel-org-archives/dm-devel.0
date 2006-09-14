From: hadmut@danisch.de (Hadmut Danisch)
Subject: LVM pv blocking RAID device
Date: Thu, 14 Sep 2006 17:14:58 +0200
Message-ID: <20060914151458.GA28614@danisch.de>
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

Hi,

I wanted to modify several RAID1 partitions (changing the preferred
minor), which requires to 

  mdadm --stop /dev/md?

before. This worked well except with the RAID device which
contained an LVM physical volume. I could not stop that contains an
pv, even after vgchange -a n  and vgexport. The RAID device is still
busy. 

How could I make LVM to release the underlying device (without
destroying the contents)?

regards
Hadmut
