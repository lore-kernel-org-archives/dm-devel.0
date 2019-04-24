From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: max_sectors_kb limitations with VDO and dm-thin
Date: Wed, 24 Apr 2019 17:27:51 -0400
Message-ID: <20190424212751.GC14367@redhat.com>
References: <CAFTvtQ=HnGB2bw8heFR5rL=5K9FOAXbbyK65pqzO0MMFV3CEiQ@mail.gmail.com>
	<45987177-c92c-d906-50bc-f4c789c36857@redhat.com>
	<CAFTvtQ=JiZ7FWNiayM5bVY5A8ZCNbDtXV=rUxa_0u6Xm6rJAqg@mail.gmail.com>
	<CAMeeMh-v+xpn2YDizFQg4cKHZgC=aCdJwLfAMeGLGT1gB1ZURw@mail.gmail.com>
	<CAFTvtQnLDU_MKzse5t4xc_CVWENsZtwQQSTAFyj-45tPg5STZQ@mail.gmail.com>
	<CAFTvtQnALzibyS3jKisXRb+XGe8dopQfkj33=gtJAjd2+XymYQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CAFTvtQnALzibyS3jKisXRb+XGe8dopQfkj33=gtJAjd2+XymYQ@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Ryan Norwood <ryan.p.norwood@gmail.com>
Cc: vdo-devel@redhat.com, dm-devel@redhat.com
List-Id: dm-devel.ids


On Wed, Apr 24 2019 at 10:46am -0400,
Ryan Norwood <ryan.p.norwood@gmail.com> wrote:

>    On Wed, Apr 24, 2019 at 9:08 AM Ryan Norwood <[1]ryan.p.norwood@gmail.com>
>    wrote:
> 
>      Thank you for your help.
>      You are correct, it appears that the problem occurs when there is a RAID
>      5 or RAID 50 volume beneath VDO.
>      NAME      KNAME    RA   SIZE ALIGNMENT  MIN-IO  OPT-IO PHY-SEC LOG-SEC
>      RQ-SIZE SCHED    WSAME
>      sdh
>       sdh     128 977.5G         0     512       0     512     512     128
>      deadline    0B
>      +-sed6
>      dm-6    128 977.5G         0     512       0     512     512     128
>               0B
>        +-md127
>       md127 12288   5.7T         0 1048576 6291456     512     512     128
>               0B
>          +-vdo_data
>      dm-17   128   5.7T         0 1048576 6291456     512     512     128
>               0B
>            +-vdo
>       dm-18   128  57.3T         0    4096    4096    4096    4096     128
>               0B
>      /sys/block/md126/queue/max_hw_sectors_kb:2147483647
>      /sys/block/md126/queue/max_integrity_segments:0
>      /sys/block/md126/queue/max_sectors_kb:512
>      /sys/block/md126/queue/max_segments:64
>      /sys/block/md126/queue/max_segment_size:4096
>      /sys/block/dm-17/queue/max_hw_sectors_kb:512
>      /sys/block/dm-17/queue/max_integrity_segments:0
>      /sys/block/dm-17/queue/max_sectors_kb:512
>      /sys/block/dm-17/queue/max_segments:64
>      /sys/block/dm-17/queue/max_segment_size:4096
>      /sys/block/dm-18/queue/max_hw_sectors_kb:4
>      /sys/block/dm-18/queue/max_integrity_segments:0
>      /sys/block/dm-18/queue/max_sectors_kb:4
>      /sys/block/dm-18/queue/max_segments:64
>      /sys/block/dm-18/queue/max_segment_size:4096
>      NAME      KNAME    RA   SIZE ALIGNMENT  MIN-IO  OPT-IO PHY-SEC LOG-SEC
>      RQ-SIZE SCHED    WSAME
>      sdq       sdq     128 977.5G         0     512       0     512     512
>         128 deadline    0B
>      +-sed15   dm-15   128 977.5G         0     512       0     512     512
>         128             0B
>        +-vdo   dm-16   128  57.3T         0    4096    4096    4096    4096
>         128             0B
>      /sys/block/sdq/queue/max_hw_sectors_kb:256
>      /sys/block/sdq/queue/max_integrity_segments:0
>      /sys/block/sdq/queue/max_sectors_kb:256
>      /sys/block/sdq/queue/max_segments:64
>      /sys/block/sdq/queue/max_segment_size:65536
>      /sys/block/dm-15/queue/max_hw_sectors_kb:256
>      /sys/block/dm-15/queue/max_integrity_segments:0
>      /sys/block/dm-15/queue/max_sectors_kb:256
>      /sys/block/dm-15/queue/max_segments:64
>      /sys/block/dm-15/queue/max_segment_size:4096
>      /sys/block/dm-16/queue/max_hw_sectors_kb:256
>      /sys/block/dm-16/queue/max_integrity_segments:0
>      /sys/block/dm-16/queue/max_sectors_kb:256
>      /sys/block/dm-16/queue/max_segments:64
>      /sys/block/dm-16/queue/max_segment_size:4096

[please don't top-post]

The above examples are hard to parse due to premature line wrapping.

Would appreciate seeing the IO stack in terms of:
dmsetup ls --tree -o blkdevname
dmsetup table

Feel free to trucate the output of both commands to just show one entire
example of the IO stack in question.

thanks,
Mike
