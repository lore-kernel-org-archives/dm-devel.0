From: Ryo Tsuruta <ryov@valinux.co.jp>
Subject: Re: I/O bandwidth control on KVM
Date: Thu, 06 Mar 2008 21:23:05 +0900 (JST)
Message-ID: <20080306.212305.104034101.ryov@valinux.co.jp>
References: <20080304.154109.193687573.ryov@valinux.co.jp>
	<20080306.005353.104038921.ryov@valinux.co.jp>
	<47CECA91.2010507@codemonkey.ws>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvm-devel-bounces@lists.sourceforge.net>
In-Reply-To: <47CECA91.2010507@codemonkey.ws>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/kvm-devel>,
	<mailto:kvm-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=kvm-devel>
List-Post: <mailto:kvm-devel@lists.sourceforge.net>
List-Help: <mailto:kvm-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/kvm-devel>,
	<mailto:kvm-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: kvm-devel-bounces@lists.sourceforge.net
Errors-To: kvm-devel-bounces@lists.sourceforge.net
To: anthony@codemonkey.ws
Cc: kvm-devel@lists.sourceforge.net, dm-devel@redhat.com, virtualization@lists.linux-foundation.org
List-Id: dm-devel.ids

Hi Anthony.

> The attached patch implements AIO support for the virtio backend so if this is the case, you should see the proper proportions.

First, thank you very much for making the patch. 
I ran the same test program on KVM with the patch but I wasn't able to
get good results.
I checked the dm-ioband log, the I/Os didn't seem to be issued simultaneously.
It looked like the next I/O was blocked until the previous I/O was completed.

                 The number of issued I/Os for 60 seconds
     --------------------------------------------------------------------
    |             device         |       sda11       |       sda12       |
    |          weight setting    |        80%        |        20%        |
    |-----------+----------------+-------------------+-------------------|
    | KVM AIO   |      I/Os      |       4596        |       4728        |
    |           | ratio to total |       49.3%       |       50.7%       |
    |-----------+----------------+-------------------+-------------------|
    | KVM       |      I/Os      |       5217        |       5623        |
    |           | ratio to total |       48.1%       |       51.9%       |
     --------------------------------------------------------------------

Here is an another test result, which is very interesting.
I/Os were issued from a KVM virtual machine and from the host machine
simultaneously. 


            The number of issued I/Os for 60 seconds
     --------------------------------------------------------
    | issue from     |  Virtual Machine  |    Host Machine   |
    |      device    |       sda11       |       sda12       |
    | weight setting |        80%        |        20%        |
    |----------------+-------------------+-------------------|
    |      I/Os      |        191        |       9466        |
    | ratio to total |        2.0%       |       98.0%       |
     --------------------------------------------------------

The most I/Os that were processed were the I/Os issued by the host machine.
There might exist another bottleneck somewhere as well.
Here is a block diagram representing the test.

    +---------------------------+
    | Virtual Machine           |
    |                           |
    | Read/Write with O_DIRECT  |     +--------------------------+
    |       process x 128       |     | Host Machine             |  
    |             |             |     |                          |
    |             V             |     | Read/Write with O_DIRECT |
    |         /dev/vda1         |     |       process x 128      |
    +-------------|-------------+     +-------------|------------+
    +-------------V---------------------------------V------------+
    |     /dev/mapper/ioband1      |     /dev/mapper/ioband2     |
    |         80% weight           |         20% weight          |
    |                              |                             |
    |    Control I/O bandwidth according to the weights          |
    +-------------|---------------------------------|------------+
    +-------------V-------------+     +-------------|------------+
    |        /dev/sda11         |     |         /dev/sda12       |
    +---------------------------+     +--------------------------+

Thanks,
Ryo Tsuruta

-------------------------------------------------------------------------
This SF.net email is sponsored by: Microsoft
Defy all challenges. Microsoft(R) Visual Studio 2008.
http://clk.atdmt.com/MRT/go/vse0120000070mrt/direct/01/
