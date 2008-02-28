From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: [PATCH 7/9] scsi_dh: Add support for SDEV_PASSIVE
Date: Wed, 27 Feb 2008 17:03:30 -0800
Message-ID: <1204160610.4963.49.camel@linuxchandra>
References: <20080124003010.18871.84095.sendpatchset@localhost.localdomain>
	 <20080124003203.18871.52040.sendpatchset@localhost.localdomain>
	 <1202151498.3096.84.camel@localhost.localdomain>
	 <1202156151.13537.14.camel@linuxchandra>
	 <1202156914.3096.112.camel@localhost.localdomain>
	 <1202159970.13537.19.camel@linuxchandra>
	 <20080209124511.GB28967@parisc-linux.org>
	 <1202754466.13537.123.camel@linuxchandra>
	 <20080211191800.GO5299@parisc-linux.org>
Reply-To: sekharan@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20080211191800.GO5299@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, dm-devel@redhat.com, linux-scsi@vger.kernel.org, Mike Anderson <andmike@us.ibm.com>, michaelc@cs.wisc.edu, jens.axboe@oracle.com
List-Id: dm-devel.ids

On Mon, 2008-02-11 at 12:18 -0700, Matthew Wilcox wrote:
> On Mon, Feb 11, 2008 at 10:27:46AM -0800, Chandra Seetharaman wrote:
> > On Sat, 2008-02-09 at 05:45 -0700, Matthew Wilcox wrote:
> > > On Mon, Feb 04, 2008 at 01:19:30PM -0800, Chandra Seetharaman wrote:
> > > > The device does send these error messages currently, but it takes some
> > > > time to get the check condition back, which adds up the time to boot
> > > > especially when the # of LUNS is huge.
> > > > 
> > > > For example, in my test configuration, I had 40 luns, and the time
> > > > difference (with this patch and without it) to boot is 171 seconds and
> > > > 1426 seconds.
> > > 
> > > Was that with sync or async SCSI bus scanning?
> > 
> > I didn't change anything, IOW, i did default scanning, which I would
> > guess sync ?!
> 
> That would depend on your CONFIG_SCSI_SCAN_ASYNC setting.
> 
> Try booting with 'scsi_mod.scan=async' and without this patch, and see
> how long it takes.
Hi Matthew,

scanning in async mode did not help in reducing the boot time.

I even changed the configuration, such that 20 active luns and 20
passive luns are in each path, it still didn't change the time it took
to reboot.

regards,

chandra
> 
-- 

----------------------------------------------------------------------
    Chandra Seetharaman               | Be careful what you choose....
              - sekharan@us.ibm.com   |      .......you may get it.
----------------------------------------------------------------------


