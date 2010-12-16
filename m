From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH for-2.6.37] block: max hardware sectors limit
	wrapper
Date: Thu, 16 Dec 2010 18:49:18 -0500
Message-ID: <yq1wrn92s8x.fsf@sermon.lab.mkp.net>
References: <20101206184346.GA13582@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <stable-bounces@linux.kernel.org>
In-Reply-To: <20101206184346.GA13582@redhat.com> (Mike Snitzer's message of
	"Mon, 6 Dec 2010 13:43:46 -0500")
List-Unsubscribe: <http://linux.kernel.org/mailman/options/stable>,
	<mailto:stable-request@linux.kernel.org?subject=unsubscribe>
List-Archive: <http://linux.kernel.org/mailman/private/stable/>
List-Post: <mailto:stable@linux.kernel.org>
List-Help: <mailto:stable-request@linux.kernel.org?subject=help>
List-Subscribe: <http://linux.kernel.org/mailman/listinfo/stable>,
	<mailto:stable-request@linux.kernel.org?subject=subscribe>
Sender: stable-bounces@linux.kernel.org
Errors-To: stable-bounces@linux.kernel.org
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Mike Snitzer <snitzer@redhat.com>, linux-kernel@vger.kernel.org, device-mapper development <dm-devel@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, Lars Ellenberg <lars.ellenberg@linbit.com>, stable@kernel.org, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

>>>>> "Mike" == Mike Snitzer <snitzer@redhat.com> writes:

Mike> Implement blk_limits_max_hw_sectors() and make
Mike> blk_queue_max_hw_sectors() a wrapper around it.

Mike> DM needs this to avoid setting queue_limits' max_hw_sectors and
Mike> max_sectors directly.  dm_set_device_limits() now leverages
Mike> blk_limits_max_hw_sectors() logic to establish the appropriate
Mike> max_hw_sectors minimum (PAGE_SIZE).  Fixes issue where DM was
Mike> incorrectly setting max_sectors rather than max_hw_sectors (which
Mike> caused dm_merge_bvec()'s max_hw_sectors check to be ineffective).

Acked-by: Martin K. Petersen <martin.petersen@oracle.com>

Jens, please apply.

-- 
Martin K. Petersen	Oracle Linux Engineering
