From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH] remove unneded lock_kernel in
	drivers/md/dm.c and use unlocked_ioctl.
Date: Tue, 14 Aug 2007 21:12:20 +0100
Message-ID: <20070814201220.GA30122@agk.fab.redhat.com>
References: <11858486294133-git-send-email-diego@woitasen.com.ar>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <11858486294133-git-send-email-diego@woitasen.com.ar>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Diego Woitasen <diego@woitasen.com.ar>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Mon, Jul 30, 2007 at 11:23:49PM -0300, Diego Woitasen wrote:
> -static int dm_blk_ioctl(struct inode *inode, struct file *file,
> -			unsigned int cmd, unsigned long arg)
> +static long dm_blk_ioctl(struct file *file, unsigned int cmd, unsigned long arg)

> -	/* We don't really need this lock, but we do need 'inode'. */
> -	unlock_kernel();
> +	inode = file->f_path.dentry->d_inode;

Have the call paths that pass a NULL 'file' parameter down all been
changed?  If not, perhaps pass the 'inode' parameter into
unlocked_ioctl(), as happens with ioctl(), to get rid of the lock.

Alasdair
-- 
agk@redhat.com
