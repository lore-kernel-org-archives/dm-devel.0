From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 0/4] dm-writecache patches
Date: Wed, 30 May 2018 09:23:11 -0400
Message-ID: <20180530132311.GA5157@redhat.com>
References: <20180530131654.271798747@debian.vm>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20180530131654.271798747@debian.vm>
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
Cc: Dan Williams <dan.j.williams@intel.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Wed, May 30 2018 at  9:16am -0400,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> Here I'm sending the current dm-writecache patch.
> The per-architecture switch was removed.
> 
> Some reported bugs are fixed.

I've staged dm-writecache in linux-dm.git's dm-4.18 branch.  Please
rebase ontop of that.

In particular, as I said in an earlier email, I'd really appreciate an
incremental patch that removes the per-architecture flushing.

Thanks,
Mike
