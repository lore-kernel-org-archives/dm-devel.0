From: Guido Guenther <agx@sigxcpu.org>
Subject: New multipath-tools release?
Date: Sat, 28 Jul 2007 18:13:53 +0200
Message-ID: <20070728161353.GA21276@bogon.ms20.nix>
References: <46A72D1B.1040408@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <46A72D1B.1040408@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: christophe varoqui <christophe.varoqui@free.fr>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi Christophe,
On Wed, Jul 25, 2007 at 12:59:39PM +0200, Hannes Reinecke wrote:
> Hi Christophe,
> 
> whenever a device is finally removed from a multipath map we should also remove it from the sysfs cache. Otherwise we'll hogging up memory with multipathd. And we might rely on wrong information as the device in the sysfs cache might in fact be a different device if the system decided to assign the same number to a different device or if some values have changed.
Now with this fix in, would it make any sense to tag a 0.4.8-rc1? The
last multipath-tools release has been about a year ago and it would
really be nice to have a new release, so there's a new base to diff
against.
Cheers,
 -- Guido
