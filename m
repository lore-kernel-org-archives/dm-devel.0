From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Re: [PATCH] dm: fix freeze_bdev() return value check
Date: Tue, 25 Sep 2007 16:56:24 +0100
Message-ID: <20070925155624.GA28595@infradead.org>
References: <20070924105636.GA30406@APFDCB5C>
	<961aa3350709250723q14308a41hfebbae60e0cabe53@mail.gmail.com>
	<46F92EBD.9090007@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <46F92EBD.9090007@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Milan Broz <mbroz@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Tue, Sep 25, 2007 at 05:52:29PM +0200, Milan Broz wrote:
> Akinobu Mita wrote:
> > 2007/9/24, Akinobu Mita <akinobu.mita@gmail.com>:
> >> freeze_bdev() does not return errno as pointer on failure.
> >> This patch fixes the return value check.
> > 
> ...
> > But there is no reason to check the return value with IS_ERR().
> > Because freeze_bdev return NULL or valid super block
> 
> Yes, but there is another place in kernel using this check
> (see /fs/xfs/xfs_fsops.c)
> 
> Probably question for Christoph Hellwig - some changes related to
> returning error in frezze_bdev() were planned but never commited.
> (see list archive)
> 
> Otherwise test for IS_ERR() should be removed.

The plan was to change freeze_bdev to do a trylock un s_umount_sem
and return SBUSY if it fails to avoid the deadlock scenario where
people called xfs_freeze and got another freeze request from dm.

I don't remember why this never got it, it's probably worth sending
a patch like this again.
