From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm cache: require io_mode cache feature selection to
 be mutually exclusive
Date: Wed, 27 Jun 2018 11:27:11 -0400
Message-ID: <20180627152710.GA12017@redhat.com>
References: <1529616933-11644-1-git-send-email-jpittman@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1529616933-11644-1-git-send-email-jpittman@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: John Pittman <jpittman@redhat.com>
Cc: dm-devel@redhat.com, loberman@redhat.com
List-Id: dm-devel.ids

On Thu, Jun 21 2018 at  5:35pm -0400,
John Pittman <jpittman@redhat.com> wrote:

> Due to commit 629d0a8a1a10 ("dm cache metadata: add "metadata2" feature"),
> when creating a dm cache device, more than one io_mode can be selected.
> As the io_mode selections are incompatible with one another, we should 
> force them to be selected exclusively.  Add simple ctr to check for 
> more than one io_mode selection.

I'm missing why you're associating your fix with commit 629d0a8a1a10.

Can you explain what you did to hit a problem that this patch is fixing?
Did you list conflicting modes on the ctr and the last one in the table
line won?

Thanks,
Mike
