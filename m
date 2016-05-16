From: Tim Small <tim@buttersideup.com>
Subject: Re: bcache gets stuck flushing writeback cache when used in
 combination with LUKS/dm-crypt and non-default bucket size
Date: Mon, 16 May 2016 14:53:46 +0100
Message-ID: <5739D0EA.3080000@buttersideup.com>
References: <044401d1a958$ea7ef4e0$bf7cdea0$@codenest.com>
 <alpine.LRH.2.11.1605101816240.22680@mx.ewheeler.net>
 <57383C99.6090206@buttersideup.com> <5739C4D7.7040600@buttersideup.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
In-Reply-To: <5739C4D7.7040600@buttersideup.com>
Sender: linux-bcache-owner@vger.kernel.org
To: Eric Wheeler <bcache@lists.ewheeler.net>, James Johnston <johnstonj.public@codenest.com>
Cc: linux-bcache@vger.kernel.org, dm-crypt@saout.de, dm-devel@redhat.com
List-Id: dm-devel.ids

On 16/05/16 14:02, Tim Small wrote:
> # iostat -y -d 2 -x -p /dev/sdf /dev/dm-0 /dev/md2 /dev/bcache0

... and then mangled the word-wrapping.  Try again:

Here's a typical hand-edited excerpt from:

iostat -d 2 -x -y -m -p /dev/sdf /dev/dm-0 /dev/md2 /dev/bcache0

...

Device:    r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await
sdf     396.50   19.50   272.02     0.25  1340.38   138.44  346.09
sdf3    397.00    0.00   272.52     0.00  1405.83   130.05  338.40
dm-0      0.00  149.00     0.00   271.29  3728.81     0.01    0.04
md2       0.00    0.00     0.00     0.00     0.00     0.00    0.00
bcache0   0.00    0.00     0.00     0.00     0.00     0.00    0.00

where:

sdf is the SSD (bcache cache device is sdf3)
dm-0 is dm-crypt backing device (bcache backing store)
md2 is the underlying device for dm-crypt
bcache0 is the bcache device.

According to the iostat manual page:

"avgrq-sz The average size (in sectors) of the requests that were issued
to the device."

dm-0 is described like this in the output of 'dmsetup table':

encryptedstore01: 0 46879675392 crypt aes-xts-plain64
0000000000000000000000000000000000000000000000000000000000000000 0 9:2
3072 1 allow_discards

Tim.
