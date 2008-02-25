From: Dave Wysochanski <dwysocha@redhat.com>
Subject: Re: Fwd: 2.6.25-rc1 patch prevents booting on LVM-based
	devices
Date: Mon, 25 Feb 2008 10:46:16 -0500
Message-ID: <1203954376.3278.4.camel@localhost.localdomain>
References: <0EF16AFF-CC50-424A-84FF-3E477FB9645B@oracle.com>
	<46DC665B-5B6B-4EEA-B448-1CEE07528D16@oracle.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <46DC665B-5B6B-4EEA-B448-1CEE07528D16@oracle.com>
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

On Wed, 2008-02-20 at 11:20 -0500, Chuck Lever wrote:
> Begin forwarded message:
> > From: Chuck Lever <chuck.lever@oracle.com>
> > Date: February 20, 2008 10:50:01 AM EST
> > To: dm-devel@redhat.com
> > Subject: 2.6.25-rc1 patch prevents booting on LVM-based devices
> >
> > Hello-
> >
> > I've got a Fedora 8 x86 test system that uses LVM volumes for all  
> > it's file systems except /boot.  After commit bdc80787, 2.6.24+  
> > doesn't boot on this system -- the LVM volume scan during start-up  
> > can no longer find any physical volumes on the system.
> >
> > I'm not sure whether this is an LVM issue, or something else is  
> > breaking during system init which prevents the LVM scan from  
> > working.  I need some help troubleshooting the problem.
> 
> Interestingly, if I build a non-tickless kernel, the problem goes away.
> 

Did you see this:
http://bugzilla.kernel.org/show_bug.cgi?id=10021

Another guess would be the below change is affecting your low-level
driver in some way as to prevent devices from being discovered.  Is this
FC (qla2xxx) or something else?


> > bdc80787 is:
> >
> > commit bdc807871d58285737d50dc6163d0feb72cb0dc2
> > Author: H. Peter Anvin <hpa@zytor.com>
> > Date:   Fri Feb 8 04:21:26 2008 -0800
> >
> >     avoid overflows in kernel/time.c
> >
> >     When the conversion factor between jiffies and milli- or  
> > microseconds is
> >     not a single multiply or divide, as for the case of HZ == 300,  
> > we currently
> >     do a multiply followed by a divide.  The intervening result,  
> > however, is
> >     subject to overflows, especially since the fraction is not  
> > simplified (for
> >     HZ == 300, we multiply by 300 and divide by 1000).
> >
> >     This is exposed to the user when passing a large timeout to poll 
> > (), for
> >     example.
> >
> >     This patch replaces the multiply-divide with a reciprocal  
> > multiplication on
> >     32-bit platforms.  When the input is an unsigned long, there is  
> > no portable
> >     way to do this on 64-bit platforms there is no portable way to  
> > do this
> >     since it requires a 128-bit intermediate result (which gcc does  
> > support on
> >     64-bit platforms but may generate libgcc calls, e.g.  on 64-bit  
> > s390), but
> >     since the output is a 32-bit integer in the cases affected,  
> > just simplify
> >     the multiply-divide (*3/10 instead of *300/1000).
> >
> > and so on...
> >
> > --
> > Chuck Lever
> > chuck[dot]lever[at]oracle[dot]com
> >
> >
> >
> 
> --
> Chuck Lever
> chuck[dot]lever[at]oracle[dot]com
> 
> 
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
