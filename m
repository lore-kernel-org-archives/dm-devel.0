From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 1/2] dm-multipath: cleanup IO queueing after
 table load
Date: Wed, 13 Aug 2014 22:46:15 -0400
Message-ID: <CAMM=eLdBqT9ob=-yRkguXwf6V3O9iLUJX1BJYaiJ6zhthVydhw@mail.gmail.com>
References: <1407956023-32372-1-git-send-email-bmarzins@redhat.com>
	<1407956023-32372-2-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1407956023-32372-2-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Junichi Nomura <j-nomura@ce.jp.nec.com>
List-Id: dm-devel.ids

On Wed, Aug 13, 2014 at 2:53 PM, Benjamin Marzinski <bmarzins@redhat.com> wrote:
> Commit e809917735ebf1b9a56c24e877ce0d320baee2ec changed the code in
> multipath_busy that checked if a multipath device was initializing a path.
> It returned busy if queue_io was set on the device. However queue_io is set
> when the table is loaded, and as long as the device was busy, multipath_map
> wouldn't run to clear it upon receiving requsts. multipath_ioctl and
> reinstate_path were still able to clear queue_io. But if no paths were
> reinstated and the multipath device received no ioctls after the table
> reload, all requests to it would simply queue.
>
> This patch switches the multipath_busy code to check for a pending or in
> progress path initialization, without using queue_io.  This means incoming
> requests will allow multipath_map to initialize paths and clear queue_io.

This was already addressed with commit 7a7a3b45fe ("dm mpath: fix IO
hang due to logic bug in multipath_busy").

> This patch also changes __choose_pgpath to make it clear queue_io if there
> are no valid paths, since there are obviously no paths that can be
> initialized.

Can you elaborate on why this is needed?  If it still is then it needs
to be rebased.
