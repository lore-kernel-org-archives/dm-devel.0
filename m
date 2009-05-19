From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: Re: Re: [PATCH 3/3] dm-mpath: add service-time oriented
	dynamic load balancer
Date: Tue, 19 May 2009 11:59:12 +0900
Message-ID: <4A122080.5060606@ct.jp.nec.com>
References: <49F1729A.1000906@ct.jp.nec.com>
	<49F17362.7080205@ct.jp.nec.com>	<20090509004959.GJ1320@agk-dp.fab.redhat.com>	<4A0CDCE1.50409@ct.jp.nec.com>
	<20090518114607.GA5125@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090518114607.GA5125@agk-dp.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair Kergon <agk@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi Alasdair,

On 05/18/2009 08:46 PM +0900, Alasdair G Kergon wrote:
> On Fri, May 15, 2009 at 12:09:21PM +0900, Kiyoshi Ueda wrote:
>> However, if I limit the 'perf' value in smaller range (e.g. 0 to 100),
>> such overflow shouldn't happen.  So I should be able to use
>> multiplication.  Also, I don't need to use size_t for 'perf',
>> because 'unsinged' should be enough for such small values.
>  
> I think a small range would be adequate - look at the number sizes and
> go 0-100 or 0-1000 as appropriate.
> 
> Thinking of naming, is it 'relative_throughput' ?

Yes, 'relative_throughput' may be better naming.  I'll take it.


> However, is it also going to be possible to extend this target to measure the
> the actual throughput?  If we did that, would we use a special value to 
> indicate it or add a new table parameter and keep the 'perf' ones as a
> manual adjustment factor applied on top of the calculated one?

The older version of dm-service-time calculated the actual throughput
dynamically using part_stat:
    http://marc.info/?l=dm-devel&m=123321314426149&w=2

But the calculated values often had some noises and it didn't work well.
(e.g. Once the throughput value of a path was calculated so small,
      the path was never used, and the small throughput value was never
      updated, and the path was never used, and ...)

So I think doing such calculations in user-space and simplifying
the kernel-code are better.
For dynamically changing path's bandwidth, user-space daemon can
measure the throughput periodically and notify the dm device.
I've been thinking of adding a new dm message handler to update
'relative_thoughput' in future.
What do you think?

Thanks,
Kiyoshi Ueda
