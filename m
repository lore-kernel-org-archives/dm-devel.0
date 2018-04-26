From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [dm-devel] [PATCH v5] fault-injection: introduce kvmalloc fallback
 options
Date: Thu, 26 Apr 2018 16:05:25 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1804261556290.3850@file01.intranet.prod.int.rdu2.redhat.com>
References: <1524753932.3226.5.camel@HansenPartnership.com> <alpine.LRH.2.02.1804261100170.12157@file01.intranet.prod.int.rdu2.redhat.com> <1524756256.3226.7.camel@HansenPartnership.com> <alpine.LRH.2.02.1804261142480.21152@file01.intranet.prod.int.rdu2.redhat.com>
 <20180426184845-mutt-send-email-mst@kernel.org> <alpine.LRH.2.02.1804261202350.24656@file01.intranet.prod.int.rdu2.redhat.com> <20180426214011-mutt-send-email-mst@kernel.org> <alpine.LRH.2.02.1804261451120.23716@file01.intranet.prod.int.rdu2.redhat.com>
 <20180426220523-mutt-send-email-mst@kernel.org> <alpine.LRH.2.02.1804261516250.26980@file01.intranet.prod.int.rdu2.redhat.com> <20180426223925-mutt-send-email-mst@kernel.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180426223925-mutt-send-email-mst@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Michal Hocko <mhocko@kernel.org>, David Rientjes <rientjes@google.com>, dm-devel@redhat.com, eric.dumazet@gmail.com, netdev@vger.kernel.org, jasowang@redhat.com, Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org, Matthew Wilcox <willy@infradead.org>, linux-mm@kvack.org, edumazet@google.com, Andrew Morton <akpm@linux-foundation.org>, virtualization@lists.linux-foundation.org, David Miller <davem@davemloft.net>, Vlastimil Babka <vbabka@suse.cz>
List-Id: dm-devel.ids



On Thu, 26 Apr 2018, Michael S. Tsirkin wrote:

> On Thu, Apr 26, 2018 at 03:36:14PM -0400, Mikulas Patocka wrote:
> > People on this list argue "this should be a kernel parameter".
> 
> How about making it a writeable attribute, so it's easy to turn on/off
> after boot. Then you can keep it deterministic, userspace can play with
> the attribute at random if it wants to.
> 
> -- 
> MST

It is already controllable by an attribute in debugfs.

Will you email all the testers about this attribute? How many of them will 
remember to set it? How many of them will remember to set it a year after? 
Will you write a userspace program that manages it and introduce it into 
the distributon?

This is a little feature.

Mikulas
