From: "goggin, edward" <egoggin@emc.com>
Subject: Re: bugs in handling of errors for SG_IO and SCSI_IOCT
	L_SEND_COMMAND ioctls to block device
Date: Sat, 9 Jul 2005 18:58:51 -0400
Message-ID: <C2EEB4E538D3DC48BF57F391F422779321AB5C@SRMANNING.eng.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
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
To: "'dm-devel@redhat.com'" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Fri, 08 Jul 2005 11:48:08 -0500
Mike Christie <michaelc@cs.wisc.edu> wrote

> Subject: Re: [dm-devel] bugs in handling of errors for SG_IO and
> 	SCSI_IOCT	L_SEND_COMMAND ioctls to block device
> To: device-mapper development <dm-devel@redhat.com>
> Message-ID: <42CEAE48.9050203@cs.wisc.edu>
> Content-Type: text/plain; charset=ISO-8859-1; format=flowed
> 
> goggin, edward wrote:
> > On Thu, 07 Jul 2005 23:19:57 -0500
> > Mike Christie <michaelc@cs.wisc.edu> wrote
> > 
> > 
> >>>...
> >>>
> >>>	The bio handling for these REQ_BLOCK_PC requests shouldn't be
> >>>treated any
> >>>	differently than the more typical REQ_CMD type block io request.
> >>
> > 
> >>what is meant by this last comment specifically?
> > 
> > 
> > Just trying to make a case that a device pass through read command
> > issued to a block device should transfer to user space only the
> > user requested number of bytes minus the residual from the transfer
> > (as is done for block device read and write requests) and not always
> > transfer the number of bytes requested by the user.
> > 
> 
> ah ok, I thought it was referring to something else, nevermind.
> 
> Was the reason it does SG_IO reads becuase opens on the 
> device were not 
> allowed?

Sorry, I should not have singled out pass through read commands.  My
statement above should have simply referred to "pass through commands
which are transferring data from the device".

> Was not being able to open a dm device a bug or by 
> design? 

I didn't provide my context for why the pass through commands are issued.
These are test path ios initiated by the multipathd in user space --
either tur, read of sector 0, or a page 0xc0 inquiry.

> For devices that do not support SG_IO like NBD, dasd and if you do 
> dm-multipath with AOE, another solution may have to be found.
>

Good point.  While dm-multipath is designed to be block device
protocol agnostic, its current implementation only supports
SCSI devices.
