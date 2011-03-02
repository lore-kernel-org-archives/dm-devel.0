From: "Moger, Babu" <Babu.Moger@lsi.com>
Subject: Re: Dell MD3200 - sd: Current: sense key: Illegal
 Request ASC=0x94 ASCQ=0x1ASC=0x94 ASCQ=0x1
Date: Wed, 2 Mar 2011 12:28:26 -0700
Message-ID: <E463DF2B2E584B4A82673F53D62C2EF4FF7DCA4F@cosmail01.lsi.com>
References: <4D6BFCF9.4080809@cmu.edu> <4D6E91E7.4010305@cmu.edu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4D6E91E7.4010305@cmu.edu>
Content-Language: en-US
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


> -----Original Message-----
> From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com]
> On Behalf Of Charles Slivkoff
> Sent: Wednesday, March 02, 2011 12:52 PM
> To: dm-devel@redhat.com
> Subject: Re: [dm-devel] Dell MD3200 - sd: Current: sense key: Illegal
> Request ASC=0x94 ASCQ=0x1ASC=0x94 ASCQ=0x1
> 
> Hello Babu. Thanks for responding.
> 
> > You said "The array is split into 2 virtual disk, each
> > assigned to one of the RAID controllers". Did you mean you
> > redistributed the two luns(one is owned by controller A and one by
> > controller B)?
> 
> Yes. I have assigned 1 LUN to each of the controllers.
> 
> > It appears that your luns are moving back and forth between two
> > controllers.. You can try setting failback to manual(failback
> > manual).  This is not a solution but to understand the problem.
> 
> I changed to "failback manual" in /etc/multipath.conf and rebooted. I'm
> not sure if the reboot was necessary or not. This does not appear to
> have changed the behavior.
> 
> > Are you seeing "MODE_SELECT" messages in the logs..  Can you paste
> > snippet of log messages..
> 
> There are no "MODE_SELECT" messages in syslog. Would these be appearing
> elsewhere? The syslog from the last reboot up until I started receiving
> the "Illegal Request" messages is available here
> http://tinypaste.com/f7f413

One of your lun seem to have a problem. See these messages below..

Mar  2 12:43:14 rman-ss-03 kernel: scsi 1:0:0:0: rdac: LUN 0 (unowned)
Mar  2 12:43:14 rman-ss-03 kernel: sd 1:0:0:1: rdac: LUN 1 (unowned)
Mar  2 12:43:14 rman-ss-03 kernel: sd 1:0:0:2: rdac: LUN 2 (owned)
Mar  2 12:43:14 rman-ss-03 kernel: scsi 2:0:0:0: rdac: LUN 0 (unowned)
Mar  2 12:43:14 rman-ss-03 kernel: sd 2:0:0:1: rdac: LUN 1 (owned)
Mar  2 12:43:14 rman-ss-03 kernel: sd 2:0:0:2: rdac: LUN 2 (unowned)
Mar  2 12:43:14 rman-ss-03 kernel: rdac: device handler registered

Lun 0 is not owned by any of the controllers also it is not claimed by sd driver for some reason.  Can you find out why that happened..  Or you can remove Lun 0 and see if issue goes away..



Looking at these messages below it is not clear which device caused this error.. 
Mar  2 12:56:51 rman-ss-03 kernel: FAILED
Mar  2 12:56:51 rman-ss-03 kernel:   status = 1, message = 00, host = 0, driver = 08
Mar  2 12:56:51 rman-ss-03 kernel:   <6>sd: Current: sense key: Illegal Request
Mar  2 12:56:51 rman-ss-03 kernel:     <<vendor>> ASC=0x94 ASCQ=0x1ASC=0x94 ASCQ=0x1
Mar  2 12:56:51 rman-ss-03 kernel:

Can you please set scsi logging level to 4096(echo 4096 > /proc/sys/dev/scsi/logging_level) and reboot the host.. That would probably give some more info..


> 
> 
> -Charles
