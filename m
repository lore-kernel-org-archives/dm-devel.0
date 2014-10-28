From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCHv2 0/4] blk-mq support for dm multipath
Date: Tue, 28 Oct 2014 19:48:41 +0100
Message-ID: <544FE509.3020207@suse.de>
References: <1413589598-17631-1-git-send-email-keith.busch@intel.com>
	<alpine.LNX.2.00.1410281808390.4225@localhost.lm.intel.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LNX.2.00.1410281808390.4225@localhost.lm.intel.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Keith Busch <keith.busch@intel.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

On 10/28/2014 07:13 PM, Keith Busch wrote:
> No comments this time. Did I totally botch this in the wrong direction,
> or was the timing bad with the linux con/plumbers that week?
> =

Basically the latter. We (ie hch and myself) discussed this briefly at
LPC, and thought it'd be the right step in the right direction.

'Real' multipath support w/ blk-mq would need some more thought, though.
What we've been discussing was to redo the entire I/O submission path:
a) pass down I/O _without_ cloning on the current path
b) clone the request _for retry_ only.
with b) covering retry on a different path and partial I/O submission
on the current path.
That would have the benefit doing away with the current request/bio
cloning. Plus we could even model things like 'preferred' path.

Now we only need someone to implement this ...

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
