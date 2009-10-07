From: Andy <genanr@emsphone.com>
Subject: Re: Re: IO scheduler based IO controller V10
Date: Wed, 7 Oct 2009 15:23:56 -0500
Message-ID: <20091007202356.GA2624@thumper2>
References: <e98e18940910051111r110dc776l5105bf931761b842@mail.gmail.com>
	<20091006.161744.189719641.ryov@valinux.co.jp>
	<20091006112201.GA27866@redhat.com>
	<20091007.233805.183040347.ryov@valinux.co.jp>
	<4ACCC4B7.4050805@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4ACCC4B7.4050805@redhat.com>
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

On Wed, Oct 07, 2009 at 12:41:27PM -0400, Rik van Riel wrote:
> Ryo Tsuruta wrote:
> 
> >If once dm-ioband is integrated into the LVM tools and bandwidth can
> >be assigned per device by lvcreate, the use of dm-tools is no longer
> >required for users.
> 
> A lot of large data center users have a SAN, with volume management
> handled SAN-side and dedicated LUNs for different applications or
> groups of applications.
> 
> Because of alignment issues, they typically use filesystems directly
> on top of the LUNs, without partitions or LVM layers.  We cannot rely
> on LVM for these systems, because people prefer not to use that.
> 

I am one of these people that does not use LVM, because I have no need to
with the SAN.  The SAN spreads the volume across many disks, I do not need
to do it.  LVM would add layers of complexity than I do not need.  I do use
currently use EVMS to allow me to expand volumes without rebooting.  But,
with the newer kernels I do not even need that since I can just expand the
LUN and the the filesystem (I do not use partitions either).  Why was
device-mapper stuff moved into LVM2? IMHO it should have stayed separate.

Andy
 
