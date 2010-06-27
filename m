From: Christophe Varoqui <christophe.varoqui@gmail.com>
Subject: Re: multipathd daemon and some bad behavior
Date: Sun, 27 Jun 2010 11:17:51 +0200
Message-ID: <1277630271.20849.787.camel@localhost>
References: <AANLkTikn_lqBPASgffO0fJUmvdJubbuOLQ9ZCzT_0wBQ@mail.gmail.com>
Reply-To: christophe.varoqui@opensvc.com,
        device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <AANLkTikn_lqBPASgffO0fJUmvdJubbuOLQ9ZCzT_0wBQ@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: jozef janec <jozefjanec@gmail.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On sam., 2010-06-26 at 12:13 +0200, jozef janec wrote:
> Hello All,
> 
> I'm using device mapper multipath for long time, on SAN storage and I
> have detected a few very critical issues. The main is:
> 
> example:
> 
> configure 2 multipath devices (and have friednly names enabled)
> 
> on those two devices create vg and lvol and ctivate it. Than edit the
> bindigs file and swap the ids for mpath devices.
> 
> mpatha id1
> mpathb id2
> 
> to
> 
> mpatha id2
> mpathb id1 
> 
> and restart multipathd
> 
> when you check output from multipath -ll you will see that multipath
> swapped the devices behinde the used mpath targets. The result is that
> the io operation are directed to wrong lun and the fs is corupted. We
> have found workeround and to define aliases for the luns in
> multipath.conf. Than the bindigs file is ignored .
> 
> 
> but this is not fix the best solution is if there will be added some
> check if the line in bindings file is correct, or if the mpath target
> is used or not, and if it is used don\t allow change it. IS possible
> create a patch for this?
> 
> This issue can be happneded for example when you remove bindings file
> and you restart the multipath.
> 
> the problem is that you can add lun to the server, it will get mpatha
> device name, than second but with scsi id lower as the first one but
> because mpatha is already assaigned it will get mpathb. Now when you
> remove the bindigs file and restart multipath, multipath will create
> new bindigs file not by currect situation which is in dm-multipath but
> by scsi ids, and it will swap the luns maps, and activate them .
> result corupted fs.
> 
> I think the bext way will be that multipathd should try get the
> information from dm-multipath modul, and if they aren't there than by
> scsi information. This will avoind create wrong bindings file which
> can makes troubles.
> 
> I already restored 3 servers because I lost oracle on alot of
> servers. 
> 
The bindings file is a database, not a config file. That's why it would
best reside in /var than /etc, but the mount ordering problems forced us
to move it to /etc. As a database, you wouldn't ever think sane to
mangle it freely like you do.

user_friendly_names is for people who don't want to name their multipath
devices *at all*. If you want user-defined names, you must use aliasing
in /etc/multipath.conf. If you have a cluster setup, you must user
aliasing to force a consistent device naming across the cluster.

> Please could you check if there is possible cerate some patches for
> multipathd which will avoid this behavior?
> 
A documentation patch at least.

> Thanks
> 
> best regards
> 
> Jozef

-- 
Christophe Varoqui <christophe.varoqui@opensvc.com>
OpenSVC
