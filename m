From: Hannes Reinecke <hare@suse.de>
Subject: Re: [LSF/MM ATTEND][LSF/MM TOPIC] Multipath redesign
Date: Fri, 15 Jan 2016 08:12:02 +0100
Message-ID: <56989BC2.8030008@suse.de>
References: <56961493.5010901@suse.de>
	<20160113175239.GE24960@octiron.msp.redhat.com>
	<56974D80.2020803@suse.de> <5697F270.3070205@sandisk.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; Format="flowed"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <5697F270.3070205@sandisk.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <bart.vanassche@sandisk.com>, device-mapper development <dm-devel@redhat.com>, Benjamin Marzinski <bmarzins@redhat.com>
List-Id: dm-devel.ids

On 01/14/2016 08:09 PM, Bart Van Assche wrote:
> On 01/13/2016 11:25 PM, Hannes Reinecke wrote:
>> On 01/13/2016 06:52 PM, Benjamin Marzinski wrote:
>>> On Wed, Jan 13, 2016 at 10:10:43AM +0100, Hannes Reinecke wrote:
>>>> c) implement block or scsi events whenever a remote port becomes
>>>>     unavailable. This removes the need of the 'path_checker'
>>>>     functionality in multipath-tools.
>>>
>>> I'm not convinced that we will be able to find out when paths
>>> come back
>>> online in all cases without some sort of actual polling. Again,
>>> I'd love
>>> this to be simpler, but asking all the types of storage we plan to
>>> support to notify us when they are up and down may not be realistic.
>>
>> Currently we have three main transports: FC, iSCSI, and SAS.
>
> Hello Hannes,
>
> Since several years the Linux SRP initiator driver also has reliable
> and efficient H.A. support. The IB spec supports port state change
> notifications. But whether or not port state information affects the
> path state should be configurable. Several IB users wouldn't like it
> if port state information would affect the path state because the
> time during which a port is down can be shorter than the time during
> which an IB HCA keeps retrying to send a packet.
>
Oooh, but of course I've forgotten SRP. Sorry, Bart; it's just not =

on my radar (what with me having no Infiniband equipment to speak of =

...)

But the above really sounds similar to the dev_loss_tmo mechanism we =

have on FC. Maybe it's worth looking into if we could have a similar =

mechanism on SRP.

The point here is that (on FC) we have the following flow of events:

Path loss
-> start dev_loss_tmo
-> rport set to 'blocked'
-> RSCN received
-> move to final rport state (online or gone)
-> unblock rport
-> stop dev_loss_tmo (if rport is online) or
-> dev_loss_tmo fires and removes rport

atm we're being notified once the port is moved to the final state, =

as that's when I/O continues or is being aborted and we're getting =

the I/O completion back.
With path events we could react to the actual path loss, and =

redirect I/O to another path directly when the path loss occurs.
But this really is a matter of policy; it might be that the path =

switch is taking long then the path interruption.
So this needs to be evaluated properly.
But at least we'll be notified allowing us to _do_ these kind of test.
ATM we don't really have a chance to do that.

I'm very willing to look at SRP to see if we can improve things there.

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
