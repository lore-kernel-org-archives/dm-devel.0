From: Martin Wilck <Martin.Wilck@suse.com>
Subject: Re: [PATCH v2 12/17] libmultipath: change failed path
	prio timeout
Date: Mon, 10 Feb 2020 14:51:52 +0000
Message-ID: <c852ad0717dd51caf3161aa283b0e93059cdebfc.camel@suse.com>
References: <1580929100-32572-1-git-send-email-bmarzins@redhat.com>
	<1580929100-32572-13-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1580929100-32572-13-git-send-email-bmarzins@redhat.com>
Content-Language: en-US
Content-ID: <B179715B43A315439BF9DCF449D8F06B@namprd18.prod.outlook.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "bmarzins@redhat.com" <bmarzins@redhat.com>, "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Wed, 2020-02-05 at 12:58 -0600, Benjamin Marzinski wrote:
> multipath will try to get the priority from a PATH_DOWN path, if the
> path doesn't currently have a valid priority. However, if the
> priority
> code needs to contact the device to get the priority, this is likely
> to
> fail for PATH_DOWN paths.  This code dates back to when multipathd
> could
> not easily reload device tables with failed paths, so getting the
> correct priority was important to have a correctly configured device.
> Now multipathd can simply reload the device to move the path to the
> correct pathgroup when the path comes back up.  Since there are a
> number
> of prioritizers that don't require talking to the device, multipath
> shouldn't completely skip attempting to get the priority of these
> paths,
> but it should set a small timeout, so that it isn't hanging in the
> case where it needs to contact a device through a failed path.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  libmultipath/discovery.c | 14 ++++++--------
>  libmultipath/prio.c      |  6 +++---
>  2 files changed, 9 insertions(+), 11 deletions(-)

Reviewed-by: Martin Wilck <mwilck@suse.com>

--=20
Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
SUSE  Software Solutions Germany GmbH
HRB 36809, AG N=FCrnberg GF: Felix
Imend=F6rffer
