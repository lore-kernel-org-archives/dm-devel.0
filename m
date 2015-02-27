From: "Bryn M. Reeves" <bmr@redhat.com>
Subject: Re: [PATCH 0/4] dm-latency: Introduction
Date: Fri, 27 Feb 2015 10:23:52 +0000
Message-ID: <20150227102352.GA27817@localhost.localdomain>
References: <54EEBFAF.4000002@gmail.com>
	<alpine.LRH.2.02.1502261142590.13050@file01.intranet.prod.int.rdu2.redhat.com>
	<20150226172518.GJ18511@localhost.localdomain>
	<alpine.LRH.2.02.1502261426090.10276@file01.intranet.prod.int.rdu2.redhat.com>
	<1647891142.9505344.1424979943736.JavaMail.zimbra@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1647891142.9505344.1424979943736.JavaMail.zimbra@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Laurence Oberman <loberman@redhat.com>
Cc: Tao Ma <boyu.mt@taobao.com>, Robin Dong <sanbai@alibaba-inc.com>, device-mapper development <dm-devel@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, Coly Li <colyli@gmail.com>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Thu, Feb 26, 2015 at 02:45:43PM -0500, Laurence Oberman wrote:
> For my particular use case its about providing the ability to warn on latencies being seen for multipath devices based on a given threshold.
> Of course this can simply be a userspace tool using what we already expose and do the calculations to make it work.
> When we have these latencies we then focus on which SAN path may or may not be contributing.
> Within multipathd we can already configure service time as a load balancer, perhaps we can do the monitoring in the same place.
> i.e. warn on service time above a threshold.

One limitation here is that the dm-mpath target is request-based.
Currently dm-statistics are only available for bio-based targets. This
means that to obtain fine-grained stats for multipath devices we need to
insert a linear layer on top of the dm-mpath device.

If we wanted to take this further and apply counters to each underlying
path then that would require a similar layer to be added between the sd
devices and the dm-mpath map.

> When a customer says "I currently use the following xxxx for multipath
> on RHEL however I want to go to native multipathing, but you don't
> provide the monitoring I need" I want to work to an enhancement.

Average wait times are easily obtained from the current kernel counter
set but (aside from the ability to hone in on subsections of the device)
this doesn't buy you that much beyond vanilla iostat.

Regards,
Bryn.
