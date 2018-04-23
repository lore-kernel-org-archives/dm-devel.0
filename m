From: Christopher Lameter <cl@linux.com>
Subject: Re: [PATCH] SLUB: Do not fallback to mininum order if __GFP_NORETRY
 is set
Date: Mon, 23 Apr 2018 17:41:06 -0500 (CDT)
Message-ID: <alpine.DEB.2.20.1804231738020.3811@nuc-kabylake>
References: <alpine.DEB.2.20.1804180944180.1062@nuc-kabylake> <20180419110051.GB16083@dhcp22.suse.cz> <alpine.DEB.2.20.1804200952230.18006@nuc-kabylake> <26580de4-70b5-90f7-b3b9-22f57ba38843@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <26580de4-70b5-90f7-b3b9-22f57ba38843@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Michal Hocko <mhocko@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Matthew Wilcox <willy@infradead.org>, Pekka Enberg <penberg@kernel.org>, linux-mm@kvack.org, dm-devel@redhat.com, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Sat, 21 Apr 2018, Vlastimil Babka wrote:

> > The problem is that SLUB does not honor GFP_NORETRY. The semantics of
> > GFP_NORETRY are not followed.
>
> The caller might want SLUB to try hard to get that high-order page that
> will minimize memory waste (e.g. 2MB page for 3 640k objects), and
> __GFP_NORETRY will kill the effort on allocating that high-order page.

Well yes since *_NORETRY says that fallbacks are acceptable.

> Thus, using __GPF_NORETRY for "please give me a space-optimized object,
> or nothing (because I have a fallback that's better than wasting memory,
> e.g. by using 1MB page for 640kb object)" is not ideal.
>
> Maybe __GFP_RETRY_MAYFAIL is a better fit? Or perhaps indicate this
> situation to SLUB with e.g. __GFP_COMP, although that's rather ugly?

Yuck. None of that sounds like an intuitive approach.
