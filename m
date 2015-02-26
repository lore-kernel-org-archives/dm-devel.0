From: Laurence Oberman <loberman@redhat.com>
Subject: Re: [PATCH 0/4] dm-latency: Introduction
Date: Thu, 26 Feb 2015 14:45:43 -0500 (EST)
Message-ID: <1647891142.9505344.1424979943736.JavaMail.zimbra@redhat.com>
References: <54EEBFAF.4000002@gmail.com>
	<alpine.LRH.2.02.1502261142590.13050@file01.intranet.prod.int.rdu2.redhat.com>
	<20150226172518.GJ18511@localhost.localdomain>
	<alpine.LRH.2.02.1502261426090.10276@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.2.02.1502261426090.10276@file01.intranet.prod.int.rdu2.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Tao Ma <boyu.mt@taobao.com>, "Bryn M. Reeves" <bmr@redhat.com>, Coly Li <colyli@gmail.com>, device-mapper development <dm-devel@redhat.com>, Robin Dong <sanbai@alibaba-inc.com>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

For my particular use case its about providing the ability to warn on latencies being seen for multipath devices based on a given threshold.
Of course this can simply be a userspace tool using what we already expose and do the calculations to make it work.
When we have these latencies we then focus on which SAN path may or may not be contributing.
Within multipathd we can already configure service time as a load balancer, perhaps we can do the monitoring in the same place.
i.e. warn on service time above a threshold.

When a customer says "I currently use the following xxxx for multipath  on RHEL however I want to go to native multipathing, but you don't provide the monitoring I need" I want to work to an enhancement.

For example I had Ben add the ability just recently to multipath to control re-establishing path usage based on path health when the path returns to mimic what DMP can do to avoid recovery due to path flapping. 

Thanks

Laurence Oberman
Red Hat Global Support Service
SEG Team

----- Original Message -----
From: "Mikulas Patocka" <mpatocka@redhat.com>
To: "Bryn M. Reeves" <bmr@redhat.com>
Cc: "device-mapper development" <dm-devel@redhat.com>, "Tao Ma" <boyu.mt@taobao.com>, "Robin Dong" <sanbai@alibaba-inc.com>, "Laurence Oberman" <loberman@redhat.com>, "Coly Li" <colyli@gmail.com>, "Alasdair Kergon" <agk@redhat.com>
Sent: Thursday, February 26, 2015 2:34:40 PM
Subject: Re: [dm-devel] [PATCH 0/4] dm-latency: Introduction



On Thu, 26 Feb 2015, Bryn M. Reeves wrote:

> On Thu, Feb 26, 2015 at 11:49:28AM -0500, Mikulas Patocka wrote:
> > We have already dm-statistics that counts various events - see 
> > Documentation/device-mapper/statistics.txt. It counts the nubmer of 
> > requests and the time spent servicing each request, thus you can 
> > calculate average latency from these values.
> 
> Right: average service time (as reported by iostat etc.) is easily derived
> from the existing stats.
> 
> Does the separate latency accounting buy anything additional?
>
> > Please look at dm-statistics to see if it fits your purpose. If you need 
> > additional information not provided by dm-statistics, it would be better 
> > to extend the statistics code rather than introduce new "latency" 
> > infrastructure.
> 
> Agreed; I'm working on userspace support for dm-statistics at the moment
> and if there is a need for these additional measurements I would greatly
> prefer to consume them as additional fields in the existing dm-stats
> counter set.
> 
> This also has the advantage of benefiting from the existing step and
> area support allowing a device to be subdivided into discrete stats
> regions.
> 
> Regards,
> Bryn.

Coly's paper (http://blog.coly.li/docs/osc13-coly.pdf) shows that they 
take histogram of latencies and use it to predict disk failure.

That could be easily added to dm-statistics.

Average latency alone can't be used to predict disk failure because 
average latency depends on the type of workload (for example - sequantial 
or nearly sequential requests have much lower latency than random 
requests).

I'd like to know if we need separate histogram per region, or if it is 
sufficient to have a histogram per device. dm-latency has no regions, it 
has a histogram for the whole device. The histogram-per-region would 
consume more memory, I'm interested if there is some reasonable use case 
for that.

Mikulas
