From: Pasi =?iso-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>
Subject: Re: dm multipath kernel driver version too old - 2.6.32
Date: Fri, 1 Jan 2010 18:00:49 +0200
Message-ID: <20100101160049.GC25902@reaktio.net>
References: <1262246366.8333.13.camel@jaspav.ssiservices.biz>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1262246366.8333.13.camel@jaspav.ssiservices.biz>
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

On Thu, Dec 31, 2009 at 02:59:26AM -0500, John A. Sullivan III wrote:
> Hello, all.  We are attempting to upgrade our kernel on our VServer
> hosts from 2.6.28 to 2.6.32.1.  After some initial grief, we thought we
> were successful until multipath kicked in and we received an error
> message:
> 
> DM multipath kernel driver version too old
> 
> In the RAID and LVM section of our kernel configuration, we have enabled
> Multipath I/O support.  We have then created modules for Multipath
> target and both I/O Path Selectors (in-flight I/Os and service time).
> 
> We are running fully patched CentOS 5.4.  What have we done wrong?
> Thanks - John
> 

Are you using the dm-multipath rpm that comes with CentOS/RHEL?
I believe that dm-multipath version requires the CentOS/RHEL kernel
(because of the patches Redhat has applied to that kernel).

You might have better luck using the upstream dm-multipath with the
upstream kernel.

-- Pasi
