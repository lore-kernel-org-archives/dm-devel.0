From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 0/3] dm thin metadata: handful of improvements
Date: Mon, 15 Apr 2019 17:17:14 -0400
Message-ID: <20190415211717.18737-1-snitzer@redhat.com>
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
Cc: ejt@redhat.com
List-Id: dm-devel.ids

All are working well in my testing but I'd appreciate further review
from others.

Thanks,
Mike

Mike Snitzer (3):
  dm space map common: zero entire ll_disk
  dm thin metadata: do not write metadata if no changes occurred
  dm thin metadata: check __commit_transaction()'s return

 drivers/md/dm-thin-metadata.c                 | 63 +++++++++++++------
 .../md/persistent-data/dm-space-map-common.c  |  2 +
 2 files changed, 47 insertions(+), 18 deletions(-)

-- 
2.18.0
