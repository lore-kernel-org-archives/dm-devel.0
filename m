From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH][RESEND] multipath: check if a device belongs
 to multipath
Date: Mon, 20 Aug 2012 14:15:21 +0200
Message-ID: <50322A59.5080209@suse.de>
References: <20120727205524.GJ5299@ether.msp.redhat.com>
	<1345234390.12286.9.camel@lapoo.opensvc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1345234390.12286.9.camel@lapoo.opensvc.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: christophe.varoqui@opensvc.com, device-mapper development <dm-devel@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

On 08/17/2012 10:13 PM, Christophe Varoqui wrote:
> On ven., 2012-07-27 at 15:55 -0500, Benjamin Marzinski wrote:
>> This patch adds a new multipath option "-c", which checks if a device
>> belongs to multipath.  This can be done during the add uevent for the
>> device, before the multipath device has even been created.  This allows
>> udev to be able to handle multipath path devices differently.  To do
>> this multipath now keeps track of the wwids of all previously created
>> multipath devices in /etc/multipath/wwids. The file creating and
>> editting code from alias.[ch] has been split out into file.[ch]. When a
>> device is checked to see if it's a multipath path, it's wwid is
>> compared against the ones in the wwids file. Also, since the
>> uid_attribute may not have been added to the udev database entry for
>> the device if this is called in a udev rule, when using the "-c" option,
>> get_uid will now also check the process' envirionment variables for the
>> uid_attribute.
>>
> I'd like other distribution maintainers' comments on this one, as it
> impacts the multipath-tools intregration with udev.
> =

> Hannes ? Did you face the same issue with SuSE ? Did you solve it
> differently ?
> =

No; currently I didn't solve it at all, what with me being tied up
with customer issues :-(

But this is basically the approach I've discussed with Harald Hoyer
and Kay Sievers on how we should facilitate proper systemd integration.

The idea here is to have a udev rule calling 'multipath -c' via
PROGRAM, so that udev can detect if a device should've been handled
via multipath.
Which would allow any rules following that one to evaluate this
status and possibly skip the device.

So from that perspective the patch should be okay.

However, the one thing to note is this patch _again_ is using
hard-coded filenames under /etc, which really shouldn't happen.
We should be introducing a configuration file variable to set it.

> Ben, does this approach supersedes/extends the "complicated blacklisting
> scheme" you proposed earlier ?
> =

I sincerely hope so ...

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
