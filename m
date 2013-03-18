From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] dm-cache: Add handle to contlr if
 cache_create failed.
Date: Mon, 18 Mar 2013 16:13:57 -0700
Message-ID: <20130318231357.GA10638@blackbox.djwong.org>
References: <5139441C.7000309@gmail.com>
	<20130308021027.GV8913@agk.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20130308021027.GV8913@agk.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: majianpeng <majianpeng@gmail.com>, dm-devel@redhat.com, agk@redhat.com
List-Id: dm-devel.ids

On Fri, Mar 08, 2013 at 02:10:27AM +0000, Alasdair G Kergon wrote:
> On Fri, Mar 08, 2013 at 09:51:24AM +0800, majianpeng wrote:
> > It  ignored to judge the result of cache_create.
> > If cache_create failed, but the copy_ctr_args successed.
> 
> Thanks for reporting this, but I already added this patch to linux-next today:
>   https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/commit/?id=f1ccbd181202c660b237b9bef0af277b980d5073
> 
> and will push the batch of 7 patches upstream either Friday or early
> next week.  (I'm waiting to hear about two more patches first: a fix for
> a theoretical problem that's been discovered and a possible adjustment
> to the hints metadata.)

Hmm... by 'adjustment', do you mean this commit?
https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/commit/?id=1005501c2f71931bd4cda2238b7698562a744f1a

I think this change modifies the on-disk format so that I have to flush the
dirty parts of the cache, zero the superblock, and recreate the cache?
Otherwise, reading in an old superblock will result in metadata_space_map_root
being read from the wrong place on disk...

I realize dm-cache hasn't been in an upstream release yet, but could we add new
fields at the end of the disk superblock?  And after 3.9, maybe have some sort
of guard too?

(Or maybe I've misunderstood the patch...)

--D
> 
> Alasdair
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
