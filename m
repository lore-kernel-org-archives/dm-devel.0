From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: dm snapshot: allow live exception store handover
	between tables
Date: Fri, 6 Nov 2009 20:07:39 +0000
Message-ID: <20091106200739.GU13375@agk-dp.fab.redhat.com>
References: <1257532814-17100-1-git-send-email-snitzer@redhat.com>
	<20091106184642.GC13427@redhat.com>
	<20091106192620.GD13427@redhat.com>
	<20091106194136.GT13375@agk-dp.fab.redhat.com>
	<20091106195429.GE13427@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20091106195429.GE13427@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

On Fri, Nov 06, 2009 at 02:54:30PM -0500, Mike Snitzer wrote:
> Alasdair G Kergon <agk@redhat.com> wrote:
> > On Fri, Nov 06, 2009 at 02:26:21PM -0500, Mike Snitzer wrote:
> > > OK, actually in practice 'lvchange --refresh' is:
> > > old->suspend
> > > new->ctr
> > Those two need to be swapped.
> Why do they _need_ to be swapped?
 
old->suspend stops I/O to the device.
new->ctr allocates memory and in a bad case might lead to waiting for I/O to
the device we've just suspended.

Alasdair
