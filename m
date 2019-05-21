From: Andrea Gelmini <andrea.gelmini@gelma.net>
Subject: Re: fstrim discarding too many or wrong blocks on Linux 5.1, leading
 to data loss
Date: Tue, 21 May 2019 20:54:56 +0200
Message-ID: <CAK-xaQYT_m2UV0w_MLbpGAb-ckyVc1YLnGdpX42eQRj1JZf4WA@mail.gmail.com>
References: <297da4cbe20235080205719805b08810@bi-co.net> <CAJCQCtR-uo9fgs66pBMEoYX_xAye=O-L8kiMwyAdFjPS5T4+CA@mail.gmail.com>
 <8C31D41C-9608-4A65-B543-8ABCC0B907A0@bi-co.net> <CAJCQCtTZWXUgUDh8vn0BFeEbAdKToDSVYYw4Q0bt0rECQr9nxQ@mail.gmail.com>
 <AD966642-1043-468D-BABF-8FC9AF514D36@bi-co.net> <158a3491-e4d2-d905-7f58-11a15bddcd70@gmx.com>
 <C1CD4646-E75D-4AAF-9CD6-B3AC32495FD3@bi-co.net> <CAK-xaQYPs62v971zm1McXw_FGzDmh_vpz3KLEbxzkmrsSgTfXw@mail.gmail.com>
 <9D4ECE0B-C9DD-4BAD-A764-9DE2FF2A10C7@bi-co.net> <CAK-xaQYakXcAbhfiH_VbqWkh+HBJD5N69ktnnA7OnWdhL6fDLA@mail.gmail.com>
 <ea5552b8-7b6a-2516-d968-c3f3c731e159@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <ea5552b8-7b6a-2516-d968-c3f3c731e159@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
To: Milan Broz <gmazyland@gmail.com>
Cc: =?UTF-8?B?TWljaGFlbCBMYcOf?= <bevan@bi-co.net>, Qu Wenruo <quwenruo.btrfs@gmx.com>, Chris Murphy <lists@colorremedies.com>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>, dm-devel@redhat.com
List-Id: dm-devel.ids

Il giorno lun 20 mag 2019 alle ore 18:45 Milan Broz
<gmazyland@gmail.com> ha scritto:
> Note, it is the root filesystem, so you have to regenerate initramfs
> to update crypttab inside it.

Good catch. I didn't re-mkinitramfs.

> Could you paste "dmsetup table" and "lsblk -D" to verify that discard flag
> is not there?
> (I mean dmsetup table with the zeroed key, as a default and safe output.)

This weekend if I have time I'm going to re-test it. It takes a lot to
restore 4TB.

Thanks a lot,
Andrea
