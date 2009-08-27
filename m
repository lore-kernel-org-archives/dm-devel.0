From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Subject: Re: [PATCH 02/24] io-controller: Core of the elevator fair queuing
Date: Thu, 27 Aug 2009 10:49:40 +0800
Message-ID: <4A95F444.9040705@cn.fujitsu.com>
References: <1250451046-9966-1-git-send-email-vgoyal@redhat.com> <1250451046-9966-3-git-send-email-vgoyal@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1751718AbZH0Cut@vger.kernel.org>
In-Reply-To: <1250451046-9966-3-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, dm-devel@redhat.com, jens.axboe@oracle.com, ryov@valinux.co.jp, balbir@linux.vnet.ibm.com, righi.andrea@gmail.com, nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp, jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, m-ikeda@ds.jp.nec.com, agk@redhat.com, akpm@linux-foundation.org, peterz@infradead.org, jmarchan@redhat.com
List-Id: dm-devel.ids

Vivek Goyal wrote:
=2E..
> +static void update_min_vdisktime(struct io_service_tree *st)
> +{
> +	u64 vdisktime;
> +
> +	if (st->active_entity)
> +		vdisktime =3D st->active_entity->vdisktime;
> +
> +	if (st->rb_leftmost) {
> +		struct io_entity *entity =3D rb_entry(st->rb_leftmost,
> +						struct io_entity, rb_node);
> +
> +		if (!st->active_entity)
> +			vdisktime =3D entity->vdisktime;
> +		else
> +			vdisktime =3D min_vdisktime(vdisktime, entity->vdisktime);
> +	}
> +
> +	st->min_vdisktime =3D max_vdisktime(st->min_vdisktime, vdisktime);
> +}

block/elevator-fq.c: In function =E2=80=98elv_ioq_slice_expired=E2=80=99=
:
block/elevator-fq.c:132: warning: =E2=80=98vdisktime=E2=80=99 may be us=
ed uninitialized in this function
LD      block/built-in.o

We'd better initialize vdisktime at first.

Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
---
 block/elevator-fq.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/block/elevator-fq.c b/block/elevator-fq.c
index d04e925..a4161c2 100644
--- a/block/elevator-fq.c
+++ b/block/elevator-fq.c
@@ -131,6 +131,8 @@ static void update_min_vdisktime(struct io_service_=
tree *st)
 {
 	u64 vdisktime;
=20
+	vdisktime =3D st->min_vdisktime;
+
 	if (st->active_entity)
 		vdisktime =3D st->active_entity->vdisktime;
=20
--=20
1.5.4.rc3
