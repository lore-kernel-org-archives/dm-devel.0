From: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v3 1/3] pmem: only set QUEUE_FLAG_DAX for fsdax mode
Date: Tue, 26 Jun 2018 13:11:29 -0600
Message-ID: <20180626191129.GA18273@linux.intel.com>
References: <20180626175932.8899-1-ross.zwisler@linux.intel.com>
 <20180626175932.8899-2-ross.zwisler@linux.intel.com>
 <CAPcyv4iWgPnHmBKhUvhManC6UL9CkLqN_d8vBo6KmcPJdPzuUw@mail.gmail.com>
 <20180626185830.GA7171@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180626185830.GA7171-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-nvdimm <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, stable <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-xfs <linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, device-mapper development <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: dm-devel.ids

On Tue, Jun 26, 2018 at 02:58:30PM -0400, Mike Snitzer wrote:
> On Tue, Jun 26 2018 at  2:52pm -0400,
> Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> 
> > On Tue, Jun 26, 2018 at 10:59 AM, Ross Zwisler
> > <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote:
> > > QUEUE_FLAG_DAX is an indication that a given block device supports
> > > filesystem DAX and should not be set for PMEM namespaces which are in "raw"
> > > or "sector" modes.  These namespaces lack struct page and are prevented
> > > from participating in filesystem DAX.
> > >
> > > Signed-off-by: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> > > Suggested-by: Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > > Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > 
> > Why is this cc: stable? What is the user visible impact of this change
> > especially given the requirement to validate QUEUE_FLAG_DAX with
> > bdev_dax_supported()? Patch looks good, but it's just a cosmetic fixup
> > afaics.
> 
> This isn't cosmetic when you consider that stacking up a DM device is
> looking at this flag to determine whether a table does or does _not_
> support DAX.
> 
> So this patch, in conjunction with the other changes in the series, is
> certainly something I'd consider appropriate for stable.
> 
> Mike

Because in patch 3 of this series we now use the full bdev_dax_supported()
instead of just checking the queue flag in device_supports_dax(), I agree that
this isn't strictly necessary for stable.  device_supports_dax() will still
notice that the raw/sector namespaces don't support DAX because
bdev_dax_supported() will fail, and we'll end up doing the right thing and not
setting QUEUE_FLAG_DAX on the DM device.

I think maybe it's good to have in stable for completeness (and it's a very
small change), but if we drop it from stable the code will still do the right
thing AFAICT.
