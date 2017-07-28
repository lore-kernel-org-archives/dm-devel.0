From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [resend PATCH v2 11/33] dm: add dax_device and dax_operations
 support
Date: Fri, 28 Jul 2017 13:48:30 -0400
Message-ID: <20170728174830.GA13772@redhat.com>
References: <149245612770.10206.15496018295337908594.stgit@dwillia2-desk3.amr.corp.intel.com>
 <149245618859.10206.13182319600260215993.stgit@dwillia2-desk3.amr.corp.intel.com>
 <1501258623.2413.3.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1501258623.2413.3.camel@wdc.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "dan.j.williams@intel.com" <dan.j.williams@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "toshi.kani@hpe.com" <toshi.kani@hpe.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "hch@lst.de" <hch@lst.de>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
List-Id: dm-devel.ids

On Fri, Jul 28 2017 at 12:17pm -0400,
Bart Van Assche <Bart.VanAssche@wdc.com> wrote:

> On Mon, 2017-04-17 at 12:09 -0700, Dan Williams wrote:
> > diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
> > index b7767da50c26..1de8372d9459 100644
> > --- a/drivers/md/Kconfig
> > +++ b/drivers/md/Kconfig
> > @@ -200,6 +200,7 @@ config BLK_DEV_DM_BUILTIN
> >  config BLK_DEV_DM
> >  	tristate "Device mapper support"
> >  	select BLK_DEV_DM_BUILTIN
> > +	select DAX
> >  	---help---
> >  	  Device-mapper is a low level volume manager.  It works by allowing
> >  	  people to specify mappings for ranges of logical sectors.  Various
> 
> (replying to an e-mail of three months ago)
> 
> Hello Dan,
> 
> While building a v4.12 kernel I noticed that enabling device mapper support
> now unconditionally enables DAX. I think there are plenty of systems that use
> dm but do not need DAX. Have you considered to rework this such that instead
> of dm selecting DAX that DAX support is only enabled in dm if CONFIG_DAX is
> enabled?

I haven't but patches to do so would be welcomed.

Mike
