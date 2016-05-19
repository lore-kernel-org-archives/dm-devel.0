From: heinzm@redhat.com
Subject: [PATCH 00/11] dm-raid: add RAID level takeover
	cababilities
Date: Thu, 19 May 2016 18:49:23 +0200
Message-ID: <1463676574-12596-1-git-send-email-heinzm@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
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
Cc: Heinz Mauelshagen <heinzm@redhat.com>
List-Id: dm-devel.ids

From: Heinz Mauelshagen <heinzm@redhat.com>

This series of patches for the device-mapper dm-raid target
(which utilizes the md kernel raid runtime) provides superblock
enhancements and additional infrastructure for full
takover/reshape and raid set shrink support.

It includes full raid level takeover functionality,
reshape and shrink will follow later based on the hereby
provided infrastructure.

Raid level takeover is any change of the raid level
(e.g. raid <-> raid 6; see more below).

Raid reshaping is any change in layout on a particular raid level
(e.g. raid5_ls -> raid5_ra) and is subject to followup patches
to this series (same applies to raid set shrink support).

Reshaping is possible with the md personalities raid4/5/6/10,
allowing to change the stripe size, the mapping algorithm,
the number of devices or the region size in a raid set
conforming to md personality specific restrictions
(e.g. minimum of devices to ensure resilience or
raid10 not capable to remove devices from a raid set).

New raid types such as raid5_n, raid6_n_6 etc. are
introduced to support additonal md-raid layouts, which
are mandatory to enable takeover/reshape:

This series includes full takover
('<->' meaning either way) support for:

raid0 w/ <-> raid0 w/o metadata
raid0 <-> raid4
raid0 <-> raid5
raid0 <-> raid6
raid0 <-> raid10
raid4 <-> raid5
raid4 <-> raid6
raid5 <-> raid6


A raid level takeover has to be prepared by providing any needed
metadata devices and data devices;
e.g. 3-way striped raid0 -> raid6 requires 5 new metadata devices
and 2 new data devices for parity and Q-syndrome.


This added dm-raid target functionality will be made accessible
to the user via lvm2 enhancements.

It can be used immediately using the 'dmsetup' test tool.


Heinz Mauelshagen (11):
  dm-raid: rename variable 'ret' to 'r' to conform to other dm code
  dm-raid: use dm_arg_set API in ctr
  dm-raid: cleanup / provide infrastructure
  dm-raid: check constructor arguments for invalid raid level/argument combinations
  dm-raid: provide more infrastructure
  dm-raid: use rt_is_raid*() in all appropriate checks
  dm-raid: introduce v1.8.0 extended superblock to support takeover/reshaping    
  dm-raid: add new reshaping/raid10 format table line options to parameter parser
  dm-raid: enhance super_sync() to cope with new members inroduced 
  dm-raid: add raid level takeover support
  dm-raid: enhance status interface and fixup takeover/raid0

 drivers/md/dm-raid.c | 2234 +++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 1666 insertions(+), 568 deletions(-)

-- 
2.5.5
