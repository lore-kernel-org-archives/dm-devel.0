From: "Kani, Toshi" <toshi.kani-ZPxbGqLxI0U@public.gmane.org>
Subject: Re: [PATCH v3 1/3] pmem: only set QUEUE_FLAG_DAX for fsdax mode
Date: Tue, 26 Jun 2018 21:23:29 +0000
Message-ID: <1530048093.14039.286.camel@hpe.com>
References: <20180626175932.8899-1-ross.zwisler@linux.intel.com>
 <20180626175932.8899-2-ross.zwisler@linux.intel.com>
 <CAPcyv4iWgPnHmBKhUvhManC6UL9CkLqN_d8vBo6KmcPJdPzuUw@mail.gmail.com>
 <20180626185830.GA7171@redhat.com>
 <CAPcyv4h6HO6fs6k7QMD77jkz2djCeWCtWomCdNb0-1Q4VKanqw@mail.gmail.com>
 <20180626191346.GA7233@redhat.com> <1530046327.14039.273.camel@hpe.com>
 <CAPcyv4hP_Y3xdyCa-UkYCMJ5OtnjnkwPZDS2Z2Ge8+5ymBONwQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <CAPcyv4hP_Y3xdyCa-UkYCMJ5OtnjnkwPZDS2Z2Ge8+5ymBONwQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Content-ID: <75043E6597155E4E8B827A7631A8CDEC-mmYPd6ayCNGroOM5E8FhRbjFIynDaujOfM0AETQt39g@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: "dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org" <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: dm-devel.ids

On Tue, 2018-06-26 at 14:02 -0700, Dan Williams wrote:
> On Tue, Jun 26, 2018 at 1:54 PM, Kani, Toshi <toshi.kani-ZPxbGqLxI0U@public.gmane.org> wrote:
> > On Tue, 2018-06-26 at 15:13 -0400, Mike Snitzer wrote:
> > > On Tue, Jun 26 2018 at  3:07pm -0400,
> > > Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> > > 
> > > > On Tue, Jun 26, 2018 at 11:58 AM, Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> > > > > On Tue, Jun 26 2018 at  2:52pm -0400,
> > > > > Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> > > > > 
> > > > > > On Tue, Jun 26, 2018 at 10:59 AM, Ross Zwisler
> > > > > > <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote:
> > > > > > > QUEUE_FLAG_DAX is an indication that a given block device supports
> > > > > > > filesystem DAX and should not be set for PMEM namespaces which are in "raw"
> > > > > > > or "sector" modes.  These namespaces lack struct page and are prevented
> > > > > > > from participating in filesystem DAX.
> > > > > > > 
> > > > > > > Signed-off-by: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> > > > > > > Suggested-by: Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > > > > > > Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > > > > > 
> > > > > > Why is this cc: stable? What is the user visible impact of this change
> > > > > > especially given the requirement to validate QUEUE_FLAG_DAX with
> > > > > > bdev_dax_supported()? Patch looks good, but it's just a cosmetic fixup
> > > > > > afaics.
> > > > > 
> > > > > This isn't cosmetic when you consider that stacking up a DM device is
> > > > > looking at this flag to determine whether a table does or does _not_
> > > > > support DAX.
> > > > > 
> > > > > So this patch, in conjunction with the other changes in the series, is
> > > > > certainly something I'd consider appropriate for stable.
> > > > 
> > > > I think this classifies as something that never worked correctly and
> > > > is not a regression. It does not identify which commit it is repairing
> > > > or the user visible failure mode.
> > > 
> > > So you're taking issue with making stacked dax configs work in older
> > > kernels?  That's fine.  We can drop the stable cc if you like.
> > > 
> > > But I mean we intended for this to work.. so the Fixes commit references
> > > can easily be added, e.g.: 545ed20e6df68a4d2584a29a2a28ee8b2f7e9547
> > > ("dm: add infrastructure for DAX support")
> > 
> > When this dm change was made, the pmem driver supported DAX for both raw
> > and memory modes (note: sector mode does not use the pmem driver).  I
> > think the issue was introduced when we dropped DAX support from raw
> > mode.
> 
> Still DAX with raw mode never really worked any way. It was also
> something that was broken from day one. So what happens to someone who
> happened to avoid all the problems with page-less DAX and enabled
> device-mapper on top? That failure mode detail needs to be added to
> this changelog if we want to propose this for -stable.

My point is that the behavior should be consistent between pmem and
device-mapper.  When -o dax succeeds on a pmem, then it should succeed
on a device-mapper on top of that pmem.

Has the drop of dax support from raw mode made to -stable back to the
baseline accepted 545ed20e6df6?  It will introduce inconsistency,
otherwise.

Thanks,
-Toshi
