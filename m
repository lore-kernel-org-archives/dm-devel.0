From: Michal Hocko <mhocko@kernel.org>
Subject: Re: dm bufio: Reduce dm_bufio_lock contention
Date: Wed, 1 Aug 2018 09:03:12 +0200
Message-ID: <20180801070312.GC16767@dhcp22.suse.cz>
References: <1528790608-19557-1-git-send-email-jing.xia@unisoc.com>
 <20180612212007.GA22717@redhat.com>
 <alpine.LRH.2.02.1806131001250.15845@file01.intranet.prod.int.rdu2.redhat.com>
 <CAN=25QMQiJ7wvfvYvmZnEnrkeb-SA7_hPj+N2RnO8y-aVO8wOQ@mail.gmail.com>
 <20180614073153.GB9371@dhcp22.suse.cz>
 <CAN=25QNrENVFbb9UAAAJJqKsEeMY+qNs5cQA4EGwgB2dMYTZug@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAN=25QNrENVFbb9UAAAJJqKsEeMY+qNs5cQA4EGwgB2dMYTZug@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jing xia <jing.xia.mail@gmail.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@redhat.com>, agk@redhat.com, dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Wed 01-08-18 10:48:00, jing xia wrote:
> We reproduced this issue again and found out the root cause.
> dm_bufio_prefetch() with dm_bufio_lock enters the direct reclaim and
> takes a long time to do the soft_limit_reclaim, because of the huge
> number of memory excess of the memcg.
> Then, all the task who do shrink_slab() wait for  dm_bufio_lock.
> 
> Any suggestions for this?Thanks.

Do not use soft limit?
-- 
Michal Hocko
SUSE Labs
