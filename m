From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [dm-devel] linux-next: Tree for Feb 2 (drivers/md/dm.c)
Date: Thu, 2 Feb 2017 10:44:10 -0800
Message-ID: <20170202184409.GA27869@infradead.org>
References: <20170202182117.73e354f1@canb.auug.org.au>
 <8a8224e7-4c90-7fa7-9960-fc04fe658014@infradead.org>
 <20170202182916.GA26910@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170202182916.GA26910@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Randy Dunlap <rdunlap@infradead.org>, Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org, hch@infradead.org, dm <dm-devel@redhat.com>, linux-next@vger.kernel.org, Alasdair G Kergon <agk@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>
List-Id: dm-devel.ids

On Thu, Feb 02, 2017 at 01:29:16PM -0500, Mike Snitzer wrote:
> Are you trying to say that this happens using a certain .config?
> 
> Also, not sure why you didn't cc Christoph (or Jens) seeing as these
> changes are _not_ staged in linux-next by linux-dm.git.

No changes to dm caused this, it was me making the SCSI ioctl / request
code optional.  The tree apparently has nothing pulling in the SCSI
ioctls (SCSI, IDE, virtio, cciss, target, cdrom, etc).  It turns
out DM calls the SCSI ioctl verification functions, despite never
actually using SCSIO ioctls directly, which looks very odd (and which is
why I missed it).

Git-blame for these lines pointes to ... me.  Heh.  But I just moved the
code around, before that every target had a copy of it.  The original
calls seem to come from:

ec8013bedd ("dm: do not forward ioctls from logical volumes to the
underlying device"),

The trivial fix would be to add a select of the SCSI_REQUEST symbol
to dm, but my gut feeling teels me the call is simply wrong, and
should be removed and instead all ioctls on DM devices that don't
map to a full underlying devices should be rejected.
