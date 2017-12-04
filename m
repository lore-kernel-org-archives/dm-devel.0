From: Guan Junxiong <guanjunxiong@huawei.com>
Subject: Re: [PATCH 0/4] path latency prio fixes
Date: Mon, 4 Dec 2017 22:23:37 +0800
Message-ID: <ec755f37-cecf-ef5c-d9ee-fa63ff39ec99@huawei.com>
References: <06F84A57D601574CAA706EE1A6270A5F01039517@DGGEMM505-MBX.china.huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <06F84A57D601574CAA706EE1A6270A5F01039517@DGGEMM505-MBX.china.huawei.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Wilck <mwilck@suse.com>
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>, guanjunxiong <guanjunxiong@huawei.com>, "Shenhong (C)" <shenhong09@huawei.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, niuhaoxin <niuhaoxin@huawei.com>
List-Id: dm-devel.ids

Hi Martin,

Sorry for the late reply. I have recovered from a busy week.
Please find my comments below.

On 2017/11/23 10:10, Martin wrote:
> Hi Guan,
> 
> while staring at this code the other day, I realized another possible
> issue with your latency prioritizer. 
> 
> It will cause significant IO to every path of a map during multipath /
> multipathd startup. If any paths really have latencies as long as your
> patch considers (up to 100s), or worse if they don't respond at all,
> startup may be *massively* delayed or may even never complete. So if we
> a storage with two mirrors with a fast and a slow leg (I reckon that's
> the scenario this patch was made for), and if we're out of luck and the
> slow leg is probed first, we may end up in a situation where the fast
> leg, which may be fully up and healthy, is never set up (or with big
> delay) because multipathd keeps waiting for the slow leg to respond.
> 

Yes, we should take of the above case.  The prio_args num_io is not the
essential method to avoid this.

> Similar delays can occur whenever pathinfo(..., DI_PRIO) is called.
> Unless I'm overlooking something essential here, that's a really
> dangerous thing to do. I believe that before activating this prio
> checker for  everyone, we need find a way to avoid this scenario. 
> 
> By using aio with a reasonable timeout for the latency check rather
> then sync IO, we could at least set an upper limit for the time
> get_prio takes. That would be a first step. But I don't think that
> would be sufficient. 
> 
> What we'd really need is an asynchronous priority checker, similar to
> the asynchronous path checker. The get_prio() call would return
> immediately with some special return code indicating to the caller that
> a priority check is running the background. A preliminary prio would be

Aligned with this. An asynchronous priority checker is helpful.

> set for the path in pathinfo(), and multipathd would re-check later (or
> get some sort of event) when the priority check has actually been done.
> An open question is what multipathd should do wrt path grouping if it
> only has preliminary prio values, in particular with group_by_prio.

For the open question, in this situation, IMO  it's reasonable to overwriting
the preliminary prio values if we let the user/admin know : "this is an
asynchronous priority checkers and it has high priority to the other synchronous
prioritizer.

> Putting Hannes and Ben on CC because I'd like to get their opinion,
> too.
Me too.


> Regards
> Martin
