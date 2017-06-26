From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] dm mirror: fix crash caused by NULL-pointer
 dereference
Date: Mon, 26 Jun 2017 11:14:54 +0200
Message-ID: <20170626091454.GA12767@linux-x5ow.site>
References: <20170626090848.21585-1-zren@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20170626090848.21585-1-zren@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Eric Ren <zren@suse.com>
Cc: jtang@suse.com, dm-devel@redhat.com, agk@redhat.com, neilb@suse.com, snitzer@redhat.com
List-Id: dm-devel.ids

On Mon, Jun 26, 2017 at 05:08:48PM +0800, Eric Ren wrote:
> When the primary mirror device fails, activating a mirrored
> LV will crash the kernel. It can be reproduced 100% with the
> scripts below:
> =

> """
> dd if=3D/dev/zero of=3Dfile.raw bs=3D1G count=3D1
> loopdev=3D$(losetup -f)
> losetup $loopdev file.raw
> dmsetup create pv1 --table "0 102399 linear $loopdev 0"
> dmsetup create pv2 --table "0 102399 linear $loopdev 102400"
> vgcreate vgtest /dev/mapper/pv1 /dev/mapper/pv2
> lvcreate -l1 --type mirror -m1 -n mirror12 --mirrorlog core \
>                  vgtest /dev/mapper/pv1 /dev/mapper/pv2
> vgchange -an vgtest
> echo 0 10000000 error | dmsetup load /dev/mapper/pv1
> dmsetup resume /dev/mapper/pv1
> vgchange -ay vgtest
> """

So as you have a reproducer, can you eventually write an blktest [1]
regression test for it?


Thanks,
	Johannes

[1] https://github.com/osandov/blktests

-- =

Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=FCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
