From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2] block: disallow changing max_sectors_kb on a request stacking device
Date: Tue, 08 Nov 2016 16:10:02 -0500
Message-ID: <yq1wpgdsmol.fsf@sermon.lab.mkp.net>
References: <20161028194549.14556-1-snitzer@redhat.com>
        <20161107164029.GA27464@redhat.com>
        <20161107192646.GA11572@redhat.com>
        <8d0f16fe-7293-3b1c-1c60-32a50c77fa89@kernel.dk>
        <20161107212732.GA28478@redhat.com>
        <yq1zilau1rz.fsf@sermon.lab.mkp.net>
        <20161108033457.GA30325@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20161108033457.GA30325@redhat.com> (Mike Snitzer's message of
        "Mon, 7 Nov 2016 22:34:57 -0500")
Sender: linux-block-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

>>>>> "Mike" == Mike Snitzer <snitzer@redhat.com> writes:

Mike,

>> However, doesn't it make more sense to tweak limits on DM device
>> instead of the underlying ones? It seems a bit counter-intuitive to
>> me to change max_sectors_kb on a different device than the one where
>> the filesystem whose max I/O size you want to change is located.

Mike> As you know, the limits are stacked from the bottom-up.

Yep, but since max_sectors_kb is a performance tunable and not something
enforced by the hardware, maybe we should consider treating it
differently?

Mike> As the commit header from this thread mentioned, what I've arrived
Mike> at is to have multipathd establish a desired max_sectors_kb (if
Mike> configured to do so in multipath.conf) on the underlying paths
Mike> _before_ the multipath device is created.  Yet to check with Ben
Mike> Marzinski or others but it seems like a reasonable feature (and
Mike> really the cleaniset way to deal with this issue IMHO.. no need
Mike> for lots of kernel code changes for something so niche).

That's fine. Another option would be to use the max_dev_sectors queue
limit to contain the minimum max_sectors from below. It was really only
envisioned as a LLD limit but it may be useful in this case.
queue_max_sectors_store() already enforces it.

-- 
Martin K. Petersen	Oracle Linux Engineering
