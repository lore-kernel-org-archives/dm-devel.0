From: Ryo Tsuruta <ryov@valinux.co.jp>
Subject: Re: Regarding dm-ioband tests
Date: Wed, 09 Sep 2009 18:24:04 +0900 (JST)
Message-ID: <20090909.182404.39170557.ryov@valinux.co.jp>
References: <20090908.120119.71095369.ryov@valinux.co.jp>
	<4AA6AF58.3050501@redhat.com>
	<20090909000900.GK17468@gandalf.sssup.it>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090909000900.GK17468@gandalf.sssup.it>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: fchecconi@gmail.com
Cc: riel@redhat.com, guijianfeng@cn.fujitsu.com, linux-kernel@vger.kernel.org, jmoyer@redhat.com, dm-devel@redhat.com, vgoyal@redhat.com, jens.axboe@oracle.com, nauman@google.com, akpm@linux-foundation.org, agk@redhat.com, balbir@linux.vnet.ibm.com
List-Id: dm-devel.ids

Hi,

Fabio Checconi <fchecconi@gmail.com> wrote:
> Hi,
> 
> > From: Rik van Riel <riel@redhat.com>
> > Date: Tue, Sep 08, 2009 03:24:08PM -0400
> >
> > Ryo Tsuruta wrote:
> > >Rik van Riel <riel@redhat.com> wrote:
> > 
> > >>Are you saying that dm-ioband is purposely unfair,
> > >>until a certain load level is reached?
> > >
> > >Not unfair, dm-ioband(weight policy) is intentionally designed to
> > >use bandwidth efficiently, weight policy tries to give spare bandwidth
> > >of inactive groups to active groups.
> > 
> > This sounds good, except that the lack of anticipation
> > means that a group with just one task doing reads will
> > be considered "inactive" in-between reads.
> > 
> 
>   anticipation helps in achieving fairness, but CFQ currently disables
> idling for nonrot+NCQ media, to avoid the resulting throughput loss on
> some SSDs.  Are we really sure that we want to introduce anticipation
> everywhere, not only to improve throughput on rotational media, but to
> achieve fairness too?

I'm also not sure if it's worth introducing anticipation everywhere.
The storage devices are becoming faster and smarter every year. In
practice, I did a benchmark with a SAN storage and the noop scheduler
got the best result.

However, I'll consider how IO from one task should take care of.

Thanks,
Ryo Tsuruta
