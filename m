From: Milan Broz <gmazyland@gmail.com>
Subject: Re: fstrim discarding too many or wrong blocks on Linux 5.1, leading
 to data loss
Date: Mon, 20 May 2019 18:45:04 +0200
Message-ID: <ea5552b8-7b6a-2516-d968-c3f3c731e159@gmail.com>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAK-xaQYakXcAbhfiH_VbqWkh+HBJD5N69ktnnA7OnWdhL6fDLA@mail.gmail.com>
Content-Language: en-US
Sender: linux-btrfs-owner@vger.kernel.org
To: Andrea Gelmini <andrea.gelmini@gelma.net>, =?UTF-8?Q?Michael_La=c3=9f?= <bevan@bi-co.net>
Cc: Qu Wenruo <quwenruo.btrfs@gmx.com>, Chris Murphy <lists@colorremedies.com>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>, dm-devel@redhat.com
List-Id: dm-devel.ids

On 20/05/2019 16:53, Andrea Gelmini wrote:
...
> Also, changing crypttab:
> root@glet:~# cat /etc/crypttab
> sda6_crypt UUID=fe03e2e6-b8b1-4672-8a3e-b536ac4e1539 none luks,discard
> 
> removing discard didn't solve the issue.

This is very strange, disabling discard should reject every discard IO
on the dmcrypt layer. Are you sure it was really disabled?

Note, it is the root filesystem, so you have to regenerate initramfs
to update crypttab inside it.

Could you paste "dmsetup table" and "lsblk -D" to verify that discard flag
is not there?
(I mean dmsetup table with the zeroed key, as a default and safe output.)

Milan
