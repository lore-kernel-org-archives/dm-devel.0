From: Brian De Wolf <bldewolf@csupomona.edu>
Subject: scsi_dh_emc vs scsi_dh_alua in RHEL5.5
Date: Wed, 22 Sep 2010 16:44:38 -0700
Message-ID: <20100922164438.33e6ae04@csupomona.edu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
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
To: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

Greetings,

In our environment we have hosts with two qla2xxx HBAs crossing a SAN
to our Clariion CX4-480, no clustering, configured with ALUA (failover
mode 4).  The CX4-480 has two controllers so each host sees four
paths for each volume.  The original configuration worked great using
the multipath defaults in RHEL5.4, using dm-emc.  All path priorities
picked up correctly, all paths responded to I/O, failover worked, etc.

However, once we upgraded to 5.5, we now default to using scsi_dh_emc,
which doesn't behave quite the same as dm-emc used to.  The non-optimal
paths fail I/O as though they aren't in ALUA mode.  This is despite
output from the device handler:

Sep 15 17:15:20 victoria kernel: sd 2:0:1:0: emc: ALUA failover mode detected

It's still able to fail over though, so all is not lost.  The ALUA
handler behaves like our old setup, so it seems that's the way to go.
I wanted to clear up a few questions before I stuck with that though:

For an ALUA setup with EMC hardware, is scsi_dh_alua the way to go?

Is the EMC handler supposed to support ALUA?  If not, why doesn't it
suggest using scsi_dh_alua when it detects an ALUA configuration?

Is multipath not capable of detecting ALUA, and that's why it uses the
EMC handler for EMC volumes that are configured for ALUA?  Will this
ever be automatic?

While testing, it was not possible to change the handler on a volume by
flushing and re-detecting the path in multipath, the slave devices had
to be deleted in sysfs and the scsi_dh_emc module had to be removed.
Is this intentional?  Both modules seem rather "aggressive" about
claiming devices.

Is it possible to have two multipath devices with different hardware
handlers?  If I had an existing multipath using scsi_dh_emc, it
prevented other multipaths from appearing using scsi_dh_alua and vice
versa.  I don't plan on mixing device handlers, but it means that I
can't leave the config change in place until the next reboot, lest I
have to add volumes before then.


Thanks for any help you can provide.
