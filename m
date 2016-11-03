From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm mpath: remove unusable kmultipathd work queue
Date: Thu, 3 Nov 2016 10:48:26 -0400
Message-ID: <20161103144826.GA21719@redhat.com>
References: <1478168994-9376-1-git-send-email-tang.junhui@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1478168994-9376-1-git-send-email-tang.junhui@zte.com.cn>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: tang.junhui@zte.com.cn
Cc: zhang.kai16@zte.com.cn, dm-devel@redhat.com, agk@redhat.com
List-Id: dm-devel.ids

On Thu, Nov 03 2016 at  6:29am -0400,
tang.junhui@zte.com.cn <tang.junhui@zte.com.cn> wrote:

> From: "tang.junhui" <tang.junhui@zte.com.cn>
> 
> kmultipathd work queue is used to process queued IOs for multipath
> target when IOs need to retry, but now these IOs have been requeued
> to block queue of DM device, hence this work queue is not useful
> anymore, and this patch deletes it.
> 
> Signed-off-by: tang.junhui <tang.junhui@zte.com.cn>

Nack, you must be looking at older code.  bio-based DM multipath makes
use of kmultipathd.

When suggesting changes please always make sure you're working with the
latest upstream Linux code.
