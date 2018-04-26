From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [dm-devel] [PATCH v5] fault-injection: introduce kvmalloc fallback
	options
Date: Thu, 26 Apr 2018 15:36:14 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1804261516250.26980@file01.intranet.prod.int.rdu2.redhat.com>
References: <20180426125817.GO17484@dhcp22.suse.cz>
	<alpine.LRH.2.02.1804261006120.32722@file01.intranet.prod.int.rdu2.redhat.com>
	<1524753932.3226.5.camel@HansenPartnership.com>
	<alpine.LRH.2.02.1804261100170.12157@file01.intranet.prod.int.rdu2.redhat.com>
	<1524756256.3226.7.camel@HansenPartnership.com>
	<alpine.LRH.2.02.1804261142480.21152@file01.intranet.prod.int.rdu2.redhat.com>
	<20180426184845-mutt-send-email-mst@kernel.org>
	<alpine.LRH.2.02.1804261202350.24656@file01.intranet.prod.int.rdu2.redhat.com>
	<20180426214011-mutt-send-email-mst@kernel.org>
	<alpine.LRH.2.02.1804261451120.23716@file01.intranet.prod.int.rdu2.redhat.com>
	<20180426220523-mutt-send-email-mst@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <20180426220523-mutt-send-email-mst@kernel.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: eric.dumazet@gmail.com, netdev@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org, Matthew Wilcox <willy@infradead.org>, Michal Hocko <mhocko@kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-mm@kvack.org, dm-devel@redhat.com, Vlastimil Babka <vbabka@suse.cz>, David Rientjes <rientjes@google.com>, Andrew Morton <akpm@linux-foundation.org>, virtualization@lists.linux-foundation.org, David Miller <davem@davemloft.net>, edumazet@google.com
List-Id: dm-devel.ids



On Thu, 26 Apr 2018, Michael S. Tsirkin wrote:

> On Thu, Apr 26, 2018 at 02:54:26PM -0400, Mikulas Patocka wrote:
> > 
> > 
> > On Thu, 26 Apr 2018, Michael S. Tsirkin wrote:
> > 
> > > On Thu, Apr 26, 2018 at 12:07:25PM -0400, Mikulas Patocka wrote:
> > > > > IIUC debug kernels mainly exist so people who experience e.g. memory
> > > > > corruption can try and debug the failure. In this case, CONFIG_DEBUG_SG
> > > > > will *already* catch a failure early. Nothing special needs to be done.
> > > > 
> > > > The patch helps people debug such memory coprruptions (such as using DMA 
> > > > API on the result of kvmalloc).
> > > 
> > > That's my point.  I don't think your patch helps debug any memory
> > > corruptions.  With CONFIG_DEBUG_SG using DMA API already causes a
> > > BUG_ON, that's before any memory can get corrupted.
> > 
> > The patch turns a hard-to-reproduce bug into an easy-to-reproduce bug. 
> 
> It's still not a memory corruption. It's a BUG_ON the source of which -
> should it trigger - can be typically found using grep.
> 
> > Obviously we don't want this in production kernels, but in the debug 
> > kernels it should be done.
> > 
> > Mikulas
> 
> I'm not so sure. debug kernels should make debugging easier,
> definitely.
> 
> Unfortunately they are already slower so some races don't trigger.
> 
> If they also start crashing more because we are injecting
> memory allocation errors, people are even less likely to
> be able to use them.

I've actually already pushed this patch to RHEL-7 (just before 7.5 was 
released) and it found out some powerpc issues. See the commit 
ea376cc55bc3 in the RHEL-7 git. It was reverted just before RHEL-7.5 was 
released with the intention that it will be reinstated just after RHEL-7.5 
release, so that these issues could be found and eliminated in the 
7.5->7.6 development cycle. Jeff Moyer asked me to put it upstream because 
they want to follow upstream and they don't like RHEL-specific patches. 
There's clear incentive to put this patch to RHEL-7, that's why I'm 
posting it here.

> Just add a comment near the BUG_ON within DMA API telling people how
> they can inject this error some more if the bug does not
> reproduce, and leave it at that.

But the problem is that the powerpc bug only triggers with this patch. It 
doesn't trigger without it. So, we have a potential random-crashing bug in 
the codebase (and perhaps more others) and we want to eliminate them - 
that's why we need the patch.

People on this list argue "this should be a kernel parameter". But the 
testers won't enable the kernel parameter, the crashes won't happen 
without the kernel parameter and the bugs will stay unreported and 
uncorrected. That's why it needs to be the default.

Mikulas
