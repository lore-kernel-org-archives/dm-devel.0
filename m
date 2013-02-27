From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [BUG] pvmove corrupting XFS filesystems (was Re: [BUG]
	Internal error xfs_dir2_data_reada_verify)
Date: Wed, 27 Feb 2013 01:04:14 +0000
Message-ID: <20130227010414.GD1514@agk.fab.redhat.com>
References: <87d2vnc34r.fsf@fftw.org> <20130226044039.GM5551@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <xfs-bounces@oss.sgi.com>
Content-Disposition: inline
In-Reply-To: <20130226044039.GM5551@dastard>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>, Matteo Frigo <athena@fftw.org>, dm-devel@redhat.com, xfs@oss.sgi.com
List-Id: dm-devel.ids

(Quick pointers that might be relevant)

EAGAIN, I'm not aware of dm itself returning that on the i/o path.

For 3.8 issues, read dm-devel around https://www.redhat.com/archives/dm-devel/2013-February/msg00086.html
(I queued the dm-side fixes for linux-next earlier today)

For pvmove, check exactly which version and whether discards are enabled: there
was a userspace bug for a short period some time ago when discards were enabled.

Alasdair

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
