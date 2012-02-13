From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 0/2] block: online resize of disk partitions
Date: Mon, 13 Feb 2012 17:24:54 -0500
Message-ID: <20120213222454.GF3130@redhat.com>
References: <1329161438-12602-1-git-send-email-vgoyal@redhat.com>
 <4F3981FE.7090601@ubuntu.com>
 <20120213215039.GD3130@redhat.com>
 <4F398C39.6010901@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4F398C39.6010901@ubuntu.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Phillip Susi <psusi@ubuntu.com>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk, dm-devel@redhat.com, Karel Zak <kzak@redhat.com>, maxim.patlasov@gmail.com
List-Id: dm-devel.ids

On Mon, Feb 13, 2012 at 05:18:33PM -0500, Phillip Susi wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> On 2/13/2012 4:50 PM, Vivek Goyal wrote:
> > So if a user anyway does not specify the start of sector, then 
> > tools shall have to first read it and then call the ioctl. If 
> > anyway tools are specifying, there is no much scope of screwing up 
> > the things?
> 
> Tools certainly should know where the partition starts.  I already
> have patched parted and partx to pass the current size, which they
> had trivially available.  Making sure of that is a good sanity check
> to guard against, for instance, resizing the wrong partition.

Ok, so user still specifies just the new size of partition and tool
passes in both the "start" and new "size" to the ioctl?

> 
> > Even if we allow changing start at some point of time, then IOCTL 
> > can remain the same and just the implementation will change in a 
> > backward compatible manner. Old tools still will continue to work 
> > as they have always been, and new ones can start passing "start" 
> > too.
> > 
> > So I really did not find passing and checking "start" of partition
> >  very appealing.
> 
> That is exactly why passing and checking start is required.  If it is
> entirely ignored, then the interface can not start using it in the
> future in a backward compatible way, because user mode tools will have
> grown used to passing in any kind of garbage, so if the kernel starts
> using it to alter the start position of the partition, older tools
> would randomly and accidentally be shifting the the start of
> partitions they just mean to change the length of.

Ok, I think keeping the ioctl backward compatible in light of any
future changes makes sense. I will change the patches to not ignore
the partition "start" and repost.

Thanks for the comments.

Vivek
