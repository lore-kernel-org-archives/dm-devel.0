From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 0/3] Provide more fine grained control over multipathing
Date: Mon, 4 Jun 2018 09:18:29 +0200
Message-ID: <20180604071829.tq7wmx4bvk4uzubd@linux-x5ow.site>
References: <20180525135813.GB9591@redhat.com>
 <20180525141211.GA25971@lst.de>
 <20180525145056.GD9591@redhat.com>
 <yq1muwj45sg.fsf@oracle.com>
 <20180529030236.GA28895@redhat.com>
 <20180529072240.np5c62akbr7jqelr@linux-x5ow.site>
 <20180529080952.GA1369@lst.de>
 <20180529232718.GA1730@redhat.com>
 <f4951571-d37d-73cd-1d6c-0ca84647d5ac@kernel.dk>
 <20180604081921.3cedecbc@pentland.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180604081921.3cedecbc@pentland.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@redhat.com>, Christoph Hellwig <hch@lst.de>, Linus Torvalds <torvalds@linux-foundation.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Linux NVMe Mailinglist <linux-nvme@lists.infradead.org>, Laurence Oberman <loberman@redhat.com>, Sagi Grimberg <sagi@grimberg.me>, James Smart <james.smart@broadcom.com>, Ewan Milne <emilne@redhat.com>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Keith Busch <keith.busch@intel.com>, Martin George <marting@netapp.com>, John Meneghini <John.Meneghini@netapp.com>, dm-devel@redhat.com, mwilck@suse.de
List-Id: dm-devel.ids

On Mon, Jun 04, 2018 at 08:19:21AM +0200, Hannes Reinecke wrote:
> Without it we're having a choice of disappointing (paying) customers or
> disappointing the upstream community.

I personally think (regardless of the fact, that I wrote the patch
under discussion), using the module parameter is sufficient for these
kind of customers. For me it's an either/or kind of setting (either
native or dm-mpath).

Downstream distributions could still carry a small patch flipping the
default to off if they want to maintain backwards compatibility with
existing dm-mpath setups (which for NVMe I doubt there are many!).

What we really should do is, try to give multipath-tools a 'nvme
list-subsys' like view of nvme native multipathing (and I think Martin
W. has already been looking into this a while ago).


   Johannes
-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
