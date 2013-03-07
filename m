From: Dave Chinner <david@fromorbit.com>
Subject: Re: [dm-devel] [BUG] pvmove corrupting XFS filesystems (was Re:
	[BUG] Internal error xfs_dir2_data_reada_verify)
Date: Fri, 8 Mar 2013 09:31:40 +1100
Message-ID: <20130307223140.GU23616@dastard>
References: <87d2vnc34r.fsf@fftw.org> <20130226044039.GM5551@dastard>
	<20130227010414.GD1514@agk.fab.redhat.com>
	<20130227014900.GY5551@dastard> <87y5eah4xz.fsf@fftw.org>
	<87k3pjs908.fsf@fftw.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <xfs-bounces@oss.sgi.com>
Content-Disposition: inline
In-Reply-To: <87k3pjs908.fsf@fftw.org>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Matteo Frigo <athena@fftw.org>
Cc: dm-devel@redhat.com, xfs@oss.sgi.com
List-Id: dm-devel.ids

On Thu, Mar 07, 2013 at 07:13:27AM -0500, Matteo Frigo wrote:
> Matteo Frigo <athena@fftw.org> writes:
> 
> > Well, I don't really know anything about this topic, so I may be
> > completely off the mark, but dm-raid1.c:mirror_map() does indeed return
> > EWOULDBLOCK, and EWOULDBLOCK is #define'd to be EAGAIN, so it seems to
> > me that dm-raid1 does indeed return EAGAIN for "rw == READA" (which I
> > assume is read-ahead) if the "region is not in-sync":
> >
> > 	/*
> > 	 * If region is not in-sync queue the bio.
> > 	 */
> > 	if (!r || (r == -EWOULDBLOCK)) {
> > 		if (rw == READA)
> > 			return -EWOULDBLOCK;
> >
> > 		queue_bio(ms, bio, rw);
> > 		return DM_MAPIO_SUBMITTED;
> > 	}
> 
> Dave (and others),
> 
> do you have any suggestion on what should be done to fix this bug?
> 
> I have tried returning -EIO instead of -EWOULDBLOCK, but xfs does not
> like that.  dm-zero.c:zero_map() appears to return -EIO too, so this is
> another potential issue.

You need the XFS patch I posted so that readahead buffer
verification is avoided in the case of an error being returned from
the readahead.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
