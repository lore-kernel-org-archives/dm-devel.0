From: Arthur Bergman <sky@nanisky.com>
Subject: Re: device mapper and resizing devices
Date: Tue, 1 Mar 2005 21:11:53 +0000
Message-ID: <24af3ad901c63c392059b4f6dccb37b6@nanisky.com>
References: <20050301210307.GA28559@thumper2>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v619.2)
Content-Type: text/plain; charset=US-ASCII; format=flowed
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

As far as I understand this is not supported. What we do is we add a 
new device, we then do sg_reset -b /dev/sgX and then we add them into 
the volume group and then we resize it.

I would also warn you that we have seen corruption repeatable times 
with xfs over devicemapper under 2.6.

Cheers
Arthur

-----
CTO @ Fotango Ltd
+447834716919
http://www.fotango.com/

On 1 Mar 2005, at 21:03, Andy wrote:

> I am using dm-multipath on non-partitioned (xfs) devices on a SAN.  If 
> I
> resize the device, and rescan my path devices (i.e rescan /dev/sda,
> /dev/sdb, /dev/sdc,/dev/sdd (all the same path)) the kernel sees the 
> new
> size of the individual devices, but the /sys/block/dm-0 device is 
> still the
> old size.  I believe this is the reason why I cannot grow my xfs 
> filesystem
> without doing a reboot so that the dm device will have the new size. 
> I'd
> like to avoid unmounting and rebooting to resize the device.  I haven't
> played with lvm enough to feel comfortable using it.  Is there any way 
> to
> get the dm device to be the proper size, or is this a bug, or a 
> feature that
> needs further discussion?
>
> Andy
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
