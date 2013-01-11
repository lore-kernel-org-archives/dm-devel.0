From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2] multipath: make devt2devname use lstat to
 check sysfs	links
Date: Fri, 11 Jan 2013 08:01:17 +0100
Message-ID: <50EFB8BD.7000501@suse.de>
References: <20130110200619.GP19059@ether.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"; Format="flowed"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20130110200619.GP19059@ether.msp.redhat.com>
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

On 01/10/2013 09:06 PM, Benjamin Marzinski wrote:
> dm_reassign wasn't working correctly for me because devt2devname used sta=
t()
> to check if /sys/dev/block/major:minor was a symlink.  But stat() never r=
eturns
> a symlink, if follows it. It needs to use lstat() instead.  Also, I made
> multipath log a message when a dm device gets reassigned to use multipath.
>
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Acked-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
