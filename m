From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v6 4/6] dm,dax: Add dax zero_page_range operation
Date: Thu, 2 Apr 2020 21:02:32 -0400
Message-ID: <20200403010231.GA4475@redhat.com>
References: <20200228163456.1587-1-vgoyal@redhat.com>
 <20200228163456.1587-5-vgoyal@redhat.com>
 <CAPcyv4iWfL+KQjjUXqrTKOL8F4M05Vu=imm5tqsD6MO=XLzoMA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAPcyv4iWfL+KQjjUXqrTKOL8F4M05Vu=imm5tqsD6MO=XLzoMA@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, Christoph Hellwig <hch@infradead.org>, david <david@fromorbit.com>, jmoyer <jmoyer@redhat.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Tue, Mar 31 2020 at  3:34pm -0400,
Dan Williams <dan.j.williams@intel.com> wrote:

> [ Add Mike ]
> 
> On Fri, Feb 28, 2020 at 8:35 AM Vivek Goyal <vgoyal@redhat.com> wrote:
> >
> > This patch adds support for dax zero_page_range operation to dm targets.
> 
> Mike,
> 
> Sorry, I should have pinged you earlier, but could you take a look at
> this patch and ack it if it looks ok to go through the nvdimm tree
> with the rest of the series?

Yes, looks fine to me.

Acked-by: Mike Snitzer <snitzer@redhat.com>
