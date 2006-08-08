From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: geometry of dm devices......
Date: Tue, 8 Aug 2006 15:05:43 -0500
Message-ID: <20060808200543.GA7418@ether.msp.redhat.com>
References: <1121230D3E3B6B4E9162069832D90A641BC017@XYUS-EX22.xyus.xyratex.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1121230D3E3B6B4E9162069832D90A641BC017@XYUS-EX22.xyus.xyratex.com>
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

On Wed, Aug 02, 2006 at 09:26:31AM -0700, Peter Koutoupis wrote:
> Unfortunately I got no reponses in my last post so I will try this
> again...but now is a slightly different direction.
> 
> I understand the HDIO_GETGEO is an unsupported feature to dm
> devices....but under normal practices how would a normal end-user be
> able to obtain such geometry from a raw dm device?  I have read of
> individuals looking into the MBR or grub (which sometimes resulted in
> incorrect results) and a few other things.  But if a dba type app such
> as oracle needs to work with a dm created raw device...how would it
> normally stat for the device geometry?  Any ideas?  Directions?

I suppose it depends on what the dm device is.  If it is a mirror or stripped
device with multiple devices under it, I'm not sure what a good answer is.

However if it is a multipath device, with only one physical device under it,
couldn't you just send the ioctl to one of the underlying paths?

Say you have a multipath device (dm-0), that is composed of 4 paths (sda, sdb,
sdc, sdd).  Sending the ioctl to any one of those sd* paths would return the
same device geometry. Since you are using multipath, you are obviously concerned
that one of those paths might be down. So you could try sending the ioctl
down each path in succession, until you got one that successfully returned.

-Ben
 
> Thanks,
> 
> Petros
> 
> -----Original Message-----
> From: Peter Koutoupis 
> Sent: Friday, July 28, 2006 4:17 PM
> To: 'device-mapper development'
> Subject: [dm-devel] aliases as raw devices......
> 
> All,
> 
> Using Redhat Advanced Server 4 Update 3 and the
> device-mapper/multipath-tools native to it
> (device-mapper-1.02.02-3.RHEL4 +
> device-mapper-multipath-0.4.5-12.0.RHEL4), we have a failover
> configuration of however many raw devices sorted by their WWID.  An
> alias of both dm-x and the WWID number is given to that one LD of many
> LUN mapping.  Let us say I have:
> /dev/sda
> /dev/sdb
> /dev/sdc
> /dev/sdd
> All being different LUN mappings of the same LD and assigned the alias
> of dm-0.  I can obviously write to the raw device of /dev/sda or
> /dev/sdb and so on but I am unable to write to the raw device of
> /dev/dm-0.  Actually to get into more detail..... dd writes to dm-0 just
> fine but our own coded I/O read/write utility as an issue with ioctl
> statting the geometry to the alias to the raw device.
> 
> Oictl_status = ioctl(fd, HDIO_GETGEO, &disk_geometry_info); //part of
> source
> 
> The IO utility comes back saying:
> 
> HDIO_GETGEO error number 25
> 
> To stat a dm device what parameter would be most appropriate for ioctl
> to pass?
> 
> Regards,
> 
> Peter Koutoupis
> Systems Engineer
> Xyratex International, Inc.
> 1804 Centre Point Circle
> Suite 112
> Naperville, IL 60563 USA
> (630)364-7656
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
