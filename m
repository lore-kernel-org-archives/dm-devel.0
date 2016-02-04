From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-multipath low performance with blk-mq
Date: Thu, 4 Feb 2016 09:09:59 -0500
Message-ID: <20160204140959.GA18328@redhat.com>
References: <56A904B6.50407@dev.mellanox.co.il>
	<20160129233504.GA13661@redhat.com> <56AC79D0.5060104@suse.de>
	<20160130191238.GA18686@redhat.com> <56AEFF63.7050606@suse.de>
	<20160203180406.GA11591@redhat.com>
	<20160203182423.GA12913@redhat.com> <56B2F5BC.1010700@suse.de>
	<20160204135420.GA18227@redhat.com> <56B358EE.6000007@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <56B358EE.6000007@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: axboe@kernel.dk, Christoph Hellwig <hch@infradead.org>, Sagi Grimberg <sagig@dev.mellanox.co.il>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "keith.busch@intel.com" <keith.busch@intel.com>, device-mapper development <dm-devel@redhat.com>, linux-block@vger.kernel.org, Bart Van Assche <bart.vanassche@sandisk.com>
List-Id: dm-devel.ids

On Thu, Feb 04 2016 at  8:58am -0500,
Hannes Reinecke <hare@suse.de> wrote:

> On 02/04/2016 02:54 PM, Mike Snitzer wrote:
> > On Thu, Feb 04 2016 at  1:54am -0500,
> > Hannes Reinecke <hare@suse.de> wrote:
> > 
> [ .. ]
> >> But anyway, I'll be looking at your patches.
> > 
> > Thanks, sadly none of the patches are going to fix the performance
> > problems but I do think they are a step forward.
> > 
> Hmm. I've got a slew of patches converting dm-mpath to use atomic_t
> and bitops; with that we should be able to move to rcu for path
> lookup and do away with most of the locking.
> Quite raw, though; drop me a mail if you're interested.

Hmm, ok I just switched m->lock from spinlock_t to rwlock_t, see:
https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-4.6&id=a5226e23a6958ac9b7ade13a983604c43d232c7d

So any patch you'd have in this area would need rebasing.  I'll gladly
look at what you have (even if it isn't rebased).  So yes please share.

(it could be that there isn't a big enough win associated with switching
to rwlock_t -- that we could get away without doing that particular
churn.. open to that if you think rwlock_t pointless given we'll take
the write lock after repeat_count drops to 0)
