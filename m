From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 03/12] kpartx(coverity): fix apparent
	out-of-bounds access
Date: Tue,  8 Jan 2019 23:54:00 +0100
Message-ID: <20190108225409.15977-4-mwilck@suse.com>
References: <20190108225409.15977-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190108225409.15977-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

This was a false positive.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 kpartx/dasd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kpartx/dasd.c b/kpartx/dasd.c
index fb358ad..61b609a 100644
--- a/kpartx/dasd.c
+++ b/kpartx/dasd.c
@@ -190,7 +190,7 @@ read_dasd_pt(int fd, struct slice all, struct slice *sp, int ns)
 		memcpy (&vlabel, data, sizeof(vlabel));
 	else {
 		bzero(&vlabel,4);
-		memcpy (&vlabel.vollbl, data, sizeof(vlabel) - 4);
+		memcpy ((char *)&vlabel + 4, data, sizeof(vlabel) - 4);
 	}
 	vtoc_ebcdic_dec(vlabel.vollbl, type, 4);
 
-- 
2.19.2
