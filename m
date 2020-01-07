From: Joe Thornber <thornber@redhat.com>
Subject: Re: [dm-devel] kernel BUG at
 drivers/md/persistent-data/dm-space-map-disk.c:178
Date: Tue, 7 Jan 2020 10:35:46 +0000
Message-ID: <20200107103546.asf4tmlfdmk6xsub@reti>
References: <alpine.LRH.2.11.1909251814220.15810@mx.ewheeler.net>
	<alpine.LRH.2.11.1912201829300.26683@mx.ewheeler.net>
	<alpine.LRH.2.11.1912270137420.26683@mx.ewheeler.net>
	<alpine.LRH.2.11.1912271946380.26683@mx.ewheeler.net>
Reply-To: LVM2 development <lvm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <lvm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.2.11.1912271946380.26683@mx.ewheeler.net>
List-Unsubscribe: <https://www.redhat.com/mailman/options/lvm-devel>,
	<mailto:lvm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/lvm-devel>
List-Post: <mailto:lvm-devel@redhat.com>
List-Help: <mailto:lvm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/lvm-devel>,
	<mailto:lvm-devel-request@redhat.com?subject=subscribe>
Sender: lvm-devel-bounces@redhat.com
Errors-To: lvm-devel-bounces@redhat.com
Content-Disposition: inline
To: LVM2 development <lvm-devel@redhat.com>
Cc: Mike Snitzer <snitzer@redhat.com>, markus.schade@gmail.com, dm-devel@redhat.com, linux-block@vger.kernel.org, ejt@redhat.com, joe.thornber@gmail.com
List-Id: dm-devel.ids

On Sat, Dec 28, 2019 at 02:13:07AM +0000, Eric Wheeler wrote:
> On Fri, 27 Dec 2019, Eric Wheeler wrote:

> > Just hit the bug again without mq-scsi (scsi_mod.use_blk_mq=n), all other 
> > times MQ has been turned on. 
> > 
> > I'm trying the -ENOSPC hack which will flag the pool as being out of space 
> > so I can recover more gracefully than a BUG_ON. Here's a first-draft 
> > patch, maybe the spinlock will even prevent the issue.
> > 
> > Compile tested, I'll try on a real system tomorrow.
> > 
> > Comments welcome:

Both sm_ll_find_free_block() and sm_ll_inc() can trigger synchronous IO.  So you
absolutely cannot use a spin lock.

dm_pool_alloc_data_block() holds a big rw semaphore which should prevent anything
else trying to allocate at the same time.

- Joe

--
lvm-devel mailing list
lvm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/lvm-devel
