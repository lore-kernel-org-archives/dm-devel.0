From: Adrian Bunk <bunk@stusta.de>
Subject: [-mm patch] drivers/md/Kconfig: fix BLOCK dependency
Date: Fri, 1 Sep 2006 15:50:55 +0200
Message-ID: <20060901135055.GA18276@stusta.de>
References: <20060901015818.42767813.akpm@osdl.org> <44F80F0D.70100@zen.co.uk>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <44F80F0D.70100@zen.co.uk>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Grant Wilson <grant.wilson@zen.co.uk>, David Howells <dhowells@redhat.com>, Jens Axboe <axboe@kernel.dk>
Cc: Andrew Morton <akpm@osdl.org>, dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Fri, Sep 01, 2006 at 11:44:29AM +0100, Grant Wilson wrote:
> Andrew Morton wrote:
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.18-rc5/2.6.18-rc5-mm1/
> [snip]
> >  The CONFIG_BLOCK changes wrecked these.
> 
> The CONFIG_BLOCK changes also seem to prevent the selection of any RAID
> or LVM drivers...

Thanks for the bug report, patch below.

> Cheers,
> Grant

cu
Adrian


<--  snip  -->


Signed-off-by: Adrian Bunk <bunk@stusta.de>

--- linux-2.6.18-rc5-mm1/drivers/md/Kconfig.old	2006-09-01 15:47:10.000000000 +0200
+++ linux-2.6.18-rc5-mm1/drivers/md/Kconfig	2006-09-01 15:47:16.000000000 +0200
@@ -2,7 +2,7 @@
 # Block device driver configuration
 #
 
-if CONFIG_BLOCK
+if BLOCK
 
 menu "Multi-device support (RAID and LVM)"
 
