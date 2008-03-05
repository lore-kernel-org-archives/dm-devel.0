From: Ryo Tsuruta <ryov@valinux.co.jp>
Subject: Re: [kvm-devel] I/O bandwidth control on KVM
Date: Thu, 06 Mar 2008 00:53:53 +0900 (JST)
Message-ID: <20080306.005353.104038921.ryov@valinux.co.jp>
References: <20080229.210531.226799765.ryov__28298.7898834564$1204287044$gmane$org@valinux.co.jp>
	<47CA2A7B.8000400@codemonkey.ws>
	<20080304.154109.193687573.ryov@valinux.co.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20080304.154109.193687573.ryov@valinux.co.jp>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: anthony@codemonkey.ws
Cc: kvm-devel@lists.sourceforge.net, dm-devel@redhat.com, virtualization@lists.linux-foundation.org
List-Id: dm-devel.ids

Hi,

> If you are using virtio drivers in the guest (which I presume you are 
> given the reference to /dev/vda), try using the following -drive syntax:
> 
> -drive file=/dev/mapper/ioband1,if=virtio,boot=on,cache=off
> 
> This will force the use of O_DIRECT.  By default, QEMU does not open 
> with O_DIRECT so you'll see page cache effects.

I tried the test with "cache=off" option, here is the result. 

                       The number of issued I/Os
     --------------------------------------------------------------------
    |             device         |       sda11       |       sda12       |
    |          weight setting    |        80%        |        20%        |
    |----------------------------+-------------------+-------------------|
    | KVM       |      I/Os      |       5217        |       5623        |
    | cache=off | ratio to total |       48.1%       |       51.9%       |
    |-----------+----------------+-------------------+-------------------|
    | KVM       |      I/Os      |       4397        |       2902        |
    | cache=on  | ratio to total |       60.2%       |       39.8%       |
    |-----------+----------------+-------------------+-------------------|
    |local      |      I/Os      |       5447        |       1314        |
    |           | ratio to total |       80.6%       |       19.4%       |
     --------------------------------------------------------------------

I could see the page cache effect through the /sys/block/sda/sda[12]/stat,
O_DIRECT was taking effect. However, the bandwidth control didn't work.

I also did another test. The difference from the previous test is that
the weights were assigned on a per partition basis instead of a per
cgroup basis.
It worked fine on Xen and local processes, but unfortunately it didn't
work on KVM.

                       The number of issued I/Os
            The weights were assigned on a per partition basis
     --------------------------------------------------------------------
    |             device         |       sda11       |       sda12       |
    |          weight setting    |        80%        |        20%        |
    |----------------------------+-------------------+-------------------|
    | KVM       |      I/Os      |       5905        |       5873        |
    | cache=off | ratio to total |       50.1%       |       49.9%       |
    |-----------+----------------+-------------------+-------------------|
    |local      |      I/Os      |       6929        |       1629        |
    |           | ratio to total |       81.0%       |       19.0%       |
    |--------------------------------------------------------------------|
    | Xen       |      I/Os      |       8534        |       2360        |
    |           | ratio to total |       78.3%       |       21.7%       |
     --------------------------------------------------------------------

I don't understand what was going on. I'd be appreciate if you could give
me other suggestions.

Thanks,
Ryo Tsuruta
