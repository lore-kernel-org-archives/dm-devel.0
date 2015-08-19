From: "Bryn M. Reeves" <bmr@redhat.com>
Subject: Re: [PATCH] dm-statistics: report precise timestamps and
	histogram
Date: Wed, 19 Aug 2015 09:43:55 +0100
Message-ID: <20150819084354.GA7891@bmr.fab.redhat.com>
References: <alpine.LRH.2.02.1508181618100.19666@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1508181618100.19666@file01.intranet.prod.int.rdu2.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Mike Snitzer <msnitzer@redhat.com>, Bryn Reeves <breeves@redhat.com>, dm-devel@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

On Tue, Aug 18, 2015 at 04:26:16PM -0400, Mikulas Patocka wrote:
> If the user selected precise timestamps or histogram, report it in the
> output of the @stats_list message.
> 
> If the user didn't select these options, no extra tokens are reported,
> thus it is backward compatible with old software that doesn't know about
> precise timestamps and histogram.

It's not strictly backwards compatible in that someone mixing old and
new code could have a situation where "old" dm-stats parsing code could
see entries in list output created using "new" features.

This would only affect users not implementing program_id filtering (or
using it in broken ways) though so it's probably insignificant enough to
be ignored.

Regards,
Bryn.
