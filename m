From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v3] block,
 dm: don't copy bios for request clones
Date: Tue, 28 Apr 2015 07:49:56 +0200
Message-ID: <553F1F84.6020007@suse.de>
References: <1429957432-20672-1-git-send-email-hch@lst.de>
	<20150428005950.GA31039@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20150428005950.GA31039@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>, Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@fb.com>
List-Id: dm-devel.ids

On 04/28/2015 02:59 AM, Mike Snitzer wrote:
> From: Christoph Hellwig <hch@lst.de>
> =

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

> I've done some basic testing of this on a Linux target with ALUA support,
> and it survives path failures during I/O nicely.
> =

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
