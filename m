From: Richard Weinberger <richard.weinberger@gmail.com>
Subject: Re: [PATCH 04/14] bdi: initialize ->ra_pages in bdi_init
Date: Mon, 20 Jul 2020 23:27:57 +0200
Message-ID: <CAFLxGvyxtYnJ5UdD18uNA97zQaDB8-Wv8MHQn2g9GYD74v7cTg@mail.gmail.com>
References: <20200720075148.172156-1-hch@lst.de> <20200720075148.172156-5-hch@lst.de>
 <CAFLxGvxNHGEOrj6nKTtDeiU+Rx4xv_6asjSQYcFWXhk5m=1cBA@mail.gmail.com>
 <20200720120734.GA29061@lst.de> <2827a5dbd94bc5c2c1706a6074d9a9a32a590feb.camel@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <2827a5dbd94bc5c2c1706a6074d9a9a32a590feb.camel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, linux-raid@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>, Richard Weinberger <richard@nod.at>, LKML <linux-kernel@vger.kernel.org>, linux-block@vger.kernel.org, Song Liu <song@kernel.org>, device-mapper development <dm-devel@redhat.com>, linux-mtd@lists.infradead.org, linux-mm@kvack.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, cgroups mailinglist <cgroups@vger.kernel.org>, drbd-dev@lists.linbit.com
List-Id: dm-devel.ids

On Mon, Jul 20, 2020 at 2:37 PM Artem Bityutskiy <dedekind1@gmail.com> wrote:
>
> On Mon, 2020-07-20 at 14:07 +0200, Christoph Hellwig wrote:
> > What about jffs2 and blk2mtd raw block devices?

I don't worry much about blk2mtd.

> If my memory serves me correctly JFFS2 did not mind readahead.

This covers my knowledge too.
I fear enabling readahead on JFFS2 will cause performance issues, this
filesystem
is mostly used on small and slow NOR devices.

-- 
Thanks,
//richard
