From: Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 52/72] libmultipath: use unsigned blksize in
	directio context
Date: Sat, 12 Oct 2019 21:28:41 +0000
Message-ID: <20191012212703.12989-53-martin.wilck@suse.com>
References: <20191012212703.12989-1-martin.wilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20191012212703.12989-1-martin.wilck@suse.com>
Content-Language: en-US
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
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, Martin Wilck <Martin.Wilck@suse.com>
List-Id: dm-devel.ids

From: Martin Wilck <mwilck@suse.com>

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/checkers/directio.c | 2 +-
 libmultipath/io_err_stat.c       | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/libmultipath/checkers/directio.c b/libmultipath/checkers/directio.c
index 1b00b775..239a811c 100644
--- a/libmultipath/checkers/directio.c
+++ b/libmultipath/checkers/directio.c
@@ -37,7 +37,7 @@ const char *libcheck_msgtable[] = {
 struct directio_context {
 	int		running;
 	int		reset_flags;
-	int		blksize;
+	unsigned int	blksize;
 	unsigned char *	buf;
 	unsigned char * ptr;
 	io_context_t	ioctx;
diff --git a/libmultipath/io_err_stat.c b/libmultipath/io_err_stat.c
index d7e296fa..dcc8690d 100644
--- a/libmultipath/io_err_stat.c
+++ b/libmultipath/io_err_stat.c
@@ -54,7 +54,7 @@ struct io_err_stat_pathvec {
 
 struct dio_ctx {
 	struct timespec	io_starttime;
-	int		blksize;
+	unsigned int	blksize;
 	void		*buf;
 	struct iocb	io;
 };
@@ -128,7 +128,7 @@ static int setup_directio_ctx(struct io_err_stat_path *p)
 {
 	unsigned long pgsize = getpagesize();
 	char fpath[PATH_MAX];
-	int blksize = 0;
+	unsigned int blksize = 0;
 	int i;
 
 	if (snprintf(fpath, PATH_MAX, "/dev/%s", p->devname) >= PATH_MAX)
-- 
2.23.0
