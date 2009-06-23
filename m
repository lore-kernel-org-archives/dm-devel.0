From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: rdac priority checker changing priorities
Date: Mon, 22 Jun 2009 17:47:24 -0700
Message-ID: <1245718044.10657.12.camel@chandra-ubuntu>
References: <9ad205140904291534j4cc1a71aq3b4a0e308f1687bd@mail.gmail.com>
	<49F9443E.7040109@suse.de> <1241114743.11905.13.camel@chandra-ubuntu>
	<49FEC6E6.6070105@suse.de>
Reply-To: sekharan@linux.vnet.ibm.com,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-qk1QgWoqRQ3L3Krml6C4"
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


--=-qk1QgWoqRQ3L3Krml6C4
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi Hannes,

Please see the attached file for the real example.

Can I go ahead and generate a patch to increase the priority of the
preferred path to say, 50 ?

chandra
On Mon, 2009-05-04 at 12:43 +0200, Hannes Reinecke wrote:
> Hi Chandra,
> 
> Chandra Seetharaman wrote:
> > Hannes,
> > 
> > I think we need to revisit the priority value we provide for preferred
> > path(4) relative to active path (2) and non-preferred(1).
> > 
> > Consider the following scenario:
> > 
> > Access to a lun thru 2 preferred and 2 non-preferred path. Lets call
> > path group with preferred paths as pg1 and with non-preferred paths as
> > pg2. 
> > 
> > Initially pg1 has priority of 8 and pg2 has priority of 2. pg1 is chosen
> > and I/O goes thru pg1, all good.
> > 
> > Both the paths in pg1 fails, pg2 has been made the active path group and
> > I/O is sent thru that path and since it became "active", its priority
> > raises to 6 ( 2 path times (active + non-preferred)). 
> > 
> > When one of the paths in pg1 comes back, one would expect the failback
> > to happen. It doesn't happen as pg1's priority (4) is smaller than that
> > of pg2 (6). Which is not correct.
> > 
> Is this really a valid case?
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
> So, given your assumptions, the proposed scenario would be represented
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
> path would not be reachable here, so any path switch command wouldn't
> have been received, either. I'm not sure _what_ is going to happen
> when we switch paths now and sdb comes back later; but most likely
> the entire setup will be messed up then:
>   sda (pref & owned) 6
>   sdb                0
>   sdc (sec)          1
>   sdd (sec & owned)  3
> and we'll be getting the path layout thoroughly jumbled then.
> So I don't really like this idea. We should only be switching
> paths when _all_ paths of a path group become available again.
> Providing not all paths have failed in the active group, of course.
> Then we should be switching paths regardless.
> 
> Cheers,
> 
> Hannes

--=-qk1QgWoqRQ3L3Krml6C4
Content-Disposition: attachment; filename=typescript
Content-Type: text/plain; name=typescript; charset=UTF-8
Content-Transfer-Encoding: 7bit

$ multipath -ll 3600a0b800011a1ee00003f834a3f7a65
3600a0b800011a1ee00003f834a3f7a65 dm-0 IBM,1815      FAStT
[size=10G][features=1 queue_if_no_path][hwhandler=1 rdac]
\_ round-robin 0 [prio=12][active]
 \_ 2:0:1:4 sdu 65:64 [active][ready]
 \_ 2:0:0:4 sdp 8:240 [active][ready]
\_ round-robin 0 [prio=2][enabled]
 \_ 1:0:1:4 sdk 8:160 [active][ghost]
 \_ 1:0:0:4 sdf 8:80  [active][ghost]
$ # disabled one preferred path
$ multipath -ll 3600a0b800011a1ee00003f834a3f7a65
sdp: rdac prio: inquiry command indicates error
3600a0b800011a1ee00003f834a3f7a65 dm-0 IBM,1815      FAStT
[size=10G][features=1 queue_if_no_path][hwhandler=1 rdac]
\_ round-robin 0 [prio=6][active]
 \_ 2:0:1:4 sdu 65:64 [active][ready]
 \_ 2:0:0:4 sdp 8:240 [failed][faulty]
\_ round-robin 0 [prio=2][enabled]
 \_ 1:0:1:4 sdk 8:160 [active][ghost]
 \_ 1:0:0:4 sdf 8:80  [active][ghost]
$ # ALL GOOD
$ # disabled another preferred path
$ multipath -ll 3600a0b800011a1ee00003f834a3f7a65
sdu: rdac prio: inquiry command indicates error
sdp: rdac prio: inquiry command indicates error
3600a0b800011a1ee00003f834a3f7a65 dm-0 IBM,1815      FAStT
[size=10G][features=1 queue_if_no_path][hwhandler=1 rdac]
\_ round-robin 0 [prio=0][enabled]
 \_ 2:0:1:4 sdu 65:64 [failed][faulty]
 \_ 2:0:0:4 sdp 8:240 [failed][faulty]
