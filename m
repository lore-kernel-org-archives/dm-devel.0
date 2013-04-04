From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: dm-mpath: do not change SCSI device handler
Date: Thu, 4 Apr 2013 09:36:20 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1304040918460.17024@file.rdu.redhat.com>
References: <Pine.LNX.4.64.1304022000390.27554@file.rdu.redhat.com>
	<515D21EB.8010701@suse.de> <20130404122408.GA9996@redhat.com>
	<Pine.LNX.4.64.1304040847580.13053@file.rdu.redhat.com>
	<20130404131631.GA10208@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20130404131631.GA10208@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids



On Thu, 4 Apr 2013, Mike Snitzer wrote:

> On Thu, Apr 04 2013 at  8:55am -0400,
> Mikulas Patocka <mpatocka@redhat.com> wrote:
> 
> > 
> > 
> > On Thu, 4 Apr 2013, Mike Snitzer wrote:
> > 
> > > I'll take a look at fixing this by deferring the scsi_dh switch until
> > > resume.  This fix would assume multipath-tools is _not_ doing a noflush
> > > suspend/resume when it is switching the scsi_dh.
> > > 
> > > Mike
> > 
> > This won't work because scsi_dh_attach allocates memory and you can't 
> > allocate memory when something is suspended.
> 
> Ah yeah, scsi_dh->attach allocates memory for scsi_dh_data.  But
> couldn't those scsi_dh_* attach allocations be switched from GFP_KERNEL
> to GFP_NOIO?

Yes and no.

GFP_NOIO allocations don't issue any IO, so they have higher possibility 
of failure - if the memory is full of user space pages or dirty file pages 
and there are no clean cache pages, then GFP_NOIO allocation can't make 
any progress and fails. GFP_KERNEL allocation could swap out some pages 
and succeed.

On the other hand, kernel developers use GFP_NOIO allocations and assume 
that they don't fail. And they don't fail most of the time. Although I 
have seen cases where it failed and caused trouble - when allocating 
inodes with GFP_NOIO under high memory stress. (the correct solution would 
be to allocate the inode with GFP_KERNEL earlier, when we are not holding 
any filesystem lock).

From the point of formal correctness, relying on GFP_NOIO is wrong, but if 
the allocated space is small and it happens infrequently (only on 
activation), you can likely get away with it without being caught.

Mikulas
