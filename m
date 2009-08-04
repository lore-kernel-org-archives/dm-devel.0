From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Subject: Re: [PATCH] io-controller: implement per group request
 allocation limitation
Date: Tue, 04 Aug 2009 14:38:35 +0800
Message-ID: <4A77D76B.3090502@cn.fujitsu.com>
References: <1246564917-19603-1-git-send-email-vgoyal@redhat.com>
	<4A569FC5.7090801@cn.fujitsu.com>
	<20090713160352.GA3714@redhat.com> <4A5BA238.3030902@ds.jp.nec.com>
	<4A5C377F.4040105@cn.fujitsu.com> <4A77964A.7040602@ds.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4A77964A.7040602@ds.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Munehiro Ikeda <m-ikeda@ds.jp.nec.com>
Cc: dhaval@linux.vnet.ibm.com, snitzer@redhat.com, peterz@infradead.org, dm-devel@redhat.com, dpshah@google.com, jens.axboe@oracle.com, agk@redhat.com, balbir@linux.vnet.ibm.com, paolo.valente@unimore.it, fernando@oss.ntt.co.jp, mikew@google.com, jmoyer@redhat.com, nauman@google.com, Vivek Goyal <vgoyal@redhat.com>, righi.andrea@gmail.com, lizf@cn.fujitsu.com, fchecconi@gmail.com, akpm@linux-foundation.org, jbaron@redhat.com, linux-kernel@vger.kernel.org, s-uchida@ap.jp.nec.com, containers@lists.linux-foundation.org
List-Id: dm-devel.ids

Munehiro Ikeda wrote:
...
> 
> Consideration and Conclusion
> =============================
> 
>  From result(1), it is observed that it takes 1000~1200[ms] to rise P2
> bandwidth.  In result(2), where both of g1 and g2 have
> nr_group_requests=100, the delay gets longer as 1800~2000[ms].  In
> addition to it, the average bandwidth becomes ~5% lower than result(1). 
> This is supposed that P2 couldn't allocate enough requests.
> Then, result(3) shows that bandwidth of P2 can rise quickly (~300[ms])
> if nr_group_requests can be set per-cgroup.  Result(4) shows that the
> delay can be shortened by setting g2 as RT class, however, the delay is
> still longer than result(3).
> 
> I think it is confirmed that "per-cgroup nr_requests limitation is
> useful in a certain situation".  Beyond that, the discussion topic is
> the benefit pointed out above is eligible for the complication of the
> implementation.  IMHO, I don't think the implementation of per-cgroup
> request limitation is too complicated to accept.  On the other hand I
> guess it suddenly gets complicated if we try to implement further more,
> especially hierarchical support.  It is also true that I have a feeling
> that implementation without per-device limitation and hierarchical
> support is like "unfinished work".
> 
> So, my opinion so far is that, per-cgroup nr_requests limitation should
> be merged only if hierarchical support is concluded "unnecessary" for
> it.  If merging it tempts hierarchical support, it shouldn't be.
> How about your opinion, all?

  Hi Munehiro-san,

  Thanks for the great job. It seems Per-cgroup requests allocation limits
  has its value in some cases. IMHO, for the time being, we can just drop
  the hierarchical support for "Per-cgroup requests allocation limits", and
  see whether it can work well.

> 
> My considerations or verification method might be wrong.  Please correct
> them if any.  And if you have any other idea of scenario to verify the
> effect of per-cgroup nr_requests limitation, please let me know.  I'll
> try it.
> 
> 
> 
> 
> ------------------------------------------------------------------------
> 

-- 
Regards
Gui Jianfeng
