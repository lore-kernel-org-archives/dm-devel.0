From: Song Liu <song@kernel.org>
Subject: Re: [PATCH 05/12] md: update the optimal I/O size on reshape
Date: Fri, 11 Sep 2020 23:17:28 -0700
Message-ID: <CAPhsuW56nRgq_hAs4zdg+qabVsbyYkmZk2+4+4ykzbg0Aa=W2g@mail.gmail.com>
References: <20200910144833.742260-1-hch@lst.de> <20200910144833.742260-6-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200910144833.742260-6-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Hans de Goede <hdegoede@redhat.com>, Richard Weinberger <richard@nod.at>, Minchan Kim <minchan@kernel.org>, linux-mtd@lists.infradead.org, dm-devel@redhat.com, linux-block@vger.kernel.org, open list <linux-kernel@vger.kernel.org>, drbd-dev@lists.linbit.com, linux-raid <linux-raid@vger.kernel.org>, Linux-Fsdevel <linux-fsdevel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>, cgroups@vger.kernel.org
List-Id: dm-devel.ids

On Thu, Sep 10, 2020 at 7:48 AM Christoph Hellwig <hch@lst.de> wrote:
>
> The raid5 and raid10 drivers currently update the read-ahead size,
> but not the optimal I/O size on reshape.  To prepare for deriving the
> read-ahead size from the optimal I/O size make sure it is updated
> as well.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: Song Liu <song@kernel.org>
