From: Lars Ellenberg <lars.ellenberg@linbit.com>
Subject: [PATCH] if READA is intentionally ignored,
	that is not EIO, but EWOULDBLOCK
Date: Fri, 25 Jul 2008 14:54:31 +0200
Message-ID: <20080725125431.GD28245@soda.linbit>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/md/dm-zero.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/md/dm-zero.c b/drivers/md/dm-zero.c
index bdec206..7b9f5e5 100644
--- a/drivers/md/dm-zero.c
+++ b/drivers/md/dm-zero.c
@@ -37,7 +37,7 @@ static int zero_map(struct dm_target *ti, struct bio *bio,
 		break;
 	case READA:
 		/* readahead of null bytes only wastes buffer cache */
-		return -EIO;
+		return -EWOULDBLOCK;
 	case WRITE:
 		/* writes get silently dropped */
 		break;
-- 
1.5.5.GIT


-- 
: Lars Ellenberg                            Tel +43-1-8178292-55 :
: LINBIT Information Technologies GmbH      Fax +43-1-8178292-82 :
: Vivenotgasse 48, A-1120 Vienna/Europe    http://www.linbit.com :
