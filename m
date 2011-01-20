From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: multipath: change the DEFAULT_MINIO for the request
 based multipath
Date: Thu, 20 Jan 2011 11:07:26 -0500
Message-ID: <20110120160726.GA23529@redhat.com>
References: <91d6dae7d88296d8a1fe.1295472607@malahal>
	<4D37E513.3070506@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4D37E513.3070506@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Thu, Jan 20 2011 at  2:32am -0500,
Hannes Reinecke <hare@suse.de> wrote:

> On 01/19/2011 10:30 PM, Malahal Naineni wrote:
> > The value of 1000 is good for bio based multipath. Seen 50% increase in
> > I/O ops by setting it to 1 in request based multipath configuration.
> > This patch would give poor performance for people still using the bio
> > based multipath!
> > 
> > Is it possible to detect request based multipath and change only for
> > those configurations?
> > 
> > diff -r e504a50b0db5 -r 91d6dae7d882 libmultipath/defaults.h
> > --- a/libmultipath/defaults.h	Wed Jan 19 13:16:40 2011 -0800
> > +++ b/libmultipath/defaults.h	Wed Jan 19 13:29:52 2011 -0800
> > @@ -5,7 +5,7 @@
> >  #define DEFAULT_ALIAS_PREFIX	"mpath"
> >  #define DEFAULT_FEATURES	"0"
> >  #define DEFAULT_HWHANDLER	"0"
> > -#define DEFAULT_MINIO		1000
> > +#define DEFAULT_MINIO		1
> >  #define DEFAULT_PGPOLICY       FAILOVER
> >  #define DEFAULT_FAILBACK       -FAILBACK_MANUAL
> >  #define DEFAULT_RR_WEIGHT      RR_WEIGHT_NONE
> > 
> Heh, that was the main reason for using request-based multipathing :-)

Exactly, since I/O merging occurs before entering request-based
multipath, frequent round-robin path switching doesn't cause the number
of overall requests to increase (like it did for bio-based).

Given the data from the 2007 Linux Symposim request-based DM paper (see
[1], figure 7), a safer rr_min_io default for both bio-based and
request-based might be 50 or 100.

But regardless of the default, no one size fits all.

Depending on the FC storage backend, a rr_min_io of 1 may not _always_
be ideal for request-based DM.  But clearly additional testing would be
needed.

> So yes, changing the behaviour is a good idea. But we should equally
> be able to detect if request-based multipathing is present; maybe
> we can key off the version number of dm-multipath?

Unfortunately, the multipath target version wasn't bumped when
request-based mpath was introduced (commit f40c67f0f7e2767f).

Similarly, the DM ioctl version wasn't bumped when the DM core was
updated to support request-based (primarily via commits e6ee8c0b767540
and cec47e3d4a861e).

Fortunately, the DM ioctl version was bumped in a release (therefore a
dedicated version bump related to request-based DM changes was deemed
unnecessary).

$ git log --tags --source --oneline include/linux/dm-ioctl.h
...
60935eb v2.6.31-rc1 dm ioctl: support cookies for udev

$ git log --tags --source --oneline drivers/md/dm.c
...
a77e28c v2.6.31-rc9 dm multipath: fix oops when request based io fails when no paths
a732c20 v2.6.31-rc5 dm: remove queue next_ordered workaround for barriers
7878cba v2.6.31-rc2 block: Create bip slabs with embedded integrity vectors
523d929 v2.6.31-rc1 dm: disable interrupt when taking map_lock
5d67aa2 v2.6.31-rc1 dm: do not set QUEUE_ORDERED_DRAIN if request based
e6ee8c0 v2.6.31-rc1 dm: enable request based option
cec47e3 v2.6.31-rc1 dm: prepare for request based option

Long story short, it seems we _could_ use the DM ioctl version bump that
occurred for 2.6.31 (from commit 60935eb):  4.15.0-ioctl (2009-04-01) 

Mike


[1] http://www.linuxsymposium.org/archives/OLS/Reprints-2007/ueda-Reprint.pdf
