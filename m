From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-mpath: do not change SCSI device handler
Date: Thu, 4 Apr 2013 09:16:31 -0400
Message-ID: <20130404131631.GA10208@redhat.com>
References: <Pine.LNX.4.64.1304022000390.27554@file.rdu.redhat.com>
	<515D21EB.8010701@suse.de> <20130404122408.GA9996@redhat.com>
	<Pine.LNX.4.64.1304040847580.13053@file.rdu.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1304040847580.13053@file.rdu.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Thu, Apr 04 2013 at  8:55am -0400,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> 
> 
> On Thu, 4 Apr 2013, Mike Snitzer wrote:
> 
> > I'll take a look at fixing this by deferring the scsi_dh switch until
> > resume.  This fix would assume multipath-tools is _not_ doing a noflush
> > suspend/resume when it is switching the scsi_dh.
> > 
> > Mike
> 
> This won't work because scsi_dh_attach allocates memory and you can't 
> allocate memory when something is suspended.

Ah yeah, scsi_dh->attach allocates memory for scsi_dh_data.  But
couldn't those scsi_dh_* attach allocations be switched from GFP_KERNEL
to GFP_NOIO?

> If we want to make it possible to change device handler, we need to add a 
> counter to "struct scsi_dh_data", increment the counter when the device 
> handler issues some request, decrement the counter when it finishes the 
> request (it may be tricky because you can't decrement it from the device 
> handler module because the module may be unloaded as soon as you decrement 
> it). Then, you wait until the counter is zero and detach the handler.

Noted, but I haven't given up hope on just deferring the scsi_dh switch
quite yet.

Mike
