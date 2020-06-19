From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH 0/2] dm-zoned fixes
Date: Fri, 19 Jun 2020 16:49:54 +0900
Message-ID: <20200619074956.352647-1-damien.lemoal@wdc.com>
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
Cc: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
List-Id: dm-devel.ids

A couple of fixes for dm-zoned which solve target hangs under severe
zone shortage conditions with a write intensive workload. Both fixes are
for reclaim zone selection.

Damien Le Moal (1):
  dm zoned: Fix random zone reclaim selection

Shin'ichiro Kawasaki (1):
  dm zoned: Fix reclaim zone selection

 drivers/md/dm-zoned-metadata.c | 39 +++++++++++++++++++++++++---------
 1 file changed, 29 insertions(+), 10 deletions(-)

-- 
2.26.2
