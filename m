From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-mpath: do not change SCSI device handler
Date: Thu, 4 Apr 2013 08:24:09 -0400
Message-ID: <20130404122408.GA9996@redhat.com>
References: <Pine.LNX.4.64.1304022000390.27554@file.rdu.redhat.com>
	<515D21EB.8010701@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <515D21EB.8010701@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

On Thu, Apr 04 2013 at  2:47am -0400,
Hannes Reinecke <hare@suse.de> wrote:

> NACK.
> 
> This kills multipath startup when scsi_dh_* modules are already loaded.

You mean an incorrect scsi_dh is already attached.

> After boot scsi_dh_* modules might already be loaded without
> multipath running.
> Multipath might have defined other hardware handlers in the
> configuration file, and will re-attach them on startup.
> 
> With this patch multipath cannot configure the devices properly and
> will abort.

In practice the scenario you describe is configuration error and can
easily be avoided in a properly configured system.

But that aside, Alasdair pointed out that it appears the heart of the
problem which Mikulas described in his patch header is due the fact that
the scsi_dh is switched, while IO may still be in-flight, during table
load (multipath_ctr -> parse_priority_group -> parse_path) rather than
deferring the switch until multipath_resume.  

I'll take a look at fixing this by deferring the scsi_dh switch until
resume.  This fix would assume multipath-tools is _not_ doing a noflush
suspend/resume when it is switching the scsi_dh.

Mike
