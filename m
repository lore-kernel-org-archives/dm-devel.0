From: D Canfield <canfield@uindy.edu>
Subject: DS4400 Strangeness
Date: Mon, 09 Apr 2007 15:26:19 -0400
Message-ID: <461A935B.3060903@uindy.edu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

Not sure if this is a RHEL5 issue, or a DS4000 issue, or what...

Basically, I have a bladecenter booting from a DS4000 SAN.  I've muddled 
by through RHEL3 & RHEL4 with the qlogic drivers half working, but with 
RHEL 5 thing pretty much seem to work out of the box when installing 
with the mpath install-time argument.

After the install, I comment out the blacklist line in multipath.conf 
and thing look the way I'd expect for an active/passive array:
[root@gimli ~]# multipath -l
mpath0 () dm-0 IBM,1742
[size=8.0G][features=0][hwhandler=0]
\_ round-robin 0 [prio=0][enabled]
 \_ 0:0:0:0 sda 8:0   [active][undef]
\_ round-robin 0 [prio=0][enabled]
 \_ 1:0:0:0 sdb 8:16  [active][undef]

At this point things seem to work properly, and while the paths may not 
be the preferred paths, I can wait until RHEL 5.1 for the RDAC support 
that's been added to the multipath tools (I've been told a kernel patch 
is also required, or I would just upgrade the tools myself).

However, I then attempted to install the first RHEL5 errata kernel, and 
during the upgrade, the paths failed and the filesystem was labeled 
read-only.  The kernel install finished, but after the reboot I have a 
bit of a mess.  Notably, during boot the following errors are displayed:

Cannot open bindings file [/var/lib/multipath/bindings] : Read-only file 
system
/dev/sda2: open failed: No such device or address
Found duplicate PV  using /dev/dm-7 not /dev/mapper/mpath0p2

And the multipath output is a mess as well (though better after a -F run):

[root@gimli ~]# multipath -l
mpath0 () dm-0 IBM,1742
[size=8.0G][features=0][hwhandler=0]
\_ round-robin 0 [prio=0][active]
 \_ 0:0:0:0 sda 8:0   [active][undef]
 \_ 1:0:0:0 sdb 8:16  [active][undef]
3600a0b80000f82ce0000006241e539ccdm-5 IBM,1742
[size=8.0G][features=0][hwhandler=0]
\_ round-robin 0 [prio=0][active]
 \_ 0:0:0:0 sda 8:0   [active][undef]
\_ round-robin 0 [prio=0][enabled]
 \_ 1:0:0:0 sdb 8:16  [active][undef]

[root@gimli ~]# multipath -F
mpath0: map in use

[root@gimli ~]# multipath -l
mpath0 () dm-0 IBM,1742
[size=8.0G][features=0][hwhandler=0]
\_ round-robin 0 [prio=0][active]
 \_ 0:0:0:0 sda 8:0   [active][undef]
 \_ 1:0:0:0 sdb 8:16  [active][undef]

Rebooting to the original kernel has no effect, and this process is 
reproducible (I've done about 3 clean installs). My only guess is that 
it has something to do with mkinitrd not taking into account the 
multipathing the same way RHEL5 anaconda does.  But that doesn't explain 
to me why the old kernel doesn't work, nor why the paths fail during the 
kernel upgrade.

Any guesses/insights/suggestions?

Thanks
Dana
