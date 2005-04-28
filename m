From: "goggin, edward" <egoggin@emc.com>
Subject: Re: multipath affinity to SCSI
Date: Thu, 28 Apr 2005 15:26:51 -0400
Message-ID: <C2EEB4E538D3DC48BF57F391F422779321A95B@SRMANNING.eng.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "'dm-devel@redhat.com'" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Wed, 27 Apr 2005 19:11:33 +0200, Lars Marowsky-Bree wrote:
 
> > Has anyone tried multipathing to non-SCSI target devices, 
> e.g., LOOP,
> > NBD, USB?  While the architecture looks fully capable of supporting
> > such, it looks like both the kernel and user implementation 
> would have
> > some problems due to some SCSI affinity.
> 
> Well, I can see the user-space not auto-detecting the paths right now
> (probably because simply noone has added those features yet 
> ;-), but the
> kernel shouldn't have any issues with it. I've played with it 
> over loop
> devices for testing.
> 
> Which SCSI affinity are you referring to?

Kernel components look fine.  Mapped and target device concepts seem
abstract enough to encompass multiple underlying block device session
protocols.  I was wrong to implicate them.

As reported yesterday by Benjamin Marzinski, sysfs_devinfo()
definitely shows this affinity.  Look in libmultipath/structs.h
for more examples.  

I think the definition of a path may be too focused on SCSI.  Path
attributes and path discovery are clearly SCSI centric.  Possibly
the path data structure could use unions for the different
definitions for a path (address attributes for a path are surely
different across these protocols) in order to accommodate
different underlying protocols.  Another idea is to have per
protocol callouts from sysfs_devinfo to perform path discovery.

This isn't all that different (although its at the session layer
not the SCSI transport layer) than the need for transport specific
handlers if/when the path testing starts making use of transport
level attributes as pointed out by Mike Anderson yesterday. 
