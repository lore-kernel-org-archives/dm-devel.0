From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: Re: [PATCH 1/9] dm core: clean up in-flight checking
Date: Tue, 20 Oct 2009 16:47:38 +0900
Message-ID: <4ADD6B1A.3040309@ct.jp.nec.com>
References: <4AD7FC11.7030009@ct.jp.nec.com> <4AD7FCC1.6040100@ct.jp.nec.com>
	<20091019211656.GB25347@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20091019211656.GB25347@agk-dp.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair G Kergon <agk@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi Alasdair,

On 2009/10/20 6:16 +0900, Alasdair G Kergon wrote:
> On Fri, Oct 16, 2009 at 01:55:29PM +0900, Kiyoshi Ueda wrote:
>> This patch depends on:
>>   http://git.kernel.org/?p=linux/kernel/git/axboe/linux-2.6-block.git;a=commit;h=a9327cac440be4d8333bba975cbbf76045096275
>>   (Seperate read and write statistics of in_flight requests)
>  
> Already upstream I think!

It has been committed in 2.6.32-rc5, so this clean-up patch
can be applied on it now.

I'll update my patch-set (on top of 2.6.32-rc6 probably) and re-post
if you want.

> Alasdair

Thanks,
Kiyoshi Ueda
