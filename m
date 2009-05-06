From: Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: IO scheduler based IO Controller V2
Date: Wed, 6 May 2009 09:11:18 +0530
Message-ID: <20090506034118.GC4416@balbir.in.ibm.com>
References: <1241553525-28095-1-git-send-email-vgoyal@redhat.com> <20090505132441.1705bfad.akpm@linux-foundation.org>
Reply-To: balbir@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754133AbZEFGZk@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090505132441.1705bfad.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Vivek Goyal <vgoyal@redhat.com>, dhaval@linux.vnet.ibm.com, snitzer@redhat.com, dm-devel@redhat.com, jens.axboe@oracle.com, agk@redhat.com, paolo.valente@unimore.it, fernando@oss.ntt.co.jp, jmoyer@redhat.com, fchecconi@gmail.com, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, righi.andrea@gmail.com
List-Id: dm-devel.ids

* Andrew Morton <akpm@linux-foundation.org> [2009-05-05 13:24:41]:

> On Tue,  5 May 2009 15:58:27 -0400
> Vivek Goyal <vgoyal@redhat.com> wrote:
> 
> > 
> > Hi All,
> > 
> > Here is the V2 of the IO controller patches generated on top of 2.6.30-rc4.
> > ...
> > Currently primarily two other IO controller proposals are out there.
> > 
> > dm-ioband
> > ---------
> > This patch set is from Ryo Tsuruta from valinux.
> > ...
> > IO-throttling
> > -------------
> > This patch set is from Andrea Righi provides max bandwidth controller.
> 
> I'm thinking we need to lock you guys in a room and come back in 15 minutes.
> 
> Seriously, how are we to resolve this?  We could lock me in a room and
> cmoe back in 15 days, but there's no reason to believe that I'd emerge
> with the best answer.
>

We are planning an IO mini-summit prior to the kernel summit
(hopefully we'll all be able to attend and decide).
 
-- 
	Balbir
