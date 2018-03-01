From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH 4/6] kpartx: Improve reliability of
	find_loop_by_file()
Date: Thu,  1 Mar 2018 11:29:33 -0800
Message-ID: <20180301192935.14643-5-bart.vanassche@wdc.com>
References: <20180301192935.14643-1-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180301192935.14643-1-bart.vanassche@wdc.com>
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
Cc: Bart Van Assche <bart.vanassche@wdc.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

Avoid that the strchr() call in this function examines uninitialized
data on the stack. This patch avoids that Coverity reports the following:

    CID 173252:  Error handling issues  (CHECKED_RETURN)
    "read(int, void *, size_t)" returns the number of bytes read, but it is ignored.

Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
---
 kpartx/lopart.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/kpartx/lopart.c b/kpartx/lopart.c
index 02b29e8cf91d..69c1eda1cc5c 100644
--- a/kpartx/lopart.c
+++ b/kpartx/lopart.c
@@ -64,7 +64,7 @@ char *find_loop_by_file(const char *filename)
 	DIR *dir;
 	struct dirent *dent;
 	char dev[64], *found = NULL, *p;
-	int fd;
+	int fd, bytes_read;
 	struct stat statbuf;
 	struct loop_info loopinfo;
 	const char VIRT_BLOCK[] = "/sys/devices/virtual/block";
@@ -86,14 +86,15 @@ char *find_loop_by_file(const char *filename)
 		if (fd < 0)
 			continue;
 
-		if (read(fd, dev, sizeof(dev)) <= 0) {
+		bytes_read = read(fd, dev, sizeof(dev) - 1);
+		if (bytes_read <= 0) {
 			close(fd);
 			continue;
 		}
 
 		close(fd);
 
-		dev[sizeof(dev)-1] = '\0';
+		dev[bytes_read] = '\0';
 		p = strchr(dev, '\n');
 		if (p != NULL)
 			*p = '\0';
-- 
2.16.2
