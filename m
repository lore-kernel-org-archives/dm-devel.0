From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: bcache performance test problem
Date: Wed, 23 May 2012 21:34:02 -0400
Message-ID: <CAH+dOx+2_u9pefH7RLerGOOx6rEs5Co6yXTjsv0haVHP+SUsNg@mail.gmail.com>
References: <205C8BB0A6FD70439409355AE09A1FC629172FA3@szxeml509-mbx>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <205C8BB0A6FD70439409355AE09A1FC629172FA3@szxeml509-mbx>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Qinling <mail.qinling-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: "dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Keliang <kernel.ke-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Lizefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: dm-devel.ids

That is pretty terrible performance. If you could try digging around a
bit with perf, blktrace, etc. that'd be much appreciated - otherwise
I'll see if I can come up with some way of reproducing it as soon as I
have time. I haven't done a lot of performance testing on upstream
kernels, unfortunately.

On Wed, May 23, 2012 at 9:14 PM, Qinling <mail.qinling-hv44wF8Li93QT0dZR+AlfA@public.gmane.org> wrot=
e:
> Hi Kent,
>
>
>
> I have tested bcache on my platform, but the result is not good. I th=
ink
> maybe the wrong config caused it. Would you pls help me to check the =
config,
> or give me some advice for bcache performance testing?
>
>
>
> My SSD card is =A0a PCIe SSD card (about 120,000 IOPS), and I used 10=
GB.
>
>
>
> I have download the code from
> git://evilpiepirate.org/~kent/linux-bcache.git.
>
> The commands creating bcache is below:
>
> make-bcache =96B /dev/sdb8
>
> make-bcache =96C =96w4k =96b1M =96writeback /dev/hioa5
>
>
>
> I use FIO to test the seq./random IO performance, and the result is b=
elow:
>
> write=A0=A0=A0=A0 =A0=A0=A0=A0=A0=A0=A0=A0read=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 =A0=A0=A0=A0=A0=A0=A0=A0=A0randwrite=A0=A0=A0 randread
>
> bcache=A0=A0=A0=A0=A0=A0 =A0=A0=A0=A0=A0=A0=A0=A010809 KB/s=A0 =A0=A0=
164502.5 KB/s=A0=A0=A0=A0 2713 KB/s=A0=A0=A0 29640 KB/s
>
> cache_hit_rate=A0 80=A0=A0=A0=A0 =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A079=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A094
> =A0=A0=A0=A0=A092
>
>
>
>
>
> And the basic test result is:
>
> Write =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0read=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 randwrite=A0=A0=A0=A0=A0=A0=
=A0 =A0=A0=A0=A0=A0randread
>
> HDD=A0=A0=A0=A0=A0 81211.6 KB/s=A0=A0=A0=A0=A0=A0 172242 KB/s=A0=A0=A0=
=A0 2606 KB/s=A0=A0=A0=A0=A0=A0=A0=A0 =A0=A0=A0=A01855 KB/s
>
> SSD=A0=A0=A0=A0=A0=A0 250948.2 KB/s=A0=A0=A0=A0 813855 KB/s=A0=A0=A0=A0=
 238892.7 KB/s=A0=A0=A0=A0=A0 657319.5 KB/s
>
>
