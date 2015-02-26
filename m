From: "Bryn M. Reeves" <bmr@redhat.com>
Subject: Re: [PATCH 0/4] dm-latency: Introduction
Date: Thu, 26 Feb 2015 17:39:09 +0000
Message-ID: <20150226173908.GK18511@localhost.localdomain>
References: <54EEBFAF.4000002@gmail.com>
	<alpine.LRH.2.02.1502261142590.13050@file01.intranet.prod.int.rdu2.redhat.com>
	<1377703243.9422950.1424970047797.JavaMail.zimbra@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1377703243.9422950.1424970047797.JavaMail.zimbra@redhat.com>
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
Cc: Tao Ma <boyu.mt@taobao.com>, Robin Dong <sanbai@alibaba-inc.com>, Mikulas Patocka <mpatocka@redhat.com>, Coly Li <colyli@gmail.com>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Thu, Feb 26, 2015 at 12:00:47PM -0500, Laurence Oberman wrote:
> Mikulas
> Thanks
> This came from customer asking for support for similar functionality in proprietary solutions such as PowerPath and HDLM.
> I had seen the information from Coly Li and asked if he could submit for comments.
> I will look into what can be done with what is is /sys/block/dm-xxx/stat

Those are just the basic diskstats counters (similar to /proc/diskstats).

You want to look at the stuff described in Documentation/device-mapper/dm-statistics.txt

Regards,
Bryn.
