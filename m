From: Michal Hocko <mhocko@kernel.org>
Subject: Re: dm bufio: Reduce dm_bufio_lock contention
Date: Fri, 22 Jun 2018 15:10:13 +0200
Message-ID: <20180622131013.GA10465@dhcp22.suse.cz>
References: <20180615073201.GB24039@dhcp22.suse.cz>
 <alpine.LRH.2.02.1806150724260.15022@file01.intranet.prod.int.rdu2.redhat.com>
 <20180615115547.GH24039@dhcp22.suse.cz>
 <alpine.LRH.2.02.1806150832100.26650@file01.intranet.prod.int.rdu2.redhat.com>
 <20180615130925.GI24039@dhcp22.suse.cz>
 <alpine.LRH.2.02.1806181003560.4201@file01.intranet.prod.int.rdu2.redhat.com>
 <20180619104312.GD13685@dhcp22.suse.cz>
 <alpine.LRH.2.02.1806191228110.25656@file01.intranet.prod.int.rdu2.redhat.com>
 <20180622090151.GS10465@dhcp22.suse.cz>
 <alpine.LRH.2.02.1806220828040.8072@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1806220828040.8072@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: jing xia <jing.xia.mail@gmail.com>, Mike Snitzer <snitzer@redhat.com>, agk@redhat.com, dm-devel@redhat.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
List-Id: dm-devel.ids

On Fri 22-06-18 08:44:52, Mikulas Patocka wrote:
> On Fri, 22 Jun 2018, Michal Hocko wrote:
[...]
> > Why? How are you going to audit all the callers that the behavior makes
> > sense and moreover how are you going to ensure that future usage will
> > still make sense. The more subtle side effects gfp flags have the harder
> > they are to maintain.
> 
> I did audit them - see the previous email in this thread: 
> https://www.redhat.com/archives/dm-devel/2018-June/thread.html

I do not see any mention about throttling expectations for those users.
You have focused only on the allocation failure fallback AFAIR
-- 
Michal Hocko
SUSE Labs
