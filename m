From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm mpath: integrity errors should not cause failover
Date: Mon, 28 Mar 2011 15:48:32 -0400
Message-ID: <20110328194831.GA29351@redhat.com>
References: <1301341030-28997-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1301341030-28997-1-git-send-email-snitzer@redhat.com>
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
Cc: James Bottomley <James.Bottomley@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: dm-devel.ids

On Mon, Mar 28 2011 at  3:37pm -0400,
Mike Snitzer <snitzer@redhat.com> wrote:

> From: "Martin K. Petersen" <martin.petersen@oracle.com>
> 
> Integrity errors need to be passed to the owner of the integrity
> metadata for processing. Consequently EILSEQ should be passed up the
> stack.
> 
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> ---
>  drivers/md/dm-mpath.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> [resubmitting to dm-devel to get this in through the DM tree, next
> merge window, now that this change missed the 2.6.39 merge window]

Though this change could easily be considered a fix (for those lucky
enough to even have a DIF/DIX capable mpath configuration)...

Anyway, please consider it on the DM queue.
