From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH v6 4/6] dm,dax: Add dax zero_page_range operation
Date: Thu, 2 Apr 2020 17:49:56 -0700
Message-ID: <CAPcyv4h=xQRPBwfy6xMjUONk41aO0xBYHpu9auSHdG17CWdv=g@mail.gmail.com>
References: <20200228163456.1587-1-vgoyal@redhat.com> <20200228163456.1587-5-vgoyal@redhat.com>
 <CAPcyv4iWfL+KQjjUXqrTKOL8F4M05Vu=imm5tqsD6MO=XLzoMA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <CAPcyv4iWfL+KQjjUXqrTKOL8F4M05Vu=imm5tqsD6MO=XLzoMA@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, Christoph Hellwig <hch@infradead.org>, david <david@fromorbit.com>, jmoyer <jmoyer@redhat.com>, device-mapper development <dm-devel@redhat.com>, Mike Snitzer <msnitzer@redhat.com>
List-Id: dm-devel.ids

On Tue, Mar 31, 2020 at 12:34 PM Dan Williams <dan.j.williams@intel.com> wrote:
>
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

I'm going to proceed with pushing this into -next to get more exposure
and check back later next week about pushing it to Linus. It looks
good to me and it unblocks Vivek on his virtio-fs work, but still
don't want to push device-mapper bits without device-mapper maintainer
Ack.
