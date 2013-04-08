From: neha naik <nehanaik27@gmail.com>
Subject: Performance of passthrough block device driver is low
 for reads compared to writes
Date: Mon, 8 Apr 2013 16:55:31 -0600
Message-ID: <CAOb=_xLD0j_VUA8FLm7MPrP0MKSuvUFsXeJkdYKYNNTJFyEpEg@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============5747757075339346374=="
Return-path: <dm-devel-bounces@redhat.com>
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

--===============5747757075339346374==
Content-Type: multipart/alternative; boundary=047d7b4147b47ac91e04d9e155c3

--047d7b4147b47ac91e04d9e155c3
Content-Type: text/plain; charset=ISO-8859-1

Hi All,
   If this is the wrong mailing list to ask my questions then i am sorry
and tell me where i should post them.
I have written a passthrough block device driver using 'make_request' call.
This block device driver simply passes any request that comes to it down to
lvm.

However, the read performance for my passthrough driver is around 65MB/s
(measured through dd) and write performance is around 140MB/s for dd block
size 4096.
The write performance matches with lvm's write performance more or less
but, the read performance on lvm is around 365MB/s.

I am posting snippets of code which i think are relevant here:

static int passthrough_make_request(struct request_queue * queue, struct
bio * bio)
{

        passthrough_device_t * passdev = queue->queuedata;
        bio->bi_bdev = passdev->bdev_backing;
        generic_make_request(bio);
        return 0;
}

For initializing the queue i am using following:

blk_queue_make_request(passdev->queue, passthrough_make_request);
passdev->queue->queuedata = sbd;
passdev->queue->unplug_fn = NULL;
bdev_backing = passdev->bdev_backing;
blk_queue_stack_limits(passdev->queue, bdev_get_queue(bdev_backing));
if ((bdev_get_queue(bdev_backing))->merge_bvec_fn) {
        blk_queue_merge_bvec(sbd->queue, sbd_merge_bvec_fn);
}

Now, I browsed through dm code in kernel to see if there is some flag or
something which i am not using which is causing this huge performance
penalty.
But, I have not found anything.

If you have any ideas about what i am possibly doing wrong then please tell
me.

Thanks in advance.

Regards,
Neha

--047d7b4147b47ac91e04d9e155c3
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi All,<br>=A0=A0 If this is the wrong mailing list to ask my questions the=
n i am sorry and tell me where i should post them.<br>I have written a pass=
through block device driver using &#39;make_request&#39; call. This block d=
evice driver simply passes any request that comes to it down to lvm.<br>
<br>However, the read performance for my passthrough driver is around 65MB/=
s (measured through dd) and write performance is around 140MB/s for dd bloc=
k size 4096.<br>The write performance matches with lvm&#39;s write performa=
nce more or less but, the read performance on lvm is around 365MB/s.<br>
<br>I am posting snippets of code which i think are relevant here:<br><br>s=
tatic int passthrough_make_request(struct request_queue * queue, struct bio=
 * bio)<br>{<br><br>=A0=A0=A0=A0=A0=A0=A0 passthrough_device_t * passdev =
=3D queue-&gt;queuedata;<br>
=A0=A0=A0=A0=A0=A0=A0 bio-&gt;bi_bdev =3D passdev-&gt;bdev_backing;<br>=A0=
=A0=A0=A0=A0=A0=A0 generic_make_request(bio);<br>=A0=A0=A0=A0=A0=A0=A0 retu=
rn 0;<br>}<br><br>For initializing the queue i am using following:<br><br>b=
lk_queue_make_request(passdev-&gt;queue, passthrough_make_request);<br>
passdev-&gt;queue-&gt;queuedata =3D sbd;<br>passdev-&gt;queue-&gt;unplug_fn=
 =3D NULL;<br>bdev_backing =3D passdev-&gt;bdev_backing;<br>blk_queue_stack=
_limits(passdev-&gt;queue, bdev_get_queue(bdev_backing));<br>if ((bdev_get_=
queue(bdev_backing))-&gt;merge_bvec_fn) {<br>
=A0=A0=A0=A0=A0=A0=A0 blk_queue_merge_bvec(sbd-&gt;queue, sbd_merge_bvec_fn=
);<br>}<br><br>Now, I browsed through dm code in kernel to see if there is =
some flag or something which i am not using which is causing this huge perf=
ormance penalty.<br>
But, I have not found anything.<br><br>If you have any ideas about what i a=
m possibly doing wrong then please tell me.<br><br>Thanks in advance.<br><b=
r>Regards,<br>Neha<br>

--047d7b4147b47ac91e04d9e155c3--


--===============5747757075339346374==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============5747757075339346374==--
