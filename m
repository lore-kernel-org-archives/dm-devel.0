From: "McGreal, Martin (EHQ)" <MMcGreal@express-scripts.com>
Subject: Question about EMC Clariion trespass in multipath
Date: Thu, 22 Oct 2009 13:07:24 -0700
Message-ID: <9083A7B28D088E4ABC0651D61B19F5C207575ED2@mail9.express-scripts.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
content-class: urn:content-classes:message
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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


I've been told that dm multipath does not support trespassing LUNs on
Clariion, but after looking through the hardware handler for EMC
Clariion devices, I believe it does.  However, I'm confused about how it
determines when to issue the trespass command.

Since we are using RHEL 5.3, I am looking at the 2.6.18.8 version of the
hardware handler, dm-emc.c
(http://lxr.linux.no/#linux+v2.6.18.8/drivers/md/dm-emc.c).

Looking at emc_pg_init(), which, according to the documentation, is
called "when a Priority Group is selected for use, but before any I/O is
sent to it" (http://lwn.net/Articles/123134), it looks like the only way
out of this function is by either failing the path via
dm_pg_init_complete(), or issuing a switch-over command.  So either a
path is failed or a trespass occurs every time that a priority group is
selected?  What am I missing here?

Any guidance would be appreciated.

Thanks!
Martin


 192static void emc_pg_init(struct hw_handler *hwh, unsigned bypassed,
 193                        struct path *path)
 194{
 195        struct request *rq;
 196        struct request_queue *q =3D bdev_get_queue(path->dev->bdev);
 197
 198        /*
 199         * We can either blindly init the pg (then look at the
sense),
 200         * or we can send some commands to get the state here (then
 201         * possibly send the fo cmnd), or we can also have the
 202         * initial state passed into us and then get an update here.
 203         */
 204        if (!q) {
 205                DMINFO("emc_pg_init: no queue");
 206                goto fail_path;
 207        }
 208
 209        /* FIXME: The request should be pre-allocated. */
 210        rq =3D emc_trespass_get(hwh->context, path);
 211        if (!rq) {
 212                DMERR("emc_pg_init: no rq");
 213                goto fail_path;
 214        }
 215
 216        DMINFO("emc_pg_init: sending switch-over command");
 217        elv_add_request(q, rq, ELEVATOR_INSERT_FRONT, 1);
 218        return;
 219
 220fail_path:
 221        dm_pg_init_complete(path, MP_FAIL_PATH);
 222}
