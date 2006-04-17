From: =?ISO-8859-1?Q?Roger_H=E5kansson?= <hson@ludd.luth.se>
Subject: Re: Problems with multipathing
Date: Mon, 17 Apr 2006 02:35:57 +0200
Message-ID: <4442E2ED.7020405@ludd.luth.se>
References: <443BF12E.50900@ludd.luth.se>	<443BF87A.10804@free.fr>	<443C19E6.8000607@ludd.luth.se>	<443E870E.1070902@ludd.luth.se>
	<443EB907.1070600@free.fr>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <443EB907.1070600@free.fr>
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

Christophe Varoqui wrote:
> > I don't know your hardware (vendor = IFT, product = A16F-R2221)

http://www.infortrend.com/main/2_product/a16f-r2221.asp

> > but it seems assymmetrical.

I guess that you with "asymmetrical" means that paths are only presented
on one controller at a time, more on that later.

> > Most hardware in this familly need a hardware
> > handler, and some need the "queue_if_no_path" feature set too.
> >
> > You'll have to find how your array works and try to figure if some
> > existing hardware handler does the good thing.

I've done some testing and it seems that multibus works fine, but when a
controller fails and the secondary controller takes over, the
scsi-devices are seen as "dead" and if I, before multipath determines
both paths to be permanently faulty, do a "echo 1 >
/sys/class/scsi_device/1:0:0:0/device/rescan", multipath will not fail
the device.

So the question is if this is something a hardware_handler could do, and
if so, how hard is it to write such a handler?

> > As a last resort, post the maximum techical details about what  your
> > hardware needs to activate backup paths, and hope that some good soul is
> > willing to code the handler.

Ok, I'll give you as much info as I can (if its of any use is another
thing...).

The "box" has two controllers, which Infortrend calls active-active,
which in this case means that one can create logical drives (and
optionally logical volumes) which are assigned to one of the
controllers, but a logical drive can only be active on one controller at
a time.
The "box" also has two "channels" which are connected to both
controllers, each controller can be assigned multiple "host controller
IDs" on each channel.
"Host controller ID-index" (lowest "host controller id" on primary
controller will have 0, next 1.. to N, lowest on secondary will have N+1
and so on) together with some static pieces (MAC-address) form the WWNN,
beginning with 20.
All targets on "channel 0" will have WWPN beginning with 21 and the rest
identical to the WWNN, targets on "channel 1" begin with 22.

When a controller fails, the other one takes over all logical drives,
LUNs, WWNN and WWPN.

Another thing which I don't know if its important or not, but the "box"
have four fysical SFP-ports which can be configured in two ways, either
in "hubbed mode" where two are "hubbed" together on one "channel" on
both controllers and the other two on the other channel, or "non-hubbed
mode" where each port are staticly bound to a specific "channel" on a
specific controller.
As far as I've been able to tell, there is no difference in behaviour
between hubbed/non-hubbed mode
