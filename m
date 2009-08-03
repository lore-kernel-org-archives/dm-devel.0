From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Subject: Re: [PATCH 20/25] io-controller: map async requests to
 appropriate cgroup
Date: Mon, 03 Aug 2009 10:13:46 +0800
Message-ID: <4A7647DA.5050607@cn.fujitsu.com>
References: <1246564917-19603-1-git-send-email-vgoyal@redhat.com>
	<1246564917-19603-21-git-send-email-vgoyal@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1246564917-19603-21-git-send-email-vgoyal@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Vivek Goyal <vgoyal@redhat.com>
Cc: dhaval@linux.vnet.ibm.com, snitzer@redhat.com, peterz@infradead.org, dm-devel@redhat.com, dpshah@google.com, jens.axboe@oracle.com, agk@redhat.com, balbir@linux.vnet.ibm.com, paolo.valente@unimore.it, fernando@oss.ntt.co.jp, mikew@google.com, jmoyer@redhat.com, nauman@google.com, m-ikeda@ds.jp.nec.com, lizf@cn.fujitsu.com, fchecconi@gmail.com, akpm@linux-foundation.org, jbaron@redhat.com, linux-kernel@vger.kernel.org, s-uchida@ap.jp.nec.com, righi.andrea@gmail.com, containers@lists.linux-foundation.org
List-Id: dm-devel.ids

Vivek Goyal wrote:
...
> +
> +struct io_group *io_get_io_group_bio(struct request_queue *q, struct b=
io *bio,
> +					int create)
> +{
> +	struct page *page =3D NULL;
> +
> +	/*
> +	 * Determine the group from task context. Even calls from
> +	 * blk_get_request() which don't have any bio info will be mapped
> +	 * to the task's group
> +	 */
> +	if (!bio)
> +		goto sync;
> +
> +	if (bio_barrier(bio)) {
> +		/*
> +		 * Map barrier requests to root group. May be more special
> +		 * bio cases should come here
> +		 */
> +		return q->elevator->efqd.root_group;
> +	}
> +
> +	/* Map the sync bio to the right group using task context */
> +	if (elv_bio_sync(bio))
> +		goto sync;
> +
> +#ifdef CONFIG_TRACK_ASYNC_CONTEXT
> +	/* Determine the group from info stored in page */
> +	page =3D bio_iovec_idx(bio, 0)->bv_page;
> +	return io_get_io_group(q, page, create);
> +#endif
> +
> +sync:
> +	return io_get_io_group(q, NULL, create);

Fix build warning.

block/elevator-fq.c: In function =E2=80=98io_get_io_group_bio=E2=80=99:
block/elevator-fq.c:2075: warning: unused variable =E2=80=98page=E2=80=99

---
diff --git a/block/elevator-fq.c b/block/elevator-fq.c
index 66b10eb..d304f79 100644
--- a/block/elevator-fq.c
+++ b/block/elevator-fq.c
@@ -2102,7 +2102,7 @@ struct io_group *io_get_io_group_bio(struct request=
_queue *q, struct bio *bio,
 #endif
=20
 sync:
-	return io_get_io_group(q, NULL, create);
+	return io_get_io_group(q, page, create);
 }
 EXPORT_SYMBOL(io_get_io_group_bio);


> +}
> +EXPORT_SYMBOL(io_get_io_group_bio);
> +


--=20
Regards
Gui Jianfeng
