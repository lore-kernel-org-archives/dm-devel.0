From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 0/3] Provide more fine grained control over multipathing
Date: Mon, 4 Jun 2018 14:59:18 +0200
Message-ID: <20180604125918.GC30945@lst.de>
References: <20180525141211.GA25971@lst.de> <20180525145056.GD9591@redhat.com> <yq1muwj45sg.fsf@oracle.com> <20180529030236.GA28895@redhat.com> <20180529072240.np5c62akbr7jqelr@linux-x5ow.site> <20180529080952.GA1369@lst.de> <20180529232718.GA1730@redhat.com> <f4951571-d37d-73cd-1d6c-0ca84647d5ac@kernel.dk> <20180604081921.3cedecbc@pentland.suse.de> <20180604071829.tq7wmx4bvk4uzubd@linux-x5ow.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180604071829.tq7wmx4bvk4uzubd@linux-x5ow.site>
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: Hannes Reinecke <hare@suse.de>, Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@redhat.com>, Christoph Hellwig <hch@lst.de>, Linus Torvalds <torvalds@linux-foundation.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Linux NVMe Mailinglist <linux-nvme@lists.infradead.org>, Laurence Oberman <loberman@redhat.com>, Sagi Grimberg <sagi@grimberg.me>, James Smart <james.smart@broadcom.com>, Ewan Milne <emilne@redhat.com>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Keith Busch <keith.busch@intel.com>, Martin George <marting@netapp.com>, John Meneghini <John.Meneghini@netapp.com>, dm-devel@redhat.com, mwilck@suse.de
List-Id: dm-devel.ids

On Mon, Jun 04, 2018 at 09:18:29AM +0200, Johannes Thumshirn wrote:
> What we really should do is, try to give multipath-tools a 'nvme
> list-subsys' like view of nvme native multipathing (and I think Martin
> W. has already been looking into this a while ago).

Which has been merged into multipath-tools a while ago:

https://git.opensvc.com/gitweb.cgi?p=multipath-tools/.git;a=commit;h=86553b57b6bd55e0355ac27ae100cce6cc42bee3
