From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2] block: disallow changing max_sectors_kb on a request stacking device
Date: Mon, 07 Nov 2016 21:46:24 -0500
Message-ID: <yq1zilau1rz.fsf@sermon.lab.mkp.net>
References: <20161028194549.14556-1-snitzer@redhat.com>
        <20161107164029.GA27464@redhat.com>
        <20161107192646.GA11572@redhat.com>
        <8d0f16fe-7293-3b1c-1c60-32a50c77fa89@kernel.dk>
        <20161107212732.GA28478@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20161107212732.GA28478@redhat.com> (Mike Snitzer's message of
        "Mon, 7 Nov 2016 16:27:34 -0500")
Sender: linux-block-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, dm-devel@redhat.com, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: dm-devel.ids

>>>>> "Mike" == Mike Snitzer <snitzer@redhat.com> writes:

Mike,

Mike> You're suggesting that when the DM multipath device's limits are
Mike> stacked up from the underlying devices: cap the mpath's
Mike> max_hw_sectors to the underlying devices' max_sectors?

That will break SG_IO, firmware upgrades, etc. (things you probably
shouldn't do on the MP device in the first place but which users often
do).

However, doesn't it make more sense to tweak limits on DM device instead
of the underlying ones? It seems a bit counter-intuitive to me to change
max_sectors_kb on a different device than the one where the filesystem
whose max I/O size you want to change is located.

I guess this brings us back to the desire to be able to restack the
limits at will when something changes somewhere...

-- 
Martin K. Petersen	Oracle Linux Engineering
