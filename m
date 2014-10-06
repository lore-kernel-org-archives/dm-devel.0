From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v2 4/4] dm: use bioset_create_nobvec()
Date: Sun, 5 Oct 2014 20:24:49 -0400
Message-ID: <20141006002449.GA31993@redhat.com>
References: <20141003204852.GA14135@redhat.com>
	<1412371633-30356-4-git-send-email-snitzer@redhat.com>
	<5431CF03.406@ce.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <5431CF03.406@ce.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Junichi Nomura <j-nomura@ce.jp.nec.com>
Cc: Jens Axboe <axboe@kernel.dk>, device-mapper development <dm-devel@redhat.com>, Kent Overstreet <kmo@daterainc.com>
List-Id: dm-devel.ids

On Sun, Oct 05 2014 at  7:06pm -0400,
Junichi Nomura <j-nomura@ce.jp.nec.com> wrote:

> On 10/04/14 06:27, Mike Snitzer wrote:
> > @@ -3021,7 +3021,7 @@ struct dm_md_mempools *dm_alloc_md_mempools(unsigned type, unsigned integrity, u
> >  	if (!pools->io_pool)
> >  		goto out;
> >  
> > -	pools->bs = bioset_create(pool_size, front_pad);
> > +	pools->bs = bioset_nobvec_create(pool_size, front_pad);
> >  	if (!pools->bs)
> >  		goto out;
> 
> Hi Mike,
> 
> thank you for the rename. It's better.
> But we have to s/nobvec_create/create_nobvec/ here, too.

Oops, thanks for letting me know.  I've fixed it and rebased
linux-dm.git's for-next branch ontop of linux-block's for-3.18/core
since Jens staged your 2 block patches.
