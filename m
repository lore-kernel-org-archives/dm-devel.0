From: "Guy Watkins" <linux-raid@watkins-home.com>
Subject: RE: [RFD] BIO_RW_BARRIER - what it means for devices, filesystems,   and dm/md.
Date: Sat, 2 Jun 2007 18:57:11 -0400
Message-ID: <200706022257.l52MvGc06632@www.watkins-home.com>
References: <20070602143438.GB32105@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20070602143438.GB32105@kernel.dk>
Sender: linux-raid-owner@vger.kernel.org
To: 'Jens Axboe' <jens.axboe@oracle.com>, 'Tejun Heo' <htejun@gmail.com>
Cc: 'David Chinner' <dgc@sgi.com>, david@lang.hm, 'Phillip Susi' <psusi@cfl.rr.com>, 'Neil Brown' <neilb@suse.de>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, 'Stefan Bader' <Stefan.Bader@de.ibm.com>, 'Andreas Dilger' <adilger@clusterfs.com>
List-Id: dm-devel.ids

} -----Original Message-----
} From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
} owner@vger.kernel.org] On Behalf Of Jens Axboe
} Sent: Saturday, June 02, 2007 10:35 AM
} To: Tejun Heo
} Cc: David Chinner; david@lang.hm; Phillip Susi; Neil Brown; linux-
} fsdevel@vger.kernel.org; linux-kernel@vger.kernel.org; dm-
} devel@redhat.com; linux-raid@vger.kernel.org; Stefan Bader; Andreas Dilger
} Subject: Re: [RFD] BIO_RW_BARRIER - what it means for devices,
} filesystems, and dm/md.
} 
} On Sat, Jun 02 2007, Tejun Heo wrote:
} > Hello,
} >
} > Jens Axboe wrote:
} > >> Would that be very different from issuing barrier and not waiting for
} > >> its completion?  For ATA and SCSI, we'll have to flush write back
} cache
} > >> anyway, so I don't see how we can get performance advantage by
} > >> implementing separate WRITE_ORDERED.  I think zero-length barrier
} > >> (haven't looked at the code yet, still recovering from jet lag :-)
} can
} > >> serve as genuine barrier without the extra write tho.
} > >
} > > As always, it depends :-)
} > >
} > > If you are doing pure flush barriers, then there's no difference.
} Unless
} > > you only guarantee ordering wrt previously submitted requests, in
} which
} > > case you can eliminate the post flush.
} > >
} > > If you are doing ordered tags, then just setting the ordered bit is
} > > enough. That is different from the barrier in that we don't need a
} flush
} > > of FUA bit set.
} >
} > Hmmm... I'm feeling dense.  Zero-length barrier also requires only one
} > flush to separate requests before and after it (haven't looked at the
} > code yet, will soon).  Can you enlighten me?
} 
} Yeah, that's what the zero-length barrier implementation I posted does.
} Not sure if you have a question beyond that, if so fire away :-)
} 
} --
} Jens Axboe

I must admit I have only read some of the barrier related posts, so this
issue may have been covered.  If so, sorry.

What I have read seems to be related to a single disk.  What if a logical
disk is used (md, LVM, ...)?  If a barrier is issued to a logical disk and
that driver issues barriers to all related devices (logical or physical),
all the devices MUST honor the barrier together.  If 1 device crosses the
barrier before another reaches the barrier, corruption should be assumed.
It seems to me each block device that represents more than 2 other devices
must do a flush at a barrier so that all devices will cross the barrier at
the same time.

Guy

