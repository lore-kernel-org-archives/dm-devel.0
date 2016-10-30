From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 03/10] do not allow in-use path to change wwid
Date: Sun, 30 Oct 2016 14:45:01 +0100
Message-ID: <04fc0201-86a7-d83c-f2dd-5b24e6393a64@suse.de>
References: <1477709726-5442-1-git-send-email-bmarzins@redhat.com>
	<1477709726-5442-4-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; Format="flowed"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1477709726-5442-4-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, Benjamin Marzinski <bmarzins@redhat.com>
List-Id: dm-devel.ids

On 10/29/2016 04:55 AM, Benjamin Marzinski wrote:
> When a path is part of a multipath device, it must not change it's wwid.
> If it can, when multipathd is reconfigured, you can end up with two
> multipath devices owning the same path, eventually leading to a crash.
>
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  libmultipath/dmparser.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
>
Hmm. While I do see that this is an issue, just continuing is probably =

as bad; the wwid change might be genuine, in which case this device has =

no business being part of that particular multipath device.
Can't we just evict that offending path eg by orphaning it and let the =

admin figure things out?

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
