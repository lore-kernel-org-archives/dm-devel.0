From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 3/5] dm: relax ordering of bio-based flush
	implementation
Date: Wed, 01 Sep 2010 15:56:57 +0200
Message-ID: <4C7E5BA9.7020509@kernel.org>
References: <1283162296-13650-1-git-send-email-tj@kernel.org>
	<1283162296-13650-4-git-send-email-tj@kernel.org>
	<20100901135120.GA25251@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20100901135120.GA25251@redhat.com>
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
Cc: k-ueda@ct.jp.nec.com, jaxboe@fusionio.com, jamie@shareable.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org, dm-devel@redhat.com, j-nomura@ce.jp.nec.com, hch@lst.de
List-Id: dm-devel.ids

On 09/01/2010 03:51 PM, Mike Snitzer wrote:
> Could you please document why it is OK to remove 'flush_error' in the
> patch header?  The -EOPNOTSUPP handling removal (done in patch 2)
> obviously helps enable this but it is not clear how the
> 'num_flush_requests' flushes that __clone_and_map_flush() generates do
> not need explicit DM error handling.

Sure, I'll.  It's because it now uses the same error handling path in
dec_pending() all other bio's use.  The flush_error thing was there
because flushes got executed/completed in a separate code path to
begin with.  With the special path gone, there's no need for
flush_error path either.

Thanks.

-- 
tejun
