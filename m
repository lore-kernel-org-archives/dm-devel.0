From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: 2.6.27-rc5-mmotm0829 - lvm issues at boot, possible disk_devt() related?
Date: Mon, 1 Sep 2008 11:50:32 +0200
Message-ID: <20080901095032.GK20055@kernel.dk>
References: <4963.1220240176@turing-police.cc.vt.edu> <48BBA0B0.5070309@kernel.org> <7045.1220260558@turing-police.cc.vt.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1758115AbYIAJup@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <7045.1220260558@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
To: Valdis.Kletnieks@vt.edu
Cc: Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, dm-devel@redhat.com, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
List-Id: dm-devel.ids

On Mon, Sep 01 2008, Valdis.Kletnieks@vt.edu wrote:
> On Mon, 01 Sep 2008 09:58:40 +0200, Tejun Heo said:
> 
> > Yeah, I made a mistake converting two of them and devt lookup fails when
> > the disk is zero sized.  Bartlomiej debugged the problem and posted a
> > patch and I followed up with an updated patch.  It should be fine in the
> > next round.
> > 
> >   http://article.gmane.org/gmane.linux.kernel.next/2663
> >   http://article.gmane.org/gmane.linux.kernel.next/2676
> > 
> > If you're seeing other problems, please let me know.
> 
> Confirming - 2.6.27-rc5-mmotm0829 plus the merge of the 2 above patches
> does find the LVM volumes and come up.  Thanks for the clue.. :)

Thanks for confirming, both patches are in the updated block branch that
-mm and -next pull down.

-- 
Jens Axboe
