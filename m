From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2] multipath: enable getting uevents through
 libudev
Date: Mon, 16 Apr 2012 08:44:53 +0200
Message-ID: <4F8BBFE5.3090907@suse.de>
References: <20120410040154.GT1241@ether.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20120410040154.GT1241@ether.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

On 04/10/2012 06:01 AM, Benjamin Marzinski wrote:
> udev is removing support for RUN+=3D"socket:..." rules. For now, I've kept
> all the existing uevent code, but I've added a new method for getting the
> uevent information using libudev that will be tried first.  =

> =

> This version includes more error checking.
> =

Thanks for this. Based on this I did a patchset for replacing the
hand-crafted sysfs code in multipath with calls to libudev.

Will be sending out the patches soon.

(Just as a heads up. so as to spare you some effort :-)

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
