From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [RFC] IO scheduler based IO controller V4
Date: Tue, 9 Jun 2009 09:52:56 -0400
Message-ID: <20090609135256.GA13476@redhat.com>
References: <1244513342-11758-1-git-send-email-vgoyal@redhat.com>
	<4A2DE381.6090205@cn.fujitsu.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4A2DE381.6090205@cn.fujitsu.com>
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
Cc: dhaval@linux.vnet.ibm.com, snitzer@redhat.com, peterz@infradead.org, dm-devel@redhat.com, dpshah@google.com, jens.axboe@oracle.com, agk@redhat.com, balbir@linux.vnet.ibm.com, paolo.valente@unimore.it, fernando@oss.ntt.co.jp, mikew@google.com, jmoyer@redhat.com, nauman@google.com, m-ikeda@ds.jp.nec.com, lizf@cn.fujitsu.com, fchecconi@gmail.com, akpm@linux-foundation.org, jbaron@redhat.com, linux-kernel@vger.kernel.org, s-uchida@ap.jp.nec.com, righi.andrea@gmail.com, containers@lists.linux-foundation.org
List-Id: dm-devel.ids

On Tue, Jun 09, 2009 at 12:22:25PM +0800, Gui Jianfeng wrote:
> Vivek Goyal wrote:
> > Hi All,
> > 
> > Here is the V4 of the IO controller patches generated on top of 2.6.30-rc8.
> > 
> 
> Hi Vivek,
> 
> I can't apply the patchset.
> 
> [root@localhost linux-2.6.30-rc8-Vivek-V4]# git-am ../V4/1.eml
> Applying io-controller: Documentation
> [root@localhost linux-2.6.30-rc8-Vivek-V4]# git-am ../V4/2.eml
> Applying io-controller: Common flat fair queuing code in elevaotor layer
> error: patch failed: block/Makefile:15
> error: block/Makefile: patch does not apply
> Patch failed at 0001.
> When you have resolved this problem run "git-am --resolved".
> If you would prefer to skip this patch, instead run "git-am --skip".

Hi Gui,

This is strange. It seems to be applying cleanly for me. Can you please
recheck your setup and also see why it is failing. In block/Makefile,
there is one line change and recently no change has taken to that file
in git.

Thanks
Vivek

[vgoyal@machine linux-2.6]$ git-am /tmp/V4/ioc-v4 
Applying: io-controller: Documentation
Applying: io-controller: Common flat fair queuing code in elevaotor layer
Applying: io-controller: Charge for time slice based on average disk rate
Applying: io-controller: Modify cfq to make use of flat elevator fair
queuing
Applying: io-controller: Common hierarchical fair queuing code in
elevaotor layer
Applying: io-controller: cfq changes to use hierarchical fair queuing code
in elevaotor layer
Applying: io-controller: Export disk time used and nr sectors dipatched
through cgroups
Applying: io-controller: idle for sometime on sync queue before expiring
it
Applying: io-controller: Separate out queue and data
Applying: io-conroller: Prepare elevator layer for single queue schedulers
Applying: io-controller: noop changes for hierarchical fair queuing
Applying: io-controller: deadline changes for hierarchical fair queuing
Applying: io-controller: anticipatory changes for hierarchical fair
queuing
Applying: blkio_cgroup patches from Ryo to track async bios.
Applying: io-controller: map async requests to appropriate cgroup
Applying: io-controller: Per cgroup request descriptor support
Applying: io-controller: Support per cgroup per device weights and io
class
Applying: io-controller: Debug hierarchical IO scheduling
Applying: io-controller: experimental debug patch for async queue wait
before expiry
