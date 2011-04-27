From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH, RFC] dm: relax discard restrictions
Date: Wed, 27 Apr 2011 11:19:11 -0400
Message-ID: <20110427151911.GF7294@redhat.com>
References: <20110427150623.GC13487@infradead.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20110427150623.GC13487@infradead.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christoph Hellwig <hch@infradead.org>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Wed, Apr 27 2011 at 11:06am -0400,
Christoph Hellwig <hch@infradead.org> wrote:

> With targets like dm-thinp we might want to allow discard even if the
> underlying devices don't support them natively.  This patch is the
> extreme variant of not restricting discard support at all, but maybe
> there are other options.  Or maybe we should keep the old
> dm_table_supports_discards function as a helper for targets that
> want simple discard passthrough?

I think we could accomplish the same by adding a target override flag
(e.g. ti->discards_supported) that enables dm_table_supports_discards()
to short-circuit device_discard_capable's native discard checking.

Mike
