Return-Path: <SRS0=XTDI=IK=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03A2CC433DB
	for <dm-devel@archiver.kernel.org>; Fri, 12 Mar 2021 14:07:55 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 77C5264FEA
	for <dm-devel@archiver.kernel.org>; Fri, 12 Mar 2021 14:07:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 77C5264FEA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1615558073;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Ag3eqyJaMKRbRRORWZ6qB7e6SNQsWpg/HRnTZ319Akc=;
	b=CTId0tScx3WCYaUYmtMHUqdiCuqnT4hOj5YfBpSExg4LVJcu1f+c1NSZItOK36qegFfTl8
	Q7Jh9e0437S0eIzrAUq3nwttS5EoCK0cJJe1a4V52PzG+uwBtGJXDOzVRDiYXirm/IR5iJ
	1MawEeN9dfntYQky0fjKe5t/HONmHTs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-350-jQGh62hFNSS3cSYRGtk0xg-1; Fri, 12 Mar 2021 09:07:51 -0500
X-MC-Unique: jQGh62hFNSS3cSYRGtk0xg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0AB89107ACCD;
	Fri, 12 Mar 2021 14:07:45 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A1E105C1C5;
	Fri, 12 Mar 2021 14:07:43 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id DC1451C97;
	Fri, 12 Mar 2021 14:07:39 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com
	[10.5.11.23])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12CE7bMp007139 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 12 Mar 2021 09:07:37 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 7347D99A5; Fri, 12 Mar 2021 14:07:37 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com
	(file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 425BD19704;
	Fri, 12 Mar 2021 14:07:31 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
	by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP
	id 12CE7UXS015710; Fri, 12 Mar 2021 09:07:30 -0500
Received: from localhost (mpatocka@localhost)
	by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with
	ESMTP id 12CE7U3c015706; Fri, 12 Mar 2021 09:07:30 -0500
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka
	owned process doing -bs
Date: Fri, 12 Mar 2021 09:07:30 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Mike Snitzer <snitzer@redhat.com>
In-Reply-To: <20210311200736.GA29043@redhat.com>
Message-ID: <alpine.LRH.2.02.2103120857270.17950@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.2103111326050.28706@file01.intranet.prod.int.rdu2.redhat.com>
	<20210311184116.GB28637@redhat.com>
	<alpine.LRH.2.02.2103111438170.3860@file01.intranet.prod.int.rdu2.redhat.com>
	<20210311200736.GA29043@redhat.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>,
	Zdenek Kabelac <zkabelac@redhat.com>
Subject: [dm-devel] [PATCH v3] dm-ioctl: return UUID in DM_LIST_DEVICES_CMD
	result
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit



On Thu, 11 Mar 2021, Mike Snitzer wrote:

> On Thu, Mar 11 2021 at  2:43pm -0500,
> Mikulas Patocka <mpatocka@redhat.com> wrote:
> 
> > 
> > 
> > On Thu, 11 Mar 2021, Mike Snitzer wrote:
> > 
> > > > Index: linux-2.6/include/uapi/linux/dm-ioctl.h
> > > > ===================================================================
> > > > --- linux-2.6.orig/include/uapi/linux/dm-ioctl.h	2021-03-09 12:20:23.000000000 +0100
> > > > +++ linux-2.6/include/uapi/linux/dm-ioctl.h	2021-03-11 18:42:14.000000000 +0100
> > > > @@ -193,8 +193,15 @@ struct dm_name_list {
> > > >  	__u32 next;		/* offset to the next record from
> > > >  				   the _start_ of this */
> > > >  	char name[0];
> > > > +
> > > > +	/* uint32_t event_nr; */
> > > > +	/* uint32_t flags; */
> > > > +	/* char uuid[0]; */
> > > >  };
> > > 
> > > If extra padding is being leveraged here (from the __u32 next), why not
> > > at least explicitly add the members and then pad out the balance of that
> > > __u32?  I'm not liking the usage of phantom struct members.. e.g.
> > > the games played with accessing them.
> > > 
> > > Mike
> > 
> > What exactly do you mean?
> > 
> > Do you want to create another structure that holds event_nr, flags and 
> > uuid? Or something else?
> 
> Just not liking the comments you added in lieu of explicit struct
> members.
> 
> Can't you remove __u32 next; and replace with named members of
> appropriate size? Adding explicit padding to end to get you to 32bit
> offset?  I'd need to look closer at the way the code is written, but I
> just feel like this patch makes the code even more fiddley.
> 
> But I can let it go if you don't see a way forward to make it better..
> 
> Mike

Hi

Here I added a comment to "struct dm_name_list" that explains how to 
access fields "event_nr", "flags" and "uuid". Hopefully it makes the 
structure layout more understandable.

Mikulas


From: Mikulas Patocka <mpatocka@redhat.com>

dm-ioctl: return UUID in DM_LIST_DEVICES_CMD result

When LVM needs to find a device with a particular UUID it needs to ask for
UUID for each device. This patch returns UUID directly in the list of
devices, so that LVM doesn't have to query all the devices with an ioctl.
The UUID is returned if the flag DM_UUID_FLAG is set in the parameters.

Returning UUID is done in backward-compatible way. There's one unused
32-bit word value after the event number. This patch sets the bit
DM_NAME_LIST_FLAG_HAS_UUID if UUID is present and
DM_NAME_LIST_FLAG_DOESNT_HAVE_UUID if it isn't (if none of these bits is
set, then we have an old kernel that doesn't support returning UUIDs). The
UUID is stored after this word. The 'next' value is updated to point after
the UUID, so that old version of libdevmapper will skip the UUID without
attempting to interpret it.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-ioctl.c         |   20 +++++++++++++++++---
 include/uapi/linux/dm-ioctl.h |   14 ++++++++++++++
 2 files changed, 31 insertions(+), 3 deletions(-)

Index: linux-2.6/drivers/md/dm-ioctl.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-ioctl.c	2021-03-09 21:04:07.000000000 +0100
+++ linux-2.6/drivers/md/dm-ioctl.c	2021-03-12 15:02:42.000000000 +0100
@@ -558,7 +558,9 @@ static int list_devices(struct file *fil
 	for (n = rb_first(&name_rb_tree); n; n = rb_next(n)) {
 		hc = container_of(n, struct hash_cell, name_node);
 		needed += align_val(offsetof(struct dm_name_list, name) + strlen(hc->name) + 1);
-		needed += align_val(sizeof(uint32_t));
+		needed += align_val(sizeof(uint32_t) * 2);
+		if (param->flags & DM_UUID_FLAG && hc->uuid)
+			needed += align_val(strlen(hc->uuid) + 1);
 	}
 
 	/*
@@ -577,6 +579,7 @@ static int list_devices(struct file *fil
 	 * Now loop through filling out the names.
 	 */
 	for (n = rb_first(&name_rb_tree); n; n = rb_next(n)) {
+		void *uuid_ptr;
 		hc = container_of(n, struct hash_cell, name_node);
 		if (old_nl)
 			old_nl->next = (uint32_t) ((void *) nl -
@@ -588,8 +591,19 @@ static int list_devices(struct file *fil
 
 		old_nl = nl;
 		event_nr = align_ptr(nl->name + strlen(hc->name) + 1);
-		*event_nr = dm_get_event_nr(hc->md);
-		nl = align_ptr(event_nr + 1);
+		event_nr[0] = dm_get_event_nr(hc->md);
+		event_nr[1] = 0;
+		uuid_ptr = align_ptr(event_nr + 2);
+		if (param->flags & DM_UUID_FLAG) {
+			if (hc->uuid) {
+				event_nr[1] |= DM_NAME_LIST_FLAG_HAS_UUID;
+				strcpy(uuid_ptr, hc->uuid);
+				uuid_ptr = align_ptr(uuid_ptr + strlen(hc->uuid) + 1);
+			} else {
+				event_nr[1] |= DM_NAME_LIST_FLAG_DOESNT_HAVE_UUID;
+			}
+		}
+		nl = uuid_ptr;
 	}
 	/*
 	 * If mismatch happens, security may be compromised due to buffer
Index: linux-2.6/include/uapi/linux/dm-ioctl.h
===================================================================
--- linux-2.6.orig/include/uapi/linux/dm-ioctl.h	2021-03-09 12:20:23.000000000 +0100
+++ linux-2.6/include/uapi/linux/dm-ioctl.h	2021-03-12 15:03:11.000000000 +0100
@@ -193,8 +193,22 @@ struct dm_name_list {
 	__u32 next;		/* offset to the next record from
 				   the _start_ of this */
 	char name[0];
+
+	/*
+	   The following members can be accessed by taking a pointer that points
+	   immediatelly after the terminating zero character in "name" and
+	   aligning this pointer to next 8-byte boundary.
+	   Uuid is present if the flag DM_NAME_LIST_FLAG_HAS_UUID is set.
+
+	   __u32 event_nr;
+	   __u32 flags;
+	   char uuid[0];
+	*/
 };
 
+#define DM_NAME_LIST_FLAG_HAS_UUID		1
+#define DM_NAME_LIST_FLAG_DOESNT_HAVE_UUID	2
+
 /*
  * Used to retrieve the target versions
  */

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

