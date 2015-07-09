From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: API for multi-segment atomic IO
Date: Thu, 9 Jul 2015 09:34:37 -0700
Message-ID: <559EA29D.9000700@sandisk.com>
References: <CAFx4rwRyVL4Kt_DgHyHMRZ9SBM3Ao=VubCk7nXBS3Qg68YD_hw@mail.gmail.com>
	<559D43F7.9010506@sandisk.com>
	<CAFx4rwTEe5i1s0na0oncht9OEbJVhtgJe21VmS_0E-zxK_Vdrg@mail.gmail.com>
	<20150708193832.GA26268@infradead.org>
	<CAFx4rwR980To5cK=UgW1-qe8psgeQFYYm0-g_sPz1cEs48JiYg@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAFx4rwR980To5cK=UgW1-qe8psgeQFYYm0-g_sPz1cEs48JiYg@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: doug@easyco.com, device-mapper development <dm-devel@redhat.com>, Christoph Hellwig <hch@infradead.org>
List-Id: dm-devel.ids

On 07/09/2015 08:41 AM, Doug Dumitru wrote:> Mr. Hellwig,
> On Wed, Jul 8, 2015 at 12:38 PM, Christoph Hellwig <hch@infradead.org
> <mailto:hch@infradead.org>> wrote:
>
>     On Wed, Jul 08, 2015 at 09:21:21AM -0700, Doug Dumitru wrote:
>     > I have a "smart" block device that can implement multi-segment atomic
>     > writes.
>
>     How about submitting your driver upstream first and then we can work
>     with you on an API that fits the devices and the consumers needs.
>
> I usually like to start with an interface and then implement the
> driver's from there.
>
> In this case, this is a block-level interface that supports new
> functionality (atomic writes).  In the past, you would approach this
> type of problem by having the atomic and user layers as a monolithic
> solution.  Consider database updates and the complexity that they go
> through to insure database integrity.  If a block device could provide a
> database with an atomic update interface, the database would get a lot
> simpler.  The same discussion holds true for file systems.  Depending on
> the atomic update implementation, you might end up in the same place in
> terms of total code, but you might also end up somewhere completely
> different.
>
> The impetus for this is some research on file system "write
> amplification".  In general, file system design seems to be heading in
> the direction of higher and higher write amplification.  For example,
> the tree structure of zfs is shockingly inefficient in terms of write
> overhead.  This is happening at the same time as Flash is becoming
> popular but is also moving to smaller and smaller geometries.  So write
> efficiency is becoming more and more important.
>
> By decoupling the atomic update semantics from file system and other
> block device "users", this gives devices the opportunity to implement
> atomic updates internal to or in cooperation with Flash management
> algorithms.  In theory, you can implement atomic updates without any
> extra writes.  In practice, some devices will be better than others.
>
> I was hoping to stumble across someone interested in this as a concept,
> or someone who has researched this area, as I don't have any near
> production existing code.  I could pretty easily hack in a couple of
> extra fields in struct bio that would accomplish what I see, but others
> might have differing input.

Hello Doug,

When designing such an API, please try to stay close to the semantics of 
the already standardized SCSI commands. As you probably know the Linux 
SCSI core has been implemented as a block driver. Any new command that 
is added to the Linux block layer has to be translated by the Linux SCSI 
core into a SCSI command. An example of a patch series that adds support 
for a new block layer primitive is the patch series that adds 
compare-and-write support 
(http://thread.gmane.org/gmane.linux.scsi/95869). Although that patch 
series is not yet upstream I think it is a good example of how to add 
new functionality to the block layer and SCSI core.

Bart.
