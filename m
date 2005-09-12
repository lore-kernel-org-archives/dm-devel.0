From: gistolero@gmx.de
Subject: Re: Problems with multipathd
Date: Mon, 12 Sep 2005 17:52:57 +0200
Message-ID: <4325A459.2030005@gmx.de>
References: <20050831152928.GA53290@sysconfig.de>	<1125518162.6375.52.camel@zezette>
	<431DC7D6.1010900@gmx.de> <1126039647.9859.89.camel@zezette>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1126039647.9859.89.camel@zezette>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

>>===> I found some settings in /sys/module/qla2xxx/parameters/...,
>>but most of them are read-only values. I have changed ql2xretrycount
>>and ql2xsuspendcount but without success. Any suggestions for
>>this driver?
>>
> 
> Here are the interesting one I guess.
> 
> [root@s64p17bibro ~]# find /sys/class/ -name "*tmo*"
> /sys/class/fc_remote_ports/rport-1:0-3/dev_loss_tmo
> /sys/class/fc_remote_ports/rport-1:0-2/dev_loss_tmo
> /sys/class/fc_remote_ports/rport-1:0-1/dev_loss_tmo
> /sys/class/fc_remote_ports/rport-1:0-0/dev_loss_tmo
> /sys/class/scsi_host/host1/lpfc_nodev_tmo

Ok, I have a 6 seconds timeout now :-)


>>I have commented this line, but udev still has difficulties to create this
>>links. Therefore I have changed /etc/dev.d/block/multipath.dev (the script
>>is attached at the end of this post) and added debug messages. The most
>>important modification is that kpartx uses the block-device-files in
>>/dev/mapper/... instead of /dev/...
>>===> Why isn't that the default? Are there any disadvantages?
>>
> 
> Not really. All distributors seem to have their own ideas about naming
> policies. You should ask about, and follow the Gentoo philosophy I
> guess.


I'm sure of not beeing the only one who has problems with missing /dev/... 
links. It's possible that multipath installs a device-mapper table without 
errors, but kpartx fails because udev doesn't create links in /dev/... So, I 
think multipath.dev should execute kpartx with /dev/mapper/... instead of 
/dev/... by default.


>>===> Without "udevstart" udev doesn't create the /dev/150gb*
>>links! Is this a udev bug?
>>
> You can still identify the udev problems keeping the node creation
> in /dev/. Maybe all path setupis done in the initrd/initramfs without
> multipath being able to react.

multipath is able to react. I don't understand why I have to execute udevstart.



>>===> First multipathd says "8:0: tur checker reports
>>path is down" and multipath prints sda "failed" (ok).
>>After a few seconds sda is "ready" and multipathd says
>>"8:0: tur checker reports path is up"?! I have changed
>>nothing during this time.
>>
> 
> Maybe the checker is confused by the long timeouts.
> Worth another try after the lowering.

After lowering the timeouts to 6 seconds multipathd shows the same behavior.



>>===> Multipathing seems to work without but not with multipathd.
>>It's very slow, but Christophe Varoqui wrote that I have to lower
>>the HBA timeouts (unfortunately, I don't know how to do this,
>>see above). Does I really need multipathd? I suppose so :-)
>>
> 
> multipathd is needed to reinstate paths.
> In your case the rport disappears and reappears so the mecanism is all
> hotplug-driven and thus may work without the daemon ... if memory
> ressources permits hotplug and multipath(8) execution, that is.

What do you means with "In your case..."? Because 2.6 and udev are 
multipath-tools dependencies all systems running multipath have the same 
environment. They all use kernel 2.6 and udev, that is hotplug-driven. The 
kernel starts this hotplug process and udev executes multipath. Sorry, but I 
have to ask again: Does we really need multipathd?


After lowering dev_loss_tmo timeouts and stopping multipathd I have a working 
multipath environment :-))) I tested this with a little perl script and a 
mysql database:



My trafficmaker-host executed this script 27 times (parallel):

...
for(my $count=1;$count<=1000000;$count++)
{
   ...
   my $sql="INSERT INTO $table VALUES($id,\"$value\")";
   my $return=$dbh->do($sql);
   ...
}
...
{
   my $sql="SELECT COUNT(*) FROM $table WHERE id=$id";
   my $sth=$dbh->prepare($sql);
   my $return=$sth->execute();
   ...
   $selectCount=$sth->fetchrow_array();
   ...;
}


The database host had to insert this 30 byte strings and I have started some 
copy-jobs (cp -a /usr/* /partition_mounted_with_multipath/ etc.) to increase 
the I/O load. During this test I have disabled and enabled the different 
HBA-Switch-Ports with the following result: It took 6 to 15 seconds before 
"multipath -l" showed that a path is down (15 seconds because the host had a 
30.0 CPU load and responded very slowly), but no INSERT got lost :-)))

But sometimes multipath seems to be a bit confused...



1.) one path disabled

In the majority of cases multipath prints...

testhalde2 sbin # multipath -l
150gb ()
[size=150 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [active]
  \_ #:#:#:#     8:0  [active]
  \_ 1:0:0:1 sdb 8:16 [active]


But sometimes I get...

testhalde2 usr # multipath -l
150gb ()
[size=150 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [active]
  \_ 4:0:0:1 sdb 8:16 [active]



2.) all paths enabled (default)

In the majority of cases multipath prints...

testhalde2 sbin # multipath -l
150gb ()
[size=150 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [enabled]
  \_ 1:0:0:1 sdb 8:16 [active]
  \_ 0:0:0:1 sdc 8:32 [active]


But sometimes I get...

testhalde2 usr # multipath -l
150gb ()
[size=150 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [active]
  \_ 0:0:0:1 sdb 8:16 [active]
\_ round-robin 0 [enabled]
  \_ 4:0:0:1 sdc 8:32 [active]


Regards
Simon
