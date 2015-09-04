From: Christoph Lameter <cl@linux.com>
Subject: Re: slab-nomerge (was Re: [git pull] device mapper changes for
 4.3)
Date: Fri, 4 Sep 2015 08:55:25 -0500 (CDT)
Message-ID: <alpine.DEB.2.11.1509040849460.30848@east.gentwo.org>
References: <CA+55aFyepmdpbg9U2Pvp+aHjKmmGCrTK2ywzqfmaOTMXQasYNw@mail.gmail.com> <20150903005115.GA27804@redhat.com> <CA+55aFxpH6-XD97dOsuGvwozyV=28eBsxiKS901h8PFZrxaygw@mail.gmail.com> <20150903060247.GV1933@devil.localdomain>
 <CA+55aFxftNVWVD7ujseqUDNgbVamrFWf0PVM+hPnrfmmACgE0Q@mail.gmail.com> <20150904032607.GX1933@devil.localdomain>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20150904032607.GX1933@devil.localdomain>
Sender: owner-linux-mm@kvack.org
To: Dave Chinner <dchinner@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Mike Snitzer <snitzer@redhat.com>, Pekka Enberg <penberg@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, Alasdair G Kergon <agk@redhat.com>, Joe Thornber <ejt@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, Vivek Goyal <vgoyal@redhat.com>, Sami Tolvanen <samitolvanen@google.com>, Viresh Kumar <viresh.kumar@linaro.org>, Heinz Mauelshagen <heinzm@redhat.com>, linux-mm <linux-mm@kvack.org>
List-Id: dm-devel.ids

On Fri, 4 Sep 2015, Dave Chinner wrote:

> There are generic cases where it hurts, so no justification should
> be needed for those cases...

Inodes and dentries have constructors. These slabs are not mergeable and
will never be because they have cache specific code to be executed on the
object.

> Really, we don't need some stupidly high bar to jump over here -
> whether merging should be allowed can easily be answered with a
> simple question: "Does the slab have a shrinker or does it back a
> mempool?" If the answer is yes then using SLAB_SHRINKER or
> SLAB_MEMPOOL to trigger the no-merge case doesn't need any more
> justification from subsystem maintainers at all.

The slab shrinkers do not use mergeable slab caches.


--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
