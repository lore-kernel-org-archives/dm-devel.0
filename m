From: Hannes Reinecke <hare@suse.de>
Subject: Re: good dm-mpath test setup?
Date: Thu, 05 Jun 2014 14:17:10 +0200
Message-ID: <53905FC6.5030006@suse.de>
References: <20140605115011.GA816@infradead.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"; Format="flowed"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20140605115011.GA816@infradead.org>
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
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 06/05/2014 01:50 PM, Christoph Hellwig wrote:
> I've been looking into support blk-mq/scsi-mq in dm-mpath, but I'm
> already running into issues with mainline.  I created a couple luns
> (without second path) using iet, and then using the iscsi initiator
> to access them.  But it seems like no I/O is possible through dm-mpath
> for this simple setup as the kpartx processes spawned by udev already
> hang.  Is dm-mpath (default config, no multipath.conf) support to work
> for a single path setup, or is this expected behavior?
>
On a complete different footing, I've whipped together some patches =

to simplify the request/bio cloning when using multipath;
basically do _not_ clone the bios, but just modify the rq_end_io =

handler.

You mentioned something at LSF that the current way of handling is =

quite insane, and looking at it I tend to agree.

So if you'd be interested I'll be posting them.

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
