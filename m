From: Fabio Checconi <fchecconi@gmail.com>
Subject: Re: [PATCH 02/20] io-controller: Common flat fair queuing code in elevaotor layer
Date: Tue, 23 Jun 2009 15:42:40 +0200
Message-ID: <20090623134240.GU28770@gandalf.sssup.it>
References: <1245443858-8487-1-git-send-email-vgoyal@redhat.com> <1245443858-8487-3-git-send-email-vgoyal@redhat.com> <20090622084612.GD3728@balbir.in.ibm.com> <20090622124313.GF28770@gandalf.sssup.it> <20090623024337.GC3620@redhat.com> <20090623041052.GS28770@gandalf.sssup.it> <20090623073252.GJ8642@balbir.in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1759789AbZFWNlv@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090623073252.GJ8642@balbir.in.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, dm-devel@redhat.com, jens.axboe@oracle.com, nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com, paolo.valente@unimore.it, ryov@valinux.co.jp, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp, guijianfeng@cn.fujitsu.com, jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, jbaron@redhat.com, agk@redhat.com, snitzer@redhat.com, akpm@linux-foundation.org, peterz@infradead.org
List-Id: dm-devel.ids

> From: Balbir Singh <balbir@linux.vnet.ibm.com>
> Date: Tue, Jun 23, 2009 01:02:52PM +0530
>
> * Fabio Checconi <fchecconi@gmail.com> [2009-06-23 06:10:52]:
> 
> > > From: Vivek Goyal <vgoyal@redhat.com>
> > > Date: Mon, Jun 22, 2009 10:43:37PM -0400
> > >
> > > On Mon, Jun 22, 2009 at 02:43:13PM +0200, Fabio Checconi wrote:
> > > 
> > ...
> > > > > Please help me understand this, we sort the tree by finish time, but
> > > > > search by vtime, start_time. The worst case could easily be O(N),
> > > > > right?
> > > > > 
> > > > 
> > > > no, (again, the full answer is in the paper); the nice property of
> > > > min_start is that it partitions the tree in two regions, one with
> > > > eligible entities and one without any of them.  once we know that
> > > > there is one eligible entity (checking the min_start at the root)
> > > > we can find the node i with min(F_i) subject to S_i < V walking down
> > > > a single path from the root to the leftmost eligible entity.  (we
> > > > need to go to the right only if the subtree on the left contains 
> > > > no eligible entities at all.)  since the RB tree is balanced this
> > > > can be done in O(log N).
> > > > 
> > > 
> > > Hi Fabio,
> > > 
> > > When I go thorough the paper you mentioned above, they seem to have
> > > sorted the tree based on eligible time (looks like equivalent of start
> > > time) and then keep track of minimum deadline on each node (equivalnet of
> > > finish time).
> > > 
> > > We seem to be doing reverse in BFQ where we sort tree on finish time
> > > and keep track of minimum start time on each node. Is there any specific
> > > reason behind that?
> > > 
> > 
> > Well... no specific reasons...  I think that our implementation is easier
> > to understand than the one of the paper, because it actually uses finish
> > times as the ordering key, and min_start to quickly locate eligible
> > subtrees, following the definition of the algorithm.
> > 
> 
> Is it still O(log N)?
> 

Yes, it goes along a single path from the root to a leaf of a balanced
tree (i.e., it starts from the root, and at the end of each iteration
it selects the left or the right child of the current node), thus it is
O(log N).
