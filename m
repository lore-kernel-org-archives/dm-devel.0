From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH 2/2] dm thin: elevate the bio_prison
	and	deferred_set code to allow for re-use
Date: Sat, 3 Mar 2012 00:26:40 +0000
Message-ID: <20120303002640.GF1328@agk-dp.fab.redhat.com>
References: <1330732770-18621-1-git-send-email-snitzer@redhat.com>
	<1330732770-18621-2-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1330732770-18621-2-git-send-email-snitzer@redhat.com>
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
Cc: dm-devel@redhat.com, ejt@redhat.com
List-Id: dm-devel.ids

On Fri, Mar 02, 2012 at 06:59:30PM -0500, Mike Snitzer wrote:
> +EXPORT_SYMBOL(prison_create);

_GPL please and place a dm_something prefix on everything exported.

Thanks,
Alasdair
