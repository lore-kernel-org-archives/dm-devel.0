From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [RFC] IO scheduler based IO controller V9
Date: Wed, 9 Sep 2009 11:41:10 +0200
Message-ID: <20090909094109.GS18599@kernel.dk>
References: <1251495072-7780-1-git-send-email-vgoyal@redhat.com>
	<4AA4B905.8010801@cn.fujitsu.com>
	<20090908191941.GF15974@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20090908191941.GF15974@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Vivek Goyal <vgoyal@redhat.com>
Cc: dhaval@linux.vnet.ibm.com, peterz@infradead.org, dm-devel@redhat.com, dpshah@google.com, agk@redhat.com, balbir@linux.vnet.ibm.com, paolo.valente@unimore.it, jmarchan@redhat.com, Gui Jianfeng <guijianfeng@cn.fujitsu.com>, fernando@oss.ntt.co.jp, mikew@google.com, jmoyer@redhat.com, nauman@google.com, mingo@elte.hu, m-ikeda@ds.jp.nec.com, riel@redhat.com, lizf@cn.fujitsu.com, fchecconi@gmail.com, s-uchida@ap.jp.nec.com, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org, righi.andrea@gmail.com, torvalds@linux-foundation.org
List-Id: dm-devel.ids

On Tue, Sep 08 2009, Vivek Goyal wrote:
> On Mon, Sep 07, 2009 at 03:40:53PM +0800, Gui Jianfeng wrote:
> > Hi Vivek,
> > 
> > I happened to encount a bug when i test IO Controller V9.
> > When there are three tasks to run concurrently in three group,
> > that is, one is parent group, and other two tasks are running 
> > in two different child groups respectively to read or write 
> > files in some disk, say disk "hdb", The task may hang up, and 
> > other tasks which access into "hdb" will also hang up.
> > 
> > The bug only happens when using AS io scheduler.
> > The following scirpt can reproduce this bug in my box.
> > 
> 
> Hi Gui,
> 
> I tried reproducing this on my system and can't reproduce it. All the
> three processes get killed and system does not hang.

The key factor is likely the old IDE driver, since this is IO scheduler
related. It probably works if Gui uses libata instead, and you can
probably reproduce if you could use drivers/ide/ on a disk.

So the likely culprit is probably a missing queue restart somewhere on
IO completion.

-- 
Jens Axboe
