Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81B53C433FE
	for <dm-devel@archiver.kernel.org>; Wed, 30 Mar 2022 22:15:40 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-445-firEJg-ENwKfuNGOwrsOqg-1; Wed, 30 Mar 2022 18:15:34 -0400
X-MC-Unique: firEJg-ENwKfuNGOwrsOqg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 90AF5899EDD;
	Wed, 30 Mar 2022 22:15:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7D551590746;
	Wed, 30 Mar 2022 22:15:31 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 312521947BBC;
	Wed, 30 Mar 2022 22:15:31 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id CE4FB19466DF
 for <dm-devel@listman.corp.redhat.com>; Wed, 30 Mar 2022 22:15:29 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A211AC08F23; Wed, 30 Mar 2022 22:15:29 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 9E14EC08F11
 for <dm-devel@redhat.com>; Wed, 30 Mar 2022 22:15:29 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 85848101161B
 for <dm-devel@redhat.com>; Wed, 30 Mar 2022 22:15:29 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-324-5wZEDZ5vOt2usJR0e6lYWQ-1; Wed, 30 Mar 2022 18:15:27 -0400
X-MC-Unique: 5wZEDZ5vOt2usJR0e6lYWQ-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id 20EA81F870;
 Wed, 30 Mar 2022 22:15:26 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id D4D2213AF3;
 Wed, 30 Mar 2022 22:15:25 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id IJrrMX3WRGL8JgAAMHmgww
 (envelope-from <mwilck@suse.com>); Wed, 30 Mar 2022 22:15:25 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Benjamin Marzinski <bmarzins@redhat.com>
Date: Thu, 31 Mar 2022 00:15:04 +0200
Message-Id: <20220330221510.22578-9-mwilck@suse.com>
In-Reply-To: <20220330221510.22578-1-mwilck@suse.com>
References: <20220330221510.22578-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Subject: [dm-devel] [PATCH 08/14] libmultipath: uevent_listen(): don't delay
 uevents
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>, tang.junhui@zte.com.cn
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="===============0382425677569740510=="

--===============0382425677569740510==
Content-Transfer-Encoding: quoted-printable
Content-Type: application/octet-stream; x-default=true

From: Martin Wilck <mwilck@suse.com>

When multipathd starts up early, basically all devices are added
through uevent processing. This takes much more time than necessary
because of the artificial delays introduced for passing uevents
between the listener and the receiver thread in ee8888f
("multipath-tools: improve processing efficiency for addition and deletion =
of
multipath devices"). This delay could be up to 30s.

It's generally not a good idea to delay uevent processing in multipathd.
ADD events must normally be handled ASAP in order to avoid maps entering
queueing mode or eventually failing. Handling REMOVE events quickly is
also important to make multipathd aware of deleted devices and keep
kernel and multipathd state in sync.

If uevents arrive quickly, the assumption is that the dispatcher will proce=
ss
them more slowly than the listener. This was the idea of commit ee8888f,
AFAIU: if a queue of unprocessed events piles up because the dispatcher is
too slow, use filtering and merging to reduce the length of the queue, and
thus the work to be done for the uevent dispatcher, especially the work
that needs to be done while holding the vecs lock. In ee8888f, the
queue was created by allowing uevents to accumulate in the listener.

This patch changes the logic of ee8888f, while keeping the uevent
filtering and discarding features. The idea is that the uevent dispatcher
shouldn't be idle if there are uevents to process. Therefore uevents
are passed to it immediately. But it now checks for new uevents after
processing every individual event, before processing the entire queue,
and it applies filtering and merging to the queue as it grows.

This patch set avoids any delay when the uevent dispatcher is idle or
able to keep up with the rate of incoming uevents, while applying an
increasing amount of filtering and merging as pressure on the uevent
dispatcher increases. It's reasonable to assume that filtering and
merging get more efficient with increasing queue length, because the
probability of finding matching events will increase.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/uevent.c | 108 +++++++++++++++---------------------------
 1 file changed, 37 insertions(+), 71 deletions(-)

diff --git a/libmultipath/uevent.c b/libmultipath/uevent.c
index 0de9c6b..51c912f 100644
--- a/libmultipath/uevent.c
+++ b/libmultipath/uevent.c
@@ -52,10 +52,6 @@
 #include "blacklist.h"
 #include "devmapper.h"
=20
-#define MAX_ACCUMULATION_COUNT 2048
-#define MAX_ACCUMULATION_TIME 30*1000
-#define MIN_BURST_SPEED 10
-
 typedef int (uev_trigger)(struct uevent *, void * trigger_data);
=20
 static LIST_HEAD(uevq);
@@ -567,44 +563,43 @@ static struct uevent *uevent_from_udev_device(struct =
udev_device *dev)
 =09return uev;
 }
