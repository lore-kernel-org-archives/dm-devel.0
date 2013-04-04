From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: dm-mpath: do not change SCSI device handler
Date: Thu, 4 Apr 2013 11:38:23 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1304041136380.5697@file.rdu.redhat.com>
References: <Pine.LNX.4.64.1304022000390.27554@file.rdu.redhat.com>
	<515D21EB.8010701@suse.de> <20130404122408.GA9996@redhat.com>
	<Pine.LNX.4.64.1304040847580.13053@file.rdu.redhat.com>
	<20130404131631.GA10208@redhat.com>
	<Pine.LNX.4.64.1304040918460.17024@file.rdu.redhat.com>
	<20130404142048.GB10208@redhat.com>
	<Pine.LNX.4.64.1304041106420.2172@file.rdu.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.1304041106420.2172@file.rdu.redhat.com>
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



On Thu, 4 Apr 2013, Mikulas Patocka wrote:

> On Thu, 4 Apr 2013, Mike Snitzer wrote:
> 
> > I'm suggesting that switching the scsi_dh is not something that will be
> > done on a system that is suffering from serious memory contention.
> > 
> > But I think we need to get back to analyzing the scsi_dh change you
> > mentioned before with tracking counts, etc.
> 
> When I look at the code, I see module_put(THIS_MODULE) in all scsi device 
> handlers. Moreover, there are many 'module_put(THIS_MODULE)' over the 
> whole kernel. It seems buggy, because when the function module_put 
> returns, reschedule happens, module is unloaded, the process that called 
> module_put(THIS_MODULE) is scheduled back again, crash happens because we 
> are running a code that no longer exists. Is it a bug or is there some 
> trick that prevents the kernel from crashing in this scenario?
> 
> Mikulas

I found this 
http://lkml.indiana.edu/hypermail/linux/kernel/1111.0/00218.html saying 
that they don't care about module unloading races ...

Mikulas
