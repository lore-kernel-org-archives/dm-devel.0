Return-Path: <SRS0=dXIA=QF=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 650ABC433F5
	for <dm-devel@archiver.kernel.org>; Thu, 18 Nov 2021 23:05:40 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 0357C6128E
	for <dm-devel@archiver.kernel.org>; Thu, 18 Nov 2021 23:05:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 0357C6128E
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-120-gRWGpwyuM5qXzEHKlbFz8w-1; Thu, 18 Nov 2021 18:05:35 -0500
X-MC-Unique: gRWGpwyuM5qXzEHKlbFz8w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2BEC410151E2;
	Thu, 18 Nov 2021 23:05:31 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0E6CB3AEA;
	Thu, 18 Nov 2021 23:05:31 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id B5FD34EA2A;
	Thu, 18 Nov 2021 23:05:30 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AIMx3nF002002 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 18 Nov 2021 17:59:03 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 351CE218013A; Thu, 18 Nov 2021 22:59:03 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2B5B8218012A
	for <dm-devel@redhat.com>; Thu, 18 Nov 2021 22:59:00 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3A8388027FB
	for <dm-devel@redhat.com>; Thu, 18 Nov 2021 22:59:00 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-205-KGIU3cucNLOPwbW6AGuS-w-1; Thu, 18 Nov 2021 17:58:58 -0500
X-MC-Unique: KGIU3cucNLOPwbW6AGuS-w-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id D03DE1FD38;
	Thu, 18 Nov 2021 22:58:56 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 71D4913B11;
	Thu, 18 Nov 2021 22:58:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id lrJfGbDalmGHPAAAMHmgww
	(envelope-from <mwilck@suse.com>); Thu, 18 Nov 2021 22:58:56 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Thu, 18 Nov 2021 23:57:52 +0100
Message-Id: <20211118225840.19810-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1AIMx3nF002002
X-loop: dm-devel@redhat.com
Cc: lixiaokeng@huawei.com, Chongyun Wu <wu.chongyun@h3c.com>,
	dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH v2 00/47] multipathd: uxlsnr overhaul
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

Hello Christophe, hello Ben,

The current multipathd unix listener code has various deficiencies.

 - client disconnects aren't handled correctly,
 - the uxsock_timeout is applied for receiving, handling, and
   responding to the client requests separately, rather than for
   the entire operation,
 - timeouts are logged, but not acted upon, causing the timeout
   to be noticed in the client rather than in the server.
 - clients may see a timeout while "reconfigure" is running,
 - unpriviledged (non-root) client connections don't work
   correctly
 - most importantly, the code busy-loops, polls, or waits in
   various places in called subroutines, which is a no-go in a
   piece of code designed as an event handler and may lead
   to spurious timeouts and delayed reaction e.g. to signals
   or client requests.

This patch set approaches all these issues. Fixing the last one,
in particular, requires a major refactoring of the uxlsnr code.
Overall, the reliability and latency of client request handling
and signal handling by multipathd should be noticeably improved
by this patch set.

The biggest problem (waiting for the vecs lock in a client handler)
can only be fixed by moving this wait into the handlers ppoll()
loop (another possible fix would have been to handle all clients
in separate threads, but that would have required even more
complexity). The patch set achieves this by adding an eventfd-based
notification mechanism to the vecs lock, which can be passed to
ppoll() to wake up when the lock is freed.

Furthermore, client requests can't be handled in a single poll
iteration any more. Therefore the client connection becomes stateful,
and is handled by a state machine using the states RECEIVE, PARSE,
WAIT FOR LOCK, WORK, and SEND.

The refactoring is done step by step for ease (hopefully) of
review. 1/35-4/35 add utility code that will be used by the uxlsnr
refactoring. 5/35-7/35 are some independent patches that
aren't directly related to uxlnsr, but fix issues that I observed
while working on this set.

8/35-13/35 are minor fixups in the client handling code. This code is
strongly related to the uxlsnr, thus I thought I'd rather fix it
before making the other changes. In 25/35, the cli-handlers are
converted to use the strbuf API everywhere instead of separate "reply"
and "len" arguments. 15/35-18/35 are minor fixes for the
uxlsnr. 19/35-34/35 are the actual refactoring patches for the uxlsnr
code. First I move some code around unchanged, then I add the
state machine (handle_client()) and move the code into it piece
by piece. 35/35 adds a fix for the client side (multipathd -k).

CC'ing Lixiaokeng and Chongyun Wu, as they have test cases that use
the client code heavily AFAIR. Testing by 3rd parties would be
very welcome.

---

