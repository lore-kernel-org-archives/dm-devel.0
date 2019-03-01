From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: linux-next: Boot hangs 3 minutes with device mapper
	on s390
Date: Fri, 1 Mar 2019 15:30:08 -0500
Message-ID: <20190301203008.GB30080@redhat.com>
References: <20190301183350.5ff697d4@TP-holzheu>
	<alpine.LRH.2.02.1903011516160.20592@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1903011516160.20592@file01.intranet.prod.int.rdu2.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Benjamin Block <bblock@linux.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, dm-devel@redhat.com, linux-next@vger.kernel.org, Steffen Maier <maier@linux.ibm.com>, Michael Holzheu <holzheu@linux.ibm.com>
List-Id: dm-devel.ids

On Fri, Mar 01 2019 at  3:19pm -0500,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> 
> 
> On Fri, 1 Mar 2019, Michael Holzheu wrote:
> 
> > Hi Mike,
> > 
> > On Fedora 29, the following "linux-next" commit introduced a regression on s390:
> > 
> >   commit 1efa3bb79d3de8ca1b7f6770313a1fc0bebe25c7
> >   Author: Mike Snitzer <snitzer@redhat.com>
> >   Date:   Fri Feb 22 11:23:01 2019 -0500
> > 
> >     dm: must allocate dm_noclone for stacked noclone devices
> >     
> >     Otherwise various lvm2 testsuite tests fail because the lower layers of
> >     the stacked noclone device aren't updated to allocate a new 'struct
> >     dm_clone' that reflects the upper layer bio that was issued to it.
> >     
> >     Fixes: 97a89458020b38 ("dm: improve noclone bio support")
> >     Reported-by: Mikulas Patocka <mpatocka@redhat.com>
> >     Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> 
> Should we just drop 97a89458020b388b910160c4f4aa5e24318d2460 and 
> 1efa3bb79d3de8ca1b7f6770313a1fc0bebe25c7?

No.

> 97a89458020b388b910160c4f4aa5e24318d2460 claims to be an improvement, but 
> it broke the tests twice.

This report from Michael needs proper review and triage.

It literally makes _zero_ sense that all 5 mpath devices are suffering
from a 3 minute boot stall (rooted in udev action) when I'm pretty
certain they are using request-based multipath for 4 of the 5 devices.
The 5th likely having a dm-linear ontop of request-based multipath.
And I've tested stacking bio-based linear on request-based multipath.

Mike
