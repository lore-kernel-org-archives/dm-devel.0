From: Dmitry Fomichev <dmitry.fomichev@wdc.com>
Subject: [PATCH 0/2] dm-zoned: add SPDX identifiers
Date: Fri,  2 Aug 2019 15:02:49 -0700
Message-ID: <20190802220251.1217-1-dmitry.fomichev@wdc.com>
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
To: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
Cc: Dmitry Fomichev <dmitry.fomichev@wdc.com>, Damien Le Moal <damien.lemoal@wdc.com>
List-Id: dm-devel.ids

The first patch adds SPDX IDs to all dm-zoned source files.

The second patch fixes a few typos.

No functional change.

Dmitry Fomichev (2):
  dm-zoned: add SPDX license identifiers
  dm-zoned: fix a few typos

 drivers/md/dm-zoned-metadata.c | 9 +++++----
 drivers/md/dm-zoned-reclaim.c  | 3 ++-
 drivers/md/dm-zoned-target.c   | 1 +
 drivers/md/dm-zoned.h          | 1 +
 4 files changed, 9 insertions(+), 5 deletions(-)

-- 
2.21.0