Changes wrt v1 (Ben Marzinski):
  03: this is a major library version change.
  07: make set_config_state() static
  12: further simplify add_handler, make it static, and use assert
        to check for multiply-defined handlers
  14: dropped in favor of Ben's "reconfigure all" set, numbering changes
        from here on
  29 (was 30): don't use fallthrough; call state machine in a loop instead.
     fix signedness of return codes. Fix double messages.
  30 (was 31): The lock handling in this patch was broken. It could happen that
     the uxlsnr was cancelled without releasing the lock. Fixed by
     simplification. 
  35 (new): Use recv() for getting the command length, as suggested by Ben.

Moreover, I'm reposting Ben's rebased series on top of mine.

Comments welcome, regards,
Martin

Benjamin Marzinski (12):
  multipathd: move delayed_reconfig out of struct config
  multipathd: remove reconfigure from header file.
  multipathd: pass in the type of reconfigure
  multipathd: add "reconfigure all" command.
  multipathd: remove missing paths on startup
  libmultipath: skip unneeded steps to get path name
  libmultipath: don't use fallback wwid in update_pathvec_from_dm
  libmultipath: always set INIT_REMOVED in set_path_removed
  multipathd: fully initialize paths added by update_pathvec_from_dm
  multipathd: retrigger uevent for partial paths
  multipathd: remove INIT_PARTIAL paths that aren't in a multipath
    device
  multipathd: Remove dependency on systemd-udev-settle.service

Martin Wilck (36):
  libmultipath: add timespeccmp() utility function
  libmultipath: add trylock() helper
  libmultipath: add optional wakeup functionality to lock.c
  libmultipath: print: add __snprint_config()
  libmultipath: improve cleanup of uevent queues on exit
  multipathd: fix systemd notification when stopping while reloading
  multipathd: improve delayed reconfigure
  multipathd: cli.h: formatting improvements
  multipathd: cli_del_map: fix reply for delayed action
  multipathd: add prototype for cli_handler functions
  multipathd: make all cli_handlers static
  multipathd: add and set cli_handlers in a single step
  multipathd: cli.c: use ESRCH for "command not found"
  multipathd: uxlsnr: avoid stalled clients during reconfigure
  multipathd: uxlsnr: handle client HUP
  multipathd: uxlsnr: use symbolic values for pollfd indices
  multipathd: uxlsnr: avoid using fd -1 in ppoll()
  multipathd: uxlsnr: data structure for stateful client connection
  multipathd: move uxsock_trigger() to uxlsnr.c
  multipathd: move parse_cmd() to uxlsnr.c
  multipathd: uxlsnr: remove check_timeout()
  multipathd: uxlsnr: move client handling to separate function
  multipathd: uxlsnr: use main poll loop for receiving
  multipathd: use strbuf in cli_handler functions
  multipathd: uxlsnr: check root on connection startup
  multipathd: uxlsnr: pass struct client to uxsock_trigger() and
    parse_cmd()
  multipathd: uxlsnr: move handler execution to separate function
  multipathd: uxlsnr: use parser to determine non-root commands
  multipathd: uxlsnr: merge uxsock_trigger() into state machine
  multipathd: uxlsnr: add idle notification
  multipathd: uxlsnr: add timeout handling
  multipathd: uxlsnr: use poll loop for sending, too
  multipathd: uxlsnr: drop client_lock
  multipathd: uxclt: allow client mode for non-root, too
  multipathd: uxlsnr: use recv() for command length
  libmultipath: add path wildcard "%I" for init state

 libmpathpersist/libmpathpersist.version |  12 +-
 libmultipath/config.h                   |   1 -
 libmultipath/configure.c                |   4 +-
 libmultipath/devmapper.c                |   2 +
 libmultipath/discovery.c                |   7 +-
 libmultipath/discovery.h                |   2 +
 libmultipath/libmultipath.version       |  10 +-
 libmultipath/lock.c                     |  12 +-
 libmultipath/lock.h                     |  11 +-
 libmultipath/print.c                    |  55 ++-
 libmultipath/print.h                    |   2 +
 libmultipath/structs.h                  |   9 +
 libmultipath/structs_vec.c              |  41 +-
 libmultipath/structs_vec.h              |   2 +-
 libmultipath/time-util.c                |  12 +
 libmultipath/time-util.h                |   1 +
 libmultipath/uevent.c                   |  49 +-
 multipath/main.c                        |   2 +-
 multipathd/cli.c                        | 181 ++-----
 multipathd/cli.h                        | 102 ++--
 multipathd/cli_handlers.c               | 596 ++++++++++++------------
 multipathd/cli_handlers.h               |  61 +--
 multipathd/main.c                       | 357 +++++++-------
 multipathd/main.h                       |   4 +-
 multipathd/multipathd.8                 |  10 +-
 multipathd/multipathd.service           |   3 +-
 multipathd/uxlsnr.c                     | 542 +++++++++++++++------
 multipathd/uxlsnr.h                     |   4 +-
 28 files changed, 1193 insertions(+), 901 deletions(-)

-- 
2.33.1


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

