From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [dm-devel] [PATCH] block: do not return -EOPNOTSUPP only when issue a discard request
Date: Wed, 03 Feb 2016 17:00:56 -0500
Message-ID: <yq1egctlahz.fsf@sermon.lab.mkp.net>
References: <56B1CE5C.10201@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <56B1CE5C.10201@huawei.com> (jiangyiwen@huawei.com's message of
	"Wed, 3 Feb 2016 17:54:36 +0800")
Sender: linux-kernel-owner@vger.kernel.org
To: jiangyiwen <jiangyiwen@huawei.com>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, dm-devel@redhat.com, martin.petersen@oracle.com, =?utf-8?B?THVr?= =?utf-8?B?w6HFoQ==?= Czerner <lczerner@redhat.com>, xuejiufei@huawei.com, "Qijiang (Joseph, Euler)" <joseph.qi@huawei.com>
List-Id: dm-devel.ids

>>>>> "Yiwen" == jiangyiwen  <jiangyiwen@huawei.com> writes:

Yiwen> commit 8af1954d172a("blkdev: Do not return -EOPNOTSUPP if discard
Yiwen> is supported") only solve the situation of discard, because When
Yiwen> applications issue a discard request to device, they can't expect
Yiwen> deterministic behaviour. However, WRITE SAME should not ignore
Yiwen> error with EOPNOTSUPP, because if applications issue WRITE SAME
Yiwen> requests to device, it should return deterministic results to
Yiwen> applications according to the T10 standard, or else it will cause
Yiwen> an inconsistent state between upper layer and bottom layer.

Yiwen> So ignoring error with EOPNOTSUPP only in discard situation.

If an underlying device fails a WRITE SAME request, SCSI will not return
EOPNOTSUPP. Instead we will mark 0 bytes of the request as complete and
disable WRITE SAME support on the device. So any EOPNOTSUPP error in
this case would be coming from MD/DM.

That said, I agree with the patch.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
