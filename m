From: Milan Broz <mbroz@redhat.com>
Subject: Re: Re: [PATCH] dm: fix freeze_bdev() return value check
Date: Tue, 25 Sep 2007 17:52:29 +0200
Message-ID: <46F92EBD.9090007@redhat.com>
References: <20070924105636.GA30406@APFDCB5C>
	<961aa3350709250723q14308a41hfebbae60e0cabe53@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <961aa3350709250723q14308a41hfebbae60e0cabe53@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>
List-Id: dm-devel.ids

Akinobu Mita wrote:
> 2007/9/24, Akinobu Mita <akinobu.mita@gmail.com>:
>> freeze_bdev() does not return errno as pointer on failure.
>> This patch fixes the return value check.
> 
...
> But there is no reason to check the return value with IS_ERR().
> Because freeze_bdev return NULL or valid super block

Yes, but there is another place in kernel using this check
(see /fs/xfs/xfs_fsops.c)

Probably question for Christoph Hellwig - some changes related to
returning error in frezze_bdev() were planned but never commited.
(see list archive)

Otherwise test for IS_ERR() should be removed.

Milan
--
mbroz@redhat.com

> 
> Subject: [PATCH] dm: remove freeze_bdev() return value check
> From: Akinobu Mita <akinobu.mita@gmail.com>
> 
> There is no reason to check the return value with IS_ERR().
> Because freeze_bdev return NULL or valid super block.
> 
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> 
> ---
>  drivers/md/dm.c |    7 -------
>  1 file changed, 7 deletions(-)
> 
> Index: 2.6-git/drivers/md/dm.c
> ===================================================================
> --- 2.6-git.orig/drivers/md/dm.c
> +++ 2.6-git/drivers/md/dm.c
> @@ -1290,16 +1290,9 @@ out:
>   */
>  static int lock_fs(struct mapped_device *md)
>  {
> -	int r;
> -
>  	WARN_ON(md->frozen_sb);
> 
>  	md->frozen_sb = freeze_bdev(md->suspended_bdev);
> -	if (IS_ERR(md->frozen_sb)) {
> -		r = PTR_ERR(md->frozen_sb);
> -		md->frozen_sb = NULL;
> -		return r;
> -	}
> 
>  	set_bit(DMF_FROZEN, &md->flags);
> 
