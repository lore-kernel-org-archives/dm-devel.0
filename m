From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH v2 45/72] libmultipath: fix -Wsign-compare
 warnings with snprintf()
Date: Thu, 24 Oct 2019 19:51:43 -0700
Message-ID: <26742e32-731b-f62b-a230-f41d0ee67da9@acm.org>
References: <20191024150556.19575-1-martin.wilck@suse.com>
	<20191024150556.19575-2-martin.wilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20191024150556.19575-2-martin.wilck@suse.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Wilck <Martin.Wilck@suse.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>, Bart Van Assche <Bart.VanAssche@sandisk.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 2019-10-24 08:06, Martin Wilck wrote:
> +#define safe_snprintf(var, size, format, args...)=09=09=09\
> +=09({=09=09=09=09=09=09=09=09\
> +=09=09size_t __size =3D size;=09=09=09=09=09\
> +=09=09int __ret;=09=09=09=09=09=09\
> +=09=09=09=09=09=09=09=09=09\
> +=09=09__ret =3D snprintf(var, size, format, ##args);=09=09\
> +=09=09__ret < 0 || (size_t)__ret >=3D __size;=09=09=09\
> +=09})

How about adding a comment that explains the meaning of the returned
value? Otherwise this patch looks fine to me. Thank you for having done
this rework.

Bart.