\_ round-robin 0 [prio=6][active]
 \_ 1:0:1:4 sdk 8:160 [active][ready]
 \_ 1:0:0:4 sdf 8:80  [active][ready]
$ # failed over to the non-preferred path
$ # that is good
$ # disabled a non-preferred path
$ multipath -ll 3600a0b800011a1ee00003f834a3f7a65
sdu: rdac prio: inquiry command indicates error
sdp: rdac prio: inquiry command indicates error
sdk: rdac prio: inquiry command indicates error
3600a0b800011a1ee00003f834a3f7a65 dm-0 IBM,1815      FAStT
[size=10G][features=1 queue_if_no_path][hwhandler=1 rdac]
\_ round-robin 0 [prio=0][enabled]
 \_ 2:0:1:4 sdu 65:64 [failed][faulty]
 \_ 2:0:0:4 sdp 8:240 [failed][faulty]
\_ round-robin 0 [prio=3][active]
 \_ 1:0:1:4 sdk 8:160 [failed][faulty]
 \_ 1:0:0:4 sdf 8:80  [active][ready]
$ # all good
$ # enabled a non-preferred path
$ multipath -ll 3600a0b800011a1ee00003f834a3f7a65
sdu: rdac prio: inquiry command indicates error
sdp: rdac prio: inquiry command indicates error
3600a0b800011a1ee00003f834a3f7a65 dm-0 IBM,1815      FAStT
[size=10G][features=1 queue_if_no_path][hwhandler=1 rdac]
\_ round-robin 0 [prio=0][enabled]
 \_ 2:0:1:4 sdu 65:64 [failed][faulty]
 \_ 2:0:0:4 sdp 8:240 [failed][faulty]
\_ round-robin 0 [prio=6][active]
 \_ 1:0:1:4 sdk 8:160 [active][ready]
 \_ 1:0:0:4 sdf 8:80  [active][ready]
$ # Good
$ # enabled a preferred path.
$ # expected failback to the preferred path group
$ multipath -ll 3600a0b800011a1ee00003f834a3f7a65
sdp: rdac prio: inquiry command indicates error
3600a0b800011a1ee00003f834a3f7a65 dm-0 IBM,1815      FAStT
[size=10G][features=1 queue_if_no_path][hwhandler=1 rdac]
\_ round-robin 0 [prio=4][enabled]
 \_ 2:0:1:4 sdu 65:64 [active][ghost]
 \_ 2:0:0:4 sdp 8:240 [failed][faulty]
\_ round-robin 0 [prio=6][active]
 \_ 1:0:1:4 sdk 8:160 [active][ready]
 \_ 1:0:0:4 sdf 8:80  [active][ready]
$ # no. failback did not happen. [see the first path group still states "ghost"]
$ # the reason is that the priority of the preferred path group is less than
$ # that of the non-preferred path group.
$ # Basically, non-preferred path is used even though one preferred path is available
$ # which is not correct
$ # wait for a a minute, may be
$ sleep 60
$ multipath -ll 3600a0b800011a1ee00003f834a3f7a65
sdp: rdac prio: inquiry command indicates error
3600a0b800011a1ee00003f834a3f7a65 dm-0 IBM,1815      FAStT
[size=10G][features=1 queue_if_no_path][hwhandler=1 rdac]
\_ round-robin 0 [prio=4][enabled]
 \_ 2:0:1:4 sdu 65:64 [active][ghost]
 \_ 2:0:0:4 sdp 8:240 [failed][faulty]
\_ round-robin 0 [prio=6][active]
 \_ 1:0:1:4 sdk 8:160 [active][ready]
 \_ 1:0:0:4 sdf 8:80  [active][ready]
$ # nope... failback didn't happen.
$ # enabled the other preferred path.
$ # only now the failback happens.
$ 
$ multipath -ll 3600a0b800011a1ee00003f834a3f7a65
3600a0b800011a1ee00003f834a3f7a65 dm-0 IBM,1815      FAStT
[size=10G][features=1 queue_if_no_path][hwhandler=1 rdac]
\_ round-robin 0 [prio=12][active]
 \_ 2:0:1:4 sdu 65:64 [active][ready]
 \_ 2:0:0:4 sdp 8:240 [active][ready]
\_ round-robin 0 [prio=2][enabled]
 \_ 1:0:1:4 sdk 8:160 [active][ghost]
 \_ 1:0:0:4 sdf 8:80  [active][ghost]
$ exit


--=-qk1QgWoqRQ3L3Krml6C4
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--=-qk1QgWoqRQ3L3Krml6C4--
