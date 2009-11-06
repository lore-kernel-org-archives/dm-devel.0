From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm snapshot: allow live exception store handover
	between tables
Date: Fri, 6 Nov 2009 15:37:43 -0500
Message-ID: <20091106203742.GF13427@redhat.com>
References: <1257532814-17100-1-git-send-email-snitzer@redhat.com>
	<20091106184642.GC13427@redhat.com>
	<20091106192620.GD13427@redhat.com>
	<20091106194136.GT13375@agk-dp.fab.redhat.com>
	<20091106195429.GE13427@redhat.com>
	<20091106200739.GU13375@agk-dp.fab.redhat.com>
Reply-To: LVM2 development <lvm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <lvm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20091106200739.GU13375@agk-dp.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/lvm-devel>,
	<mailto:lvm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/lvm-devel>
List-Post: <mailto:lvm-devel@redhat.com>
List-Help: <mailto:lvm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/lvm-devel>,
	<mailto:lvm-devel-request@redhat.com?subject=subscribe>
Sender: lvm-devel-bounces@redhat.com
Errors-To: lvm-devel-bounces@redhat.com
To: Alasdair G Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com, lvm-devel@redhat.com
List-Id: dm-devel.ids

On Fri, Nov 06 2009 at  3:07pm -0500,
Alasdair G Kergon <agk@redhat.com> wrote:

> On Fri, Nov 06, 2009 at 02:54:30PM -0500, Mike Snitzer wrote:
> > Alasdair G Kergon <agk@redhat.com> wrote:
> > > On Fri, Nov 06, 2009 at 02:26:21PM -0500, Mike Snitzer wrote:
> > > > OK, actually in practice 'lvchange --refresh' is:
> > > > old->suspend
> > > > new->ctr
> > > Those two need to be swapped.
> > Why do they _need_ to be swapped?
>  
> old->suspend stops I/O to the device.
> new->ctr allocates memory and in a bad case might lead to waiting for I/O to
> the device we've just suspended.

Ouch, yes good point.

So I'll put the following on my lvm2 TODO:

- establish a REFRESH flag (set on lvchange --refresh)
- if REFRESH is set then _lv_suspend() will treat the live metadata as
  if it is precommitted metadata

Mike

--
lvm-devel mailing list
lvm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/lvm-devel
