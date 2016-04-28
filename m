From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH 19/20] md: simplify free_params for kmalloc vs vmalloc
 fallback
Date: Thu, 28 Apr 2016 18:00:21 +0200
Message-ID: <20160428160021.GN31489@dhcp22.suse.cz>
References: <1461849846-27209-1-git-send-email-mhocko@kernel.org>
 <1461849846-27209-20-git-send-email-mhocko@kernel.org>
 <20160428153730.GA14570@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20160428153730.GA14570@redhat.com>
Sender: owner-linux-mm@kvack.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, Shaohua Li <shli@kernel.org>
List-Id: dm-devel.ids

On Thu 28-04-16 11:37:31, Mike Snitzer wrote:
> On Thu, Apr 28 2016 at  9:24am -0400,
> Michal Hocko <mhocko@kernel.org> wrote:
> 
> > From: Michal Hocko <mhocko@suse.com>
> > 
> > Use kvfree rather than DM_PARAMS_[KV]MALLOC specific param flags.
> > 
> > Cc: Shaohua Li <shli@kernel.org>
> > Cc: Mikulas Patocka <mpatocka@redhat.com>
> > Cc: dm-devel@redhat.com
> > Signed-off-by: Michal Hocko <mhocko@suse.com>
> 
> Nack, seriously, this is the 3rd time this patch has been attempted.
> Did you actually test the change?  It'll crash very quickly, see:
> 
> https://www.redhat.com/archives/dm-devel/2016-April/msg00103.html

You are right! My bad I should have checked the other callers!

-- 
Michal Hocko
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
