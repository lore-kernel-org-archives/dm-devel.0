From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2] block,
 dm: don't copy bios for request clones
Date: Sat, 25 Apr 2015 20:13:28 +0200
Message-ID: <553BD948.5040302@suse.de>
References: <1429957432-20672-1-git-send-email-hch@lst.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1429957432-20672-1-git-send-email-hch@lst.de>
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
Cc: Jens Axboe <axboe@fb.com>, dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

On 04/25/2015 12:23 PM, Christoph Hellwig wrote:
> Currently dm-multipath has to clone the bios for every request sent
> to the lower devices, which wastes cpu cycles and ties down memory.
> =

> This patch instead adds a new REQ_CLONE flag that instructs req_bio_endio
> to not complete bios attached to a request, which we set on clone
> requests similar to bios in a flush sequence.  With this change I/O
> errors on a path failure only get propagated to dm-multipath, which
> can then either resubmit the I/O or complete the bios on the original
> request.
> =

Hehe.

I seem to remember having sent a similar patch about a year ago;
which then got shot down due to the missing partial completion
handling.

> I've done some basic testing of this on a Linux target with ALUA support,
> and it survives path failures during I/O nicely.
> =

So did I ...

Anyway; we've discussed this at LSF in Boston, haven't we?
AFAICR we've found that having to resubmit the entire command
in the case of partial completion is okay with the storage
vendors, so this patch is a viable way of handling things.

_But_ I really would like to have a consensus here that this
_is_ the correct way of handling partial request; because
if that is the case then we should adopt this strategy
throughout the SCSI layer (ie in scsi_io_completion())
and document the fact.

I really don't like to have two different completion paths;
we should decide on one way and then use it throughout
the stack.

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
