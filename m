From: Andy <genanr@emsphone.com>
Subject: Re: device mapper and resizing devices
Date: Tue, 1 Mar 2005 16:22:45 -0600
Message-ID: <20050301222245.GA28834@thumper2>
References: <20050301210307.GA28559@thumper2>
	<1109715643.21776.1.camel@zezette>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1109715643.21776.1.camel@zezette>
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

On Tue, Mar 01, 2005 at 11:20:43PM +0100, christophe varoqui wrote:
> On Tue, 2005-03-01 at 15:03 -0600, Andy wrote:
> >I am using dm-multipath on non-partitioned (xfs) devices on a SAN.  If I
> >resize the device, and rescan my path devices (i.e rescan /dev/sda,
> >/dev/sdb, /dev/sdc,/dev/sdd (all the same path)) the kernel sees the new
> >size of the individual devices, but the /sys/block/dm-0 device is still the
> >old size.  I believe this is the reason why I cannot grow my xfs filesystem
> >without doing a reboot so that the dm device will have the new size. I'd
> >like to avoid unmounting and rebooting to resize the device.  I haven't
> >played with lvm enough to feel comfortable using it.  Is there any way to
> >get the dm device to be the proper size, or is this a bug, or a feature that
> >needs further discussion?
> >
> 
> Runing "multipath" again, after rescans, should pick up the size change
> and adjust the device map.
> 
multipath does, and prints the new size, but it is unable to add the target
to the dm table because dev_size in device-mapper is still the smaller size
and I get the "device x:yy too small for target" message
(/sys/block/dm-x/size still shows the old size, even when everything else
has the new size).

Andy

 
