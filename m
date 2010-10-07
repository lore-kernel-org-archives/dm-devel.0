From: <wayne.berthiaume@emc.com>
Subject: Re: scsi_dh_emc vs scsi_dh_alua in RHEL5.5
Date: Thu, 7 Oct 2010 09:53:33 -0400
Message-ID: <8F08A56613D77044BD153E2AC5DA0F840518B72A@CORPUSMX40A.corp.emc.com>
References: <20100922164438.33e6ae04@csupomona.edu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <20100922164438.33e6ae04@csupomona.edu>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

Hi Brian.

	You are correct that you should configure /etc/multipath.conf
for ALUA. Presently, the default handler for when an EMC CLARiiON is
detected is scsi_dh_emc. What follows would be used for ALUA.

# Device attribute for EMC CLARiiON with ALUA
	device {
	vendor "DGC"
	product "*"
	prio_callout "/sbin/mpath_prio_alua /dev/%n"
	path_grouping_policy group_by_prio
	features "1 queue_if_no_path"
	failback immediate
	hardware_handler "1 alua"
	}
}

	A method to detect and use scsi_dh_emc for PNR or scsi_dh_alua
for ALUA is under investigation. Presently the scsi_dh_emc only supports
the PNR mode; however, the array will use implicit ALUA so it will work
when configured to use scsi_dh_emc. You won't gain the full benefits of
ALUA, however.

	 Is it possible to have two multipath devices with different
hardware handlers? Yes but it will be painful. =;^) You would need to
create an individual stanza filtering on the WWID of the devices. The
array will not allow you to set each LUN as ALUA or PNR, it's policy is
host based; therefore, this would only be possible if you had multiple
arrays. EMC's present policy is if there is one PNR array connected to
the server you need to use the PNR policy for all the storage attached
to that server. 

Regards,
Wayne.

-----Original Message-----
From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com]
On Behalf Of Brian De Wolf
Sent: Wednesday, September 22, 2010 7:45 PM
To: dm-devel@redhat.com
Subject: [dm-devel] scsi_dh_emc vs scsi_dh_alua in RHEL5.5

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

Sep 15 17:15:20 victoria kernel: sd 2:0:1:0: emc: ALUA failover mode
detected

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

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
