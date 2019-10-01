From: Nikos Tsironis <ntsironis@arrikto.com>
Subject: [PATCH 0/1] dm snapshot: Fix bug in COW throttling
	mechanism causing deadlocks
Date: Tue,  1 Oct 2019 14:57:46 +0300
Message-ID: <20191001115747.4473-1-ntsironis@arrikto.com>
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
To: snitzer@redhat.com, agk@redhat.com, dm-devel@redhat.com
Cc: ntsironis@arrikto.com, guru2018@gmail.com
List-Id: dm-devel.ids

Hello,

This patch fixes the deadlock issue reported in this thread:
https://www.redhat.com/archives/dm-devel/2019-September/msg00168.html.

Although I have been really careful preparing this patch, in order to
avoid any further issues, any extra review would be greatly appreciated.

Thanks,
Nikos

Nikos Tsironis (1):
  dm snapshot: Fix bug in COW throttling mechanism causing deadlocks

 drivers/md/dm-snap.c | 99 +++++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 90 insertions(+), 9 deletions(-)

-- 
2.11.0
