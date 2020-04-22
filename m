From: Martin Wilck <mwilck@suse.com>
Subject: Re: 'multipath add path' returns ok but the path is
 missing in the topology
Date: Wed, 22 Apr 2020 17:40:24 +0200
Message-ID: <3dbafeb000d558af21db70816130573106b56a9c.camel@suse.com>
References: <CAJX1YtZiGXdZTrGtw8ksP3khRf26jQ7dhBWoEJcGfQQZMGb-gg@mail.gmail.com>
	<086d3e2baae71658539ac7caf634336ea0927c04.camel@suse.com>
	<CAJX1YtaKhjLNN56rvwAXh7tOP1Egbo1izmFn3OUEhD4c489E1w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAJX1YtaKhjLNN56rvwAXh7tOP1Egbo1izmFn3OUEhD4c489E1w@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Gioh Kim <gi-oh.kim@cloud.ionos.com>
Cc: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>, Jinpu, dm-devel@redhat.com, Wang <jinpu.wang@cloud.ionos.com>
List-Id: dm-devel.ids

On Wed, 2020-04-22 at 16:00 +0200, Gioh Kim wrote:
> 
> One question.
> Is it possible for multipathd to generate an event for removing a
> map?
> I am looking into the source code, ev_add_path and some functions
> related to add a path,
> but it looks like it does not generate any event.

I guess you mean an uevent. These events are created by the kernel when
multipath creates or reloads maps. multipathd normally doesn't trigger
the events directly.  But there are some cases where multipathd
basically runs the equivalent of "udevadm trigger -c change" on either
maps or paths. Search the code for "trigger" for details.

There are also device mapper events which are created by the kernel for
certain state changes of dm devices. Again, multipathd only receives
such events.

Regards
Martin
