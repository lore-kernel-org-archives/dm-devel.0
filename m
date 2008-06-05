From: "Craig Simpson" <csimpson@visto.com>
Subject: RE: simple question... to tough to answer?
Date: Thu, 5 Jun 2008 12:06:46 -0700
Message-ID: <ABFD05FF09D13E4883B757E75603624D011E9889@ex-sea1.vistocorp.com>
References: <7BC3A7DB53028743B733D298244A8C626E3A0D@sjcpexch02.citrite.net><482D6DB1.5080709@suse.de>
	<20080516152707.GA24657@linux.vnet.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <20080516152707.GA24657@linux.vnet.ibm.com>
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


By chance does anyone have a working configuration of some example of
this working?

I am not so interested in a SNMP trap. But if I could have it email/page
me, now that would rock.=20

Craig

-----Original Message-----
From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com]
On Behalf Of Mike Anderson
Sent: Friday, May 16, 2008 8:27 AM
To: device-mapper development
Subject: Re: [dm-devel] simple question... to tough to answer?

Hannes Reinecke <hare@suse.de> wrote:
> Hi Wim,
>
> Wim Colgate wrote:
>> Hi,
>>
>> I???m not quite sure why no one in the community hasn???t been able
to=20
>> answer my questions.
>>
>> Simply (re)stated:
>>
>> 1) Are there hooks for dm/multipath events to notify software?
>>
> Yes. There is the general dm_event mechanism (which I wouldn't
recommend)
> or with newer kernels you'll get netlink events from multipath for any
> path-related events.
>

You can look at the documentation in recent kernels trees to get an
example of the event attributes provided with each event using the
uevent interface: Documentation/device-mapper/dm-uevent.txt

>> 2) does path down/up fire up udev rules?
>>
> Not as such. As stated above we should be sending out netlink events
for
> path up/down events, but to my knowledge no-one is taking advantage
> of them. Certainly not udev in its default setting nor multipath.

One should note that if using the the current git version of the
multipath
tools and one wants to experiment with additional events one would need
to
add a udev rule "(i.e., RUN+=3D"socket:...") You can reference this
previous
email for context.
http://article.gmane.org/gmane.linux.scsi/36165

On some what related note. With all the work around making sure we can
run
in low memory situations we should make a choice to use raw netlink
interface or the udev abstract namespace socket.

-andmike
--
Michael Anderson
andmike@linux.vnet.ibm.com

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
