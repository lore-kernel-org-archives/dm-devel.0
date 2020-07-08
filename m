From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH 0/2] dm zoned fixes for 5.8
Date: Wed,  8 Jul 2020 09:20:21 +0900
Message-ID: <20200708002023.738147-1-damien.lemoal@wdc.com>
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
Cc: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>, Damien Le Moal <damien.lemoal@wdc.com>
List-Id: dm-devel.ids

Mike,

A couple of fixes for dm-zoned for this cycle. The first patch fixes
a possible hang under intensive write workload with a setup that has a
very limited number of cache zones. The second patch fixes some
compilation warnings showing when compiling with W=1.

Damien Le Moal (2):
  dm zoned: Fix zone reclaim trigger
  dm zoned: Remove set but unused variables

 drivers/md/dm-zoned-metadata.c |  9 ++++++++-
 drivers/md/dm-zoned-reclaim.c  |  7 +++----
 drivers/md/dm-zoned-target.c   | 10 +---------
 3 files changed, 12 insertions(+), 14 deletions(-)

-- 
2.26.2
