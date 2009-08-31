From: Ryo Tsuruta <ryov@valinux.co.jp>
Subject: Re: [Test Result] I/O bandwidth Control by dm-ioband -
 partition-based environment
Date: Mon, 31 Aug 2009 11:12:33 +0900 (JST)
Message-ID: <20090831.111233.226777940.ryov@valinux.co.jp>
References: <20090827.152042.104028330.ryov@valinux.co.jp>
	<2891419e0908270403kd439d29gedeea6fcae753d6d@mail.gmail.com>
	<2891419e0908280324v32e7ba3fq88eb754052cbf094@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <2891419e0908280324v32e7ba3fq88eb754052cbf094@mail.gmail.com>
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

Thanks for testing.
Could you do the same test without dm-ioband? I would like to know
the throughput of your disk drive and a difference with and withour
dm-ioband.

Thanks,
Ryo Tsuruta

Dong-Jae Kang <baramsori72@gmail.com> wrote:
> Hi Ryo
> I attached new file that includes I/O total bandwidth of evaluation system.
> We tested total bandwidth of weight policy by I/O in Dom0 and DomU system
> and it is measured through iostat tool and dm-ioband debug patch which I
> gave you several months ago.
> Of course, the result in prior report was measured by dm-ioband debug patch.
> 
> As a result, the big difference in prior report derives from the location
> where we measured I/O bandwidth
> iostat counts it in application level and dm-ioband debug patch does it in
> dm-ioband controller.
> I think the difference is related with buffer cache.
> 
> Thank you.
> Have a nice weekend
> 
> 2009/8/27 Dong-Jae Kang <baramsori72@gmail.com>
> 
> > Hi Ryo
> >
> > 2009/8/27 Ryo Tsuruta <ryov@valinux.co.jp>
> >
> > Hi Dong-Jae,
> >>
> >> # I've added dm-devel to Cc:.
> >>
> >> Dong-Jae Kang <baramsori72@gmail.com> wrote:
> >> > Hi Ryo
> >> >
> >> > I attached new test result file(ioband-partition-based-evaluation.xls)in
> >> > this mail.
> >>
> >> Thanks for your great job.
> >>
> >> > In this time, it is not virtualization environment.
> >> > I evaluated partition-based use cases before I do it in vitualization
> >> > environment.
> >> > because I think the two cases are smilar each other.
> >> >
> >> > The detailed information about the evaluation can be referred in
> >> attached
> >> > file.
> >> >
> >> > If you have any questions or comments after examine it,
> >> > please give me your opinion.
> >>
> >> I would like to know the throughput without dm-ioband in your
> >> environment. Because the total throughput of range-bw policy is
> >> 8000KB/s, which means the device has a capability to perform over
> >> 8000KB/s, but the total throughput of weight policy is lower than
> >> the range-bw policy. In my environment, there is no significant
> >> difference in average throughput between with and without dm-ioband.
> >> I ran fio in the way described in your result file. Here are the
> >> results of my environment. The throughputs were calculated from
> >> "iostat -k 1" outputs.
> >>
> >>            buffered write test
> >>           Avg. throughput [KB/s]
> >>        w/o ioband     w/ioband
> >> sdb2         14485         5788
> >> sdb3         12494        22295
> >> total        26979        28030
> >>
> >
> > OK, good comments.
> > I omitted the total bandwidth of the evaluation system.
> >
> > I will reply to you about it tomorrow after I check and re-test it again.
> >
> >>
> >> Thanks,
> >> Ryo Tsuruta
> >>
> >
> > Thank you for comments.
> >
> >
> > --
> > Best Regards,
> > Dong-Jae Kang
> >
> 
> 
> 
> -- 
> Best Regards,
> Dong-Jae Kang
