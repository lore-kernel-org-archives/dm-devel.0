From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH v3 2/7] multipath: fix DEF_TIMEOUT use
Date: Mon, 12 Feb 2018 21:42:09 -0600
Message-ID: <1518493334-18170-3-git-send-email-bmarzins@redhat.com>
References: <1518493334-18170-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1518493334-18170-1-git-send-email-bmarzins@redhat.com>
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
List-Id: dm-devel.ids

DEF_TIMEOUT is specified in seconds. The io_hdr timeout is specified in
milliseconds, so we need to convert it. Multipath should be waiting
longer than 30 milliseconds here. If there are concerns that 30 seconds
may be too long, we could always make this configurable, using
conf->checker_timeout if set.

Reviewed-by: Martin Wilck <mwilck@suse.com>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/discovery.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 4b31dde..f118800 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -766,7 +766,7 @@ do_inq(int sg_fd, int cmddt, int evpd, unsigned int pg_op,
 	io_hdr.dxferp = resp;
 	io_hdr.cmdp = inqCmdBlk;
 	io_hdr.sbp = sense_b;
-	io_hdr.timeout = DEF_TIMEOUT;
+	io_hdr.timeout = DEF_TIMEOUT * 1000;
 
 	if (ioctl(sg_fd, SG_IO, &io_hdr) < 0)
 		return -1;
-- 
2.7.4
