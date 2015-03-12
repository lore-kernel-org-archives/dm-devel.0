From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1/7 v2] blk-mq: fix use of incorrect goto
 label in blk_mq_init_queue error path
Date: Thu, 12 Mar 2015 13:13:33 -0400
Message-ID: <5501C93D.2070806@suse.de>
References: <1426132602-34331-1-git-send-email-snitzer@redhat.com>	<1426132602-34331-2-git-send-email-snitzer@redhat.com>
	<20150312142730.GA3159@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20150312142730.GA3159@redhat.com>
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

On 03/12/2015 10:27 AM, Mike Snitzer wrote:
> If percpu_ref_init() fails the 'err_hctxs' label should be used instead
> of 'err_map'.
> =

> Rather than reuse 'err_hw', which was introduced if the later
> blk_mq_init_hw_queues() call fails, move percpu_ref_init() before
> blk_alloc_queue_node().
> =

> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> Reviewed-by: Ming Lei <ming.lei@canonical.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
