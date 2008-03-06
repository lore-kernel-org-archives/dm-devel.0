From: Anthony Liguori <anthony@codemonkey.ws>
Subject: Re: [kvm-devel] I/O bandwidth control on KVM
Date: Thu, 06 Mar 2008 10:05:59 -0600
Message-ID: <47D01667.10809@codemonkey.ws>
References: <20080304.154109.193687573.ryov@valinux.co.jp>	<20080306.005353.104038921.ryov@valinux.co.jp>	<47CECA91.2010507@codemonkey.ws>
	<20080306.212305.104034101.ryov@valinux.co.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20080306.212305.104034101.ryov@valinux.co.jp>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Ryo Tsuruta <ryov@valinux.co.jp>
Cc: kvm-devel@lists.sourceforge.net, dm-devel@redhat.com, virtualization@lists.linux-foundation.org
List-Id: dm-devel.ids

Ryo Tsuruta wrote:
> Hi Anthony.
>
>   
>> The attached patch implements AIO support for the virtio backend so if this is the case, you should see the proper proportions.
>>     
>
> First, thank you very much for making the patch. 
> I ran the same test program on KVM with the patch but I wasn't able to
> get good results.
> I checked the dm-ioband log, the I/Os didn't seem to be issued simultaneously.
>   

There's an aio_init in block-raw-posix.c that sets the thread count to 
1.  If you #if 0 out that block, or increase the threads to something 
higher (like 16), you should see multiple simultaneous requests.  Sorry 
about that, I had that in a different patch in my tree.

> It looked like the next I/O was blocked until the previous I/O was completed.
>
>                  The number of issued I/Os for 60 seconds
>      --------------------------------------------------------------------
>     |             device         |       sda11       |       sda12       |
>     |          weight setting    |        80%        |        20%        |
>     |-----------+----------------+-------------------+-------------------|
>     | KVM AIO   |      I/Os      |       4596        |       4728        |
>     |           | ratio to total |       49.3%       |       50.7%       |
>     |-----------+----------------+-------------------+-------------------|
>     | KVM       |      I/Os      |       5217        |       5623        |
>     |           | ratio to total |       48.1%       |       51.9%       |
>      --------------------------------------------------------------------
>
> Here is an another test result, which is very interesting.
> I/Os were issued from a KVM virtual machine and from the host machine
> simultaneously. 
>
>
>             The number of issued I/Os for 60 seconds
>      --------------------------------------------------------
>     | issue from     |  Virtual Machine  |    Host Machine   |
>     |      device    |       sda11       |       sda12       |
>     | weight setting |        80%        |        20%        |
>     |----------------+-------------------+-------------------|
>     |      I/Os      |        191        |       9466        |
>     | ratio to total |        2.0%       |       98.0%       |
>      --------------------------------------------------------
>
> The most I/Os that were processed were the I/Os issued by the host machine.
> There might exist another bottleneck somewhere as well.
>   

The virtio block backend isn't quite optimal right now.  I have some 
patches (that are currently suffering bitrot) that switch over to 
linux-aio which allows zero-copy and for proper barrier support (so the 
guest block device will use an ordered queue).  The QEMU aio 
infrastructure makes it tough to integrate it properly though.

Regards,

Anthony Liguori

> Here is a block diagram representing the test.
>
>     +---------------------------+
>     | Virtual Machine           |
>     |                           |
>     | Read/Write with O_DIRECT  |     +--------------------------+
>     |       process x 128       |     | Host Machine             |  
>     |             |             |     |                          |
>     |             V             |     | Read/Write with O_DIRECT |
>     |         /dev/vda1         |     |       process x 128      |
>     +-------------|-------------+     +-------------|------------+
>     +-------------V---------------------------------V------------+
>     |     /dev/mapper/ioband1      |     /dev/mapper/ioband2     |
>     |         80% weight           |         20% weight          |
>     |                              |                             |
>     |    Control I/O bandwidth according to the weights          |
>     +-------------|---------------------------------|------------+
>     +-------------V-------------+     +-------------|------------+
>     |        /dev/sda11         |     |         /dev/sda12       |
>     +---------------------------+     +--------------------------+
>
> Thanks,
> Ryo Tsuruta
>   
