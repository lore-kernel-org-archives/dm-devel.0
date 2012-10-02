From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v3 04/26] block: Refactor blk_update_request()
Date: Tue, 2 Oct 2012 14:59:55 -0400
Message-ID: <20121002185955.GD3283@redhat.com>
References: <1348526106-17074-1-git-send-email-koverstreet@google.com>
	<1348526106-17074-5-git-send-email-koverstreet@google.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1348526106-17074-5-git-send-email-koverstreet@google.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Kent Overstreet <koverstreet@google.com>
Cc: tj@kernel.org, axboe@kernel.dk, linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On Mon, Sep 24, 2012 at 03:34:44PM -0700, Kent Overstreet wrote:
> Converts it to use bio_advance(), simplifying it quite a bit in the
> process.
> 
> Note that req_bio_endio() now always calls bio_advance() - which means
> it always loops over the biovec, not just on partial completions. Don't
> expect it to affect performance, but worth noting.
> 
> Tested it by forcing partial updates, and dumping before and after on
> various bio/bvec fields when doing a partial update.

Kent,

In general, have you tested all these changes with FLUSH and DISCARD 
bios/requests. Some of the code paths tend to break down because of these
special bios don't have payload.

Thanks
Vivek
