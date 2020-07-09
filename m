From: mwilck@suse.com
Subject: [PATCH 67/74] libmultipath: disassemble_map(): always
	search paths by dev_t
Date: Thu,  9 Jul 2020 12:51:38 +0200
Message-ID: <20200709105145.9211-15-mwilck@suse.com>
References: <20200709105145.9211-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200709105145.9211-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

From: Martin Wilck <mwilck@suse.com>

There's no point in searching for the devname first. dev_t is the primary
device property for both device mapper and udev.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/dmparser.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/libmultipath/dmparser.c b/libmultipath/dmparser.c
index 27581cd..7fcd76e 100644
--- a/libmultipath/dmparser.c
+++ b/libmultipath/dmparser.c
@@ -295,12 +295,8 @@ int disassemble_map(vector pathvec, char *params, struct multipath *mpp,
 				devname[0] = '\0';
 			}
 
-			if (pathvec) {
-				if (strlen(devname))
-					pp = find_path_by_dev(pathvec, devname);
-				else
-					pp = find_path_by_devt(pathvec, word);
-			}
+			if (pathvec)
+				pp = find_path_by_devt(pathvec, word);
 
 			if (!pp) {
 				pp = alloc_path();
-- 
2.26.2
