From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 16/23] io-controller: deadline changes for
	hierarchical fair queuing
Date: Mon, 31 Aug 2009 09:46:33 -0400
Message-ID: <20090831134633.GA3758@redhat.com>
References: <1251495072-7780-1-git-send-email-vgoyal@redhat.com>
	<1251495072-7780-17-git-send-email-vgoyal@redhat.com>
	<4A9B3FD3.6000407@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4A9B3FD3.6000407@redhat.com>
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

On Sun, Aug 30, 2009 at 11:13:23PM -0400, Rik van Riel wrote:
> Vivek Goyal wrote:
>> This patch changes deadline to use queue scheduling code from elevator layer.
>> One can go back to old deadline by selecting CONFIG_IOSCHED_DEADLINE_HIER.
>                                     ^ deselecting ?
>

Yes. Its a typo. Should be "deselecting". Will fix the comment.

Thanks
Vivek

>> Signed-off-by: Nauman Rafique <nauman@google.com>
>> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
>
> Acked-by: Rik van Riel <riel@redhat.com>
>
> -- 
> All rights reversed.
