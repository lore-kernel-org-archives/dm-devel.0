From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 0/7] dm-mpath: Fix a race condition in the
	blk-mq path
Date: Tue, 15 Nov 2016 19:47:53 -0500
Message-ID: <20161116004752.GD19059@redhat.com>
References: <e83f8718-9e73-5544-3bcc-4d9851b90ba1@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <e83f8718-9e73-5544-3bcc-4d9851b90ba1@sandisk.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Tue, Nov 15 2016 at  6:31pm -0500,
Bart Van Assche <bart.vanassche@sandisk.com> wrote:

> Hello Mike,
> 
> The seven patches in this series is what I came up with while
> reviewing and testing the dm-mpath single queue and multiqueue code.
> It would be appreciated if these patches would be considered for
> inclusion in the upstream kernel.

This series seems like it is not a product of need.  But that of changes
that fell out from code review.

If not, what test was failing that now passes with this patchset?
