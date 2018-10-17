From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH 0/2] dm-zoned fixes
Date: Wed, 17 Oct 2018 18:05:06 +0900
Message-ID: <20181017090508.22376-1-damien.lemoal@wdc.com>
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
List-Id: dm-devel.ids

Mike,

As discussed, the first patch changes the atomic_t type of metadata block
reference count to a simple integer (unsigned). While making this change,
I found a couple of problems with the dmz_get_mblock() function which are
fixed in the second patch.

Both are Cc: stable so that the main fix (the second patch) applies
cleanly.

Damien Le Moal (2):
  dm-zoned: Fix metadata block ref counting
  dm-zoned: Fix dmz_get_mblock()

 drivers/md/dm-zoned-metadata.c | 80 +++++++++++++++++++++-------------
 1 file changed, 50 insertions(+), 30 deletions(-)

-- 
2.17.2
