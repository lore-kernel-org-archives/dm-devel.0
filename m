Return-Path: <SRS0=Fgdj=IA=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4078C433E0
	for <dm-devel@archiver.kernel.org>; Tue,  2 Mar 2021 12:45:19 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E3FB7601FA
	for <dm-devel@archiver.kernel.org>; Tue,  2 Mar 2021 12:45:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E3FB7601FA
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-509-8hSx4PTMPtu9oSPB8hM7KA-1; Tue, 02 Mar 2021 07:45:15 -0500
X-MC-Unique: 8hSx4PTMPtu9oSPB8hM7KA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9435C107ACF9;
	Tue,  2 Mar 2021 12:45:09 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A0B801002388;
	Tue,  2 Mar 2021 12:45:07 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 1676E4E58D;
	Tue,  2 Mar 2021 12:45:05 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 122Cj2oQ032349 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 2 Mar 2021 07:45:03 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id CC3722167D66; Tue,  2 Mar 2021 12:45:02 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C6C9F2167D60
	for <dm-devel@redhat.com>; Tue,  2 Mar 2021 12:44:58 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2D655803904
	for <dm-devel@redhat.com>; Tue,  2 Mar 2021 12:44:58 +0000 (UTC)
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com
	[45.249.212.191]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-316-P87O057iOgeagpCAvAPfyQ-1; Tue, 02 Mar 2021 07:44:53 -0500
X-MC-Unique: P87O057iOgeagpCAvAPfyQ-1
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.60])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4DqcGn6yG4zMgtr;
	Tue,  2 Mar 2021 20:42:41 +0800 (CST)
Received: from [10.174.178.113] (10.174.178.113) by
	DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server
	id 14.3.498.0; Tue, 2 Mar 2021 20:44:43 +0800
To: Martin Wilck <mwilck@suse.com>, Benjamin Marzinski <bmarzins@redhat.com>, 
	Christophe Varoqui <christophe.varoqui@opensvc.com>
References: <20210128210852.23207-1-mwilck@suse.com>
	<c1dddccecfe0e12a2fe2dca66faad740a30acd53.camel@suse.com>
	<99488b1b-2339-338d-e951-0b8f3e78449b@huawei.com>
	<dcc6fb2a344ce75972242e2c78e2e485b58140da.camel@suse.com>
	<655de0b3-9625-bf3c-85f8-d19832bd84d8@huawei.com>
	<79f18cdb19b41be24d082d5528ab2325e6552395.camel@suse.com>
From: lixiaokeng <lixiaokeng@huawei.com>
Message-ID: <05c23ce9-4859-b0c3-3acb-c74f2c4510d6@huawei.com>
Date: Tue, 2 Mar 2021 20:44:43 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
	Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <79f18cdb19b41be24d082d5528ab2325e6552395.camel@suse.com>
X-Originating-IP: [10.174.178.113]
X-CFilter-Loop: Reflected
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 122Cj2oQ032349
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
Content-Language: en-GB
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable


> Note that unlike all other threads, TUR threads are _detached_ threads.
> multipathd tries to cancel them, but it has no way to verify that they
> actually stopped. It may be just a normal observation that you can't
> see the messages when a TUR thread terminates, in particular if the
> program is exiting and might have already closed the stderr file
> descriptor.
>=20
>=20
> If you look at the crashed processes with gdb, the thread IDs should
> give you some clue which stack belongs to which thread. The TUR threads
> will have higher thread IDs than the others because they are started
> later.
>


??

