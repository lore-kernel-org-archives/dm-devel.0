From: Anthony Liguori <anthony@codemonkey.ws>
Subject: Re: I/O bandwidth control on KVM
Date: Sun, 02 Mar 2008 12:08:39 -0600
Message-ID: <47CAED27.10308@codemonkey.ws>
References: <20080229.210531.226799765.ryov__28298.7898834564$1204287044$gmane$org@valinux.co.jp>
	<47CA2A7B.8000400@codemonkey.ws> <47CAD9C7.90900@qumranet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvm-devel-bounces@lists.sourceforge.net>
In-Reply-To: <47CAD9C7.90900@qumranet.com>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/kvm-devel>,
	<mailto:kvm-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=kvm-devel>
List-Post: <mailto:kvm-devel@lists.sourceforge.net>
List-Help: <mailto:kvm-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/kvm-devel>,
	<mailto:kvm-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: kvm-devel-bounces@lists.sourceforge.net
Errors-To: kvm-devel-bounces@lists.sourceforge.net
To: Avi Kivity <avi@qumranet.com>
Cc: kvm-devel@lists.sourceforge.net, Ryo Tsuruta <ryov@valinux.co.jp>, dm-devel@redhat.com, virtualization <virtualization@lists.linux-foundation.org>
List-Id: dm-devel.ids

Avi Kivity wrote:
> Anthony Liguori wrote:
>>
>> If you are using virtio drivers in the guest (which I presume you are 
>> given the reference to /dev/vda), try using the following -drive syntax:
>>
>> -drive file=/dev/mapper/ioband1,if=virtio,boot=on,cache=off
>>
>> This will force the use of O_DIRECT.  By default, QEMU does not open 
>> with O_DIRECT so you'll see page cache effects.
>>
>>   
>
> Good point.  But IIRC cache=off is not limited to virtio?

Nope.  I just wanted to give the exact syntax to use and it looked like 
he was using virtio.

Regards,

Anthony Liguori


-------------------------------------------------------------------------
This SF.net email is sponsored by: Microsoft
Defy all challenges. Microsoft(R) Visual Studio 2008.
http://clk.atdmt.com/MRT/go/vse0120000070mrt/direct/01/
