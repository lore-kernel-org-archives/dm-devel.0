From: urgrue <urgrue@bulbous.org>
Subject: Revisited: SAN failover question
Date: Tue, 19 Jun 2012 11:16:59 +0300
Message-ID: <1340093819.16650.140661091085853.37B36B66@webmail.messagingengine.com>
References: <4DBDCA1D.3070500@bulbous.org> <1304286007.11965.19.camel@zezette>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1304286007.11965.19.camel@zezette>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: christophe.varoqui@opensvc.com, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hello,

I'm testing something very unconventional with multipath that I posted
about a year ago (quoted below). I've got synchronously replicated SAN,
and my hosts see both the online disks (sda+sdb=mpatha) and the offline
disks (sdc+sdd=mpathb). The offline disks are not readable, so as far as
multipath is concerned they are failed paths. What I'm doing is lumping
all these into one mpath device.

My disks have serials like "<site id><disk serial>". Replicated disks
always have the same serial, while the site id varies depending on the
datacenter and storage filer used.
So my getuid_callout is the usual scsi_id piped through sed to replace
all site id's with a common string like: s/^......../00000000/.
Result: multipath configures sda+sdb+sdc+sdd=mpatha, which has two
active paths (sda+sdb) and two failed paths (the replicas, sdc+sdd).
I'm not load balancing or anything, so it's just a simple failover.

We very regularly switch the direction of the replication on our SAN as
a DR test, and when that happens: the online paths fail, and shortly
afterwards (seconds), the replica comes online, and multipath activates
those paths.

Basically what I'm seeing in my tests is that we can failover the SAN
completely transparently. I've had databases churning stuff, all sorts
of I/O going on, while the failover happens and they all resume happily
(if they paused at all) without a single error once the disks come back.
The time for the SAN to failover (on the storage side) has varied from 2
seconds to a few minutes.

I do expect things to start breaking if the outage is longer, but that's
not really an issue (it means extended downtime anyway). 

Red Hat has said they don't see any immediate problems with this but
that it's up to me to support, which is understandable.

I would be interested to hear any thoughts and comments.

-urgrue


On Sun, May 1, 2011, at 23:40, Christophe Varoqui wrote:
> On dim., 2011-05-01 at 23:01 +0200, urgrue wrote:
> > I've tried all around to find a good solution for my conundrum, without 
> > much luck.
> > 
> > The point is, multipath works nice. Until a bigger disaster comes along, 
> > e.g. san or datacenter failure. Of course like most big environments you 
> > have a synchronous replica of your SAN. But you have to "do stuff" to 
> > get Linux to take that new LUN and get back to work. A reboot, or san 
> > rescans, forcibly removing disks and so forth. It's not very pretty.
> > 
> > So my question is, is there any way to get multipath to treat both the 
> > active lun and it's passive replica (usually in readonly or offline 
> > state) as one and the same disk? The goal being, if your SAN fails, you 
> > merely have to activate your DR replica, and multipath would pick it up 
> > and all's well (except for the 30 sec to a few mins of I/O hanging until 
> > the DR was online). In essence, you'd have four paths to a LUN - 2 to 
> > the active one, 2 to the passive one, which is a different LUN 
> > technically speaking (different serials, WWNs, etc), but an identical 
> > synchronous replica (identical data, identical state, identical PVID, etc).
> > 
> You would have to :
> 
> 1/ setup a customized getuid program instead of the default scsi_id.
> (may be based on the pairing id if there is such thing in your context)
> 
> 2/ set the 'group_by_prio' path grouping policy
> 
> 3/ develop a prioritizer shared object to assign path priorities based
> on the master/slave role of the logical unit. Paths to master get prio
> 2, paths to slave get prio 1.
> 
> May be someone else can comment on the specific ro->rw promotion issue
> upon path_group switching. I can't tell if it needs a hw_handler these
> days.
> 
> -- 
> Christophe Varoqui
> OpenSVC - Tools to scale
> http://www.opensvc.com/
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
