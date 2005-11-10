From: Greg KH <greg@kroah.com>
Subject: Re: patch to bus_add_device to delay call to
	device_attach till after "bus" and bus id sym links are set up
Date: Thu, 10 Nov 2005 14:40:01 -0800
Message-ID: <20051110224001.GB5179@kroah.com>
References: <C2EEB4E538D3DC48BF57F391F422779321ADE3@srmanning.eng.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <C2EEB4E538D3DC48BF57F391F422779321ADE3@srmanning.eng.emc.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "goggin, edward" <egoggin@emc.com>
Cc: "'dm-devel@redhat.com'" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Thu, Nov 10, 2005 at 03:03:53PM -0500, goggin, edward wrote:
> Resend (hopefully) without line wrap.

Nope, linewrap still there :(

As well as a lack of Signed-off-by: line :(

> Patch to drivers/base/bus.c:bus_add_device to delay the driver_attach
> call until after the "bus" and bus_id symbolic links for the device exist
> so that a hotplug/uevent handler will not fail to find these links already
> established for a newly added device.

What version of udev are you running that causes you to see this
problem?

> --- ../base/linux-2.6.14-rc4

Lots of stuff has changed in the driver core since 2.6.14-rc4, you might
need to update this and your other patch to the latest -git tree.

thanks,

greg k-h
