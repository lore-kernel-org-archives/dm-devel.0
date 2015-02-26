From: "Bryn M. Reeves" <bmr@redhat.com>
Subject: Re: [PATCH 0/4] dm-latency: Introduction
Date: Thu, 26 Feb 2015 17:25:18 +0000
Message-ID: <20150226172518.GJ18511@localhost.localdomain>
References: <54EEBFAF.4000002@gmail.com>
	<alpine.LRH.2.02.1502261142590.13050@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1502261142590.13050@file01.intranet.prod.int.rdu2.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Tao Ma <boyu.mt@taobao.com>, Robin Dong <sanbai@alibaba-inc.com>, Laurence Oberman <loberman@redhat.com>, Coly Li <colyli@gmail.com>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Thu, Feb 26, 2015 at 11:49:28AM -0500, Mikulas Patocka wrote:
> We have already dm-statistics that counts various events - see 
> Documentation/device-mapper/statistics.txt. It counts the nubmer of 
> requests and the time spent servicing each request, thus you can 
> calculate average latency from these values.

Right: average service time (as reported by iostat etc.) is easily derived
from the existing stats.

Does the separate latency accounting buy anything additional?

> Please look at dm-statistics to see if it fits your purpose. If you need 
> additional information not provided by dm-statistics, it would be better 
> to extend the statistics code rather than introduce new "latency" 
> infrastructure.

Agreed; I'm working on userspace support for dm-statistics at the moment
and if there is a need for these additional measurements I would greatly
prefer to consume them as additional fields in the existing dm-stats
counter set.

This also has the advantage of benefiting from the existing step and
area support allowing a device to be subdivided into discrete stats
regions.

Regards,
Bryn.
