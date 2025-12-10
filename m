Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1F4A25F988
	for <dm-devel@lists.linux.dev>; Wed, 10 Dec 2025 02:26:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765333590; cv=pass; b=OBx+nRZpwgKVCzy5qGc5SZbby6S5p+O/BR8x/ma6pZNiWbtrkIzq729kv6gpYqbzKxTVSi4NJLdn8u8YRl8gE0XQ/M49FZif2dRkST6XoWkBg1ttg/tgUfMOpaP0QFImsQ9K2z9yqtvMZjxacEHv6dQcSkiI+Gy2n0a/SHWoQck=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765333590; c=relaxed/simple;
	bh=V0OIYXAGzwC4Tog3CYY65G2nfhUJ5RfyokwxHZad4hI=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 MIME-Version:Content-Type; b=YncgCAOMqYFmi2E5kKKAtOFxwVE0hzlyOfcStGVb+ivINTzP0q/Mv9X5yv+Y0bvXYhZKvYvCtgKFInWJqYGcympwgPYjyRkXaVpry5BLMXd19pU0LtKmZNvwyFx5DoID82ShKVv7vEvc1WtCWNYKbIhL/C7bzuB8FGYqAP9M7S0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=EV1Hawy7; arc=pass smtp.client-ip=136.143.188.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux.beauty
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.beauty
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b="EV1Hawy7"
ARC-Seal: i=1; a=rsa-sha256; t=1765333586; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=N0H/xv7pDIWFjfDDCnEnwi3ZB1ftXNn9poAZfxuO+TEbNjZeV8m9HPM8b0A5cKk08fHh7b1OlAsIjDZjX/74gPHelJv3fwYJjwryXVnrhnW7EBsiDYzsRWBvK3QC7x9QAsypdD0RcosocMVUDUILMy7hSxURVv/06HefYjqTPqY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1765333586; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=+vXQOpz2PKNdr32G1KBvoHRl20zslOhskAzh0kGAvyk=; 
	b=T7DyLjTHRsDj5qxnBYFeoYzvF+35pWAnQa7cWH0AyZnzy/Hqh1InOZvRYUCPwYj2Lt8TI9NPsjJIKxtpC+VeANYbN2cQNQUcowZiO+yQBrzZe95EpsXxdOCpArPJ/R7U2K8E4PpGD/8zwQPzLkowzyvqIWg8h89/glQ0hnNgNXo=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1765333586;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=Date:Date:From:From:To:To:Cc:Cc:Message-ID:In-Reply-To:References:Subject:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=+vXQOpz2PKNdr32G1KBvoHRl20zslOhskAzh0kGAvyk=;
	b=EV1Hawy7OXtrypKHwcBIKngcf35Pc6j/OQWmcwvLq5zp20I0YwUFdRDVOjZpMxox
	plovFdZsCunM2m0IgZdKMSoewaoNW+XP4eDEmP7/0GrzthEYG9w99N+0HbpDu+Xcvh+
	B0CfXsT+zqOxlFjW6+obBI5ORzBGQMWSW6EozQMg=
Received: from mail.zoho.com by mx.zohomail.com
	with SMTP id 17653335844720.8870215287477095; Tue, 9 Dec 2025 18:26:24 -0800 (PST)
Date: Wed, 10 Dec 2025 10:26:24 +0800
From: Li Chen <me@linux.beauty>
To: "Dongsheng Yang" <dongsheng.yang@linux.dev>
Cc: "dm-devel" <dm-devel@lists.linux.dev>,
	"linux-kernel" <linux-kernel@vger.kernel.org>,
	"Zheng Gu" <cengku@gmail.com>,
	"Mikulas Patocka" <mpatocka@redhat.com>
Message-ID: <19b0614ca46.65ed8ae3522798.9016216162556753318@linux.beauty>
In-Reply-To: <562c7d90-7c8b-46ef-b01f-561d86c722b4@linux.dev>
References: <20251208112552.147756-1-me@linux.beauty> <562c7d90-7c8b-46ef-b01f-561d86c722b4@linux.dev>
Subject: Re: [PATCH] dm pcache: reject mappings larger than backing
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Importance: Medium
User-Agent: Zoho Mail
X-Mailer: Zoho Mail

Hi Dongsheng,

Thanks for your quick reply.
 ---- On Mon, 08 Dec 2025 19:44:40 +0800  Dongsheng Yang <dongsheng.yang@li=
nux.dev> wrote ---=20
 >=20
 > =E5=9C=A8 12/8/2025 7:25 PM, Li Chen =E5=86=99=E9=81=93:
 > > Reject pcache targets whose logical size exceeds the backing device.
 > > Prevent oversized tables from issuing IO past the end of the backing,
 > > which may corrupt memory and cause kernel crash.
 > >
 > > Signed-off-by: Li Chen <me@linux.beauty>
 > > ---
 > >   drivers/md/dm-pcache/dm_pcache.c | 15 +++++++++++++++
 > >   1 file changed, 15 insertions(+)
 > >
 > > diff --git a/drivers/md/dm-pcache/dm_pcache.c b/drivers/md/dm-pcache/d=
