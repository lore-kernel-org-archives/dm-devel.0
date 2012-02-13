From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 0/2] block: online resize of disk partitions
Date: Mon, 13 Feb 2012 16:50:39 -0500
Message-ID: <20120213215039.GD3130@redhat.com>
References: <1329161438-12602-1-git-send-email-vgoyal@redhat.com>
 <4F3981FE.7090601@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4F3981FE.7090601@ubuntu.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Phillip Susi <psusi@ubuntu.com>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk, dm-devel@redhat.com, Karel Zak <kzak@redhat.com>, maxim.patlasov@gmail.com
List-Id: dm-devel.ids

On Mon, Feb 13, 2012 at 04:34:54PM -0500, Phillip Susi wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> On 2/13/2012 2:30 PM, Vivek Goyal wrote:
> > Hi,
> > 
> > Following patch adds support for online resizing of a partition.
> > This patch is based on previously posted patches by Phillip Susi.
> > 
> > There are two patches. Out of which one is kernel patch and other
> > one is util-linux patch to add support of a user space utility
> > "resizepart" to allow resizing the partition.
> > 
> > This ioctl only resizes the partition size in kenrel and does not
> > change the size on disk. A user needs to make sure that
> > corresponding changes are made to disk data structures also using
> > fdisk(or partx), if changes are to be retained across reboot.
> > 
> > I made some changes according to the feedback received last time.
> > Following are changes since the version Phillip posted.
> > 
> > - RESIZE ioctl ignores the partition "start" and does not expect
> > user to specify one. Caller needs to just specify "device",
> > "partition number" and "size" of new partition.
> 
> I would prefer that the start argument not be left undefined.  I
> checked it to make sure it was unchanged as a simple sanity check to
> guard against user space being goofy,

I am not sure that it is really helping. I looked at pvresize, lvresize
and resize2fs user interfaces and a user has to just specify the new
size of physical volume, logical volume, filesystem respectively. So
it makes sense to keep partition resize interface inline with above
tools.

So if a user anyway does not specify the start of sector, then tools
shall have to first read it and then call the ioctl. If anyway tools
are specifying, there is no much scope of screwing up the things?

Also in delete partition ioctl, we just ask the user the partition
number being deleted. We don't ask for start and size of partition
in an effort to verify that you are deleting the right partition.

> as well as to allow for the
> possibility of extending the interface in the future to allow changing
> the start as well as the length.

Even if we allow changing start at some point of time, then IOCTL can
remain the same and just the implementation will change in a backward
compatible manner. Old tools still will continue to work as they have
always been, and new ones can start passing "start" too.

So I really did not find passing and checking "start" of partition
very appealing.

Thanks
Vivek
