From: Ryo Tsuruta <ryov@valinux.co.jp>
Subject: Re: I/O bandwidth control on KVM
Date: Mon, 10 Mar 2008 21:05:04 +0900 (JST)
Message-ID: <20080310.210504.112608852.ryov@valinux.co.jp>
References: <47CECA91.2010507@codemonkey.ws>
	<20080306.212305.104034101.ryov@valinux.co.jp>
	<47D01667.10809@codemonkey.ws>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvm-devel-bounces@lists.sourceforge.net>
In-Reply-To: <47D01667.10809@codemonkey.ws>
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

Hi Anthony,

> There's an aio_init in block-raw-posix.c that sets the thread count to 
> 1.  If you #if 0 out that block, or increase the threads to something 
> higher (like 16), you should see multiple simultaneous requests.  Sorry 
> about that, I had that in a different patch in my tree.

Thank you for your suggestion. I tried commenting out the calling
aio_init(), the AIO functions use aio_threads=20 and aio_num=64 as
default, but the results were the same as I have tested before, the
number of I/Os was divided into equal proportion.

Then, I changed "io_throttle" value to 1(default is 4). "io_throttle"
is a dm-ioband's configuration parameter, when the number of BIOs in
progress exceeds this value, dm-ioband starts to control the bandwidth. 
And then the bandwidth control seemed to work much better, but sometimes
I wasn't able to get the proper proportions. As these results indicate,
the number of simultaneous I/O requests issued from two KVM virtual
machines was less than 4.

     The number of issued I/Os for 60 seconds (io_throttle = 1)
     --------------------------------------------------------
    | weight setting  |    sda11     |   sda12     |  total  |
    |  sda11 : sda12  |    I/Os(%)   |   I/Os(%)   |  I/Os   |
    |-----------------+--------------+-------------|---------|
    |     80:20 #1    |  7264(75.8%) | 2324(24.2%) |   9588  |
    |     80:20 #2    |  7147(71.1%) | 2899(28.9%) |  10046  |
    |-----------------+--------------+-------------|---------|
    |     50:50 #1    |  5162(55.5%) | 4146(44.5%) |   9308  |
    |     50:50 #2    |  4666(49.3%) | 4793(50.7%) |   9459  |
    |-----------------+--------------+-------------|---------|
    |     20:80 #1    |  3574(39.8%) | 5402(60.2%) |   8976  |
    |     20:80 #2    |  2038(21.4%) | 7499(78.6%) |   9537  |
    |-----------------+--------------+-------------|---------|
    |     10:90 #1    |  2027(21.1%) | 7602(78.9%) |   9629  |
    |     10:90 #2    |  1556(16.4%) | 7935(83.6%) |   9491  |
     --------------------------------------------------------

> The virtio block backend isn't quite optimal right now.  I have some 
> patches (that are currently suffering bitrot) that switch over to 
> linux-aio which allows zero-copy and for proper barrier support (so the 
> guest block device will use an ordered queue).  The QEMU aio 
> infrastructure makes it tough to integrate it properly though.

That's good idea. I hope your work is going well and look forward to
releasing the patches.

Thanks,
Ryo Tsuruta

-------------------------------------------------------------------------
This SF.net email is sponsored by: Microsoft
Defy all challenges. Microsoft(R) Visual Studio 2008.
http://clk.atdmt.com/MRT/go/vse0120000070mrt/direct/01/
