From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [dm-devel] [PATCH v5] fault-injection: introduce kvmalloc
 fallback options
Date: Thu, 26 Apr 2018 18:59:40 +0300
Message-ID: <20180426184845-mutt-send-email-mst@kernel.org>
References: <alpine.DEB.2.21.1804251417470.166306@chino.kir.corp.google.com>
 <alpine.LRH.2.02.1804251720090.9428@file01.intranet.prod.int.rdu2.redhat.com>
 <1524694663.4100.21.camel@HansenPartnership.com>
 <alpine.LRH.2.02.1804251830540.25124@file01.intranet.prod.int.rdu2.redhat.com>
 <20180426125817.GO17484@dhcp22.suse.cz>
 <alpine.LRH.2.02.1804261006120.32722@file01.intranet.prod.int.rdu2.redhat.com>
 <1524753932.3226.5.camel@HansenPartnership.com>
 <alpine.LRH.2.02.1804261100170.12157@file01.intranet.prod.int.rdu2.redhat.com>
 <1524756256.3226.7.camel@HansenPartnership.com>
 <alpine.LRH.2.02.1804261142480.21152@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1804261142480.21152@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Michal Hocko <mhocko@kernel.org>, David Rientjes <rientjes@google.com>, dm-devel@redhat.com, eric.dumazet@gmail.com, netdev@vger.kernel.org, jasowang@redhat.com, Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org, Matthew Wilcox <willy@infradead.org>, linux-mm@kvack.org, edumazet@google.com, Andrew Morton <akpm@linux-foundation.org>, virtualization@lists.linux-foundation.org, David Miller <davem@davemloft.net>, Vlastimil Babka <vbabka@suse.cz>
List-Id: dm-devel.ids

On Thu, Apr 26, 2018 at 11:44:21AM -0400, Mikulas Patocka wrote:
> 
> 
> On Thu, 26 Apr 2018, James Bottomley wrote:
> 
> > On Thu, 2018-04-26 at 11:05 -0400, Mikulas Patocka wrote:
> > > 
> > > On Thu, 26 Apr 2018, James Bottomley wrote:
> > [...]
> > > > Perhaps find out beforehand instead of insisting on an approach
> > > without
> > > > knowing.  On openSUSE the grub config is built from the files in
> > > > /etc/grub.d/ so any package can add a kernel option (and various
> > > > conditions around activating it) simply by adding a new file.
> > > 
> > > And then, different versions of the debug kernel will clash when 
> > > attempting to create the same file.
> > 
> > Don't be silly ... there are many ways of coping with that in rpm/dpkg.
> 
> I know you can deal with it - but how many lines of code will that 
> consume? Multiplied by the total number of rpm-based distros.
> 
> Mikulas

I don't think debug kernels should inject faults by default.

IIUC debug kernels mainly exist so people who experience e.g. memory
corruption can try and debug the failure. In this case, CONFIG_DEBUG_SG
will *already* catch a failure early. Nothing special needs to be done.

There is a much smaller class of people like QA who go actively looking
for trouble. That's the kind of thing fault injection is good for, and
IMO you do not want your QA team to test a separate kernel - otherwise
you are never quite sure whatever was tested will work in the field.
So a config option won't help them either.

How do you make sure QA tests a specific corner case? Add it to
the test plan :)

I don't speak for Red Hat, etc.

-- 
MST
