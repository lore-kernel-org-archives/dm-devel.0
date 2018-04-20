From: Christopher Lameter <cl@linux.com>
Subject: Re: [PATCH] SLUB: Do not fallback to mininum order if __GFP_NORETRY
 is set
Date: Fri, 20 Apr 2018 09:53:53 -0500 (CDT)
Message-ID: <alpine.DEB.2.20.1804200952230.18006@nuc-kabylake>
References: <alpine.DEB.2.20.1804180944180.1062@nuc-kabylake> <20180419110051.GB16083@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180419110051.GB16083@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Michal Hocko <mhocko@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>, Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Matthew Wilcox <willy@infradead.org>, Pekka Enberg <penberg@kernel.org>, linux-mm@kvack.org, dm-devel@redhat.com, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Thu, 19 Apr 2018, Michal Hocko wrote:

> Overriding __GFP_NORETRY is just a bad idea. It will make the semantic
> of the flag just more confusing. Note there are users who use
> __GFP_NORETRY as a way to suppress heavy memory pressure and/or the OOM
> killer. You do not want to change the semantic for them.

Redoing the allocation after failing a large order alloc is a retry. I
would say its confusing right now because a retry occurs despite
specifying GFP_NORETRY,

> Besides that the changelog is less than optimal. What is the actual
> problem? Why somebody doesn't want a fallback? Is there a configuration
> that could prevent the same?

The problem is that SLUB does not honor GFP_NORETRY. The semantics of
GFP_NORETRY are not followed.
