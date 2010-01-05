From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH v2] dm: Fix alignment stacking on	partitioned
	devices
Date: Tue, 5 Jan 2010 18:04:12 +0000
Message-ID: <20100105180412.GB6042@agk-dp.fab.redhat.com>
References: <1261591640-24380-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1261591640-24380-1-git-send-email-snitzer@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: dm-devel.ids

On Wed, Dec 23, 2009 at 01:07:20PM -0500, Mike Snitzer wrote:
> +	sector_t offset = (get_start_sect(bdev) + start) << 9;

Please can you fix the types here?

'offset' is defined as sector_t i.e. number of sectors, so 
shouldn't have '<< 9' which would make it bytes i.e. *not* sector_t.

Alasdair
