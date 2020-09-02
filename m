From: Song Liu <song@kernel.org>
Subject: Re: [PATCH 9/9] block: remove revalidate_disk()
Date: Tue, 1 Sep 2020 22:59:52 -0700
Message-ID: <CAPhsuW7YKTHsWnqv22gq6VEz29=abYk7ADsxcQr9q3_kGZuiXw@mail.gmail.com>
References: <20200901155748.2884-1-hch@lst.de> <20200901155748.2884-10-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20200901155748.2884-10-hch@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Josef Bacik <josef@toxicpanda.com>, Dan Williams <dan.j.williams@intel.com>, dm-devel@redhat.com, "Martin K. Petersen" <martin.petersen@oracle.com>, open list <linux-kernel@vger.kernel.org>, linux-block@vger.kernel.org, nbd@other.debian.org, ceph-devel@vger.kernel.org, virtualization@lists.linux-foundation.org, linux-raid <linux-raid@vger.kernel.org>, linux-nvdimm@lists.01.org, linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, Linux-Fsdevel <linux-fsdevel@vger.kernel.org>
List-Id: dm-devel.ids

On Tue, Sep 1, 2020 at 9:00 AM Christoph Hellwig <hch@lst.de> wrote:
>
> Remove the now unused helper.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: Song Liu <song@kernel.org>
