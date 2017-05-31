From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 1/2] dm: Make flush bios explicitely sync
Date: Wed, 31 May 2017 10:53:51 -0400
Message-ID: <20170531145350.GA16914@redhat.com>
References: <20170531074433.14298-1-jack@suse.cz>
	<20170531074433.14298-2-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20170531074433.14298-2-jack@suse.cz>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jan Kara <jack@suse.cz>
Cc: dm-devel@redhat.com, Shaohua Li <shli@kernel.org>
List-Id: dm-devel.ids

On Wed, May 31 2017 at  3:44am -0400,
Jan Kara <jack@suse.cz> wrote:

> Commit b685d3d65ac7 "block: treat REQ_FUA and REQ_PREFLUSH as
> synchronous" removed REQ_SYNC flag from WRITE_{FUA|PREFLUSH|...}
> definitions.  generic_make_request_checks() however strips REQ_FUA and
> REQ_PREFLUSH flags from a bio when the storage doesn't report volatile
> write cache and thus write effectively becomes asynchronous which can
> lead to performance regressions
> 
> Fix the problem by making sure all bios which are synchronous are
> properly marked with REQ_SYNC.
> 
> CC: Mike Snitzer <snitzer@redhat.com>
> CC: dm-devel@redhat.com
> Fixes: b685d3d65ac791406e0dfd8779cc9b3707fea5a3
> CC: stable@vger.kernel.org
> Signed-off-by: Jan Kara <jack@suse.cz>

thanks, staged for 4.12-rc4
