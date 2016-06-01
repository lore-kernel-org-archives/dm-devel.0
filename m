From: "James Johnston" <johnstonj.public@codenest.com>
Subject: RE: [PATCH] dm-log-writes: fix bug with too large bios
Date: Wed, 1 Jun 2016 04:23:17 -0000
Message-ID: <07bf01d1bbbd$53991750$facb45f0$@codenest.com>
References: <alpine.LRH.2.02.1605271047280.2109@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.02.1605271047280.2109@file01.intranet.prod.int.rdu2.redhat.com>
Content-Language: en-us
Sender: linux-bcache-owner@vger.kernel.org
To: 'Mikulas Patocka' <mpatocka@redhat.com>, "'Alasdair G. Kergon'" <agk@redhat.com>, 'Mike Snitzer' <msnitzer@redhat.com>, 'Josef Bacik' <jbacik@fb.com>
Cc: dm-devel@redhat.com, 'Eric Wheeler' <bcache@lists.ewheeler.net>, 'Tim Small' <tim@buttersideup.com>, 'Kent Overstreet' <kent.overstreet@gmail.com>, linux-bcache@vger.kernel.org, dm-crypt@saout.de, 'Neil Brown' <neilb@suse.com>, linux-raid@vger.kernel.org
List-Id: dm-devel.ids

Hi Mikulas,

> bio_alloc can allocate a bio with at most BIO_MAX_PAGES (256) vector
> entries. However, the incoming bio may have more vector entries if it was
> allocated by other means. For example, bcache submits bios with more than
> BIO_MAX_PAGES entries. This results in bio_alloc failure.
> 
> To avoid the failure, change the code so that it allocates bio with at
> most BIO_MAX_PAGES entries. If the incoming bio has more entries,
> bio_add_page will fail and a new bio will be allocated - the code that
> handles bio_add_page failure already exists in the dm-log-writes target.
> 
> Also, move atomic_inc(&lc->io_blocks) before bio_alloc to fix a bug that
> the target hangs if bio_alloc fails. The error path does put_io_block(lc),
> so we must do atomic_inc(&lc->io_blocks) before invoking the error path to
> avoid underflow of lc->io_blocks.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> Cc: stable@vger.kernel.org	# v4.1+

How does this relate to the previous patch you made to dm-crypt?  How best
should I test this?  It looks like the dm-crypt patch fixed the problem.

Should I test by applying this patch ONLY and reverting the dm-crypt patch?
(i.e. does this patch also fix the problem.)  Or should I just test with
both patches applied simultaneously?

James
