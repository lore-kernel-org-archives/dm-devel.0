From: Andrew Morton <akpm@osdl.org>
Subject: Re: Help tracking down problem --- endless loop in
 __find_get_block_slow
Date: Wed, 23 Feb 2005 04:10:36 -0800
Message-ID: <20050223041036.5f5df2ff.akpm@osdl.org>
References: <4219BC1A.1060007@zensonic.dk>
	<20050222011821.2a917859.akpm@osdl.org>
	<20050223120013.GA28169@zensonic.dk>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
In-Reply-To: <20050223120013.GA28169@zensonic.dk>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Thomas S. Iversen" <zensonic@zensonic.dk>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

zensonic@zensonic.dk (Thomas S. Iversen) wrote:
>
> > >  dd if=/dev/zero of=/mnt/testfile count=N, N>6
> 
> It turns out N>6 is variable. But large enough and it will hang. Sugests
> some kind of race I am afraid.
> 
> > >  I get into an endless loop in __find_get_block_slow. 
> > 
> > The only way in which __find_get_block_slow() can loop is if something
> > wrecked the buffer_head ring at page->private: something caused an internal
> > loop via bh->b_this_page.
> > 
> > Are you sure that's where things are hanging?  That it's not stuck on a
> > spinlock?
> 
> I get the same message again and again all over (this trace with
> count=100 and a BUG() and panic inserted into buffer.c)
> 
> Feb 23 13:38:34 localhost kernel: __find_get_block_slow() failed.
> block=101, b_blocknr=100
> Feb 23 13:38:34 localhost kernel: b_state=0x00000010, b_size=2048
> Feb 23 13:38:34 localhost kernel: device blocksize: 2048

OK, so we're looking for the buffer_head for block 101 and the first
buffer_head which is attached to the page represents block 100.  So the
next buffer_head _should_ represent block 101.  Please print it out:

--- 25/fs/buffer.c~a	2005-02-23 04:06:12.000000000 -0800
+++ 25-akpm/fs/buffer.c	2005-02-23 04:06:51.000000000 -0800
@@ -459,8 +459,10 @@ __find_get_block_slow(struct block_devic
 	 */
 	if (all_mapped) {
 		printk("__find_get_block_slow() failed. "
-			"block=%llu, b_blocknr=%llu\n",
-			(unsigned long long)block, (unsigned long long)bh->b_blocknr);
+			"block=%llu, b_blocknr=%llu, next=%llu\n",
+			(unsigned long long)block,
+			(unsigned long long)bh->b_blocknr,
+			(unsigned long long)bh->b_this_page->b_blocknr);
 		printk("b_state=0x%08lx, b_size=%u\n", bh->b_state, bh->b_size);
 		printk("device blocksize: %d\n", 1 << bd_inode->i_blkbits);
 	}
_


> Ad inf. The output of the BUG() is show below. My questions remain:
> 
> 1. Whos fault is this?

Could be UFS.  But what does "transparent block encryption and sector
shuffling" mean?  How is the sector shuffling implemented?
