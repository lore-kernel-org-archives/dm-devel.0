Return-Path: <SRS0=Fgdj=IA=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB306C433E0
	for <dm-devel@archiver.kernel.org>; Tue,  2 Mar 2021 15:30:04 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 4C6A464F2F
	for <dm-devel@archiver.kernel.org>; Tue,  2 Mar 2021 15:30:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4C6A464F2F
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-578-1sWJdqetP8iYxbHlDrpwEQ-1; Tue, 02 Mar 2021 10:30:01 -0500
X-MC-Unique: 1sWJdqetP8iYxbHlDrpwEQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BF0D080196C;
	Tue,  2 Mar 2021 15:29:55 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DEBA210023B1;
	Tue,  2 Mar 2021 15:29:54 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 5A7B34EE76;
	Tue,  2 Mar 2021 15:29:51 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 122FTmo4018550 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 2 Mar 2021 10:29:48 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 62077106A31; Tue,  2 Mar 2021 15:29:48 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5C5A87AF4
	for <dm-devel@redhat.com>; Tue,  2 Mar 2021 15:29:46 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1A471858F0E
	for <dm-devel@redhat.com>; Tue,  2 Mar 2021 15:29:46 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-10-JW4M-f5cOUy6WA3HnS3FFQ-1;
	Tue, 02 Mar 2021 10:29:43 -0500
X-MC-Unique: JW4M-f5cOUy6WA3HnS3FFQ-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id BC892AC54;
	Tue,  2 Mar 2021 15:29:41 +0000 (UTC)
Message-ID: <41e79d67f568baf8de6b28e4924620240f0a2731.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: lixiaokeng <lixiaokeng@huawei.com>, Benjamin Marzinski
	<bmarzins@redhat.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Tue, 02 Mar 2021 16:29:40 +0100
In-Reply-To: <05c23ce9-4859-b0c3-3acb-c74f2c4510d6@huawei.com>
References: <20210128210852.23207-1-mwilck@suse.com>
	<c1dddccecfe0e12a2fe2dca66faad740a30acd53.camel@suse.com>
	<99488b1b-2339-338d-e951-0b8f3e78449b@huawei.com>
	<dcc6fb2a344ce75972242e2c78e2e485b58140da.camel@suse.com>
	<655de0b3-9625-bf3c-85f8-d19832bd84d8@huawei.com>
	<79f18cdb19b41be24d082d5528ab2325e6552395.camel@suse.com>
	<05c23ce9-4859-b0c3-3acb-c74f2c4510d6@huawei.com>