=20
-static bool uevent_burst(struct timeval *start_time, int events)
+#define MAX_UEVENTS 1000
+static int uevent_receive_events(int fd, struct list_head *tmpq,
+=09=09=09=09 struct udev_monitor *monitor)
 {
-=09struct timeval diff_time, end_time;
-=09unsigned long speed;
-=09unsigned long eclipse_ms;
+=09struct pollfd ev_poll;
+=09int n =3D 0;
=20
-=09if(events > MAX_ACCUMULATION_COUNT) {
-=09=09condlog(2, "burst got %u uevents, too much uevents, stopped", events=
);
-=09=09return false;
-=09}
+=09do {
+=09=09struct uevent *uev;
+=09=09struct udev_device *dev;
=20
-=09gettimeofday(&end_time, NULL);
-=09timersub(&end_time, start_time, &diff_time);
+=09=09dev =3D udev_monitor_receive_device(monitor);
+=09=09if (!dev) {
+=09=09=09condlog(0, "failed getting udev device");
+=09=09=09break;
+=09=09}
+=09=09uev =3D uevent_from_udev_device(dev);
+=09=09if (!uev)
+=09=09=09break;
=20
-=09eclipse_ms =3D diff_time.tv_sec * 1000 + diff_time.tv_usec / 1000;
+=09=09list_add_tail(&uev->node, tmpq);
+=09=09n++;
+=09=09condlog(4, "received uevent \"%s %s\"", uev->action, uev->kernel);
=20
-=09if (eclipse_ms =3D=3D 0)
-=09=09return true;
+=09=09ev_poll.fd =3D fd;
+=09=09ev_poll.events =3D POLLIN;
=20
-=09if (eclipse_ms > MAX_ACCUMULATION_TIME) {
-=09=09condlog(2, "burst continued %lu ms, too long time, stopped", eclipse=
_ms);
-=09=09return false;
-=09}
+=09} while (n < MAX_UEVENTS && poll(&ev_poll, 1, 0) > 0);
=20
-=09speed =3D (events * 1000) / eclipse_ms;
-=09if (speed > MIN_BURST_SPEED)
-=09=09return true;
-
-=09return false;
+=09return n;
 }
=20
 int uevent_listen(struct udev *udev)
 {
 =09int err =3D 2;
 =09struct udev_monitor *monitor =3D NULL;
-=09int fd, socket_flags, events;
-=09struct timeval start_time;
-=09int timeout =3D 30;
+=09int fd, socket_flags;
 =09LIST_HEAD(uevlisten_tmp);
=20
 =09/*
@@ -656,59 +651,30 @@ int uevent_listen(struct udev *udev)
 =09=09goto out;
 =09}
=20
-=09events =3D 0;
-=09gettimeofday(&start_time, NULL);
 =09pthread_cleanup_push(cleanup_global_uevq, NULL);
 =09pthread_cleanup_push(cleanup_uevq, &uevlisten_tmp);
 =09while (1) {
-=09=09struct uevent *uev;
-=09=09struct udev_device *dev;
-=09=09struct pollfd ev_poll;
-=09=09int poll_timeout;
-=09=09int fdcount;
+=09=09int fdcount, events;
+=09=09struct pollfd ev_poll =3D { .fd =3D fd, .events =3D POLLIN, };
=20
-=09=09memset(&ev_poll, 0, sizeof(struct pollfd));
-=09=09ev_poll.fd =3D fd;
-=09=09ev_poll.events =3D POLLIN;
-=09=09poll_timeout =3D timeout * 1000;
-=09=09errno =3D 0;
-=09=09fdcount =3D poll(&ev_poll, 1, poll_timeout);
-=09=09if (fdcount > 0 && ev_poll.revents & POLLIN) {
-=09=09=09timeout =3D uevent_burst(&start_time, events + 1) ? 1 : 0;
-=09=09=09dev =3D udev_monitor_receive_device(monitor);
-=09=09=09if (!dev) {
-=09=09=09=09condlog(0, "failed getting udev device");
-=09=09=09=09continue;
-=09=09=09}
-=09=09=09uev =3D uevent_from_udev_device(dev);
-=09=09=09if (!uev)
-=09=09=09=09continue;
-=09=09=09list_add_tail(&uev->node, &uevlisten_tmp);
-=09=09=09events++;
-=09=09=09continue;
-=09=09}
+=09=09fdcount =3D poll(&ev_poll, 1, -1);
 =09=09if (fdcount < 0) {
 =09=09=09if (errno =3D=3D EINTR)
 =09=09=09=09continue;
=20
-=09=09=09condlog(0, "error receiving "
-=09=09=09=09"uevent message: %m");
+=09=09=09condlog(0, "error receiving uevent message: %m");
 =09=09=09err =3D -errno;
 =09=09=09break;
 =09=09}
-=09=09if (!list_empty(&uevlisten_tmp)) {
-=09=09=09/*
-=09=09=09 * Queue uevents and poke service pthread.
-=09=09=09 */
-=09=09=09condlog(3, "Forwarding %d uevents", events);
-=09=09=09pthread_mutex_lock(uevq_lockp);
-=09=09=09list_splice_tail_init(&uevlisten_tmp, &uevq);
-=09=09=09pthread_cond_signal(uev_condp);
-=09=09=09pthread_mutex_unlock(uevq_lockp);
-=09=09=09events =3D 0;
-=09=09}
-=09=09gettimeofday(&start_time, NULL);
-=09=09timeout =3D 30;
+=09=09events =3D uevent_receive_events(fd, &uevlisten_tmp, monitor);
+=09=09if (events <=3D 0)
+=09=09=09continue;
+
+=09=09condlog(4, "Forwarding %d uevents", events);
+=09=09pthread_mutex_lock(uevq_lockp);
+=09=09list_splice_tail_init(&uevlisten_tmp, &uevq);
+=09=09pthread_cond_signal(uev_condp);
+=09=09pthread_mutex_unlock(uevq_lockp);
 =09}
 =09pthread_cleanup_pop(1);
 =09pthread_cleanup_pop(1);
--=20
2.35.1


--===============0382425677569740510==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

--===============0382425677569740510==--

