From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 15/23] io-controller: noop changes for
	hierarchical fair queuing
Date: Thu, 10 Sep 2009 13:32:42 -0400
Message-ID: <20090910173242.GB29559@redhat.com>
References: <1251495072-7780-1-git-send-email-vgoyal@redhat.com>
	<1251495072-7780-16-git-send-email-vgoyal@redhat.com>
	<4A9B3B0B.9090009@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4A9B3B0B.9090009@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Rik van Riel <riel@redhat.com>
Cc: dhaval@linux.vnet.ibm.com, peterz@infradead.org, dm-devel@redhat.com, dpshah@google.com, jens.axboe@oracle.com, agk@redhat.com, balbir@linux.vnet.ibm.com, paolo.valente@unimore.it, jmarchan@redhat.com, guijianfeng@cn.fujitsu.com, fernando@oss.ntt.co.jp, mikew@google.com, jmoyer@redhat.com, nauman@google.com, mingo@elte.hu, m-ikeda@ds.jp.nec.com, lizf@cn.fujitsu.com, fchecconi@gmail.com, s-uchida@ap.jp.nec.com, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org, righi.andrea@gmail.com, torvalds@linux-foundation.org
List-Id: dm-devel.ids

On Sun, Aug 30, 2009 at 10:52:59PM -0400, Rik van Riel wrote:
> Vivek Goyal wrote:
>> This patch changes noop to use queue scheduling code from elevator layer.
>> One can go back to old noop by deselecting CONFIG_IOSCHED_NOOP_HIER.
>>
>> Signed-off-by: Nauman Rafique <nauman@google.com>
>> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
>
> Not sure why noop needs hierarchical fair queueing
> support, but this patch is so small we might as well
> take it to keep things consistent between schedulers.
>

Thinking more about it. It probably can be useful for the case ryo is
pointing out where fast SSD drivers are not making use of kernel IO
schedulers.

If they want group io schduling support on these SSDs, they can modify their
driver to make use of hierarchical noop.

> Acked-by: Rik van Riel <riel@redhat.com>

Thanks
Vivek

>
> -- 
> All rights reversed.
