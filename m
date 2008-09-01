From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Re: 2.6.27-rc5-mmotm0829 - lvm issues at boot,
	possible disk_devt() related?
Date: Mon, 1 Sep 2008 12:15:43 +0200
Message-ID: <20080901101543.GL20055@kernel.dk>
References: <4963.1220240176@turing-police.cc.vt.edu>
	<48BBA0B0.5070309@kernel.org>
	<7045.1220260558@turing-police.cc.vt.edu>
	<20080901095651.GI15123@agk.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20080901095651.GI15123@agk.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair G Kergon <agk@redhat.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, linux-kernel@vger.kernel.org, lvm-devel@redhat.com, device-mapper development <dm-devel@redhat.com>, Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
List-Id: dm-devel.ids

On Mon, Sep 01 2008, Alasdair G Kergon wrote:
> On Mon, Sep 01, 2008 at 05:15:58AM -0400, Valdis.Kletnieks@vt.edu wrote:
> > On Mon, 01 Sep 2008 09:58:40 +0200, Tejun Heo said:
> > > Yeah, I made a mistake converting two of them and devt lookup fails when
> > > the disk is zero sized.  Bartlomiej debugged the problem and posted a
> > > patch and I followed up with an updated patch.  It should be fine in the
> > > next round.
> > >   http://article.gmane.org/gmane.linux.kernel.next/2663
> > >   http://article.gmane.org/gmane.linux.kernel.next/2676
> > > If you're seeing other problems, please let me know.
> > Confirming - 2.6.27-rc5-mmotm0829 plus the merge of the 2 above patches
> > does find the LVM volumes and come up.  Thanks for the clue.. :)
> 
> I expect we'll need some patches to userspace lvm2 to support these extended
> device numbers properly too...
> 
> Alasdair (back from holiday)

They'll be defaulting to off from now on, so it should not be a big
worry. But Alan Brunelle did find that the "10-character limit
in dm/lib/libdm-deptree is too small".

-- 
Jens Axboe
