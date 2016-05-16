From: Tim Small <tim@buttersideup.com>
Subject: Re: bcache gets stuck flushing writeback cache when used in
 combination with LUKS/dm-crypt and non-default bucket size
Date: Mon, 16 May 2016 14:02:15 +0100
Message-ID: <5739C4D7.7040600@buttersideup.com>
References: <044401d1a958$ea7ef4e0$bf7cdea0$@codenest.com>
 <alpine.LRH.2.11.1605101816240.22680@mx.ewheeler.net>
 <57383C99.6090206@buttersideup.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
In-Reply-To: <57383C99.6090206@buttersideup.com>
Sender: linux-bcache-owner@vger.kernel.org
To: Eric Wheeler <bcache@lists.ewheeler.net>, James Johnston <johnstonj.public@codenest.com>
Cc: linux-bcache@vger.kernel.org, dm-crypt@saout.de, dm-devel@redhat.com
List-Id: dm-devel.ids

Hi Eric,

On 15/05/16 10:08, Tim Small wrote:
> On 11/05/16 02:38, Eric Wheeler wrote:
>> Ming Lei's patch got in to 4.6 yet, but try this:
>> >   https://lkml.org/lkml/2016/4/5/1046
>> > 
>> > and maybe Shaohua Li's patch too:
>> >   http://www.spinics.net/lists/raid/msg51830.html

> I'll give them both a go...

I tried both of these on 4.6.0-rc7 without change to the symptoms (cache
device continuously read).  Then I tried also disabling
partial_stripes_expensive prior to registering the bcache device as per
your instructions here:

https://lkml.org/lkml/2016/2/1/636

and that seems to have improved things, but not fixed them.

The cache device is 120G, and dirty_data had got up to 55.3G, but has
now dropped down to 44.5G, but isn't going any further...

The cache device is being read at a steady ~270 MB/s, and the backing
device (dm-crypt) being written at the same rate, but the writes aren't
flowing down to the underlying devices (md RAID5, and SATA disks).  I'm
guessing that these writes are being refused/retried, and are maybe
failing due to their size (avgrq-sz showing > 4000 sectors on the
backing device)?  Disabling the partial stripes expensive maybe just
resulted in a few GB of small writes succeeding?

# iostat -y -d 2 -x -p /dev/sdf /dev/dm-0 /dev/md2 /dev/bcache0
Linux 4.6.0-rc7+  16/05/16        _x86_64_        (2 CPU)

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s
avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sdf               0.00     0.00  413.00    0.00 281422.00     0.00
1362.82   143.18  338.31  338.31    0.00   2.42 100.00
sdf1              0.00     0.00    0.00    0.00     0.00     0.00
0.00     0.00    0.00    0.00    0.00   0.00   0.00
sdf2              0.00     0.00    0.00    0.00     0.00     0.00
0.00     0.00    0.00    0.00    0.00   0.00   0.00
sdf3              0.00     0.00  413.00    0.00 281422.00     0.00
1362.82   143.18  338.31  338.31    0.00   2.42 100.00
dm-0              0.00     0.00    0.00  138.50     0.00 280912.00
4056.49     0.00    0.01    0.00    0.01   0.01   0.20
md2               0.00     0.00    0.00    0.00     0.00     0.00
0.00     0.00    0.00    0.00    0.00   0.00   0.00
bcache0           0.00     0.00    0.00    0.00     0.00     0.00
0.00     0.00    0.00    0.00    0.00   0.00   0.00

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s
avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sdf               0.00     6.00  412.00    1.50 281806.00    32.00
1363.18   135.19  314.09  314.78  124.00   2.42 100.00
sdf1              0.00     6.00    0.00    1.50     0.00    32.00
42.67     4.10  124.00    0.00  124.00 388.00  58.20
sdf2              0.00     0.00    0.00    0.00     0.00     0.00
0.00     0.00    0.00    0.00    0.00   0.00   0.00
sdf3              0.00     0.00  412.00    0.00 281806.00     0.00
1367.99   131.10  314.78  314.78    0.00   2.43 100.00
dm-0              0.00     0.00    0.00  138.50     0.00 282388.00
4077.81     0.00    0.01    0.00    0.01   0.01   0.20
md2               0.00     0.00    0.00    0.00     0.00     0.00
0.00     0.00    0.00    0.00    0.00   0.00   0.00
bcache0           0.00     0.00    0.00    0.00     0.00     0.00
0.00     0.00    0.00    0.00    0.00   0.00   0.00

Cheers,

Tim.
