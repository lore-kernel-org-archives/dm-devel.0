From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: bugs in handling of errors for SG_IO and SCSI_IOCT
	L_SEND_COMMAND ioctls to block device
Date: Fri, 08 Jul 2005 11:48:08 -0500
Message-ID: <42CEAE48.9050203@cs.wisc.edu>
References: <C2EEB4E538D3DC48BF57F391F422779321AB53@SRMANNING.eng.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <C2EEB4E538D3DC48BF57F391F422779321AB53@SRMANNING.eng.emc.com>
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

goggin, edward wrote:
> On Thu, 07 Jul 2005 23:19:57 -0500
> Mike Christie <michaelc@cs.wisc.edu> wrote
> 
> 
>>>...
>>>
>>>	The bio handling for these REQ_BLOCK_PC requests shouldn't be
>>>treated any
>>>	differently than the more typical REQ_CMD type block io request.
>>
> 
>>what is meant by this last comment specifically?
> 
> 
> Just trying to make a case that a device pass through read command
> issued to a block device should transfer to user space only the
> user requested number of bytes minus the residual from the transfer
> (as is done for block device read and write requests) and not always
> transfer the number of bytes requested by the user.
> 

ah ok, I thought it was referring to something else, nevermind.

Was the reason it does SG_IO reads becuase opens on the device were not 
allowed? Was not being able to open a dm device a bug or by design? For 
devices that do not support SG_IO like NBD, dasd and if you do 
dm-multipath with AOE, another solution may have to be found.
