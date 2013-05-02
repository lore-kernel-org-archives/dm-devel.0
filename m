From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH 16/16] Use mapname to choose kpartx delimiter
Date: Thu,  2 May 2013 16:46:37 -0500
Message-ID: <1367531197-8987-17-git-send-email-bmarzins@redhat.com>
References: <1367531197-8987-1-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1367531197-8987-1-git-send-email-bmarzins@redhat.com>
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
Cc: Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

When kpartx creates partition devices, it uses the mapname as the base
for the partition device names. However when choosing the delimiter,
it uses the device name passed in.  So if kpartx is called on /dev/dm-X
it will always add a 'p', even if the mapname ends in a letter.  This
patch fixes that by setting the delimiter based on the mapname.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 kpartx/kpartx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kpartx/kpartx.c b/kpartx/kpartx.c
index 30b3bd9..98d88c0 100644
--- a/kpartx/kpartx.c
+++ b/kpartx/kpartx.c
@@ -348,7 +348,7 @@ main(int argc, char **argv){
 	if (delim == NULL) {
 		delim = malloc(DELIM_SIZE);
 		memset(delim, 0, DELIM_SIZE);
-		set_delimiter(device, delim);
+		set_delimiter(mapname, delim);
 	}
 
 	fd = open(device, O_RDONLY);
-- 
1.8.2
