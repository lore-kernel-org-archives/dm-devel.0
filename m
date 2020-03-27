From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH RFC 0/4] dm-zoned: Metadata V2
Date: Fri, 27 Mar 2020 08:14:55 +0100
Message-ID: <20200327071459.67796-1-hare@suse.de>
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
To: Mike Snitzer <snitzer@redhat.com>
Cc: Damien LeMoal <damien.lemoal@wdc.com>, Bob Liu <bob.liu@oracle.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

Hi all,

here's a patchset to add UUIDs and labels to the metadata,
increasing the metadata version number to 2.
This allows to identify the various devices, and also to
have a persistent device-mapper name based on the label.
To handle and generate these new values I've also send
a pull request to the upstream dm-zoned-tools git repository.

This patchset requires the previous patch to add status
and message callbacks.

As usual, comments and reviews are welcome.

Hannes Reinecke (4):
  dm-zoned: store zone id within the zone structure
  dm-zoned: use array for superblock zones
  dm-zoned: V2 metadata handling
  dm-zoned: allow for device size smaller than the capacity

 drivers/md/dm-zoned-metadata.c | 117 ++++++++++++++++++++++++++++++-----------
 drivers/md/dm-zoned-target.c   |   4 +-
 drivers/md/dm-zoned.h          |   3 ++
 3 files changed, 91 insertions(+), 33 deletions(-)

-- 
2.16.4
