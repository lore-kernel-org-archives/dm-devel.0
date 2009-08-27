From: Ryo Tsuruta <ryov@valinux.co.jp>
Subject: Re: [Test Result] I/O bandwidth Control by dm-ioband -
 partition-based environment
Date: Thu, 27 Aug 2009 15:20:42 +0900 (JST)
Message-ID: <20090827.152042.104028330.ryov@valinux.co.jp>
References: <2891419e0908261846v4fa19791q4552975f10dd64e5@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <2891419e0908261846v4fa19791q4552975f10dd64e5@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: baramsori72@gmail.com
Cc: ioband-devel@lists.sourceforge.net, containers@lists.linux-foundation.org, dm-devel@redhat.com, corsetproject@googlegroups.com
List-Id: dm-devel.ids

Hi Dong-Jae,

# I've added dm-devel to Cc:.

Dong-Jae Kang <baramsori72@gmail.com> wrote:
> Hi Ryo
> 
> I attached new test result file(ioband-partition-based-evaluation.xls)in
> this mail.

Thanks for your great job.

> In this time, it is not virtualization environment.
> I evaluated partition-based use cases before I do it in vitualization
> environment.
> because I think the two cases are smilar each other.
> 
> The detailed information about the evaluation can be referred in attached
> file.
> 
> If you have any questions or comments after examine it,
> please give me your opinion.

I would like to know the throughput without dm-ioband in your
environment. Because the total throughput of range-bw policy is
8000KB/s, which means the device has a capability to perform over
8000KB/s, but the total throughput of weight policy is lower than
the range-bw policy. In my environment, there is no significant
difference in average throughput between with and without dm-ioband.
I ran fio in the way described in your result file. Here are the
results of my environment. The throughputs were calculated from
"iostat -k 1" outputs.

            buffered write test
           Avg. throughput [KB/s]
        w/o ioband     w/ioband
sdb2         14485         5788
sdb3         12494        22295
total        26979        28030

Thanks,
Ryo Tsuruta
