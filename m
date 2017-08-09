From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: integrity regression fixes for 4.13-rc
Date: Wed, 09 Aug 2017 12:21:50 -0400
Message-ID: <yq1d18467a9.fsf@oracle.com>
References: <20170809154727.2085-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170809154727.2085-1-hch@lst.de> (Christoph Hellwig's message
        of "Wed, 9 Aug 2017 17:47:25 +0200")
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: axboe@kernel.dk, mpatocka@redhat.com, gmazyland@gmail.com, martin.petersen@oracle.com, linux-block@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids


Christoph,

> this series fixes regressions in the integrity handling update in
> 4.13-rc.
>
> The first one was sent earlier by Milan and while both Martin and I
> aren't exactly happy about the way dm uses the integrity code to cause
> this regression this minimal fix gets us back to the status quo.
>
> The second one makes sure that we only verify the DIF checksums on the
> lowest layer where we attach the integrity information.

These look OK to me.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
