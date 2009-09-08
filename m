From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [RFC] IO scheduler based IO controller V9
Date: Tue, 8 Sep 2009 09:55:36 -0400
Message-ID: <20090908135536.GD15974@redhat.com>
References: <1251495072-7780-1-git-send-email-vgoyal@redhat.com>
	<4A9DC33E.6000408@cn.fujitsu.com> <4AA46C6E.4010109@cn.fujitsu.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4AA46C6E.4010109@cn.fujitsu.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: dhaval@linux.vnet.ibm.com, peterz@infradead.org, dm-devel@redhat.com, dpshah@google.com, jens.axboe@oracle.com, agk@redhat.com, balbir@linux.vnet.ibm.com, paolo.valente@unimore.it, jmarchan@redhat.com, fernando@oss.ntt.co.jp, mikew@google.com, jmoyer@redhat.com, nauman@google.com, mingo@elte.hu, m-ikeda@ds.jp.nec.com, riel@redhat.com, lizf@cn.fujitsu.com, fchecconi@gmail.com, s-uchida@ap.jp.nec.com, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org, righi.andrea@gmail.com, torvalds@linux-foundation.org
List-Id: dm-devel.ids

On Mon, Sep 07, 2009 at 10:14:06AM +0800, Gui Jianfeng wrote:
> Hi Vivek,
> 
> Here is the vanilla kernel and V9 comparision.
> 
>                            Normal Read  |  Random Read  |  Normal Write  |  Random Write
> 
> vanilla(Avg of 3 times)   67580 KiB/s     3540 KiB/s      61964 KiB/s      9823 KiB/s
> 
> V9(Avg of 3 times)        68954 KiB/s     3567 KiB/s      60654 KiB/s      9858 KiB/s
> 
> Performance                +2.0%           +0.7%          -2.1%             +0.3%
> 

Thanks Gui. So that's lot of improvements from previous versions. I remember
you were noticing 7% regressions in buffered write performance.

Thanks
Vivek
