From: malahal@us.ibm.com
Subject: Re: Multipath and getuid_callout issues with HP
	XP1024disk array
Date: Wed, 30 Jan 2008 10:50:25 -0800
Message-ID: <20080130185024.GA6165@us.ibm.com>
References: <20080129221851.GA13346@us.ibm.com>
	<2F1F44D192D1284BAA298E48C1B2A4F90234F146@exchmail03.ncogroup.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <2F1F44D192D1284BAA298E48C1B2A4F90234F146@exchmail03.ncogroup.com>
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

You have two default sections in your multipath.conf file, but that is not
the problem though. The scsi_id output from each path looks different,
that is why multipath treats them as different LUNs.

Make sure you configure your storage properly or change the default
getuid string that works for your storage.

Thanks, Malahal.

Greene, Rick [rick.greene@ncogroup.com] wrote:
> Ok, some more background first:
> 
> System is an HP Proliant DL380 (or maybe DL580?), using Emulex fibre
> channel cards (don't know exact model off-hand).
> 
> Running Red Hat Enterprise Linux 4, update 5.
> 
> Device-mapper-multipath was version 0.4.5-21, just updated it to
> 0.4.5-27
> 
> There are 4 LUNs from an HP XP1024 disk array, each pathed to be visible
> on each fibre channel.  LUN type is OPEN-E.
>  
> Multipath now seems to accept the longer string returned by scsi_id, but
> it doesn't seem able to tell that certain disks are the same.
> 
> Attached is the multipath.conf file I'm using and the output from
> "multipath -v3". If the attachments don't come through, I'll send
> separate emails with just the contents for each file.
> 
> Any aide gladly received, I'm in over my head on this one.
> 
> Thanks,
> Rick
> 
> 
> -----Original Message-----
> From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com]
> On Behalf Of malahal@us.ibm.com
> Sent: Tuesday, January 29, 2008 5:19 PM
> To: dm-devel@redhat.com
> Subject: Re: [dm-devel] Multipath and getuid_callout issues with HP
> XP1024disk array
> 
> Greene, Rick [rick.greene@ncogroup.com] wrote:
> >    I've done what I can to try to understand how all this works, but I
> keep
> >    getting "error calling out /sbin/scsi_id -g -u -s /block/sda" when
> I run
> >    the command "multipath -v2"
> > 
> > 
> > 
> >    I've tried a number of different things in the /etc/multipath.conf
> file,
> >    but keep coming back to this same error.  If I run the command
> manually I
> >    get the following:
> > 
> > 
> > 
> >    # /sbin/scsi_id -g -u -s /block/sda
> > 
> >    0HP______OPEN-E__________50060e80039c5a0400000000000000000000e100
> > 
> > 
> > 
> >    What's missing?  Any help greatly appreciated.
> 
> You are not missing anything. The device id is too big to fit in
> multipath tools allocated memory. The program incorrectly prints that
> there is a problem while executing /sbin/scsi_id but in fact the problem
> lies in the program itself. You may have some old version of multipath
> tools. WWID_SIZE was set to 64 bytes and that is small for your device.
> Get the latest version where that macro is set to 128 or so.
> 
> Hope that helps!
> 
> --Malahal.
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel



> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
