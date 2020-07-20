From: Richard Weinberger <richard.weinberger@gmail.com>
Subject: Re: [PATCH 04/14] bdi: initialize ->ra_pages in bdi_init
Date: Mon, 20 Jul 2020 13:58:22 +0200
Message-ID: <CAFLxGvxNHGEOrj6nKTtDeiU+Rx4xv_6asjSQYcFWXhk5m=1cBA@mail.gmail.com>
References: <20200720075148.172156-1-hch@lst.de> <20200720075148.172156-5-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20200720075148.172156-5-hch@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Song Liu <song@kernel.org>, Hans de Goede <hdegoede@redhat.com>, Richard Weinberger <richard@nod.at>, linux-mtd@lists.infradead.org, device-mapper development <dm-devel@redhat.com>, linux-block@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, drbd-dev@lists.linbit.com, linux-raid@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-mm@kvack.org, cgroups mailinglist <cgroups@vger.kernel.org>
List-Id: dm-devel.ids

Hello Chrstoph,

On Mon, Jul 20, 2020 at 9:53 AM Christoph Hellwig <hch@lst.de> wrote:
>
> Set up a readahead size by default.  This changes behavior for mtd,
> ubifs, and vboxsf to actually enabled readahead, the lack of which
> very much looks like an oversight.

UBIFS doesn't enable readahead on purpose, please see:
http://www.linux-mtd.infradead.org/doc/ubifs.html#L_readahead

-- 
Thanks,
//richard
