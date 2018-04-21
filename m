From: Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [PATCH] SLUB: Do not fallback to mininum order if __GFP_NORETRY
 is set
Date: Sat, 21 Apr 2018 19:02:07 +0200
Message-ID: <26580de4-70b5-90f7-b3b9-22f57ba38843@suse.cz>
References: <alpine.DEB.2.20.1804180944180.1062@nuc-kabylake>
 <20180419110051.GB16083@dhcp22.suse.cz>
 <alpine.DEB.2.20.1804200952230.18006@nuc-kabylake>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.20.1804200952230.18006@nuc-kabylake>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Christopher Lameter <cl@linux.com>, Michal Hocko <mhocko@kernel.org>
Cc: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Matthew Wilcox <willy@infradead.org>, Pekka Enberg <penberg@kernel.org>, linux-mm@kvack.org, dm-devel@redhat.com, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On 04/20/2018 04:53 PM, Christopher Lameter wrote:
> On Thu, 19 Apr 2018, Michal Hocko wrote:
> 
>> Overriding __GFP_NORETRY is just a bad idea. It will make the semantic
>> of the flag just more confusing. Note there are users who use
>> __GFP_NORETRY as a way to suppress heavy memory pressure and/or the OOM
>> killer. You do not want to change the semantic for them.
> 
> Redoing the allocation after failing a large order alloc is a retry. I
> would say its confusing right now because a retry occurs despite
> specifying GFP_NORETRY,
> 
>> Besides that the changelog is less than optimal. What is the actual
>> problem? Why somebody doesn't want a fallback? Is there a configuration
>> that could prevent the same?
> 
> The problem is that SLUB does not honor GFP_NORETRY. The semantics of
> GFP_NORETRY are not followed.

The caller might want SLUB to try hard to get that high-order page that
will minimize memory waste (e.g. 2MB page for 3 640k objects), and
__GFP_NORETRY will kill the effort on allocating that high-order page.

Thus, using __GPF_NORETRY for "please give me a space-optimized object,
or nothing (because I have a fallback that's better than wasting memory,
e.g. by using 1MB page for 640kb object)" is not ideal.

Maybe __GFP_RETRY_MAYFAIL is a better fit? Or perhaps indicate this
situation to SLUB with e.g. __GFP_COMP, although that's rather ugly?
