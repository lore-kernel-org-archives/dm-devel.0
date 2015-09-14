From: walter harms <wharms@bfs.de>
Subject: Re: [dm-devel] [PATCH 12/39] dm: drop null test before destroy functions
Date: Mon, 14 Sep 2015 16:23:39 +0200
Message-ID: <55F6D86B.3000304@bfs.de>
References: <1442146532-9100-1-git-send-email-Julia.Lawall@lip6.fr> <1442146532-9100-13-git-send-email-Julia.Lawall@lip6.fr> <alpine.LRH.2.02.1509140932400.7970@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: wharms@bfs.de
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.02.1509140932400.7970@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, kernel-janitors@vger.kernel.org, Neil Brown <neilb@suse.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, sergey.senozhatsky@gmail.com
List-Id: dm-devel.ids



Am 14.09.2015 15:46, schrieb Mikulas Patocka:
> 
> On Sun, 13 Sep 2015, Julia Lawall wrote:
> 
>> > Remove unneeded NULL test.
>> > 
>> > The semantic patch that makes this change is as follows:
>> > (http://coccinelle.lip6.fr/)
>> > 
>> > // <smpl>
>> > @@ expression x; @@
>> > -if (x != NULL)
>> >   \(kmem_cache_destroy\|mempool_destroy\|dma_pool_destroy\)(x);
>> > // </smpl>
>> > 
>> > Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
>> > 
>> > ---
>> >  drivers/md/dm-bufio.c              |    3 +--
>> >  drivers/md/dm-cache-target.c       |    3 +--
>> >  drivers/md/dm-crypt.c              |    6 ++----
>> >  drivers/md/dm-io.c                 |    3 +--
>> >  drivers/md/dm-log-userspace-base.c |    3 +--
>> >  drivers/md/dm-region-hash.c        |    4 +---
>> >  drivers/md/dm.c                    |   13 ++++---------
>> >  7 files changed, 11 insertions(+), 24 deletions(-)
>> > 
>> > diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
>> > index 83cc52e..8ad39b6 100644
>> > --- a/drivers/md/dm-bufio.c
>> > +++ b/drivers/md/dm-bufio.c
>> > @@ -1864,8 +1864,7 @@ static void __exit dm_bufio_exit(void)
>> >  	for (i = 0; i < ARRAY_SIZE(dm_bufio_caches); i++) {
>> >  		struct kmem_cache *kc = dm_bufio_caches[i];
>> >  
>> > -		if (kc)
>> > -			kmem_cache_destroy(kc);
>> > +		kmem_cache_destroy(kc);
>> >  	}


maybe you want to remove "kc" also
by calling kmem_cache_destroy(dm_bufio_caches[i]); directly ?

just a hint,
 wh
