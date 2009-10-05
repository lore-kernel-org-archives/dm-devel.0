From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 02/12] dm-exception-store-merge-accounting
Date: Mon, 5 Oct 2009 15:53:42 -0400
Message-ID: <20091005195342.GB5796@redhat.com>
References: <1254769367-12111-1-git-send-email-snitzer@redhat.com>
	<1254769367-12111-3-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1254769367-12111-3-git-send-email-snitzer@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

On Mon, Oct 05 2009 at  3:02pm -0400,
Mike Snitzer <snitzer@redhat.com> wrote:

> From: Mikulas Patocka <mpatocka@redhat.com>
> 
> Conditionally adjust snapshot usage accounting if snapshot-merge is in
> progress.  Care is taken to preserve the established kernel<->userspace
> interface.
> 
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> Cc: Mikulas Patocka <mpatocka@redhat.com>

I messed up on this patch header (the "From:" above).  Mikulas didn't
write this version (which maintains kernel<->userspace compatibility);
but the overall structure is directly from Mikulas' earlier version of
the patch.

Mike
