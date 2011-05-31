From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 3/3] block: Move discard and secure discard flags to queue limits
Date: Mon, 30 May 2011 22:22:37 -0400
Message-ID: <yq1fwnvzk0i.fsf@sermon.lab.mkp.net>
References: <4DDEA689.2090004@fusionio.com>
	<1306464169-4291-1-git-send-email-martin.petersen@oracle.com>
	<1306464169-4291-4-git-send-email-martin.petersen@oracle.com>
	<20110527133952.GC17219@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110527133952.GC17219@redhat.com> (Mike Snitzer's message of
	"Fri, 27 May 2011 09:39:52 -0400")
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, jaxboe@fusionio.com, msb@chromium.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

>>>>> "Mike" == Mike Snitzer <snitzer@redhat.com> writes:

Mike> Most targets do support discards (tgt->num_discard_requests > 0).
Mike> But if any target doesn't support discards then the entire table
Mike> doesn't support them.

Would you rather have the stacking policy for discard be | instead of &?

-- 
Martin K. Petersen	Oracle Linux Engineering
