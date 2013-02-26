From: Matteo Frigo <athena@fftw.org>
Subject: Re: [BUG] pvmove corrupting XFS filesystems (was Re: [BUG] Internal
	error xfs_dir2_data_reada_verify)
Date: Tue, 26 Feb 2013 06:29:58 -0500
Message-ID: <87mwurpb2h.fsf@fftw.org>
References: <87d2vnc34r.fsf@fftw.org> <20130226044039.GM5551@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <xfs-bounces@oss.sgi.com>
In-Reply-To: <20130226044039.GM5551@dastard> (Dave Chinner's message of "Tue,
	26 Feb 2013 15:40:39 +1100")
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: dm-devel@redhat.com, xfs@oss.sgi.com
List-Id: dm-devel.ids

Dave Chinner <david@fromorbit.com> writes:

> All of the evidence points of a problem caused by the pvmove
> operation. I'd suggest that you don't use it until we get to the
> bottom of the problem (i.e. where the EAGAIN is coming from and
> why)....

Dave,

thanks for your quick reply and detailed analysis.

For the benefit of other readers, I wish to add that the same problem
occurs when creating lvm mirrors (e.g. "lvconvert -m1 vg/lvol"), which
is not surprising since pvmove works itself by creating a mirror.
Consequently, mirror creation should also be avoided until the root
cause of the problem is eliminated.

Cheers,
Matteo

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
