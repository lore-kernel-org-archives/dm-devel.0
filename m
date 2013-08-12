From: "Bryn M. Reeves" <bmr@redhat.com>
Subject: Re: noob usage question
Date: Mon, 12 Aug 2013 12:40:07 +0100
Message-ID: <5208C997.503@redhat.com>
References: <CAH1aXXbG68BSLqvZeoANUkVykcBnNnTfnPqYbCVke89kBU_WTQ@mail.gmail.com>
	<34D36EB6-401C-4825-8D1E-B277EDD39ACF@redhat.com>
	<CAH1aXXZHc8rYQUfbQsAXgrjrryLvZb-NfyTEdTx+a9oJSHwc-g@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAH1aXXZHc8rYQUfbQsAXgrjrryLvZb-NfyTEdTx+a9oJSHwc-g@mail.gmail.com>
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
Cc: John Strange <johnstra10@gmail.com>
List-Id: dm-devel.ids

On 08/10/2013 03:19 AM, John Strange wrote:
> Yes, I think I do want to create partitions.  My expectation is to create a 
> mapping based on one or more raw physical device (luns).  There are a number 
> features I would like implement behind my mapping target driver.  My 
> understanding is that I can treat the mapping (the target device) as if it were 
> a raw disk and that I can format it as appropriate for whatever workload will 
> use it.

For typical uses you would format the raw physical device and then use
the kpartx device-mapper application to create linear maps for each
partition contained on the device.

For e.g. this is how users work with partitions on multipath devices
managed by multipath-tools and device-mapper.

> For instance... I need to present a device (it would appear to the OS as a raw 
> block device) composed of ranges of blocks from different devices - spinning 
> media, ssd, PCIe flash, etc.  My target driver can guarantee a QOS (throughput, 
> latency, combo) and it will service read requests across the range of physical 
> media comprising the target.
> 
> This target device would appear to the OS as a block device.  The workload that 
> uses the device might require a filesystem on it, so I need to mount a FS.

Still not sure why you would want to place partitions on the linear maps
but you can do it if you really want to:

http://paste.fedoraproject.org/31461/76307438/

First example is creating and partitioning a linar mapping (I used a
loop device as the backing but it will work with any block device).

Following that is creating a file system on a partitioned linear device,
and then on the whole linear device.

There's no problem with either operation.

> That's what I'm aiming for.  I ran into problems trying to format my target 
> device so I created a linear mapping and it behaved the same way... could not 
> put a partition on it or format it.

You do not need a partition to be able to format or use a device-mapper
device - dm's devices do not support partitions (which is why you have
to use the userspace kpartx - it reads partition tables and creates
equivalend DM linear mappings for them).

It sounds like something else is going on in your case - what errors do
you get when you try to use the linear devices (busy for e.g.)?

Regards,
Bryn.
