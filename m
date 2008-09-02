From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Problem w/ CONFIG_DEBUG_BLOCK_EXT_DEVT
Date: Tue, 2 Sep 2008 12:57:44 +0200
Message-ID: <20080902105744.GE20055@kernel.dk>
References: <48BD173B.3090600@hp.com> <48BD19B1.9040207@kernel.org> <48BD1BA5.1020604@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753045AbYIBK6U@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <48BD1BA5.1020604@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Cc: Tejun Heo <tj@kernel.org>, device-mapper development <dm-devel@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: dm-devel.ids

On Tue, Sep 02 2008, Alan D. Brunelle wrote:
> Tejun Heo wrote:
> > Hello,
> > 
> > Alan D. Brunelle wrote:
> >> I have found two problems in LVM2/DM w/ a potential new "experimental
> >> feature" in 2.6.28: CONFIG_DEBUG_BLOCK_EXT_DEVT (this is from Jens
> >> Axboe's origin/for-2.6.28 git branch)
> > 
> > It's a debug option and I don't expect it to be enabled in any
> > production kernel.
> 
> Then perhaps it should /not/ default to Y...

It has already been changed to default to 'n'.

-- 
Jens Axboe
