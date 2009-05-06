From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: IO scheduler based IO Controller V2
Date: Wed, 6 May 2009 09:28:22 -0400
Message-ID: <20090506132822.GA8180@redhat.com>
References: <1241553525-28095-1-git-send-email-vgoyal@redhat.com>
	<20090505132441.1705bfad.akpm@linux-foundation.org>
	<20090506034118.GC4416@balbir.in.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20090506034118.GC4416@balbir.in.ibm.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: paolo.valente@unimore.it, dhaval@linux.vnet.ibm.com, snitzer@redhat.com, fernando@oss.ntt.co.jp, jmoyer@redhat.com, linux-kernel@vger.kernel.org, fchecconi@gmail.com, dm-devel@redhat.com, jens.axboe@oracle.com, Andrew Morton <akpm@linux-foundation.org>, containers@lists.linux-foundation.org, agk@redhat.com, righi.andrea@gmail.com
List-Id: dm-devel.ids

On Wed, May 06, 2009 at 09:11:18AM +0530, Balbir Singh wrote:
> * Andrew Morton <akpm@linux-foundation.org> [2009-05-05 13:24:41]:
> 
> > On Tue,  5 May 2009 15:58:27 -0400
> > Vivek Goyal <vgoyal@redhat.com> wrote:
> > 
> > > 
> > > Hi All,
> > > 
> > > Here is the V2 of the IO controller patches generated on top of 2.6.30-rc4.
> > > ...
> > > Currently primarily two other IO controller proposals are out there.
> > > 
> > > dm-ioband
> > > ---------
> > > This patch set is from Ryo Tsuruta from valinux.
> > > ...
> > > IO-throttling
> > > -------------
> > > This patch set is from Andrea Righi provides max bandwidth controller.
> > 
> > I'm thinking we need to lock you guys in a room and come back in 15 minutes.
> > 
> > Seriously, how are we to resolve this?  We could lock me in a room and
> > cmoe back in 15 days, but there's no reason to believe that I'd emerge
> > with the best answer.
> >
> 
> We are planning an IO mini-summit prior to the kernel summit
> (hopefully we'll all be able to attend and decide).

Hi Balbir,

Mini summit is still few months away. I think a better idea would be to
try to thrash out the details here on lkml and try to reach to some
conclusion.

Its a complicated problem and there are no simple and easy answers. If we
can't reach a conclusion here, I am skeptical that mini summit will serve
that purpose.

Thanks
Vivek