[Thread debugging using libthread_db enabled]
Using host libthread_db library "/usr/lib64/libthread_db.so.1".
Core was generated by `/sbin/multipathd -d -s'.
Program terminated with signal SIGSEGV, Segmentation fault.
#0  0x00007f3f669e071d in ?? ()
[Current thread is 1 (Thread 0x7f3f65873700 (LWP 1645593))]
(gdb) i thread
  Id   Target Id                           Frame
* 1    Thread 0x7f3f65873700 (LWP 1645593) 0x00007f3f669e071d in ?? ()
  2    Thread 0x7f3f6611a000 (LWP 1645066) 0x00007f3f669fede7 in munmap () =
at ../sysdeps/unix/syscall-template.S:78
  3    Thread 0x7f3f6609d700 (LWP 1645095) syscall () at ../sysdeps/unix/sy=
sv/linux/x86_64/syscall.S:38
(gdb) bt
#0  0x00007f3f669e071d in ?? ()
#1  0x0000000000000000 in ?? ()
(gdb) thread 2
[Switching to thread 2 (Thread 0x7f3f6611a000 (LWP 1645066))]
#0  0x00007f3f669fede7 in munmap () at ../sysdeps/unix/syscall-template.S:7=
8
78=09T_PSEUDO (SYSCALL_SYMBOL, SYSCALL_NAME, SYSCALL_NARGS)
(gdb) bt
#0  0x00007f3f669fede7 in munmap () at ../sysdeps/unix/syscall-template.S:7=
8
#1  0x00007f3f669fb77d in _dl_unmap_segments (l=3Dl@entry=3D0x557cb432ba10)=
 at ./dl-unmap-segments.h:32
...
#10 0x00007f3f669b44ed in cleanup_prio () at prio.c:66  //cleanup_checkers(=
) is finished.
#11 0x0000557cb26db794 in child (param=3D<optimized out>) at main.c:2932
#12 0x0000557cb26d44d3 in main (argc=3D<optimized out>, argv=3D0x7ffc98d479=
48) at main.c:3150


UNWIND

[Thread debugging using libthread_db enabled]
Using host libthread_db library "/usr/lib64/libthread_db.so.1".
Core was generated by `/sbin/multipathd -d -s'.
Program terminated with signal SIGSEGV, Segmentation fault.
#0  x86_64_fallback_frame_state (fs=3D0x7fa9b2f576d0, context=3D0x7fa9b2f57=
980) at ./md-unwind-support.h:58
58=09  if (*(unsigned char *)(pc+0) =3D=3D 0x48
[Current thread is 1 (Thread 0x7fa9b2f58700 (LWP 1285074))]
(gdb) i thread
  Id   Target Id                                     Frame
* 1    Thread 0x7fa9b2f58700 (LWP 1285074) (Exiting) x86_64_fallback_frame_=
state (fs=3D0x7fa9b2f576d0, context=3D0x7fa9b2f57980) at ./md-unwind-suppor=
t.h:58
  2    Thread 0x7fa9b383e000 (LWP 1284366)           0x00007fa9b403e127 in =
__close (fd=3D5) at ../sysdeps/unix/sysv/linux/close.c:27
  3    Thread 0x7fa9b37c1700 (LWP 1284374)           syscall () at ../sysde=
ps/unix/sysv/linux/x86_64/syscall.S:38
  4    Thread 0x7fa9b2f73700 (LWP 1285077)           0x00007fa9b3e06507 in =
ioctl () at ../sysdeps/unix/syscall-template.S:78
  5    Thread 0x7fa9b2f61700 (LWP 1285076)           0x00007fa9b3e06507 in =
ioctl () at ../sysdeps/unix/syscall-template.S:78
  6    Thread 0x7fa9b2f4f700 (LWP 1285079)           0x00007fa9b3e06507 in =
ioctl () at ../sysdeps/unix/syscall-template.S:78
  7    Thread 0x7fa9b2fa9700 (LWP 1285080)           0x00007fa9b3e06507 in =
ioctl () at ../sysdeps/unix/syscall-template.S:78
(gdb) thread 2
[Switching to thread 2 (Thread 0x7fa9b383e000 (LWP 1284366))]
#0  0x00007fa9b403e127 in __close (fd=3D5) at ../sysdeps/unix/sysv/linux/cl=
ose.c:27
27=09  return SYSCALL_CANCEL (close, fd);
(gdb) bt
#0  0x00007fa9b403e127 in __close (fd=3D5) at ../sysdeps/unix/sysv/linux/cl=
ose.c:27
#1  0x00005606f030f95b in cleanup_dmevent_waiter () at dmevents.c:111
#2  0x00005606f03087a2 in child (param=3D<optimized out>) at main.c:2934
#3  0x00005606f03014d3 in main (argc=3D<optimized out>, argv=3D0x7ffdb782ab=
38) at main.c:3150


The LWP of ?? and UNWIND is much larger than thread 2(main).

I add print_func like:

@@ -228,6 +228,10 @@ static void copy_msg_to_tcc(void *ct_p, const char *ms=
g)
        pthread_mutex_unlock(&ct->lock);
 }

