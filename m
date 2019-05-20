From: =?utf-8?Q?Michael_La=C3=9F?= <bevan@bi-co.net>
Subject: Re: fstrim discarding too many or wrong blocks on Linux 5.1, leading
 to data loss
Date: Mon, 20 May 2019 21:58:20 +0200
Message-ID: <A140375B-7C55-4D1D-8892-3C93E5F0E49F@bi-co.net>
References: <297da4cbe20235080205719805b08810@bi-co.net>
 <CAJCQCtR-uo9fgs66pBMEoYX_xAye=O-L8kiMwyAdFjPS5T4+CA@mail.gmail.com>
 <8C31D41C-9608-4A65-B543-8ABCC0B907A0@bi-co.net>
 <CAJCQCtTZWXUgUDh8vn0BFeEbAdKToDSVYYw4Q0bt0rECQr9nxQ@mail.gmail.com>
 <AD966642-1043-468D-BABF-8FC9AF514D36@bi-co.net>
 <158a3491-e4d2-d905-7f58-11a15bddcd70@gmx.com>
 <C1CD4646-E75D-4AAF-9CD6-B3AC32495FD3@bi-co.net>
 <CAK-xaQYPs62v971zm1McXw_FGzDmh_vpz3KLEbxzkmrsSgTfXw@mail.gmail.com>
 <9D4ECE0B-C9DD-4BAD-A764-9DE2FF2A10C7@bi-co.net>
 <CAK-xaQYakXcAbhfiH_VbqWkh+HBJD5N69ktnnA7OnWdhL6fDLA@mail.gmail.com>
 <ea5552b8-7b6a-2516-d968-c3f3c731e159@gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <ea5552b8-7b6a-2516-d968-c3f3c731e159@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
To: Milan Broz <gmazyland@gmail.com>
Cc: Andrea Gelmini <andrea.gelmini@gelma.net>, Qu Wenruo <quwenruo.btrfs@gmx.com>, Chris Murphy <lists@colorremedies.com>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>, dm-devel@redhat.com
List-Id: dm-devel.ids


> Am 20.05.2019 um 18:45 schrieb Milan Broz <gmazyland@gmail.com>:
> 
> On 20/05/2019 16:53, Andrea Gelmini wrote:
> ...
>> Also, changing crypttab:
>> root@glet:~# cat /etc/crypttab
>> sda6_crypt UUID=fe03e2e6-b8b1-4672-8a3e-b536ac4e1539 none luks,discard
>> 
>> removing discard didn't solve the issue.
> 
> This is very strange, disabling discard should reject every discard IO
> on the dmcrypt layer. Are you sure it was really disabled?
> 
> Note, it is the root filesystem, so you have to regenerate initramfs
> to update crypttab inside it.

For me, I cannot reproduce the issue when I remove the discard option from the crypttab (and regenerate the initramfs). When trying fstrim I just get “the discard operation is not supported”, as I would expect. No damage is done to other logical volumes.

However, my stack differs from Andrea’s in that I have dm-crypt on an LVM logical volume and not dm-crypt as a physical volume for LVM. Not sure if that makes a difference here.

Cheers,
Michael

> Could you paste "dmsetup table" and "lsblk -D" to verify that discard flag
> is not there?
> (I mean dmsetup table with the zeroed key, as a default and safe output.)
> 
> Milan