m_pcache.c
 > > index e5f5936fa6f0..f72d1ba4b740 100644
 > > --- a/drivers/md/dm-pcache/dm_pcache.c
 > > +++ b/drivers/md/dm-pcache/dm_pcache.c
 > > @@ -199,6 +199,8 @@ static int parse_cache_opts(struct dm_pcache *pcac=
he, struct dm_arg_set *as,
 > >   static int pcache_start(struct dm_pcache *pcache, char **error)
 > >   {
 > >       int ret;
 > > +    struct dm_target *ti =3D pcache->ti;
 > > +    struct pcache_backing_dev *backing_dev;
 > >  =20
 > >       ret =3D cache_dev_start(pcache);
 > >       if (ret) {
 > > @@ -212,6 +214,19 @@ static int pcache_start(struct dm_pcache *pcache,=
 char **error)
 > >           goto stop_cache;
 > >       }
 > >  =20
 > > +    /* Sanity-check: logical size must not exceed backing device size=
 */
 > > +    backing_dev =3D &pcache->backing_dev;
 > > +    if (ti->len > backing_dev->dev_size) {
 > > +        pcache_dev_err(
 > > +            pcache,
 > > +            "backing device too small: logical=3D%llu sectors, backin=
g=3D%llu sectors",
 > > +            (unsigned long long)ti->len,
 > > +            (unsigned long long)backing_dev->dev_size);
 > > +        *error =3D "Requested mapping exceeds backing device size";
 > > +        ret =3D -EINVAL;
 > > +        goto stop_backing;
 > > +    }
 > > +
 >=20
 >=20
 > Thanx for your patch, When developing dm-pcache, I considered whether to=
=20
 > add a check there (for target size vs backing device size). But after=20
 > looking at other existing targets, it seems none of them implement such=
=20
 > a check, so I wasn't sure there is a requirement; hence I didn't add it=
=20
 > at that time.

 I did a quick search and found some examples:
https://github.com/torvalds/linux/blob/c9b47175e9131118e6f221cc8fb81397d62e=
7c91/drivers/md/dm-cache-target.c#L2117
https://github.com/torvalds/linux/blob/c9b47175e9131118e6f221cc8fb81397d62e=
7c91/drivers/md/dm-verity-target.c#L1416
https://github.com/torvalds/linux/blob/c9b47175e9131118e6f221cc8fb81397d62e=
7c91/drivers/md/dm-integrity.c#L5166

 > On the other hand, given that the =E2=80=9Ctarget size=E2=80=9D paramete=
r in the mapping=20
 > table is a generic parameter, if we want such a check, it would be=20
 > better to implement a generic mechanism in the Device-Mapper core=20
 > construction path =E2=80=94 provide a hook that allows every target to r=
eturn a=20
 > =E2=80=9Cmaximum creatable target size=E2=80=9D, and then in the core pa=
th validate the=20
 > user-provided target size against that max size before creation.
 >=20
 > That is just my personal idea; I hope Mikulas can provide more=20
 > information about it.

I just found a common helper called device_area_is_invalid check, already u=
sed within target_type->iterate_devices, validates target size.=20
Therefore, targets implementing iterate_devices can perform size validation=
. I confirmed this with a quick test:

modified   drivers/md/dm-pcache/dm_pcache.c
@@ -446,6 +446,15 @@ static int dm_pcache_message(struct dm_target *ti, uns=
igned int argc,
 =09return -EINVAL;
 }
=20
+static int pcache_iterate_devices(struct dm_target *ti,
+=09=09=09=09  iterate_devices_callout_fn fn, void *data)
+{
+=09struct dm_pcache *pcache =3D ti->private;
+=09struct pcache_backing_dev *backing_dev =3D &pcache->backing_dev;
+
+=09return fn(ti, backing_dev->dm_dev, 0, ti->len, data);
+}
+
 static struct target_type dm_pcache_target =3D {
 =09.name=09=09=3D "pcache",
 =09.version=09=3D {0, 1, 0},
@@ -456,6 +465,7 @@ static struct target_type dm_pcache_target =3D {
 =09.map=09=09=3D dm_pcache_map_bio,
 =09.status=09=09=3D dm_pcache_status,
 =09.message=09=3D dm_pcache_message,
+=09.iterate_devices =3D pcache_iterate_devices,
 };
=20
 static int __init dm_pcache_init(void)

And it is rejected as expected too:

```
root@localhost ~# dmsetup create pcache_vdb --table \
                                                                           =
                   "0 31457284 pcache /dev/pmem0 /dev/vdb 4 cache_mode writ=
eback data_crc false"
device-mapper: reload ioctl on pcache_vdb (253:0) failed: Invalid argument
Complete cookie 0xd4d9a60 success.
Complete cookie 0xd4d9a60 success.
Command failed.
root@localhost ~ [1]# dmesg | tail
[    1.937147] EXT4-fs (vda2): re-mounted dc39223f-5278-4b19-80bc-de1edf4a5=
a96 r/w.
[    1.941399] systemd-journald[166]: Received client request to flush runt=
ime journal.
[    2.051496] virtio_net virtio0 enp0s3: renamed from eth0
[    2.253929] FAT-fs (vda1): Volume was not properly unmounted. Some data =
may be corrupt. Please run fsck.
[    2.395796] tsc: Refined TSC clocksource calibration: 3792.905 MHz
[    2.395834] clocksource: tsc: mask: 0xffffffffffffffff max_cycles: 0x6d5=
85308801, max_idle_ns: 881590710907 ns
[    2.396195] clocksource: Switched to clocksource tsc
[  175.269911] device-mapper: table: 253:0: vdb too small for target: start=
=3D0, len=3D31457284, dev_size=3D31457280
[  175.271582] device-mapper: core: Cannot calculate initial queue limits
[  175.272688] device-mapper: ioctl: unable to set up device queue for new =
table.
```

Which do you prefer: pcache_iterate_devices or checking in parse_cache_opts=
? Thanks.

Li=E2=80=8B

