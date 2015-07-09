From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: API for multi-segment atomic IO
Date: Thu, 9 Jul 2015 10:24:22 -0700
Message-ID: <559EAE46.8000706@sandisk.com>
References: <CAFx4rwRyVL4Kt_DgHyHMRZ9SBM3Ao=VubCk7nXBS3Qg68YD_hw@mail.gmail.com>
	<559D43F7.9010506@sandisk.com>
	<CAFx4rwTEe5i1s0na0oncht9OEbJVhtgJe21VmS_0E-zxK_Vdrg@mail.gmail.com>
	<20150708193832.GA26268@infradead.org>
	<CAFx4rwR980To5cK=UgW1-qe8psgeQFYYm0-g_sPz1cEs48JiYg@mail.gmail.com>
	<559EA29D.9000700@sandisk.com>
	<CAFx4rwRBh4ix1d84rzo=_0MiLABNObA54cbBNZ5RKTnWpT78mg@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAFx4rwRBh4ix1d84rzo=_0MiLABNObA54cbBNZ5RKTnWpT78mg@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "doug@easyco.com" <doug@easyco.com>
Cc: Christoph Hellwig <hch@infradead.org>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 07/09/2015 10:09 AM, Doug Dumitru wrote:
> The problem with this is that the SCSI commands do not go far enough to
> actually address the needs of applications that need atomic updates.  An
> application would "like" to be able to update a large arbitrary set, of
> sectors on a device with atomic semantics. The SCSI commands require the
> set to be contiguous.  Application design starts to get interesting when
> the contiguous restriction goes away.
>
> My initial thoughts are to tag multiple IO requests with an ID and
> combined length field.  This would be compatible with the SCSI spec if
> the request was contiguous, but nonsensical if the request were
> multi-segment.  On the other hand, just hitting the SCSI spec is
> probably as simple as adding an "atomic" bit to the current structure so
> that IO pieces are not cut up.  But then, you don't address the
> multi-segment functionality that is possible.  Regardless, there will be
> issues as pieces of the current stack don't lend themselves well to
> propagating atomic operations up and down the stack.  Just how do you
> split an atomic write across scsi devices in a raid set anyway?
>
> What I am most interested in is keeping the stack working with at least
> 1:1 mapping layers, and with 1:many layers below the layer that
> implements the atomic functionality.  Think of a dm-atomic.ko device
> that uses a log internally to implement multi-segment atomic writes.  It
> can talk safely to raid below it, but lvm should be able to sit above it
> and still have a file system that expects atomic functionality to work.
> Now getting a SAN connection to work like this would involve a new
> transport as iSCSI doesn't really have the semantics for this, but maybe
> there are some extra "transaction ID" bits that could be put into play
> (it has been a long time since I dug into the depths of the SCSI layers).

Hello Doug,

The original proposal, from which the SBC-4 ATOMIC WRITE specification 
has been derived, had support for scattered writes and gathered reads. 
The title of that document is "SBC-4 SPC-5 Atomic writes and reads" 
(http://www.t10.org/cgi-bin/ac.pl?t=d&f=14-043r4.pdf).

Bart.
