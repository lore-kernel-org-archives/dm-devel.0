From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH 0/4] dm-latency: Introduction
Date: Fri, 27 Feb 2015 14:13:02 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1502271412250.32344@file01.intranet.prod.int.rdu2.redhat.com>
References: <54EEBFAF.4000002@gmail.com>
	<alpine.LRH.2.02.1502261142590.13050@file01.intranet.prod.int.rdu2.redhat.com>
	<20150226172518.GJ18511@localhost.localdomain>
	<alpine.LRH.2.02.1502261426090.10276@file01.intranet.prod.int.rdu2.redhat.com>
	<1647891142.9505344.1424979943736.JavaMail.zimbra@redhat.com>
	<20150227102352.GA27817@localhost.localdomain>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20150227102352.GA27817@localhost.localdomain>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Bryn M. Reeves" <bmr@redhat.com>
Cc: Laurence Oberman <loberman@redhat.com>, Tao Ma <boyu.mt@taobao.com>, Robin Dong <sanbai@alibaba-inc.com>, device-mapper development <dm-devel@redhat.com>, Coly Li <colyli@gmail.com>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids



On Fri, 27 Feb 2015, Bryn M. Reeves wrote:

> On Thu, Feb 26, 2015 at 02:45:43PM -0500, Laurence Oberman wrote:
> > For my particular use case its about providing the ability to warn on latencies being seen for multipath devices based on a given threshold.
> > Of course this can simply be a userspace tool using what we already expose and do the calculations to make it work.
> > When we have these latencies we then focus on which SAN path may or may not be contributing.
> > Within multipathd we can already configure service time as a load balancer, perhaps we can do the monitoring in the same place.
> > i.e. warn on service time above a threshold.
> 
> One limitation here is that the dm-mpath target is request-based.
> Currently dm-statistics are only available for bio-based targets. This
> means that to obtain fine-grained stats for multipath devices we need to
> insert a linear layer on top of the dm-mpath device.

Someone could hack dm statistics to work on request based targets.

Mikulas
