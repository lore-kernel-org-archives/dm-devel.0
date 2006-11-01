From: Dave Wysochanski <dave.wysochanski@redhat.com>
Subject: Re: Failover between two paths to one LU doesn't work
	onlinux-iscsi
Date: Wed, 01 Nov 2006 01:20:04 -0500
Message-ID: <1162362004.5668.21.camel@linux-cxyg.rtp.netapp.com>
References: <452BD5C6.2080808@voltaire.com> <452BD768.30206@ilm.com>
	<452BFAA0.1000100@voltaire.com>
	<1160576205.4819.13.camel@linux-cxyg.rtp.netapp.com>
	<452E8E50.3080507@voltaire.com>
	<1160684886.6294.9.camel@dhcp59-220.rdu.redhat.com>
	<4536789C.70807@voltaire.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4536789C.70807@voltaire.com>
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
List-Id: dm-devel.ids

On Wed, 2006-10-18 at 20:55 +0200, Michael Lyulko wrote:
> >>
> >> 1. How can I configure the DM to automatically detect that a path is 
> >> active again?
> >>     
> >
> > you probably want "failback immediate"
> > there's also been some bugs with failback - not sure about your version
> > - your mileage may vary
> >
> >   
> "failback immediate" didn't help on both SLES9 sp3 and SLES10. The 
> device mapper doesn't
> rescan automatically the paths, so when the failed path is back to life, 
> it is still "failed"
> in multipath -l output.
> Issuing "multipath -p failover" helps to return the path back to 
> "active". I need an automatic "rescan".

This is supposed to be multipathd's job - it's supposed to have a path
checker thread that repeatedly scans and notifies the kernel to
reinstate paths.  If the first state remains "[failed]", it indicates
either multipathd isn't running or it's not notifying the kernel
correctly of the reinstated paths.

I seem to recall there was a sequencing problem - at least on SLES9 SP?
with boot.multipath, multipathd and iscsi - something like multipathd
starting too early, which caused it not to monitor paths properly.  Did
you try restarting multipathd after everything is up (on SLES9)?
