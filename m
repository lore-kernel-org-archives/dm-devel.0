From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: rdac priority checker changing priorities
Date: Mon, 04 May 2009 10:30:28 -0700
Message-ID: <1241458228.8721.46.camel@chandra-ubuntu>
References: <9ad205140904291534j4cc1a71aq3b4a0e308f1687bd@mail.gmail.com>
	<49F9443E.7040109@suse.de> <1241114743.11905.13.camel@chandra-ubuntu>
	<49FEC6E6.6070105@suse.de>
Reply-To: sekharan@linux.vnet.ibm.com,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <49FEC6E6.6070105@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: dm-devel <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi Hannes
On Mon, 2009-05-04 at 12:43 +0200, Hannes Reinecke wrote:

<snip>
> > 
> Is this really a valid case?

Yes, Having more than one patch to a (or both) controller(s) is a valid
case.

> This means we'll have a setup like this:
> 
> rdac
>  pg1
>   sda failed
>   sdb failed
>  pg2
>   sdc active
>   sdd active
> 
> Correct?

correct.
> So, given your assumptions, the proposed scenario would be represented

It is not an assumption, it is the behavior I have seen :)
> like this:
> 
> rdac
>  pg1
>   sda active
>   sdb failed
>  pg2
>   sdc active
>   sdd active
> 
> So it is really a good idea to switch paths in this case? The 'sdb'

Yes. We need to switch for two reasons
 - since there is a preferred path available we _should_ use it
   (otherwise it will throw off the load balancing the admin has made
   in the storage).
 - To be consistent with multipath's state before the access to the 
   preferred controller failed. i.e if multipath has configured a dm
   device in this state, multipath _does_ make pg1 the active path 
   group.

> path would not be reachable here, so any path switch command wouldn't
> have been received, either. I'm not sure _what_ is going to happen

Since, both paths are leading to the same controller, mode select sent
for sda would have made sdb also the active controller. But, as you
mentioned it is not seen by dm-multipath.

> when we switch paths now and sdb comes back later; but most likely

The patch I re-submitted last week (Handle multipath paths in a path
group properly during pg_init :
http://marc.info/?l=dm-devel&m=124094710300894&w=2) handles this
situation correctly, by sending an activate during reinstate.

> the entire setup will be messed up then:
>   sda (pref & owned) 6
>   sdb                0
>   sdc (sec)          1
>   sdd (sec & owned)  3

No, this will not be the case. As soon as the access to sdb comes back
it will be seen as pref and owned and hence will get a priority value of
6.

Also, as soon as sda has been made active, sdd will become
passive/ghost, and hence will have the priority value of 1.

> and we'll be getting the path layout thoroughly jumbled then.
> So I don't really like this idea. We should only be switching
> paths when _all_ paths of a path group become available again.
> Providing not all paths have failed in the active group, of course.
> Then we should be switching paths regardless.
> 
Here are the details:

===========================================================
(1) Initial configuration (all are good):
pg1
  sda (pref and active) - 6
  sdb (pref and active) - 6
pg2
  sdc (sec and passive) - 1
  sdd (sec and passive) - 1
------
(2) Access to sdb goes down
------
pg1
  sda (pref and active) - 6
  sdb (not there)       - 0
pg2
  sdc (sec and passive) - 1
  sdd (sec and passive) - 1
------
(3) Access to sda goes down, path group switches
------
pg1
  sda (not there)       - 0
  sdb (not there)       - 0
pg2
  sdc (sec and active)  - 3
  sdd (sec and active)  - 3
------
(4) sda comes back, path group switch _should_ happen here.
    to be consistent with (1). If the path group switch happens, sda
    will have a priority of 6 and sdc/sdd will have priority
    of 1 each (as they will become passive).
    Path switch can happen only if the priority we give for preferred
    path is lot more than the sum of all priorities of all the paths
    in the other path group.
------
pg1
  sda (pref and passive)- 4
  sdb (not there)       - 0
pg2
  sdc (sec and active)  - 3
  sdd (sec and active)  - 3

Hope it is clear now.
> Cheers,
> 
> Hannes
