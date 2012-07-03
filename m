From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v2 1/3] block: add sysfs entry for discard_alignment
Date: Mon, 2 Jul 2012 23:59:24 -0400
Message-ID: <20120703035924.GA6182@redhat.com>
References: <1341235225-27551-1-git-send-email-pbonzini@redhat.com>
 <1341235225-27551-2-git-send-email-pbonzini@redhat.com>
 <20120703023442.GB3586@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120703023442.GB3586@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, axboe@kernel.dk, martin.petersen@oracle.com, david@fromorbit.com, xfs@oss.sgi.com, dm-devel@redhat.com, hch@lst.de
List-Id: dm-devel.ids

On Mon, Jul 02 2012 at 10:34pm -0400,
Vivek Goyal <vgoyal@redhat.com> wrote:

> On Mon, Jul 02, 2012 at 03:20:23PM +0200, Paolo Bonzini wrote:
> > The next patches will actually use the alignment, expose it in sysfs
> > for ease of debugging.
> > 
> 
> Don't we already have discard_alignment exported as device attribute.
> 
> /sys/block/<dev>/discard_alignment

Yes we do.  It is documented in Documentation/ABI/testing/sysfs-block

So this patch isn't needed.
