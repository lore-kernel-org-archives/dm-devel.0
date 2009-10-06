From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 1/4] dm-snapshot-rework-origin-write
Date: Tue, 6 Oct 2009 10:17:10 -0400
Message-ID: <20091006141710.GA19024@redhat.com>
References: <1254769231-12053-1-git-send-email-snitzer@redhat.com>
	<1254769231-12053-2-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1254769231-12053-2-git-send-email-snitzer@redhat.com>
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

On Mon, Oct 05 2009 at  3:00pm -0400,
Mike Snitzer <snitzer@redhat.com> wrote:

> From: Mikulas Patocka <mpatocka@redhat.com>
> 
> Rework writing to snapshot origin.
> 
> The previous code selected one exception as "primary_pe", linked all other
> exceptions on it and used reference counting to wait until all exceptions are
> reallocated. This didn't work with exceptions with different chunk sizes:
> https://bugzilla.redhat.com/show_bug.cgi?id=182659
> 
> I removed all the complexity with exceptions linking and reference counting.
> Currently, bio is linked on one exception and when that exception is
> reallocated, the bio is retried to possibly wait for other exceptions.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>

FYI, I added my "Signed-off-by" because I had to update this patch to
account for changes from these upstream linux-2.6 commits:

2913808e (dm snapshot: refactor __find_pending_exception)
c6621392 (dm snapshot: avoid dropping lock in __find_pending_exception)
0cea9c78 (dm exception store: move dm_target pointer)
