From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] backport of: dm sysfs: fix a module unload race
Date: Mon, 10 Feb 2014 16:05:17 -0800
Message-ID: <20140211000517.GB15453@kroah.com>
References: <139190449886@kroah.com>
 <alpine.LRH.2.02.1402101457550.23907@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1402101457550.23907@file01.intranet.prod.int.rdu2.redhat.com>
Sender: stable-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org, snitzer@redhat.com, dm-devel@redhat.com
List-Id: dm-devel.ids

On Mon, Feb 10, 2014 at 03:02:24PM -0500, Mikulas Patocka wrote:
> 
> 
> On Sat, 8 Feb 2014, gregkh@linuxfoundation.org wrote:
> 
> > The patch below does not apply to the 3.13-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> > 
> > thanks,
> > 
> > greg k-h
> 
> Hi
> 
> Here I'm sending backported patch 
> 2995fa78e423d7193f3b57835f6c1c75006a0315. It applies to stable kernels
> 3.4 - 3.13 (and maybe also on older versions).

For 3.10-3.13 this patch works, but for 3.4 I get the build error:

ERROR: "dm_kobject_release" [drivers/md/dm-mod.ko] undefined!
/ssd/gregkh-linux/stable/linux-3.4.y/scripts/Makefile.modpost:91: recipe for target '__modpost' failed
make[1]: *** [__modpost] Error 1

So I'm dropping it from that branch.  Care to send me a version that
builds properly for that kernel release?

thanks,

greg k-h
