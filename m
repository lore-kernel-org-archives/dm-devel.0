From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: dm bufio: Reduce dm_bufio_lock contention
Date: Tue, 4 Sep 2018 13:30:44 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1809041328320.8875@file01.intranet.prod.int.rdu2.redhat.com>
References: <1528790608-19557-1-git-send-email-jing.xia@unisoc.com>
	<20180612212007.GA22717@redhat.com>
	<alpine.LRH.2.02.1806131001250.15845@file01.intranet.prod.int.rdu2.redhat.com>
	<CAN=25QMQiJ7wvfvYvmZnEnrkeb-SA7_hPj+N2RnO8y-aVO8wOQ@mail.gmail.com>
	<20180614073153.GB9371@dhcp22.suse.cz>
	<CAN=25QNrENVFbb9UAAAJJqKsEeMY+qNs5cQA4EGwgB2dMYTZug@mail.gmail.com>
	<alpine.LRH.2.02.1809031816120.27063@file01.intranet.prod.int.rdu2.redhat.com>
	<20180904070824.GH14951@dhcp22.suse.cz>
	<20180904151844.GB10112@redhat.com>
	<20180904160732.GO14951@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180904160732.GO14951@dhcp22.suse.cz>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Michal Hocko <mhocko@kernel.org>
Cc: dm-devel@redhat.com, agk@redhat.com, jing xia <jing.xia.mail@gmail.com>, Mike Snitzer <snitzer@redhat.com>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids



On Tue, 4 Sep 2018, Michal Hocko wrote:

> Regarding other other workloads. AFAIR the problem was due to the
> wait_iff_congested in the direct reclaim. And I've been arguing that
> special casing __GFP_NORETRY is not a propoer way to handle that case.
> We have PF_LESS_THROTTLE to handle cases where the caller cannot be
> really throttled because it is a part of the congestion control. I dunno
> what happened in that regards since then though.
> -- 
> Michal Hocko
> SUSE Labs

So, could you take this patch https://patchwork.kernel.org/patch/10505523/ 
and commit it to the kernel?

You agreed with that patch, but you didn't commit it.

Mikulas
