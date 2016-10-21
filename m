From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 05/15] libmultipath: Fix POLLIN checks
Date: Fri, 21 Oct 2016 11:43:11 -0700
Message-ID: <4abc7f19-0f90-6928-09ef-1379e25debe7@sandisk.com>
References: <72bd7a6a-7fb9-5a2c-b22d-031d8feb01b0@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <72bd7a6a-7fb9-5a2c-b22d-031d8feb01b0@sandisk.com>
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
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Instead of testing (pfd.revents == 0) & 1, test whether
(pfd.revents & 1) == 0.

This has been detected by the sparse static analyzer.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
---
 libmpathcmd/mpath_cmd.c | 2 +-
 libmultipath/uxsock.c   | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/libmpathcmd/mpath_cmd.c b/libmpathcmd/mpath_cmd.c
index 667a2dc..d9c5790 100644
--- a/libmpathcmd/mpath_cmd.c
+++ b/libmpathcmd/mpath_cmd.c
@@ -31,7 +31,7 @@ static ssize_t read_all(int fd, void *buf, size_t len, unsigned int timeout)
 			if (errno == EINTR)
 				continue;
 			return -1;
-		} else if (!pfd.revents & POLLIN)
+		} else if (!(pfd.revents & POLLIN))
 			continue;
 		n = recv(fd, buf, len, 0);
 		if (n < 0) {
diff --git a/libmultipath/uxsock.c b/libmultipath/uxsock.c
index 880257f..b158a56 100644
--- a/libmultipath/uxsock.c
+++ b/libmultipath/uxsock.c
@@ -116,7 +116,7 @@ ssize_t read_all(int fd, void *buf, size_t len, unsigned int timeout)
 			if (errno == EINTR)
 				continue;
 			return -errno;
-		} else if (!pfd.revents & POLLIN)
+		} else if (!(pfd.revents & POLLIN))
 			continue;
 		n = read(fd, buf, len);
 		if (n < 0) {
-- 
2.10.1
