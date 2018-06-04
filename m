From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 0/3] Provide more fine grained control over multipathing
Date: Mon, 4 Jun 2018 09:27:31 -0400
Message-ID: <20180604132731.GA31515@redhat.com>
References: <20180525145056.GD9591@redhat.com>
 <yq1muwj45sg.fsf@oracle.com>
 <20180529030236.GA28895@redhat.com>
 <20180529072240.np5c62akbr7jqelr@linux-x5ow.site>
 <20180529080952.GA1369@lst.de>
 <20180529232718.GA1730@redhat.com>
 <f4951571-d37d-73cd-1d6c-0ca84647d5ac@kernel.dk>
 <20180604081921.3cedecbc@pentland.suse.de>
 <20180604071829.tq7wmx4bvk4uzubd@linux-x5ow.site>
 <20180604125918.GC30945@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180604125918.GC30945@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Johannes Thumshirn <jthumshirn@suse.de>, Hannes Reinecke <hare@suse.de>, Jens Axboe <axboe@kernel.dk>, Linus Torvalds <torvalds@linux-foundation.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Linux NVMe Mailinglist <linux-nvme@lists.infradead.org>, Laurence Oberman <loberman@redhat.com>, Sagi Grimberg <sagi@grimberg.me>, James Smart <james.smart@broadcom.com>, Ewan Milne <emilne@redhat.com>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Keith Busch <keith.busch@intel.com>, Martin George <marting@netapp.com>, John Meneghini <John.Meneghini@netapp.com>, dm-devel@redhat.com, mwilck@suse.de, Benjamin Marzinski <bmarzins@redhat.com>
List-Id: dm-devel.ids

On Mon, Jun 04 2018 at  8:59am -0400,
Christoph Hellwig <hch@lst.de> wrote:

> On Mon, Jun 04, 2018 at 09:18:29AM +0200, Johannes Thumshirn wrote:
> > What we really should do is, try to give multipath-tools a 'nvme
> > list-subsys' like view of nvme native multipathing (and I think Martin
> > W. has already been looking into this a while ago).
> 
> Which has been merged into multipath-tools a while ago:
> 
> https://git.opensvc.com/gitweb.cgi?p=multipath-tools/.git;a=commit;h=86553b57b6bd55e0355ac27ae100cce6cc42bee3

And this is what I heard from Ben Marzinski last week:

Yeah. Things like

multipath -l
multipathd show maps
multipathd show paths

are supported.  There is no support for the individual "show map" and
"show path" commands. Those only work on dm devices.  There is also no
json formatting option for the foreign devices, but that could be added.
And probably will need to be, since people like RHEV really want to
use the library interface to multipathd with json formatted output.
Although if there are no dm multipath devices, there is no point to
running multipathd, so it might be worthwhile thinking about a library
interface to getting the information directly, instead of through
multipathd. That's a bigger rewrite.
