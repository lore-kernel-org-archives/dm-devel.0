From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] dm mpath: remove unusable kmultipathd work
 queue
Date: Thu, 3 Nov 2016 13:44:48 +0100
Message-ID: <5339a165-9c9d-5fd1-22ae-1abae2ea6dec@suse.de>
References: <1478168994-9376-1-git-send-email-tang.junhui@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; Format="flowed"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

On 11/03/2016 11:29 AM, tang.junhui@zte.com.cn wrote:
> From: "tang.junhui" <tang.junhui@zte.com.cn>
>
> kmultipathd work queue is used to process queued IOs for multipath
> target when IOs need to retry, but now these IOs have been requeued
> to block queue of DM device, hence this work queue is not useful
> anymore, and this patch deletes it.
>
> Signed-off-by: tang.junhui <tang.junhui@zte.com.cn>
> ---
>  drivers/md/dm-mpath.c | 13 +------------
>  1 file changed, 1 insertion(+), 12 deletions(-)
>
Good point.

Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
