From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v2] dm table: simplify discard support
	processing
Date: Mon, 18 Jul 2011 11:10:56 -0400
Message-ID: <20110718151055.GA7744@redhat.com>
References: <20110714143037.GA12049@redhat.com>
	<20110714175647.GA31051@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20110714175647.GA31051@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: agk@redhat.com, dm-devel@redhat.com
Cc: Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

Updated patch header to also point out the fix:

Remove 'discards_supported' from the dm_table structure.  The same
information can be easily discovered from the table's target(s) in
dm_table_supports_discards().

This change fixes an issue with per-target 'discards_supported' being
ineffective, at insuring the final DM device advertises discard support,
due to a different target not having 'num_discard_requests' > 0 -- this
resulted in the overall table's 'discards_supported' being set to 0.

Also DMWARN if a target sets 'discards_supported' override but forgets
to set 'num_discard_requests'.
