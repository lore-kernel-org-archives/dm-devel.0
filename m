From: Ryo Tsuruta <ryov@valinux.co.jp>
Subject: Re: I/O bandwidth control on KVM
Date: Tue, 04 Mar 2008 15:41:09 +0900 (JST)
Message-ID: <20080304.154109.193687573.ryov@valinux.co.jp>
References: <20080229.210531.226799765.ryov__28298.7898834564$1204287044$gmane$org@valinux.co.jp>
	<47CA2A7B.8000400@codemonkey.ws>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvm-devel-bounces@lists.sourceforge.net>
In-Reply-To: <47CA2A7B.8000400@codemonkey.ws>
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

Hi,

> If you are using virtio drivers in the guest (which I presume you are given the reference to /dev/vda), try using the following -drive syntax:
>
> -drive file=/dev/mapper/ioband1,if=virtio,boot=on,cache=off
>
> This will force the use of O_DIRECT.  By default, QEMU does not open with O_DIRECT so you'll see page cache effects.

Thank you for your suggestion.
I was using virtio drives as you wrote.
I just thought that kvm would use O_DIRECT option when applications on
the guest opened files with O_DIRECT option.
I'll try the way you mentioned and report back.

Thanks,
Ryo Tsuruta

-------------------------------------------------------------------------
This SF.net email is sponsored by: Microsoft
Defy all challenges. Microsoft(R) Visual Studio 2008.
http://clk.atdmt.com/MRT/go/vse0120000070mrt/direct/01/
