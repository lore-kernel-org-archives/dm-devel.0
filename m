From: Ryo Tsuruta <ryov@valinux.co.jp>
Subject: Re: [Test Result] I/O bandwidth Control by dm-ioband -
 partition-based environment
Date: Wed, 02 Sep 2009 20:18:40 +0900 (JST)
Message-ID: <20090902.201840.226792198.ryov@valinux.co.jp>
References: <2891419e0908280324v32e7ba3fq88eb754052cbf094@mail.gmail.com>
	<20090831.111233.226777940.ryov@valinux.co.jp>
	<2891419e0908310308w31c46180nce72d271cd947c98@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <2891419e0908310308w31c46180nce72d271cd947c98@mail.gmail.com>
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

Dong-Jae Kang <baramsori72@gmail.com> wrote:
> Hi Ryo
> Sorry for late reply.
> 
> Mr Lee and I tested total bandwidth as you requested and the result is like
> attached file.

Thank you for your work.

> I know file attaching is not proper in mailing list,
> but I selected it for efficient and easy communication. sorry :)
> 
> And Buffed-Device case can be some strange,
> it has too much variation in total bandwidth, So you had better to see as
> only reference.
> The rests didn't have big fluctuation such like Buffered-Device case.
> 
> if you have another request about the result,
> reply to me about that.

Could you try the test on the weight policy with increaing token to
1280? I guess that the throughput difference between without and with
dm-ioband is caused since the token is a little small against the disk
speed.

> Additionally, I will try to inform the test results in cgroup environment of
> you in case by case.
> What do you think about it?

I would like to know the reason for the diffirence between debug patch
and iostat in the prvious test you did (total_bandwidth_result.xls).

Thanks,
Ryo Tsuruta
