From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] Add gfp_mask to bio_integrity_clone()
Date: Fri, 31 Oct 2008 10:16:47 -0400
Message-ID: <yq1hc6s3l4g.fsf@sermon.lab.mkp.net>
References: <490942D4.3070504@ce.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <490942D4.3070504@ce.jp.nec.com> (Jun'ichi Nomura's message of
	"Thu\, 30 Oct 2008 14\:15\:00 +0900")
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, Alasdair G Kergon <agk@redhat.com>, linux-kernel@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <jens.axboe@oracle.com>
List-Id: dm-devel.ids

>>>>> "Jun'ichi" == Jun'ichi Nomura <j-nomura@ce.jp.nec.com> writes:

Jun'ichi> What do you think about adding gfp_mask parameter to
Jun'ichi> bio_integrity_clone() like the attached patch?

Jun'ichi> It also seems natural to inherit gfp_mask from bio_clone
Jun'ichi> when bio_integrity_clone is called from it.  Since
Jun'ichi> bio_clone() is the only caller of bio_integrity_clone() in
Jun'ichi> 2.6.28-rc2 and all in-tree callers of bio_clone() are using
Jun'ichi> GFP_NOIO, the patch does nothing other than changing the
Jun'ichi> interface.

Looks good to me.  I'll update the non-multipath DM bits accordingly.

Acked-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
