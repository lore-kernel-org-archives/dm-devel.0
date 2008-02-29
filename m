From: Ryo Tsuruta <ryov@valinux.co.jp>
Subject: I/O bandwidth control on KVM
Date: Fri, 29 Feb 2008 21:05:31 +0900 (JST)
Message-ID: <20080229.210531.226799765.ryov@valinux.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvm-devel-bounces@lists.sourceforge.net>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/kvm-devel>,
	<mailto:kvm-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=kvm-devel>
List-Post: <mailto:kvm-devel@lists.sourceforge.net>
List-Help: <mailto:kvm-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/kvm-devel>,
	<mailto:kvm-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: kvm-devel-bounces@lists.sourceforge.net
Errors-To: kvm-devel-bounces@lists.sourceforge.net
To: kvm-devel@lists.sourceforge.net, dm-devel@redhat.com, virtualization@lists.linux-foundation.org
List-Id: dm-devel.ids

Hello all,

I've implemented a block device which throttles block I/O bandwidth, 
which I called dm-ioband, and been trying to throttle I/O bandwidth on
KVM environment. But unfortunately it doesn't work well, the number of
issued I/Os is not according to the bandwidth setting.
On the other hand, I got the good result when accessing directly to
the local disk on the local machine.

I'm not so familiar with KVM. Could anyone give me any advice?

For dm-ioband details, please see the website at
http://people.valinux.co.jp/~ryov/dm-ioband/

                       The number of issued I/Os
     --------------------------------------------------------------
    |       device         |       sda11       |       sda12       |
    |    weight setting    |        80%        |        20%        |
    |----------------------+-------------------+-------------------|
    | KVM |      I/Os      |       4397        |       2902        |
    |     | ratio to total |       60.2%       |       39.8%       |
    |-----+----------------+-------------------+-------------------|
    |local|      I/Os      |       5447        |       1314        |
    |     | ratio to total |       80.6%       |       19.4%       |
     --------------------------------------------------------------

The test environment and the procedure are as follow:

  o Prepare two partitions sda11 and sda12.
  o Create two bandwidth control devices, each device is mapped to the
    sda11 and sda12 respectively.
  o Give weights of 80 and 20 to each bandwidth control device respectively.
  o Run two virtual machines, the virtual machine's disk is mapped to
    the each bandwidth control device.
  o Run 128 processes issuing random read/write direct I/O with 4KB data
    on each virtual machine at the same time respectively.
  o Count up the number of I/Os which have done in 60 seconds.

                        Access through KVM
  +---------------------------+     +--------------------------+
  | Virtual Machine 1 (VM1)   |     | Virtual Machine 2 (VM2)  |
  |    in cgroup "ioband1"    |     |    in cgroup "ioband2"   |
  |                           |     |                          |
  | Read/Write with O_DIRECT  |     | Read/Write with O_DIRECT |
  |       process x 128       |     |       process x 128      |  
  |             |             |     |             |            |
  |             V             |     |             V            |
  |         /dev/vda1         |     |         /dev/vda1        |
  +-------------|-------------+     +-------------|------------+
  +-------------V---------------------------------V------------+
  |     /dev/mapper/ioband1      |     /dev/mapper/ioband2     |
  | 80% for cgroup "ioband1"     | 20% for cgroup "ioband2"    |
  |                              |                             |
  |    Control I/O bandwidth according to the cgroup tasks     |
  +-------------|---------------------------------|------------+
  +-------------V-------------+     +-------------|------------+
  |        /dev/sda11         |     |         /dev/sda12       |
  +---------------------------+     +--------------------------+

                          Direct access
  +---------------------------+     +--------------------------+
  | cgroup "ioband1"          |     | cgroup "ioband2"         |
  |                           |     |                          |
  | Read/Write with O_DIRECT  |     | Read/Write with O_DIRECT |
  |       process x 128       |     |       process x 128      |  
  |             |             |     |             |            |
  +-------------|-------------+     +-------------|------------+
  +-------------V---------------------------------V------------+
  |     /dev/mapper/ioband1      |    /dev/mapper/ioband2      |
  | 80% for cgroup "ioband1"     | 20% for cgroup "ioband2"    |
  |                              |                             |
  |     Control I/O bandwidth according to the cgroup tasks    |
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
