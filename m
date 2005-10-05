From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH] [RFC] persistent readable names
Date: Wed, 5 Oct 2005 11:07:21 -0700
Message-ID: <20051005180721.GA22387@us.ibm.com>
References: <4343DFDC.2020701@redhat.com> <20051005150923.GC6195@free.fr>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20051005150923.GC6195@free.fr>
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

On Wed, Oct 05, 2005 at 05:09:23PM +0200, Christophe Varoqui wrote:
> On Wed, Oct 05, 2005 at 03:14:52PM +0100, Patrick Caulfield wrote:
> > This patch is more for discussion than inclusion at the moment. Basically it's
> > unrealistic for users with hundreds of disks to alias them all in
> > /etc/multipath.conf and the default names are very unwieldy.
> > 
> > What this patch does is attach a name to any un-aliased path and write that name
> > to /etc/multipath.names. The file is read again every time the paths are added
> > so they are persistent.

I haven't recently looked at dm or dm multipath naming, but dm and dm
multipath should not have a different naming scheme outside of udev.

udev now has persistent naming, and probably could or should have a dm_id
(dm_id could run scsi_id on a single path, unless dm is passing down scsi
ioctl's). The udev persistent naming scheme is not intuitive (i.e.  not
easy for people to create and use).

Intuitive names could be built upon the persistent names as part of udev,
like an alias, or if you could "match" a NAME, and have a new udev rule
like:

	NAME=="disk/by-id/foo" SYMLINK+="disk/by-simple/my-database"

I hesitate to bring this up on the appropriate list, here:

	linux-hotplug-devel@lists.sourceforge.net 

without any patches :-/

-- Patrick Mansfield
