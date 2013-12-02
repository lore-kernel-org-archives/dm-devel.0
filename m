From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-cache fs corruption
Date: Mon, 2 Dec 2013 09:47:57 -0500
Message-ID: <20131202144756.GB5331@redhat.com>
References: <33A0129EBFD46748804DE81B354CA1B21C031F48@SACEXCMBX06-PRD.hq.netapp.com>
	<20131114143832.GC17651@debian>
	<CALwk7=xBTqtOQqXx6WnGyLAAXz4+wrQ9W3MOjs66mWBRhmqxBw@mail.gmail.com>
	<CALwk7=xGynqqH2CN8Eop7qioSR9FGVt7AmGRLkwWXC87KVO8WA@mail.gmail.com>
	<CALwk7=wgChKoSqnj_CJwRfnRRwrfNnjPkr-zVGKunOTSjWz2Pw@mail.gmail.com>
	<CALwk7=x72BKSFgja2zy38qfusEwTSebcaFBpuAkOaed0F-zJcQ@mail.gmail.com>
	<20131128172813.GA24861@debian>
	<CALwk7=xGqvqsiyGUryFdvuiM76iF6MY+wc4NSa==JGmR3vtZTA@mail.gmail.com>
	<CALwk7=xHQBb9wGcvo-0zhnd7rBaMUXhai2MyVC=WaQ58j8LkQg@mail.gmail.com>
	<CALwk7=yrb4awYXdyGdf5fAY8pW3=k6b+eabeDA2mooeyetBWYg@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CALwk7=yrb4awYXdyGdf5fAY8pW3=k6b+eabeDA2mooeyetBWYg@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Vladimir Smolensky <arizal@gmail.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Sat, Nov 30 2013 at  9:28am -0500,
Vladimir Smolensky <arizal@gmail.com> wrote:

> Hello, the device broke after about a day:
> 
> dmesg:
> 
> [83086.878182] device-mapper: space map metadata: unable to allocate new
> metadata block
> [83088.879861] device-mapper: space map metadata: unable to allocate new
> metadata block
> [83089.414700] device-mapper: space map metadata: unable to allocate new
> metadata block
> [83089.414706] device-mapper: cache: could not commit metadata for accurate
> status
> [83090.881533] device-mapper: space map metadata: unable to allocate new
> metadata block
> [83092.883142] device-mapper: space map metadata: unable to allocate new
> metadata block
> [83094.884719] device-mapper: space map metadata: unable to allocate new
> metadata block
> [83096.886355] device-mapper: space map metadata: unable to allocate new
> metadata block
> [83097.712195] device-mapper: space map metadata: unable to allocate new
> metadata block
> [83097.712200] device-mapper: cache: could not commit metadata for accurate
> status
> [83098.283947] device-mapper: space map metadata: unable to allocate new
> metadata block
> [83098.283952] device-mapper: cache: could not commit metadata for accurate
> status
> [83098.729396] device-mapper: space map metadata: unable to allocate new
> metadata block
> [83098.729401] device-mapper: cache: could not commit metadata for accurate
> status
> 
> dmsetup status:
> storage: 0 40963653632 cache 249856/249856 26968230 2678513 711227 30042060
> 0 248746 248729 0 1 writeback 2 migration_threshold 100000000 4
> random_threshold 4 sequential_threshold 10000000
> 
> Obviously the metadata partition is full but accourding to the formula I
> use it should be more than enough =>  4 MB + ( 16 bytes * nr_blocks ) I get
> 13341184 ~ 13MB and metadata partiton is 1024MB
>
> device sizes:
>  # blockdev --report
> RO    RA   SSZ   BSZ   StartSec            Size   Device
> rw   256   512  4096          0     26843414528   /dev/sda
> rw   256   512  4096       2048      4094689280   /dev/sda1
> rw   256   512  4096    7999488     22746759168   /dev/sda2
> rw  2048   512  4096          0  20973392756736   /dev/sdb
> rw  2048   512  4096       2048  20973390659584   /dev/sdb1
> rw  2048   512  4096          0   2397799710720   /dev/sdc
> rw  2048   512  4096       2048      1023410176   /dev/sdc1
> rw  2048   512  4096    2000896   2396774203392   /dev/sdc2
> rw  2048   512   512          0  20973390659584   /dev/dm-0
>
> What am I doing wrong?

Not clear yet.  Something is causing you to run out of metadata blocks.

Please provide the output of 'dmsetup table'.  Last time you did the
metadata device that was provided to the cache target was _not_ 1024MB.

Mike
