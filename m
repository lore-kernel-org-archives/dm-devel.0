From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: CONFIG_DM_MQ_DEFAULT makes my kernel unhappy..
Date: Mon, 27 Apr 2015 11:59:15 -0400
Message-ID: <20150427155915.GA9976@redhat.com>
References: <20150425092358.GA15550@infradead.org>
	<20150425152856.GB28453@redhat.com>
	<20150425153732.GA10612@infradead.org>
	<20150426141628.GA7085@infradead.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20150426141628.GA7085@infradead.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christoph Hellwig <hch@infradead.org>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Sun, Apr 26 2015 at 10:16am -0400,
Christoph Hellwig <hch@infradead.org> wrote:

> On Sat, Apr 25, 2015 at 08:37:32AM -0700, Christoph Hellwig wrote:
> > I'll give it a spin.
> > 
> > > What were you actually testing when this happened?  Were you failing
> > > paths under IO load or something?
> > 
> > This happened on the initial udev-direct scan of the devices.
> > 
> > > Also, which upstream commit was your tree based on?  Did you have any
> > > non-upstream patches applied that I should be aware of?
> > 
> > Latest Linus tree as of this morning.
> 
> Seems like the first warning goes away without CONFIG_DEBUG_OBJECTS.
> Note that in either way I/O over dm-mpath actually works fine.
> 
> Btw, this is the script used to reproduce it, you need
> CONFIG_TARGET_CORE, CONFIG_TCM_IBLOCK and CONFIG_LOOPBACK_TARGET
> enabled.  It jsut creates two different targets with a lun each,
> pointing to the same device.  The target code automatically supports
> ALUA in this case.
> 
> ---
> #!/bin/bash
> 
> # add your own device
> #DEV=/dev/sda
> 
> mount -t configfs none /sys/kernel/config/
> 
> tcm_node --block iblock_0/array /dev/sda
> 
> line=$(tcm_loop --createnexus=0)
> wwn=$(echo $line | awk '{print $15}')
> tcm_loop --addlun=$wwn 0 0 iblock_0/array
> 
> line=$(tcm_loop --createnexus=1)
> wwn=$(echo $line | awk '{print $15}')
> tcm_loop --addlun=$wwn 1 0 iblock_0/array
> 

So you're still using lio-utils?  Seems "lio-utils are deprecated and
have been superseded by targetcli".. what am I missing?

What lio-utils repo should I be using to get the utils that'll work with
your script?
