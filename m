From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 0/7] dm: allow mempool and bioset reserves to be
	tuned
Date: Thu, 12 Sep 2013 18:24:51 -0400
Message-ID: <1379024698-10487-1-git-send-email-snitzer@redhat.com>
References: <alpine.LRH.2.02.1308261012400.12373@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.2.02.1308261012400.12373@file01.intranet.prod.int.rdu2.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Frank Mayhar <fmayhar@google.com>, Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

You can pull these changes from the 'devel' branch of:
git://git.kernel.org/pub/scm/linux/kernel/git/snitzer/linux.git

To browse, see:
https://git.kernel.org/cgit/linux/kernel/git/snitzer/linux.git/log/?h=devel

I'm open to other suggestions but I think this is closer to the right
way forward in the near-term (for 3.13).  I welcome any review feedback
you might have.

Thanks,
Mike

Mike Snitzer (7):
  dm: lower bio-based mempool reservation
  dm: add reserved_rq_based_ios module parameter
  dm: add reserved_bio_based_ios module parameter
  dm io: use dm_get_reserved_bio_based_ios to size reserves
  dm mpath: use dm_get_reserved_rq_based_ios to size mempool
  dm: track the maximum number of bios in a cloned request
  dm: optimize clone_rq() when track_peak_rq_based_ios is disabled

 drivers/md/dm-io.c    |   7 +--
 drivers/md/dm-mpath.c |   6 +-
 drivers/md/dm.c       | 169 ++++++++++++++++++++++++++++++++++++++++++++++++--
 drivers/md/dm.h       |   3 +
 4 files changed, 174 insertions(+), 11 deletions(-)

-- 
1.8.1.4
