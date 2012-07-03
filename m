From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [dm-devel] [PATCH v2 1/3] block: add sysfs entry for
 discard_alignment
Date: Tue, 3 Jul 2012 10:00:48 -0400
Message-ID: <20120703140048.GC11272@redhat.com>
References: <1341235225-27551-1-git-send-email-pbonzini@redhat.com>
 <1341235225-27551-2-git-send-email-pbonzini@redhat.com>
 <20120703023442.GB3586@redhat.com>
 <4FF2DCB1.2090704@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4FF2DCB1.2090704@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk, snitzer@redhat.com, martin.petersen@oracle.com, david@fromorbit.com, xfs@oss.sgi.com, dm-devel@redhat.com, hch@lst.de
List-Id: dm-devel.ids

On Tue, Jul 03, 2012 at 01:51:13PM +0200, Paolo Bonzini wrote:
> Il 03/07/2012 04:34, Vivek Goyal ha scritto:
> >> > The next patches will actually use the alignment, expose it in sysfs
> >> > for ease of debugging.
> >> > 
> > Don't we already have discard_alignment exported as device attribute.
> > 
> > /sys/block/<dev>/discard_alignment
> 
> Ah, interesting, I missed it completely.  I guess it's because queue/
> directories only exist for full disks, and the correct alignment varies
> for each partition.  So this patch is unnecessary.

Partition discard_alignments are available in
/sys/block/<disk>/<partition>/discard_alignment.

That raises an interesting question for patch3. If the discard is happening to
a partition, shouldn't you be looking at partition discard_alignment
instead of always looking at queue discard_alignment?

Thanks
Vivek
