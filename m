From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 3.18-stable] dm bufio: hide bogus warning
Date: Fri, 21 Apr 2017 15:41:10 +0200
Message-ID: <20170421134212.2727744-1-arnd@arndb.de>
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
To: stable@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Mike Snitzer <snitzer@redhat.com>, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

mips-gcc-5.3 warns about correct code on linux-3.18 and earlier:

In file included from ../include/linux/blkdev.h:4:0,
                 from ../drivers/md/dm-bufio.h:12,
                 from ../drivers/md/dm-bufio.c:9:
../drivers/md/dm-bufio.c: In function 'alloc_buffer':
../include/linux/sched.h:1975:56: warning: 'noio_flag' may be used uninitialized in this function [-Wmaybe-uninitialized]
  current->flags = (current->flags & ~PF_MEMALLOC_NOIO) | flags;
                   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~
../drivers/md/dm-bufio.c:325:11: note: 'noio_flag' was declared here

The warning disappeared on later kernels with this commit: be0c37c985ed
("MIPS: Rearrange PTE bits into fixed positions.")  I assume this only
happened because it changed some inlining decisions.

On 3.18.y, we can shut up the warning by adding an extra initialization.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/md/dm-bufio.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index ecbd3ffcf359..91fe43b98c96 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -349,6 +349,7 @@ static void *alloc_buffer_data(struct dm_bufio_client *c, gfp_t gfp_mask,
 	 * as if GFP_NOIO was specified.
 	 */
 
+	noio_flag = 0;
 	if (gfp_mask & __GFP_NORETRY)
 		noio_flag = memalloc_noio_save();
 
-- 
2.9.0
