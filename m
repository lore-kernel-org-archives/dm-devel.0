From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v6 1/6] pmem: Add functions for reading/writing page
 to/from pmem
Date: Wed, 4 Mar 2020 13:44:41 -0500
Message-ID: <20200304184441.GE21542@redhat.com>
References: <20200228163456.1587-1-vgoyal@redhat.com>
 <20200228163456.1587-2-vgoyal@redhat.com>
 <CAM9Jb+gJWH_bC-9fgGdeP5LaSVjJ3JgTnjBxpRJMfe6vbTPOTA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAM9Jb+gJWH_bC-9fgGdeP5LaSVjJ3JgTnjBxpRJMfe6vbTPOTA@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org, hch@infradead.org, dan.j.williams@intel.com, david@fromorbit.com, dm-devel@redhat.com, Christoph Hellwig <hch@lst.de>
List-Id: dm-devel.ids

On Sat, Feb 29, 2020 at 09:04:00AM +0100, Pankaj Gupta wrote:
> On Fri, 28 Feb 2020 at 17:35, Vivek Goyal <vgoyal@redhat.com> wrote:
> >
> > This splits pmem_do_bvec() into pmem_do_read() and pmem_do_write().
> > pmem_do_write() will be used by pmem zero_page_range() as well. Hence
> > sharing the same code.
> >
> > Suggested-by: Christoph Hellwig <hch@infradead.org>
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> > ---
> >  drivers/nvdimm/pmem.c | 86 +++++++++++++++++++++++++------------------
> >  1 file changed, 50 insertions(+), 36 deletions(-)
> >
> > diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
> > index 4eae441f86c9..075b11682192 100644
> > --- a/drivers/nvdimm/pmem.c
> > +++ b/drivers/nvdimm/pmem.c
> > @@ -136,9 +136,25 @@ static blk_status_t read_pmem(struct page *page, unsigned int off,
> >         return BLK_STS_OK;
> >  }
> >
> > -static blk_status_t pmem_do_bvec(struct pmem_device *pmem, struct page *page,
> > -                       unsigned int len, unsigned int off, unsigned int op,
> > -                       sector_t sector)
> > +static blk_status_t pmem_do_read(struct pmem_device *pmem,
> > +                       struct page *page, unsigned int page_off,
> > +                       sector_t sector, unsigned int len)
> > +{
> > +       blk_status_t rc;
> > +       phys_addr_t pmem_off = sector * 512 + pmem->data_offset;
> 
> minor nit,  maybe 512 is replaced by macro? Looks like its used at multiple
> places, maybe can keep at is for now.

This came from existing code. If I end up spinning this patch series
again, I will replace it with (sector << SECTOR_SHIFT).

Thanks
Vivek
