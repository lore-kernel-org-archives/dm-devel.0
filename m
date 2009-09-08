From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [RFC] IO scheduler based IO controller V9
Date: Tue, 8 Sep 2009 18:28:14 -0400
Message-ID: <20090908222814.GA3558@redhat.com>
References: <1251495072-7780-1-git-send-email-vgoyal@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1251495072-7780-1-git-send-email-vgoyal@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: linux-kernel@vger.kernel.org, jens.axboe@oracle.com
Cc: dhaval@linux.vnet.ibm.com, peterz@infradead.org, dm-devel@redhat.com, dpshah@google.com, agk@redhat.com, balbir@linux.vnet.ibm.com, paolo.valente@unimore.it, jmarchan@redhat.com, guijianfeng@cn.fujitsu.com, fernando@oss.ntt.co.jp, mikew@google.com, jmoyer@redhat.com, nauman@google.com, mingo@elte.hu, m-ikeda@ds.jp.nec.com, riel@redhat.com, lizf@cn.fujitsu.com, fchecconi@gmail.com, s-uchida@ap.jp.nec.com, containers@lists.linux-foundation.org, akpm@linux-foundation.org, righi.andrea@gmail.com, torvalds@linux-foundation.org
List-Id: dm-devel.ids

On Fri, Aug 28, 2009 at 05:30:49PM -0400, Vivek Goyal wrote:
> 
> Hi All,
> 
> Here is the V9 of the IO controller patches generated on top of 2.6.31-rc7.
> 
> For ease of patching, a consolidated patch is available here.
> 
> http://people.redhat.com/~vgoyal/io-controller/io-scheduler-based-io-controller-v9.patch
> 

Found few issues during testing. Sending 3 more patches for this series.
After some more testing, will merge these patches in higher level patches
and post V10.

Thanks
Vivek
