From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH] io-controller: optimization for iog deletion
	when elevator exiting
Date: Tue, 30 Jun 2009 21:34:25 -0400
Message-ID: <20090701013425.GC13958@redhat.com>
References: <1245443858-8487-1-git-send-email-vgoyal@redhat.com>
	<1245443858-8487-6-git-send-email-vgoyal@redhat.com>
	<4A4850D3.3000700@cn.fujitsu.com>
	<20090629140631.GA4622@redhat.com>
	<e98e18940906301014n146e7146vb5a73c2f33c9e819@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <e98e18940906301014n146e7146vb5a73c2f33c9e819@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Nauman Rafique <nauman@google.com>
Cc: dhaval@linux.vnet.ibm.com, snitzer@redhat.com, peterz@infradead.org, dm-devel@redhat.com, dpshah@google.com, jens.axboe@oracle.com, agk@redhat.com, balbir@linux.vnet.ibm.com, paolo.valente@unimore.it, Gui Jianfeng <guijianfeng@cn.fujitsu.com>, fernando@oss.ntt.co.jp, mikew@google.com, jmoyer@redhat.com, m-ikeda@ds.jp.nec.com, lizf@cn.fujitsu.com, fchecconi@gmail.com, akpm@linux-foundation.org, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, s-uchida@ap.jp.nec.com, righi.andrea@gmail.com, jbaron@redhat.com
List-Id: dm-devel.ids

On Tue, Jun 30, 2009 at 10:14:48AM -0700, Nauman Rafique wrote:
> On Mon, Jun 29, 2009 at 7:06 AM, Vivek Goyal<vgoyal@redhat.com> wrote:
> > On Mon, Jun 29, 2009 at 01:27:47PM +0800, Gui Jianfeng wrote:
> >> Hi Vivek,
> >>
> >> There's no need to travel the iocg->group_data for each iog
> >> when exiting a elevator, that costs too much. An alternative
> >> solution is reseting iocg_id as soon as an io group unlinking
> >> from a iocg. Make a decision that whether it's need to carry
> >> out deleting action by checking iocg_id.
> >>
> >
> > Thanks Gui. This makes sense to me. We can check iog->iocg_id to determine
> > wheter group is still on iocg list or not instead of traversing the list.
> >
> > Nauman, do you see any issues with the patch?
> 
> Looks like this should work. The only iog with zero id is associated
> with root group, which gets deleted outside of this function anyways.
> 

Minor correction. Even root group has id "1" and not zero. 0 is associated
with error when cgroup is not present.

Thanks
Vivek
