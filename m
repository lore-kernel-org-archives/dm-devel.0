From: Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 3/7] dm: fix test for DAX device support
Date: Fri, 1 Jun 2018 16:46:04 -0400
Message-ID: <20180601204604.GB1144@redhat.com>
References: <20180529195106.14268-1-ross.zwisler@linux.intel.com>
 <20180529195106.14268-4-ross.zwisler@linux.intel.com>
 <20180601201924.GA1144@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180601201924.GA1144-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: dm-devel.ids

On Fri, Jun 01 2018 at  4:19P -0400,
Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> On Tue, May 29 2018 at  3:51P -0400,
> Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote:
> 
> > Currently device_supports_dax() just checks to see if the QUEUE_FLAG_DAX
> > flag is set on the device's request queue to decide whether or not the
> > device supports filesystem DAX.  This is insufficient because there are
> > devices like PMEM namespaces in raw mode which have QUEUE_FLAG_DAX set but
> > which don't actually support DAX.
> 
> Isn't that a PMEM bug then?
> 
> What is the point of setting QUEUE_FLAG_DAX if it cannot be trusted?
>  
> > This means that you could create a dm-linear device, for example, where the
> > first part of the dm-linear device was a PMEM namespace in fsdax mode and
> > the second part was a PMEM namespace in raw mode.  Both DM and the
> > filesystem you put on that dm-linear device would think the whole device
> > supports DAX, which would lead to bad behavior once your raw PMEM namespace
> > part using DAX needed struct page for something.
> 
> The PMEM namespace in raw mode shouldn't be setting QUEUE_FLAG_DAX, if
> it didn't then the stacked-up linear DM wouldn't 
> 
> > Fix this by using bdev_dax_supported() like filesystems do at mount time.
> > This checks for raw mode and also performs other tests like checking to
> > make sure the dax_direct_access() path works.
> 
> Sorry "This" does those things where?

I see you meant bdev_dax_supported() does these additional checks.

My previous question stands though.  Why is QUEUE_FLAG_DAX getting set
if the device hasn't already passed these checks?  Shouldn't setting
QUEUE_FLAG_DAX on request_queue depend on bdev_dax_supported() passing?

But looking at the drivers that do set QUEUE_FLAG_DAX: they
don't have the bdev readily available.  Anyway, just strikes me as
bizarre that a driver can set QUEUE_FLAG_DAX without having to have
ensured bdev_dax_supported() passes (even if not programatically, but
that the developer has verified the hooks, et al exist).

But I'll give up on this line of questioning..

My dilemma now is: how do I take these changes without first rebasing
linux-dm.git ontop of Darrick's xfs tree?

I probably should've reviewed faster and been the one to take the entire
set (with appropriate acks obviously).
