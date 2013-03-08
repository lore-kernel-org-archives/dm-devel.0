From: Matteo Frigo <athena@fftw.org>
Subject: Re: [dm-devel] [BUG] pvmove corrupting XFS filesystems (was Re: [BUG]
	Internal error xfs_dir2_data_reada_verify)
Date: Fri, 08 Mar 2013 06:38:56 -0500
Message-ID: <87ppza5df3.fsf@fftw.org>
References: <87d2vnc34r.fsf@fftw.org> <20130226044039.GM5551@dastard>
	<20130227010414.GD1514@agk.fab.redhat.com>
	<20130227014900.GY5551@dastard> <87y5eah4xz.fsf@fftw.org>
	<87k3pjs908.fsf@fftw.org> <20130307223140.GU23616@dastard>
	<87hakmpxac.fsf@fftw.org> <20130308015723.GA23616@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <xfs-bounces@oss.sgi.com>
In-Reply-To: <20130308015723.GA23616@dastard> (Dave Chinner's message of "Fri,
	8 Mar 2013 12:57:23 +1100")
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

> Add the the patch below. If you still see errors, then they are real
> IO errors from the block device.

This patch fixes the problem for me.

The patch works both when dm-raid1 returns -EIO and when it returns
-EWOULDBLOCK.

Thanks for your help.

Cheers,
Matteo

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
