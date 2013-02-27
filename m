From: Matteo Frigo <athena@fftw.org>
Subject: Re: [dm-devel] [BUG] pvmove corrupting XFS filesystems (was Re: [BUG]
	Internal error xfs_dir2_data_reada_verify)
Date: Tue, 26 Feb 2013 21:21:44 -0500
Message-ID: <87y5eah4xz.fsf@fftw.org>
References: <87d2vnc34r.fsf@fftw.org> <20130226044039.GM5551@dastard>
	<20130227010414.GD1514@agk.fab.redhat.com>
	<20130227014900.GY5551@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <xfs-bounces@oss.sgi.com>
In-Reply-To: <20130227014900.GY5551@dastard> (Dave Chinner's message of "Wed,
	27 Feb 2013 12:49:00 +1100")
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

> On Wed, Feb 27, 2013 at 01:04:14AM +0000, Alasdair G Kergon wrote:
>> (Quick pointers that might be relevant)
>> 
>> EAGAIN, I'm not aware of dm itself returning that on the i/o path.
>
> Neither am I, but it's coming from somewhere in the IO path...

Well, I don't really know anything about this topic, so I may be
completely off the mark, but dm-raid1.c:mirror_map() does indeed return
EWOULDBLOCK, and EWOULDBLOCK is #define'd to be EAGAIN, so it seems to
me that dm-raid1 does indeed return EAGAIN for "rw == READA" (which I
assume is read-ahead) if the "region is not in-sync":

	/*
	 * If region is not in-sync queue the bio.
	 */
	if (!r || (r == -EWOULDBLOCK)) {
		if (rw == READA)
			return -EWOULDBLOCK;

		queue_bio(ms, bio, rw);
		return DM_MAPIO_SUBMITTED;
	}

Regards,
MF

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