+static void lxk10 (void)
+{
+       condlog(2, "lxk exit tur_thread");
+}
 static void *tur_thread(void *ctx)
 {
        struct tur_checker_context *ct =3D ctx;
@@ -235,6 +239,8 @@ static void *tur_thread(void *ctx)
        char devt[32];

        /* This thread can be canceled, so setup clean up */
+       condlog(2, "lxk start tur_thread");
+       pthread_cleanup_push(lxk10, NULL);
        tur_thread_cleanup_push(ct);

When there are four devices, core log:
Mar 02 11:40:35 localhost.localdomain multipathd[85474]: exit (signal)
Mar 02 11:40:35 localhost.localdomain multipathd[85474]: sda: unusable path
Mar 02 11:40:35 localhost.localdomain multipathd[85474]: sdf: unusable path
Mar 02 11:40:35 localhost.localdomain multipathd[85474]: sde: unusable path
Mar 02 11:40:35 localhost.localdomain multipathd[85474]: sdd: unusable path
Mar 02 11:40:35 localhost.localdomain multipathd[85474]: sdc: unusable path
Mar 02 11:40:35 localhost.localdomain multipathd[85474]: sdb: unusable path
Mar 02 11:40:35 localhost.localdomain multipathd[85474]: lxk start tur_thre=
ad
Mar 02 11:40:35 localhost.localdomain multipathd[85474]: lxk exit tur_threa=
d
Mar 02 11:40:35 localhost.localdomain multipathd[85474]: lxk start tur_thre=
ad
Mar 02 11:40:35 localhost.localdomain multipathd[85474]: lxk start tur_thre=
ad
Mar 02 11:40:35 localhost.localdomain multipathd[85474]: lxk exit tur_threa=
d
Mar 02 11:40:35 localhost.localdomain multipathd[85474]: lxk start tur_thre=
ad
Mar 02 11:40:35 localhost.localdomain multipathd[85474]: lxk exit tur_threa=
d
Mar 02 11:40:35 localhost.localdomain multipathd[85474]: 360014057a1353ec1b=
dd4dfcad19db6db: remove multipath map
Mar 02 11:40:35 localhost.localdomain multipathd[85474]: sdg: orphan path, =
map flushed
Mar 02 11:40:35 localhost.localdomain multipathd[85474]: BUG: orphaning pat=
h sdg that holds hwe of 360014057a1353ec1bdd4dfcad19db6db
Mar 02 11:40:35 localhost.localdomain multipathd[85474]: tur checker refcou=
nt 4
Mar 02 11:40:35 localhost.localdomain multipathd[85474]: 36001405faf8a6c292=
0840ed8ba73b9ee: remove multipath map
Mar 02 11:40:35 localhost.localdomain multipathd[85474]: sdj: orphan path, =
map flushed
Mar 02 11:40:35 localhost.localdomain multipathd[85474]: BUG: orphaning pat=
h sdj that holds hwe of 36001405faf8a6c2920840ed8ba73b9ee
Mar 02 11:40:35 localhost.localdomain multipathd[85474]: tur checker refcou=
nt 3
Mar 02 11:40:35 localhost.localdomain multipathd[85474]: 36001405044c0f50ba=
3c4e5b9b57e4de4: remove multipath map
Mar 02 11:40:35 localhost.localdomain multipathd[85474]: sdi: orphan path, =
map flushed
Mar 02 11:40:35 localhost.localdomain multipathd[85474]: BUG: orphaning pat=
h sdi that holds hwe of 36001405044c0f50ba3c4e5b9b57e4de4
Mar 02 11:40:35 localhost.localdomain multipathd[85474]: tur checker refcou=
nt 2
Mar 02 11:40:35 localhost.localdomain multipathd[85474]: 36001405e0cbb95090=
7b4a51af1a002ed: remove multipath map
Mar 02 11:40:35 localhost.localdomain multipathd[85474]: sdh: orphan path, =
map flushed
Mar 02 11:40:35 localhost.localdomain multipathd[85474]: BUG: orphaning pat=
h sdh that holds hwe of 36001405e0cbb950907b4a51af1a002ed
Mar 02 11:40:35 localhost.localdomain multipathd[85474]: tur checker refcou=
nt 1
Mar 02 11:40:35 localhost.localdomain multipathd[85474]: lxk exit ueventloo=
p
Mar 02 11:40:35 localhost.localdomain multipathd[85474]: lxk exit uxlsnrloo=
p
Mar 02 11:40:35 localhost.localdomain multipathd[85474]: lxk exit uevqloop
Mar 02 11:40:35 localhost.localdomain multipathd[85474]: lxk exit wait_dmev=
ents
Mar 02 11:40:35 localhost.localdomain multipathd[85474]: lxk exit checkerlo=
op
Mar 02 11:40:35 localhost.localdomain multipathd[85474]: directio checker r=
efcount 6
Mar 02 11:40:35 localhost.localdomain multipathd[85474]: lxk free tur check=
er  //checker_put
Mar 02 11:40:36 localhost.localdomain systemd-coredump[85547]: Process 8547=
4 (multipathd) of user 0 dumped core

There are four "lxk start tur_thread" but three "lxk exit tur_thread".

>> I will use
>> =A0=A0=A0=A0=A0=A0=A0=A0int oldstate;
>> =A0=A0=A0=A0=A0=A0=A0=A0pthread_setcancelstate(PTHREAD_CANCEL_DISABLE, &=
oldstate);
>> =A0=A0=A0=A0=A0=A0=A0=A0...
>> =A0=A0=A0=A0=A0=A0=A0=A0pthread_setcancelstate(oldstate, NULL);
>> =A0=A0=A0=A0=A0=A0=A0=A0pthread_testcancel();
>> to test it.
>=20
> Where exactly do you want to put that code?
>=20
I add this in BEGAIN and END of tur_thread. But it is not helpful.

> IIUC you don't compile multipathd with -fexceptions, do you? You
> haven't answered my previous question why you do that for systemd.

I don't know why use -fexceptions before, but we have removed it
and there is no udev_monitor_receive_device core.

Regards,
Lixiaokeng


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

