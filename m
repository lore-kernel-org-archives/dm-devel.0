From: Markus Elfring <Markus.Elfring@web.de>
Subject: Re: [PATCH] dm raid1: Use struct_size() in kzalloc()
Date: Tue, 6 Aug 2019 14:45:30 +0200
Message-ID: <a6b3127e-11cb-4dc8-7db8-e526521d11d9@web.de>
References: <20190806001825.GA6854@embeddedor>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190806001825.GA6854@embeddedor>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org, Colin Ian King <colin.king@canonical.com>
List-Id: dm-devel.ids

> +++ b/drivers/md/dm-raid1.c
> @@ -878,12 +878,9 @@ static struct mirror_set *alloc_context(unsigned in=
t nr_mirrors,
>  					struct dm_target *ti,
>  					struct dm_dirty_log *dl)
>  {
> -	size_t len;
>  	struct mirror_set *ms =3D NULL;
=E2=80=A6

How do you think about to replace the initialisation =E2=80=9CNULL=E2=80=
=9D by the desired function call?

Regards,
Markus
