From: Josef Bacik <jbacik@fb.com>
Subject: Re: [PATCH] dm-log-writes: fix bug with too large bios
Date: Fri, 27 May 2016 11:36:34 -0400
Message-ID: <df07797a-6543-1e12-4692-60f471cdb0c5@fb.com>
References: <alpine.LRH.2.02.1605271047280.2109@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.02.1605271047280.2109@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>, Mike Snitzer <msnitzer@redhat.com>
Cc: dm-devel@redhat.com, James Johnston <johnstonj.public@codenest.com>, 'Eric Wheeler' <bcache@lists.ewheeler.net>, 'Tim Small' <tim@buttersideup.com>, 'Kent Overstreet' <kent.overstreet@gmail.com>, linux-bcache@vger.kernel.org, dm-crypt@saout.de, 'Neil Brown' <neilb@suse.com>, linux-raid@vger.kernel.org
List-Id: dm-devel.ids

On 05/27/2016 10:51 AM, Mikulas Patocka wrote:
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

Reviewed-by: Josef Bacik <jbacik@fb.com>

Thanks,

Josef
