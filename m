From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: xfs_btree_cur leak with 3.5-rc4
Date: Tue, 3 Jul 2012 01:53:24 -0400
Message-ID: <20120703055324.GA7129@redhat.com>
References: <20120702191412.GA3617@redhat.com> <20120703002611.GW19223@dastard>
	<20120703012628.GA5710@redhat.com> <20120703032136.GZ19223@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <xfs-bounces@oss.sgi.com>
Content-Disposition: inline
In-Reply-To: <20120703032136.GZ19223@dastard>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: dm-devel@redhat.com, xfs@oss.sgi.com
List-Id: dm-devel.ids

On Mon, Jul 02 2012 at 11:21pm -0400,
Dave Chinner <david@fromorbit.com> wrote:

> On Mon, Jul 02, 2012 at 09:26:28PM -0400, Mike Snitzer wrote:
> > On Mon, Jul 02 2012 at  8:26pm -0400,
> > Dave Chinner <david@fromorbit.com> wrote:
> > 
> > > On Mon, Jul 02, 2012 at 03:14:12PM -0400, Mike Snitzer wrote:
> > > > I get kmemleak reports against XFS when I run the thinp-test-suite
> > > > against 3.5-rc4.  I didn't see any XFS leaks with 3.4.
> > > 
> > > Already fixed in 3.5-rc5:
> > > 
> > > 76d0953 xfs: fix allocbt cursor leak in xfs_alloc_ag_vextent_near
> > 
> > Odd, I already have that fix (as it was included in 3.5-rc4).
> 
> I misread the git describe as saying it was included after -rc4. My
> mistake. That indicates that the above fix wasn't quite correct...
> 
> Try the patch below.

Looks good.  Thanks.

Tested-by: Mike Snitzer <snitzer@redhat.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
