From: Martin Wilck <mwilck@suse.com>
Subject: Re: 'multipath add path' returns ok but the path is
 missing in the topology
Date: Thu, 23 Apr 2020 15:58:51 +0200
Message-ID: <afac68664b44a28203325fed2fee7d8c0d9ae750.camel@suse.com>
References: <CAJX1YtZiGXdZTrGtw8ksP3khRf26jQ7dhBWoEJcGfQQZMGb-gg@mail.gmail.com>
	<086d3e2baae71658539ac7caf634336ea0927c04.camel@suse.com>
	<CAJX1YtaKhjLNN56rvwAXh7tOP1Egbo1izmFn3OUEhD4c489E1w@mail.gmail.com>
	<3dbafeb000d558af21db70816130573106b56a9c.camel@suse.com>
	<CAJX1YtYw+aJ5xXjZKoksF9gh3aaJoQRiqAkjUigc5R0-bFPb1w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAJX1YtYw+aJ5xXjZKoksF9gh3aaJoQRiqAkjUigc5R0-bFPb1w@mail.gmail.com>
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

On Thu, 2020-04-23 at 13:50 +0200, Gioh Kim wrote:
> Hi Martin,
> 
> On Wed, Apr 22, 2020 at 5:40 PM Martin Wilck <mwilck@suse.com> wrote:
> > On Wed, 2020-04-22 at 16:00 +0200, Gioh Kim wrote:
> > > One question.
> > > Is it possible for multipathd to generate an event for removing a
> > > map?
> > > I am looking into the source code, ev_add_path and some functions
> > > related to add a path,
> > > but it looks like it does not generate any event.
> > 
> > I guess you mean an uevent. These events are created by the kernel
> > when
> > multipath creates or reloads maps. multipathd normally doesn't
> > trigger
> > the events directly.  But there are some cases where multipathd
> > basically runs the equivalent of "udevadm trigger -c change" on
> > either
> > maps or paths. Search the code for "trigger" for details.
> > 
> > There are also device mapper events which are created by the kernel
> > for
> > certain state changes of dm devices. Again, multipathd only
> > receives
> > such events.
> > 
> > Regards
> > Martin
> > 
> > 
> > 
> 
> I am making an environment to capture log for uevent as you said.
> 
> Meanwhile I found something weird: "orphan path, waiting for create
> to
> complete" what is this message?
> I guess the second added path was not registered when I executed
> "multipathd add path" at this moment.

True. "orphan" means that you added a path that didn't belong to a map.

Again, your multipathd seems to be configured such that maps aren't
created automatically ("find_multipaths strict"). I'm not sure whether
that makes a lot of sense in your setup, the way you describe it.
With "find_multipaths smart" or "find_multipaths greedy", your new maps
would be added without admin intervention.

> 
> I guess there would be some time delay for the second path to be
> included in the topology.
> Am I right?
> If I am right, could I make "multipathd add path" return only after
> everything is completely finished?

What is "everything"? how would multipathd know that you intend to add
another path? As I said previousl, you'd probably be better off using
"multipath -a $WWID", which would add the new WWID to the WWIDs file,
which controls multipathd's operation in "find_multipaths strict" mode.

> Apr 23 11:38:25 ib1 multipathd[2132]: sdc: open node: /dev/sdc
> Apr 23 11:38:25 ib1 multipathd[2132]: sdc: domap with mpp->action=6
> Apr 23 11:38:25 ib1 multipathd[2132]:
> 360000000000000000000000000000000: load table [0 204800 multipath 1

This WWID looks very fishy to me. Especially when you add or remove
paths dynamically, be sure to use unique WWIDs.

Regards
Martin
