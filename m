From: christophe varoqui <christophe.varoqui@free.fr>
Subject: Re: device mapper and resizing devices
Date: Tue, 01 Mar 2005 23:20:43 +0100
Message-ID: <1109715643.21776.1.camel@zezette>
References: <20050301210307.GA28559@thumper2>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
In-Reply-To: <20050301210307.GA28559@thumper2>
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

On Tue, 2005-03-01 at 15:03 -0600, Andy wrote:
>I am using dm-multipath on non-partitioned (xfs) devices on a SAN.  If I
>resize the device, and rescan my path devices (i.e rescan /dev/sda,
>/dev/sdb, /dev/sdc,/dev/sdd (all the same path)) the kernel sees the new
>size of the individual devices, but the /sys/block/dm-0 device is still the
>old size.  I believe this is the reason why I cannot grow my xfs filesystem
>without doing a reboot so that the dm device will have the new size. I'd
>like to avoid unmounting and rebooting to resize the device.  I haven't
>played with lvm enough to feel comfortable using it.  Is there any way to
>get the dm device to be the proper size, or is this a bug, or a feature that
>needs further discussion?
>

Runing "multipath" again, after rescans, should pick up the size change
and adjust the device map.

If not please report.

Regards,
-- 
christophe varoqui <christophe.varoqui@free.fr>
