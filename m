From: Ryo Tsuruta <ryov@valinux.co.jp>
Subject: Re: [PATCH 18/24] blkio_cgroup patches from Ryo to track
 async bios.
Date: Tue, 18 Aug 2009 20:42:12 +0900 (JST)
Message-ID: <20090818.204212.59676649.ryov@valinux.co.jp>
References: <1250451046-9966-1-git-send-email-vgoyal@redhat.com>
	<1250451046-9966-19-git-send-email-vgoyal@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1250451046-9966-19-git-send-email-vgoyal@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: vgoyal@redhat.com
Cc: dhaval@linux.vnet.ibm.com, peterz@infradead.org, dm-devel@redhat.com, dpshah@google.com, jens.axboe@oracle.com, agk@redhat.com, balbir@linux.vnet.ibm.com, paolo.valente@unimore.it, jmarchan@redhat.com, guijianfeng@cn.fujitsu.com, fernando@oss.ntt.co.jp, mikew@google.com, jmoyer@redhat.com, nauman@google.com, m-ikeda@ds.jp.nec.com, lizf@cn.fujitsu.com, fchecconi@gmail.com, s-uchida@ap.jp.nec.com, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org, righi.andrea@gmail.com
List-Id: dm-devel.ids

Hi Vivek,

Vivek Goyal <vgoyal@redhat.com> wrote:
> o blkio_cgroup patches from Ryo to track async bios.
> 
> o Fernando is also working on another IO tracking mechanism. We are not
>   particular about any IO tracking mechanism. This patchset can make use
>   of any mechanism which makes it to upstream. For the time being making
>   use of Ryo's posting.

The patch attached with your mail is obsolete and it may potentially
cause a deadlock when lock_page_cgroup() is called under radix_tree->lock.
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=e767e0561d7fd2333df1921f1ab4176211f9036b

The latest blkio-cgroup fixes the above issue and reduces IO tracking
overhead since lock_page_cgroup() is no longer used. I would recommend
to update to the latest version.

And I have a suggestion, how about moving get_cgroup_from_page() to
biotrack.c, I think this function would be useful for people who
want to make use of the IO tracking mechanism.

Please let me know your opinion.

Thanks,
Ryo Tsuruta
