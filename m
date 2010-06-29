From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 1/2 v3] dm: discard support for the linear
	target
Date: Tue, 29 Jun 2010 01:33:25 -0400
Message-ID: <20100629053324.GA16193@redhat.com>
References: <1277584285-13774-1-git-send-email-snitzer@redhat.com>
	<20100629052546.GA15852@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20100629052546.GA15852@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

On Tue, Jun 29 2010 at  1:25am -0400,
Mike Snitzer <snitzer@redhat.com> wrote:

> Allow discards to be passed through to a single device linear mapping.
> Introduce DM_TARGET_SUPPORTS_DISCARDS target features flag that each
> target must set once discard support is added.
> 
> Verify table's underlying devices support discards prior to setting the
> associated DM device as capable of discards (via QUEUE_FLAG_DISCARD).
> 
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>

I mistakenly dropped Joe's Reviewed-by after making agk's suggested
(minor) changes for v3:
- invert if..else logic in __clone_and_map_discard
- remove unnecessary uninitialized_var() in dm_table_supports_discards

Reviewed-by: Joe Thornber <thornber@redhat.com>
