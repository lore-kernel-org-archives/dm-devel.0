From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: commit 6d2a78e783416ba99e36beb1d4395b785b34e867
	avoids dm integrity support
Date: Mon, 30 Mar 2009 20:59:45 +0200
Message-ID: <20090330185945.GA5178@kernel.dk>
References: <49D06571.70903@ct.jp.nec.com> <yq1k566x3cn.fsf@sermon.lab.mkp.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <yq1k566x3cn.fsf@sermon.lab.mkp.net>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: device-mapper development <dm-devel@redhat.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Mon, Mar 30 2009, Martin K. Petersen wrote:
> >>>>> "Kiyoshi" == Kiyoshi Ueda <k-ueda@ct.jp.nec.com> writes:
> 
> Kiyoshi> I found this commit (6d2a78e783416ba99e36beb1d4395b785b34e867)
> Kiyoshi> in the recent Linus's git makes every block device share single
> Kiyoshi> mempool for integrity cloning.
> 
> Yeah, until this patch went in I had the integrity stuff hanging off of
> the bio_set to avoid the deadlocks you mention.  When this issue came up
> a few weeks ago Jens suggested the changes in the commit above:
> 
> 	http://marc.info/?l=linux-kernel&m=123662652229483

Well, then suggestions there talk about slab reuse, it still needs
private mempools. The forward progress reference failed to take stacked
drivers into account, I didn't realize that they need to allocate
integrity data again as well. It's a shame, since the commit in question
is otherwise a nice cleanup of the integrity stuff. Apparently the patch
wasn't reviewed well enough, I'll take the blame on that.

> I just talked to him and we're going to back this patch for now.  Short
> term I guess we'll have to settle for a separate pool in the bio_set for
> integrity vectors.

Perhaps it would be cleaner to make the integrity allocation more
explicit in the supported paths, instead of hiding it in bio_set? Dunno,
haven't thought much about it, just an alternative approach

-- 
Jens Axboe
