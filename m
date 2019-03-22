From: John Dorminy <jdorminy@redhat.com>
Subject: Re: [PATCH] dm: rename max_io_len to io_boundary
Date: Fri, 22 Mar 2019 11:48:24 -0400
Message-ID: <CAMeeMh9kvpLhrL3KKx_+yNNzGdrgzpwyA_08dNzt+BRC0pPSFA@mail.gmail.com>
References: <alpine.LRH.2.02.1903211646170.994@file01.intranet.prod.int.rdu2.redhat.com>
	<CAMeeMh8Sed3ZN5wew6epsNJghzXgQ9Krsku-TSsLEGrHLACTnQ@mail.gmail.com>
	<alpine.LRH.2.02.1903220916180.23974@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.2.02.1903220916180.23974@file01.intranet.prod.int.rdu2.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Mike Snitzer <msnitzer@redhat.com>, device-mapper development <dm-devel@redhat.com>, Alasdair Kergon <agk@redhat.com>, Ming Lei <ming.lei@redhat.com>
List-Id: dm-devel.ids

Thank you! I had not encountered that useful function, it does exactly
what I want. You're the best!

On Fri, Mar 22, 2019 at 9:21 AM Mikulas Patocka <mpatocka@redhat.com> wrote:
>
>
>
> On Thu, 21 Mar 2019, John Dorminy wrote:
>
> > I'm thankful for this change making it explicit that this parameter is
> > not a max IO length but something else. I've been confused by the name
> > more than once when trying to figure out why IOs weren't coming in as
> > large as I expected. I wish there were a way for targets to say "I can
> > accept IO of up to $len" without saying "I want my IO split if it
> > crosses a multiple of $len, no matter what size it is", and I'm
> > thankful for this step making it easier if I ever act on that wish...
>
> If you want to limit the size of incoming bios, you can use
> dm_accept_partial_bio.
>
> dm_accept_partial_bio accepts a bio and a length. It will reduce the bio
> to the specified length and send the rest of data in another bio.
>
> See this piece of code in the function crypt_map:
>         /*
>          * Check if bio is too large, split as needed.
>          */
>         if (unlikely(bio->bi_iter.bi_size > (BIO_MAX_PAGES << PAGE_SHIFT)) &&
>             (bio_data_dir(bio) == WRITE || cc->on_disk_tag_size))
>                 dm_accept_partial_bio(bio, ((BIO_MAX_PAGES << PAGE_SHIFT) >> SECTOR_SHIFT));
>
>
> Mikulas
