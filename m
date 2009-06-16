From: Divyesh Shah <dpshah@google.com>
Subject: Re: [PATCH 02/19] io-controller: Common flat fair queuing code in
	elevaotor layer
Date: Tue, 16 Jun 2009 12:44:58 -0700
Message-ID: <af41c7c40906161244q61fd47c5u1a10243c8839938@mail.gmail.com>
References: <1244513342-11758-1-git-send-email-vgoyal@redhat.com>
	<1244513342-11758-3-git-send-email-vgoyal@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1761976AbZFPTph@vger.kernel.org>
In-Reply-To: <1244513342-11758-3-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, dm-devel@redhat.com, jens.axboe@oracle.com, nauman@google.com, lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it, ryov@valinux.co.jp, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp, guijianfeng@cn.fujitsu.com, jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com, righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, jbaron@redhat.com, agk@redhat.com, snitzer@redhat.com, akpm@linux-foundation.org, peterz@infradead.org
List-Id: dm-devel.ids

On Mon, Jun 8, 2009 at 7:08 PM, Vivek Goyal<vgoyal@redhat.com> wrote:
> void elv_deactivate_ioq(struct elv_fq_data *efqd, struct io_queue *io=
q,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 int requeue)
> +{
> + =A0 =A0 =A0 if (ioq =3D=3D efqd->active_queue)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 elv_reset_active_ioq(efqd);
> +
> + =A0 =A0 =A0 bfq_deactivate_entity(&ioq->entity, requeue);
> +}

The check for ioq =3D=3D efqd->active_queue and the call to
elv_reset_active_ioq() seem to be unnecessary. This gets called from
elv_del_ioq_busy() which has 2 callers which:
- either explicitly check for ioq !=3D efqd->active_queue
- or call elv_reset_active_ioq() right before invoking this function

This was needed earlier as the io_ioq_move() function didn't fall in
one of the 2 categories above. This has been done away with the ref
counting patch, AFAICT.

-Divyesh