User-Agent: Evolution 3.38.2
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 122FTmo4018550
X-loop: dm-devel@redhat.com
Cc: linfeilong <linfeilong@huawei.com>, dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH] multipathd: avoid crash in uevent_cleanup()
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Tue, 2021-03-02 at 20:44 +0800, lixiaokeng wrote:
>=20
> > Note that unlike all other threads, TUR threads are _detached_
> > threads.
> > multipathd tries to cancel them, but it has no way to verify that
> > they
> > actually stopped. It may be just a normal observation that you
> > can't
> > see the messages when a TUR thread terminates, in particular if the
> > program is exiting and might have already closed the stderr file
> > descriptor.
> >=20
> >=20
> > If you look at the crashed processes with gdb, the thread IDs
> > should
> > give you some clue which stack belongs to which thread. The TUR
> > threads
> > will have higher thread IDs than the others because they are
> > started
> > later.
> >=20
>=20
>=20
> ??
>=20
> [Thread debugging using libthread_db enabled]
> Using host libthread_db library "/usr/lib64/libthread_db.so.1".
> Core was generated by `/sbin/multipathd -d -s'.
> Program terminated with signal SIGSEGV, Segmentation fault.
> #0=A0 0x00007f3f669e071d in ?? ()
> [Current thread is 1 (Thread 0x7f3f65873700 (LWP 1645593))]
> (gdb) i thread
> =A0 Id=A0=A0 Target Id=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0 Frame
> * 1=A0=A0=A0 Thread 0x7f3f65873700 (LWP 1645593) 0x00007f3f669e071d in ??
> ()
> =A0 2=A0=A0=A0 Thread 0x7f3f6611a000 (LWP 1645066) 0x00007f3f669fede7 in
> munmap () at ../sysdeps/unix/syscall-template.S:78
> =A0 3=A0=A0=A0 Thread 0x7f3f6609d700 (LWP 1645095) syscall () at
> ../sysdeps/unix/sysv/linux/x86_64/syscall.S:38
> (gdb) bt
> #0=A0 0x00007f3f669e071d in ?? ()
> #1=A0 0x0000000000000000 in ?? ()
> (gdb) thread 2
> [Switching to thread 2 (Thread 0x7f3f6611a000 (LWP 1645066))]
> #0=A0 0x00007f3f669fede7 in munmap () at ../sysdeps/unix/syscall-
> template.S:78
> 78=A0=A0=A0=A0=A0=A0T_PSEUDO (SYSCALL_SYMBOL, SYSCALL_NAME, SYSCALL_NARGS=
)
> (gdb) bt
> #0=A0 0x00007f3f669fede7 in munmap () at ../sysdeps/unix/syscall-
> template.S:78
> #1=A0 0x00007f3f669fb77d in _dl_unmap_segments
> (l=3Dl@entry=3D0x557cb432ba10) at ./dl-unmap-segments.h:32
> ...
> #10 0x00007f3f669b44ed in cleanup_prio () at prio.c:66=A0
> //cleanup_checkers() is finished.
> #11 0x0000557cb26db794 in child (param=3D<optimized out>) at
> main.c:2932
> #12 0x0000557cb26d44d3 in main (argc=3D<optimized out>,
> argv=3D0x7ffc98d47948) at main.c:3150
>=20
>=20
> UNWIND
>=20
> [Thread debugging using libthread_db enabled]
> Using host libthread_db library "/usr/lib64/libthread_db.so.1".
> Core was generated by `/sbin/multipathd -d -s'.
> Program terminated with signal SIGSEGV, Segmentation fault.
> #0=A0 x86_64_fallback_frame_state (fs=3D0x7fa9b2f576d0,
> context=3D0x7fa9b2f57980) at ./md-unwind-support.h:58
> 58=A0=A0=A0=A0=A0=A0=A0 if (*(unsigned char *)(pc+0) =3D=3D 0x48
> [Current thread is 1 (Thread 0x7fa9b2f58700 (LWP 1285074))]
> (gdb) i thread
> =A0 Id=A0=A0 Target Id=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Frame
> * 1=A0=A0=A0 Thread 0x7fa9b2f58700 (LWP 1285074) (Exiting)
> x86_64_fallback_frame_state (fs=3D0x7fa9b2f576d0,
> context=3D0x7fa9b2f57980) at ./md-unwind-support.h:58
> =A0 2=A0=A0=A0 Thread 0x7fa9b383e000 (LWP 1284366)=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0
> 0x00007fa9b403e127 in __close (fd=3D5) at
> ../sysdeps/unix/sysv/linux/close.c:27
> =A0 3=A0=A0=A0 Thread 0x7fa9b37c1700 (LWP 1284374)=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0 syscall () at
> ../sysdeps/unix/sysv/linux/x86_64/syscall.S:38
> =A0 4=A0=A0=A0 Thread 0x7fa9b2f73700 (LWP 1285077)=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0
> 0x00007fa9b3e06507 in ioctl () at ../sysdeps/unix/syscall-
> template.S:78
> =A0 5=A0=A0=A0 Thread 0x7fa9b2f61700 (LWP 1285076)=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0
> 0x00007fa9b3e06507 in ioctl () at ../sysdeps/unix/syscall-
> template.S:78
> =A0 6=A0=A0=A0 Thread 0x7fa9b2f4f700 (LWP 1285079)=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0
> 0x00007fa9b3e06507 in ioctl () at ../sysdeps/unix/syscall-
> template.S:78
> =A0 7=A0=A0=A0 Thread 0x7fa9b2fa9700 (LWP 1285080)=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0
> 0x00007fa9b3e06507 in ioctl () at ../sysdeps/unix/syscall-
> template.S:78
> (gdb) thread 2
> [Switching to thread 2 (Thread 0x7fa9b383e000 (LWP 1284366))]
> #0=A0 0x00007fa9b403e127 in __close (fd=3D5) at
> ../sysdeps/unix/sysv/linux/close.c:27
> 27=A0=A0=A0=A0=A0=A0=A0 return SYSCALL_CANCEL (close, fd);
> (gdb) bt
> #0=A0 0x00007fa9b403e127 in __close (fd=3D5) at
> ../sysdeps/unix/sysv/linux/close.c:27
> #1=A0 0x00005606f030f95b in cleanup_dmevent_waiter () at dmevents.c:111
> #2=A0 0x00005606f03087a2 in child (param=3D<optimized out>) at
> main.c:2934
> #3=A0 0x00005606f03014d3 in main (argc=3D<optimized out>,
> argv=3D0x7ffdb782ab38) at main.c:3150
>=20
>=20
> The LWP of ?? and UNWIND is much larger than thread 2(main).
>=20
> I add print_func like:
>=20
> @@ -228,6 +228,10 @@ static void copy_msg_to_tcc(void *ct_p, const
> char *msg)
> =A0=A0=A0=A0=A0=A0=A0 pthread_mutex_unlock(&ct->lock);
> =A0}
>=20
> +static void lxk10 (void)
> +{
> +=A0=A0=A0=A0=A0=A0 condlog(2, "lxk exit tur_thread");
> +}
> =A0static void *tur_thread(void *ctx)
> =A0{
> =A0=A0=A0=A0=A0=A0=A0 struct tur_checker_context *ct =3D ctx;
> @@ -235,6 +239,8 @@ static void *tur_thread(void *ctx)
> =A0=A0=A0=A0=A0=A0=A0 char devt[32];
>=20
> =A0=A0=A0=A0=A0=A0=A0 /* This thread can be canceled, so setup clean up *=
/
> +=A0=A0=A0=A0=A0=A0 condlog(2, "lxk start tur_thread");
> +=A0=A0=A0=A0=A0=A0 pthread_cleanup_push(lxk10, NULL);
> =A0=A0=A0=A0=A0=A0=A0 tur_thread_cleanup_push(ct);
>=20
> When there are four devices, core log:
> Mar 02 11:40:35 localhost.localdomain multipathd[85474]: exit
> (signal)
> Mar 02 11:40:35 localhost.localdomain multipathd[85474]: sda:
> unusable path
> Mar 02 11:40:35 localhost.localdomain multipathd[85474]: sdf:
> unusable path
> Mar 02 11:40:35 localhost.localdomain multipathd[85474]: sde:
> unusable path
> Mar 02 11:40:35 localhost.localdomain multipathd[85474]: sdd:
> unusable path
> Mar 02 11:40:35 localhost.localdomain multipathd[85474]: sdc:
> unusable path
> Mar 02 11:40:35 localhost.localdomain multipathd[85474]: sdb:
> unusable path
> Mar 02 11:40:35 localhost.localdomain multipathd[85474]: lxk start
> tur_thread
> Mar 02 11:40:35 localhost.localdomain multipathd[85474]: lxk exit
> tur_thread
> Mar 02 11:40:35 localhost.localdomain multipathd[85474]: lxk start
> tur_thread
> Mar 02 11:40:35 localhost.localdomain multipathd[85474]: lxk start
> tur_thread
> Mar 02 11:40:35 localhost.localdomain multipathd[85474]: lxk exit
> tur_thread
> Mar 02 11:40:35 localhost.localdomain multipathd[85474]: lxk start
> tur_thread
> Mar 02 11:40:35 localhost.localdomain multipathd[85474]: lxk exit
> tur_thread
> Mar 02 11:40:35 localhost.localdomain multipathd[85474]:
> 360014057a1353ec1bdd4dfcad19db6db: remove multipath map
> Mar 02 11:40:35 localhost.localdomain multipathd[85474]: sdg: orphan
> path, map flushed
> Mar 02 11:40:35 localhost.localdomain multipathd[85474]: BUG:
> orphaning path sdg that holds hwe of
> 360014057a1353ec1bdd4dfcad19db6db
> Mar 02 11:40:35 localhost.localdomain multipathd[85474]: tur checker
> refcount 4
> Mar 02 11:40:35 localhost.localdomain multipathd[85474]:
> 36001405faf8a6c2920840ed8ba73b9ee: remove multipath map
> Mar 02 11:40:35 localhost.localdomain multipathd[85474]: sdj: orphan
> path, map flushed
> Mar 02 11:40:35 localhost.localdomain multipathd[85474]: BUG:
> orphaning path sdj that holds hwe of
> 36001405faf8a6c2920840ed8ba73b9ee
> Mar 02 11:40:35 localhost.localdomain multipathd[85474]: tur checker
> refcount 3
> Mar 02 11:40:35 localhost.localdomain multipathd[85474]:
> 36001405044c0f50ba3c4e5b9b57e4de4: remove multipath map
> Mar 02 11:40:35 localhost.localdomain multipathd[85474]: sdi: orphan
> path, map flushed
> Mar 02 11:40:35 localhost.localdomain multipathd[85474]: BUG:
> orphaning path sdi that holds hwe of
> 36001405044c0f50ba3c4e5b9b57e4de4
> Mar 02 11:40:35 localhost.localdomain multipathd[85474]: tur checker
> refcount 2
> Mar 02 11:40:35 localhost.localdomain multipathd[85474]:
> 36001405e0cbb950907b4a51af1a002ed: remove multipath map
> Mar 02 11:40:35 localhost.localdomain multipathd[85474]: sdh: orphan
> path, map flushed
> Mar 02 11:40:35 localhost.localdomain multipathd[85474]: BUG:
> orphaning path sdh that holds hwe of
> 36001405e0cbb950907b4a51af1a002ed
> Mar 02 11:40:35 localhost.localdomain multipathd[85474]: tur checker
> refcount 1
> Mar 02 11:40:35 localhost.localdomain multipathd[85474]: lxk exit
> ueventloop
> Mar 02 11:40:35 localhost.localdomain multipathd[85474]: lxk exit
> uxlsnrloop
> Mar 02 11:40:35 localhost.localdomain multipathd[85474]: lxk exit
> uevqloop
> Mar 02 11:40:35 localhost.localdomain multipathd[85474]: lxk exit
> wait_dmevents
> Mar 02 11:40:35 localhost.localdomain multipathd[85474]: lxk exit
> checkerloop
> Mar 02 11:40:35 localhost.localdomain multipathd[85474]: directio
> checker refcount 6
> Mar 02 11:40:35 localhost.localdomain multipathd[85474]: lxk free tur
> checker=A0 //checker_put


So we do not see "unloading tur checker". Like you said, that suggests
that the crash occurs between libcheck_free() and the thread exiting.
I suggest you put a message in tur.c:libcheck_free (), AFTER the call
to cleanup_context(), printing the values of "running" and "holders".

Anyway:

=09holders =3D uatomic_sub_return(&ct->holders, 1);
=09if (!holders)
=09=09cleanup_context(ct);

Whatever mistakes we have made, only one actor can have seen=A0
holders =3D=3D 0, and have called cleanup_context().

The stacks you have shown indicate that the instruction pointers were
broken. That would suggest something similar as dicussed in the ML
thread leading to 38ffd89 ("libmultipath: prevent DSO unloading with
astray checker threads"). Your logs show "tur checker refcount 1", so
the next call to checker_put would have unloaded the DSO.=20

Please try commenting out the dlclose() call in free_checker_class(),
and see if it makes a difference.

Martin



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

