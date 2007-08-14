From: malahal@us.ibm.com
Subject: Re: BUG in dm/dm-mirror module?
Date: Tue, 14 Aug 2007 08:55:34 -0700
Message-ID: <20070814155534.GA31052@us.ibm.com>
References: <20070811010853.GA9952@us.ibm.com> <46BD78B7.3080200@redhat.com>
	<45517CCC-7B68-4B0F-92EC-04F4E81CDA0E@redhat.com>
	<46C08B46.8040401@cfl.rr.com>
	<B9BBD91E-F103-40DA-85BA-4FBAF0BB0F59@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <B9BBD91E-F103-40DA-85BA-4FBAF0BB0F59@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jonathan Brassow <jbrassow@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Jonathan Brassow [jbrassow@redhat.com] wrote:
> 
> On Aug 13, 2007, at 11:48 AM, Phillip Susi wrote:
> 
> >
> >This is a problem with any mirror, not just one holding a mirror log.
> 
> It is a special problem with the mirror log.
> 
> Mirrors will recover themselves and become consistent upon a reboot.   
> In the case of a mirror that holds a file system, if you lost some of  
> your most recent writes, journaling/fsck will take care of it.  In  

I believe the mirror code handles errors at region level. So one region
could be out of sync while the other regions are updated with the latest
data if the disk failure(s) are transient. I don't think the disk with
few 'out-of-sync' regions can be assumed to have consistent data.

In any case, we need a better method to select the master mirror device.
Does LVM have an extra sector or so to give it to the kernel module?

Thanks, Malahal.
