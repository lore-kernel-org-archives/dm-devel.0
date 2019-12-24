From: zhengbin <zhengbin13@huawei.com>
Subject: [PATCH 0/4] dm: use true,false for bool variable
Date: Tue, 24 Dec 2019 14:37:59 +0800
Message-ID: <1577169483-138896-1-git-send-email-zhengbin13@huawei.com>
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
To: agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com
Cc: zhengbin13@huawei.com
List-Id: dm-devel.ids

zhengbin (4):
  dm mpath: use true,false for bool variable
  dm bio prison v2: use true,false for bool variable
  dm snapshot: use true,false for bool variable
  dm thin metadata: use true,false for bool variable

 drivers/md/dm-bio-prison-v2.c |  2 +-
 drivers/md/dm-mpath.c         |  2 +-
 drivers/md/dm-snap.c          |  6 +++---
 drivers/md/dm-thin-metadata.c | 10 +++++-----
 4 files changed, 10 insertions(+), 10 deletions(-)

--
2.7.4
