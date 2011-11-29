From: "Moger, Babu" <Babu.Moger@netapp.com>
Subject: Re: info on enabling only one path with rdac and DS4700
Date: Tue, 29 Nov 2011 12:07:56 -0500
Message-ID: <47D23AD8469A2B448F33C24BD7A39BD9109D0DC5@RTPMVEXC1-PRD.hq.netapp.com>
References: <CAG2kNCx2FSBFcKQQ5qRNNdY8c8OZ6iR+WY4XPUy21mttYn-wuw@mail.gmail.com><1321389505.23295.4.camel@lapoo.opensvc.com><CAG2kNCyHk+vosO1+TtNwLUcH5AJP-cPn8m5nCDhVkenXFFxfjw@mail.gmail.com><201111161424.50911.hirtejs@idmt.fraunhofer.de><CAG2kNCw9ZdWrk1Ai6xQ=gDeMeV22verUQWw8+18yWNMjscuPMg@mail.gmail.com><47D23AD8469A2B448F33C24BD7A39BD9109D07FE@RTPMVEXC1-PRD.hq.netapp.com><CAG2kNCxrA7twm2k7k8VWQGnWaADEog8iiyjEwfCiJj=OWCvqjQ@mail.gmail.com><47D23AD8469A2B448F33C24BD7A39BD9109D090A@RTPMVEXC1-PRD.hq.netapp.com><CAG2kNCzRbMQydCm4UQBX+fO6L1F5_jt7O3JWv-vCwgqE5Qkuww@mail.gmail.com><47D23AD8469A2B448F33C24BD7A39BD9109D0977@RTPMVEXC1-PRD.hq.netapp.com><CAG2kNCxeqXFy1i_-hET2zgf5sq==quNQt7MREKj-_0NS=9QnHQ@mail.gmail.com>
	<CAG2kNCzFdeCy-NVVBnfJxyeCMVVfHQXXF0WUvXfUjsLSFRb5dw@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <CAG2kNCzFdeCy-NVVBnfJxyeCMVVfHQXXF0WUvXfUjsLSFRb5dw@mail.gmail.com>
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

I think I got it what is happening..  Please see my comments below..

> -----Original Message-----
> From: Gianluca Cecchi [mailto:gianluca.cecchi@gmail.com]
> Sent: Tuesday, November 29, 2011 12:29 AM
> To: device-mapper development
> Subject: Re: [dm-devel] info on enabling only one path with rdac and
> DS4700
> 
> On Mon, Nov 28, 2011 at 9:13 PM, Gianluca Cecchi wrote:
> > On Mon, Nov 28, 2011 at 7:05 PM, Moger, Babu wrote:
> [snip]
> >> RHEL 5.7 has the patch already as I know. You can check to be sure.
> Can you also add "scsi_mod.scsi_logging_level=5056" in kernel line to
> get more information on what else is going on.
> >
> > Ok, I have verified that the patch should be applied.
> [snip]
> > So I'm going to add the scsi logging parameter you suggested and see.
> >
> 
> Unfortunately it seems that rh el 5.x kernel doesn't support that
> scsi_mod kernel module option directly at kernel line
> # cat /proc/cmdline
> ro root=/dev/VolGroup00/LV_root rhgb quiet
> scsi_mod.scsi_logging_level=5056
> 
> In messages:
> Nov 29 07:00:03 testserver kernel: Unknown boot option
> `scsi_mod.scsi_logging_level=5056': ignoring
> 
> So I picked up the new initrd with the scsi_dh part and put directly
> that option at insmod statement line for scsi_mod module in initrd
> init file, creating another special grub.conf stanza for this initrd
> See messages and output of dmesg with this parameter at the links below
> 
> https://docs.google.com/open?id=0BwoPbcrMv8mvNzU1ZTNlY2UtY2E5Ni00NDdlLW
> IyY2UtZmQ0Y2I4OTJmNTZi
> and
> https://docs.google.com/open?id=0BwoPbcrMv8mvZmUxNTNmNjgtOTZmMi00YTBiLT
> kyZTktZWU0NTdjZWI4OWZm
> 
> At the end of boot:
> mpath1 (3600a0b80005012440000093e4a55cf33) dm-6 IBM,1814      FAStT
> [size=3.4T][features=1 queue_if_no_path][hwhandler=1 rdac][rw]
> \_ round-robin 0 [prio=0][active]
>  \_ 3:0:1:1 sdc 8:32  [active][undef]
>  \_ 4:0:1:1 sde 8:64  [active][undef]
> \_ round-robin 0 [prio=0][enabled]
>  \_ 3:0:0:1 sdb 8:16  [active][undef]
>  \_ 4:0:0:1 sdd 8:48  [active][undef]
> 
> Hope it helps you understanding better what doesn't go as expected..
> Thanks for your time

Here are the messages without scsi_dh_rdac in initrd. 
	Nov 23 17:32:56 testserver kernel:  sdc:end_request: I/O error, dev
 		sdb, sector 0
	Nov 23 17:32:56 testserver kernel: Buffer I/O error on device sdb,
 		logical block 0

Here are the messages with scsi_dh_rdac in initrd.

	Nov 29 07:16:46 testserver kernel: Buffer I/O error on device sdd, logical block 0

If you notice above, there is only one message in having driver in initrd. The messages " Buffer I/O error" is coming from file system layer. There is no way of silencing there errors in older kernels. These messages are  harmless. The newer kernels use "BH_Quiet" flag to silence there error. You can check the newer kernel sources.

Final note. It is always recommended to include the handlers in initrd because it will avoid I/Os to passive paths reducing the boot time. 
 


> 
> Gianluca
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
