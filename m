From: Hannes Reinecke <hare@suse.de>
Subject: Re: New multipath-tools release?
Date: Mon, 30 Jul 2007 16:49:07 +0200
Message-ID: <46ADFA63.9020403@suse.de>
References: <46A72D1B.1040408@suse.de> <20070728161353.GA21276@bogon.ms20.nix>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20070728161353.GA21276@bogon.ms20.nix>
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
Cc: christophe varoqui <christophe.varoqui@free.fr>
List-Id: dm-devel.ids

Guido Guenther wrote:
> Hi Christophe,
> On Wed, Jul 25, 2007 at 12:59:39PM +0200, Hannes Reinecke wrote:
>> Hi Christophe,
>>
>> whenever a device is finally removed from a multipath map we should
>> also remove it from the sysfs cache. Otherwise we'll hogging up memory
>> with multipathd. And we might rely on wrong information as the device
>> in the sysfs cache might in fact be a different device if the system
>> decided to assign the same number to a different device or if some
>> values have changed.
> Now with this fix in, would it make any sense to tag a 0.4.8-rc1? The
> last multipath-tools release has been about a year ago and it would
> really be nice to have a new release, so there's a new base to diff
> against.

In priciple a good idea. However, I do have some to-do items on my list
yet:

- netlink messages: The FC transport class has a netlink interface
  nowadays. It may be an idea to utilize this information in to update
  the path status.
- Enhance path checker. Currently the path checker is run at periodic
  intervals regardless of the path state. This leads to quite some
  load on systems with many paths, even when all paths are healthy.
  We should rather call the path checker only if a path has failed,
  as we're being notified by a failed path soon enough via I/O errors.
  And we might even be using the netlink events from FC here, too.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
