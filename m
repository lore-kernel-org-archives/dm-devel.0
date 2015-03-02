From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm: impose configurable deadline for dm_request_fn's
 merge heuristic
Date: Mon, 2 Mar 2015 18:26:42 -0500
Message-ID: <20150302232642.GC26740@redhat.com>
References: <20150302163143.GA27120@mwanda>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20150302163143.GA27120@mwanda>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Mon, Mar 02 2015 at 11:31am -0500,
Dan Carpenter <dan.carpenter@oracle.com> wrote:

> Hello Mike Snitzer,
> 
> The patch 6ee47d96b97d: "dm: impose configurable deadline for
> dm_request_fn's merge heuristic" from Feb 26, 2015, leads to the
> following static checker warning:
> 
> 	drivers/md/dm.c:1968 dm_attr_rq_based_queue_deadline_store()
> 	warn: impossible condition '(deadline > ((~0 >> 1))) => (s32min-s32max > s32max)'

Fixed up with latest code, see:
https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=for-next&id=f975bc0d522d1e57b108bf9e2e0293ee3f78f821
