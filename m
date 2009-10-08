From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: retry:snapshots: COW drive capacity and monitoring
	space usage
Date: Thu, 8 Oct 2009 13:53:22 -0400
Message-ID: <20091008175321.GB11142@redhat.com>
References: <4ACD61A3.3020407@bfn.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4ACD61A3.3020407@bfn.org>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: af804@bfn.org, linux-lvm@redhat.com
List-Id: dm-devel.ids

On Wed, Oct 07 2009 at 11:50pm -0400,
J. Hart <af804@bfn.org> wrote:

> Greetings All,
> 
> I didn't see anything come back, so I'm giving it one last try.  I
> apologize if this is a duplicate.
> 
> After having built my own distro up from source code (just to see if I
> could), I've got snapshotting set up successfully on my system using the
> kernel device mapping facility, dmsetup, and a COW drive.  I understand
> from my reading that it is possible for the COW drive to run out of
> space while it is in use.  Since it is not mounted and does not use a
> filesystem as far as I know, I am wondering how one might go about
> deciding on how big a drive to use, and monitoring space usage.

You need to size your snapshot proportional to the rate of change you
expect during the life of the snapshot.  This change can happen to
either the origin device or directly to the snapshot device.  Regardless
of which one; if you expect excessive change you want to size the
snapshot larger, or vice-versa if you expect little change.

As for monitoring, LVM2 provides dmeventd-based snapshot usage
monitoring that is enabled by default as of LVM2 2.02.53.

When you're low on space you'll see messages like the following in
/var/log/messages:

Sep 16 21:15:05 really-raw dmeventd[12522]: dmeventd ready for processing.
Sep 16 21:15:11 really-raw lvm[12522]: Monitoring snapshot test-testlv_snap
Sep 16 21:15:15 really-raw lvm[12522]: Snapshot test-testlv_snap is now 92% full.

Mike
