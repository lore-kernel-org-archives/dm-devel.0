From: heinzm@redhat.com
Subject: [PATCH 0/2] md/dm-raid: add/use API to switch raid4/5/6
	journal cache modes
Date: Wed, 22 Mar 2017 17:43:29 +0100
Message-ID: <20170322164331.20924-1-heinzm@redhat.com>
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
Cc: heinzm@redhat.com
List-Id: dm-devel.ids

From: Heinz Mauelshagen <heinzm@redhat.com>

Upstream commit 7a771ceac771d009f7203c40b256b0608d7ea2f8 added
journal support to dm-raid to close the raid4/5/6 "write hole"
but doesn't provide an API to switch modes from device-mapper.

Add missing API to MD and use it from device-mapper dm-raid
thus supporting 'write-back' journal caching in the raid target.


Heinz Mauelshagen (2):
  md: add raid4/5/6 journal mode API (for dm-raid use)
  dm raid: add raid4/5/6 journal mode support

 Documentation/device-mapper/dm-raid.txt | 11 +++-
 drivers/md/dm-raid.c                    | 91 ++++++++++++++++++++++++++++-----
 drivers/md/raid5-cache.c                | 62 ++++++++++++----------
 drivers/md/raid5.h                      | 11 ++++
 4 files changed, 133 insertions(+), 42 deletions(-)

-- 
2.9.3
