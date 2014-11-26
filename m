From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: virtio_blk: fix defaults for max_hw_sectors and
	max_segment_size
Date: Wed, 26 Nov 2014 16:51:08 -0500
Message-ID: <20141126215108.GA32077@redhat.com>
References: <20141120190058.GA31214@redhat.com>
	<20141121095456.GB8866@infradead.org>
	<20141121154920.GA7644@redhat.com> <54762E9A.2070007@kernel.dk>
	<20141126205106.GA31815@redhat.com> <54763DEC.3050207@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org>
Content-Disposition: inline
In-Reply-To: <54763DEC.3050207@kernel.dk>
List-Unsubscribe: <https://lists.nongnu.org/mailman/options/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=unsubscribe>
List-Archive: <http://lists.nongnu.org/archive/html/qemu-devel>
List-Post: <mailto:qemu-devel@nongnu.org>
List-Help: <mailto:qemu-devel-request@nongnu.org?subject=help>
List-Subscribe: <https://lists.nongnu.org/mailman/listinfo/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=subscribe>
Errors-To: qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org
Sender: qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org
To: Jens Axboe <axboe@kernel.dk>
Cc: martin.petersen@oracle.com, mst@redhat.com, rusty@rustcorp.com.au, qemu-devel@nongnu.org, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, dm-devel@redhat.com, Paolo Bonzini <pbonzini@redhat.com>
List-Id: dm-devel.ids

On Wed, Nov 26 2014 at  3:54pm -0500,
Jens Axboe <axboe@kernel.dk> wrote:

> On 11/26/2014 01:51 PM, Mike Snitzer wrote:
> > On Wed, Nov 26 2014 at  2:48pm -0500,
> > Jens Axboe <axboe@kernel.dk> wrote:
> > 
> >>
> >> That code isn't even in mainline, as far as I can tell...
> > 
> > Right, it is old RHEL6 code.
> > 
> > But I've yet to determine what changed upstream that enables this to
> > "just work" with a really large max_sectors (I haven't been looking
> > either).
> 
> Kind of hard for the rest of us to say, since it's triggering a BUG in
> code we don't have :-)

I never asked you or others to weigh in on old RHEL6 code.  Once I
realized upstream worked even if max_sectors is _really_ high I said
"sorry for the noise".

But while you're here, I wouldn't mind getting your take on virtio-blk
setting max_hw_sectors to -1U.

As I said in my original reply to mst: it only makes sense to set a
really high initial upper bound like that in a driver if that driver
goes on to stack an underlying device's limit.
