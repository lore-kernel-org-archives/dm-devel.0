From: Rudy Gevaert <Rudy.Gevaert@UGent.be>
Subject: multipath device with name '1'
Date: Mon, 05 Mar 2012 17:52:12 +0100
Message-ID: <4F54EF3C.8050405@UGent.be>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
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
List-Id: dm-devel.ids

Hello,

 From time to time I get a multipath device called '1':

1                 dm-4 DELL,MD32xx
size=50G features='3 queue_if_no_path pg_init_retries 50' hwhandler='1 
rdac' wp=rw
`-+- policy='round-robin 0' prio=-1 status=enabled
   |- 0:0:0:1 sdd 8:48  failed undef running
   `- 0:0:1:1 sde 8:64  failed undef running


This happens when I unmap/map luns to a specific host.

I am seeing this on machines connected through fibre channel to an IBM 
DS3400, but also on a machine direct attached to a Dell MD3200.

1                 dm-6 IBM,1726-4xx  FAStT
size=550G features='1 queue_if_no_path' hwhandler='1 rdac' wp=rw
`-+- policy='round-robin 0' prio=-1 status=enabled
   `- 1:0:0:15 sdh  8:112  failed undef  running

I haven't been able to remove the device from the listing.  I can remove 
it from device mapper, but as soon as I rescan the bus it appears again.

The only way to get rid of the multipath (so it stays away) is to reboot 
the machine.

The main concern with this device I have is that some scripts (like when 
you recreate initramfs) go and check all the devices.  And when it 
checks this device the process hangs...

Has anybody seen this before?

root@cyrprd2:~# uname -a
Linux cyrprd2 2.6.32-5-amd64 #1 SMP Tue Jun 14 09:42:28 UTC 2011 x86_64 
GNU/Linux



Thanks,

Rudy
