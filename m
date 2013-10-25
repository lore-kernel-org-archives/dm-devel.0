From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH 09/24] dm cache metadata: check the
	metadata	version when reading the superblock
Date: Fri, 25 Oct 2013 18:07:11 +0100
Message-ID: <20131025170711.GI17070@agk-dp.fab.redhat.com>
References: <1382639437-27007-1-git-send-email-snitzer@redhat.com>
	<1382639437-27007-10-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1382639437-27007-10-git-send-email-snitzer@redhat.com>
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
Cc: Morgan Mears <morgan.mears@netapp.com>, Heinz Mauelshagen <heinzm@redhat.com>, dm-devel@redhat.com, Joe Thornber <ejt@redhat.com>
List-Id: dm-devel.ids

On Thu, Oct 24, 2013 at 02:30:22PM -0400, Mike Snitzer wrote:
> From: Joe Thornber <ejt@redhat.com>

> +++ b/drivers/md/dm-cache-metadata.c
> @@ -20,7 +20,13 @@

> + * defines a range of metadata versions that this module can handle.

> +{
> +	uint32_t metadata_version = le32_to_cpu(disk_super->version);

+

> +	if (metadata_version < MIN_CACHE_VERSION || metadata_version > MAX_CACHE_VERSION) {
> +		DMERR("kernel does not support this version of cache metadata (%u)",
> +		      metadata_version);

- Also state the range supported?
   "Cache metadata version %u found, but only versions between %u and %u supported."

Alasdair
