From: Andrew Morton <akpm@osdl.org>
Subject: Re: Help tracking down problem --- endless loop in
 __find_get_block_slow
Date: Tue, 22 Feb 2005 15:28:33 -0800
Message-ID: <20050222152833.75fb79a2.akpm@osdl.org>
References: <4219BC1A.1060007@zensonic.dk>
	<20050222011821.2a917859.akpm@osdl.org> <421BB65F.7040306@suse.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
In-Reply-To: <421BB65F.7040306@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jeff Mahoney <jeffm@suse.com>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

Jeff Mahoney <jeffm@suse.com> wrote:
>
> In my experience, the loop is actually outside of
> __find_get_block_slow(), in __getblk_slow(). I've been using xmon to
> interrupt the kernel, and the results vary but are all rooted in the
> for(;;) loop in __getblk_slow. It appears as though grow_buffers is
> finding/creating the page, but then __find_get_block can't locate the
> buffer it needs.

Yes, that'll happen.  Because there are still buffers attached to the page
which have the wrong blocksize.  Say, if someone is trying to read a 2k
buffer_head which is backed by a page which already has 1k buffer_heads
attached to it.

Does your kernel not have that big printk in __find_get_block_slow()?  If
it does, maybe some of the buffers are unmapped.  Try:

--- 25/fs/buffer.c~a	Tue Feb 22 15:27:35 2005
+++ 25-akpm/fs/buffer.c	Tue Feb 22 15:27:41 2005
@@ -456,7 +456,7 @@ __find_get_block_slow(struct block_devic
 	 * file io on the block device and getblk.  It gets dealt with
 	 * elsewhere, don't buffer_error if we had some unmapped buffers
 	 */
-	if (all_mapped) {
+	{
 		printk("__find_get_block_slow() failed. "
 			"block=%llu, b_blocknr=%llu\n",
 			(unsigned long long)block, (unsigned long long)bh->b_blocknr);
_
