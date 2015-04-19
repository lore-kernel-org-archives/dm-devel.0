From: =?ISO-8859-1?Q?Murilo_Opsfelder_Ara=FAjo?= <mopsfelder@gmail.com>
Subject: Re: Device mapper failed to open temporary keystore device
Date: Sun, 19 Apr 2015 14:03:56 -0300
Message-ID: <CA+LKeY7U_+y0kEwG8MB3EPPYgXvfBX_cT5CWv9kjw78p3kE0rg@mail.gmail.com>
References: <CA+LKeY6Vm=hWj+gaKxm5JqLqehu8557OX2101a8roKas6WcsFg@mail.gmail.com>
 <20150417223848.GD4028@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150417223848.GD4028@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Alasdair Kergon <agk@redhat.com>, dm-devel@redhat.com, Herbert Xu <herbert@gondor.apana.org.au>
List-Id: dm-devel.ids

On Fri, Apr 17, 2015 at 7:38 PM, Mike Snitzer <snitzer@redhat.com> wrot=
e:
> On Fri, Apr 17 2015 at  4:11pm -0400,
> Murilo Opsfelder Ara=FAjo <mopsfelder@gmail.com> wrote:
>
>> Hello, everyone.
>>
>> Right after I enter my passphrase to unlock my cryptsetup partition,
>> it displays the following error and asks for cryptsetup password aga=
in
>> (it got stuck on this loop).
>>
>> This issue was introduced in next-20150413.  next-20150410 is workin=
g just fine.
>>
>> Any hint on how to debug this?
>>
>> Unlocking the disk /dev/disk/by-uuid/<uuid> (sda5_crypt)
>> Enter passphrase: *****
>> [  244.239821] device-mapper: table: 252:0: crypt: Error allocating =
crypto tfm
>> device-mapper: reload ioctl on  failed: No such file or directory
>> Failed to open temporary keystore device.
>> device-mapper: remove ioctl on temporary-cryptsetup-239 failed: No
>> such device or address
>> device-mapper: reload ioctl on temporary-cryptsetup-239 failed: No
>> such device or address
>> device-mapper: remove ioctl on temporary-cryptsetup-239 failed: No
>> such device or address
>> device-mapper: remove ioctl on temporary-cryptsetup-239 failed: No
>> such device or address
>> device-mapper: remove ioctl on temporary-cryptsetup-239 failed: No
>> such device or address
>> device-mapper: remove ioctl on temporary-cryptsetup-239 failed: No
>> such device or address
>
> git diff next-20150410^..next-20150413 drivers/md/dm-crypt.c points t=
o
> this commit as the nly dm-crpt.c change:
> https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.g=
it/commit/?h=3Dfor-next&id=3D5977907937afa2b5584a874d44ba6c0f56aeaa9c
>
> Which appears unrelated given your "crypt: Error allocating crypto tf=
m"
> error.
>
> But any chance you can try reverting that commit from next-20150413 a=
nd
> re-test just to be absolutely sure?

Hello, Mike.

I've reverted that commit from both next-20150413 and next-20150415.
In both cases, I got the same error, no success.

--=20
Murilo
