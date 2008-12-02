From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Announce: unlimited number of shared snapshots
Date: Tue, 2 Dec 2008 02:34:43 -0500
Message-ID: <20081202073443.GA22985@infradead.org>
References: <492FAF1C.8080401@gluesys.com>
	<Pine.LNX.4.64.0811281449520.6900@hs20-bc2-1.build.redhat.com>
	<4933684F.9060606@gluesys.com>
	<Pine.LNX.4.64.0812020140540.28552@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0812020140540.28552@hs20-bc2-1.build.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@redhat.com, hgichon <kpkim@gluesys.com>
List-Id: dm-devel.ids

On Tue, Dec 02, 2008 at 02:05:28AM -0500, Mikulas Patocka wrote:
> Hi
> 
> I fixed the ext2 bug (it was unsupported handling of buffer readahead) --- 
> download the new version of patches from the same location.
> 
> I couldn't reproduce the XFS bug. Please retry. Are you sure that you 
> didn't try to mount the _snapshot_ as XFS? Snapshots are currently not 
> writeable (they will be writeable in the final version), so attempting to 
> mount the snapshot read/write would return i/o error to the filesystem and 
> produce an error message similar to the one displayed.

The error message definitively looks like trying to mount a r/o snapshots
without -o ro,norecovery:

> > fs/xfs/xfs_rw.c.  Return address = 0xffffffff8037d399
> > [ 2696.363710] Filesystem "dm-3": I/O Error Detected.  Shutting down
> > filesystem: dm-3
> > [ 2696.368085] Please umount the filesystem, and rectify the problem(s)
> > [ 2696.371756] I/O error in filesystem ("dm-3") meta-data dev dm-3 block
> > 0x200022       ("xlog_bwrite") error 5 buf count 2097152
> > [ 2696.378402] XFS: failed to locate log tail
> > [ 2696.380797] XFS: log mount/recovery failed: error 5
> > [ 2696.405586] XFS: log mount failed
