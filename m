From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 2/2] kpartx: fix new memory leak in dm_find_part
Date: Thu, 11 Oct 2018 15:43:48 -0500
Message-ID: <1539290628-16948-2-git-send-email-bmarzins@redhat.com>
References: <1539290628-16948-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1539290628-16948-1-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

While commit 960bb238 fixed one memory leak, it created another.

Fixes: 960bb238 ("kpartx: Fix memory leak of uuid found by coverity")
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 kpartx/devmapper.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kpartx/devmapper.c b/kpartx/devmapper.c
index 8db1eb5..3aa4988 100644
--- a/kpartx/devmapper.c
+++ b/kpartx/devmapper.c
@@ -690,6 +690,7 @@ int dm_find_part(const char *parent, const char *delim, int part,
 
 	r = dm_rename(tmp, name);
 	if (r == 1) {
+		free(tmp);
 		*part_uuid = uuid;
 		return 1;
 	}
-- 
2.7.4
