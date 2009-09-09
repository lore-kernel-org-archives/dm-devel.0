From: Fabio Checconi <fchecconi@gmail.com>
Subject: Re: Regarding dm-ioband tests
Date: Wed, 9 Sep 2009 02:09:00 +0200
Message-ID: <20090909000900.GK17468@gandalf.sssup.it>
References: <20090904231129.GA3689@redhat.com> <20090907.200222.193693062.ryov@valinux.co.jp> <4AA51065.6050000@redhat.com> <20090908.120119.71095369.ryov@valinux.co.jp> <4AA6AF58.3050501@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1752522AbZIIAFo@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4AA6AF58.3050501@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Rik van Riel <riel@redhat.com>
Cc: Ryo Tsuruta <ryov@valinux.co.jp>, vgoyal@redhat.com, linux-kernel@vger.kernel.org, dm-devel@redhat.com, jens.axboe@oracle.com, agk@redhat.com, akpm@linux-foundation.org, nauman@google.com, guijianfeng@cn.fujitsu.com, jmoyer@redhat.com, balbir@linux.vnet.ibm.com
List-Id: dm-devel.ids

Hi,

> From: Rik van Riel <riel@redhat.com>
> Date: Tue, Sep 08, 2009 03:24:08PM -0400
>
> Ryo Tsuruta wrote:
> >Rik van Riel <riel@redhat.com> wrote:
> 
> >>Are you saying that dm-ioband is purposely unfair,
> >>until a certain load level is reached?
> >
> >Not unfair, dm-ioband(weight policy) is intentionally designed to
> >use bandwidth efficiently, weight policy tries to give spare bandwidth
> >of inactive groups to active groups.
> 
> This sounds good, except that the lack of anticipation
> means that a group with just one task doing reads will
> be considered "inactive" in-between reads.
> 

  anticipation helps in achieving fairness, but CFQ currently disables
idling for nonrot+NCQ media, to avoid the resulting throughput loss on
some SSDs.  Are we really sure that we want to introduce anticipation
everywhere, not only to improve throughput on rotational media, but to
achieve fairness too?
