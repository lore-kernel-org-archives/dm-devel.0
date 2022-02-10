Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF925C433EF
	for <dm-devel@archiver.kernel.org>; Thu, 10 Feb 2022 21:02:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1644526957;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=LBz7xp9Xg46//lW3zBVBoyFJhPfSoXtem+Lp7Za6suI=;
	b=NcufdtbluEa38T8GAc16UgLRbp6XsxzsJjRggI4WNFsy0k6rlSDVKzl8dpAFOxI5QPIncl
	FuCRwen2DrT/sx7XaKxJ+pVR4RNfzyGQi19f50yuQGcWA4nc0OHtHfu0MErsgUeCsMcN+s
	KnlOWICOs8tDqZCf8IhPGdiV5GSAMRo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-516-K57mSViGOoWrooruWpxmGw-1; Thu, 10 Feb 2022 16:02:34 -0500
X-MC-Unique: K57mSViGOoWrooruWpxmGw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 181BE1091DA0;
	Thu, 10 Feb 2022 21:02:29 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6A8146ABB0;
	Thu, 10 Feb 2022 21:02:27 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 30FA54BB7C;
	Thu, 10 Feb 2022 21:02:23 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
	[10.5.11.12])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21AL2LZu007842 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 10 Feb 2022 16:02:21 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 557D6879DB; Thu, 10 Feb 2022 21:02:21 +0000 (UTC)
Received: from octiron.msp.redhat.com (unknown [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 342F0610A6;
	Thu, 10 Feb 2022 21:02:18 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 21AL2G5q010121; 
	Thu, 10 Feb 2022 15:02:16 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 21AL2FJJ010120;
	Thu, 10 Feb 2022 15:02:15 -0600
Date: Thu, 10 Feb 2022 15:02:15 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Message-ID: <20220210210215.GG24684@octiron.msp.redhat.com>
References: <20220210032810.714821-1-muneendra.kumar@broadcom.com>
	<bb2333d75ac49ee865a7c17c8a2c68a3421099f0.camel@suse.com>
MIME-Version: 1.0
In-Reply-To: <bb2333d75ac49ee865a7c17c8a2c68a3421099f0.camel@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-loop: dm-devel@redhat.com
Cc: "muneendra.kumar@broadcom.com" <muneendra.kumar@broadcom.com>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"mkumar@redhat.com" <mkumar@redhat.com>
Subject: Re: [dm-devel] [PATCH v3] multipathd: handle fpin events
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
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Feb 10, 2022 at 05:00:09PM +0000, Martin Wilck wrote:
> Hi Muneendra, 
> 
> coverity found some defects in your patch. Please help me review them,
> see attachment. It's well possible that they're false positives, but
> please double-check.
> 
> Thanks
> Martin
> 

> Date: Thu, 10 Feb 2022 16:50:12 +0000 (UTC)
> From: scan-admin@coverity.com
> To: mwilck@suse.com
> Subject: New Defects reported by Coverity Scan for mwilck/multipath-tools
> 
> Hi,
> 
> Please find the latest report on new defect(s) introduced to mwilck/multipath-tools found with Coverity Scan.
> 
> 3 new defect(s) introduced to mwilck/multipath-tools found with Coverity Scan.
> 
> 
> New defect(s) Reported-by: Coverity Scan
> Showing 3 of 3 defect(s)
> 
> 
> ** CID 375096:  Memory - corruptions  (OVERRUN)
> /multipathd/fpin_handlers.c: 161 in fpin_els_add_li_frame()
> 
> 
> ________________________________________________________________________________________________________
> *** CID 375096:  Memory - corruptions  (OVERRUN)
> /multipathd/fpin_handlers.c: 161 in fpin_els_add_li_frame()
> 155     	pthread_testcancel();
> 156     	els_mrg = calloc(1, sizeof(struct els_marginal_list));
> 157     	if (els_mrg != NULL) {
> 158     		els_mrg->host_num = fc_event->host_no;
> 159     		els_mrg->event_code = fc_event->event_code;
> 160     		els_mrg->length = fc_event->event_datalen;
> >>>     CID 375096:  Memory - corruptions  (OVERRUN)
> >>>     Overrunning buffer pointed to by "&fc_event->event_data" of 4 bytes by passing it to a function which accesses it at byte offset 2047 using argument "fc_event->event_datalen" (which evaluates to 2048). [Note: The source code implementation of the function has been overridden by a builtin model.]

fc_event->event_data is a u32, but that's just because the first 32 bits
of the event data is the els_cmd, right? The header makes it clear that
event_data actually does hold event_datalen worth of space

>From /usr/include/scsi/scsi_netlink_fc.h
-------------------------------------------
 * Note: if Vendor Unique message, &event_data will be  start of
 *       vendor unique payload, and the length of the payload is
 *       per event_datalen

The only thing that looks possibly suspect here to me is in
fpin_fabric_notification_receiver() which calls fpin_els_add_li_frame()

In fpin_fabric_notification_receiver() we guarantee that we read enough
for plen to be correct by calling NLMSG_OK(), and we check that plen is
big enough to hold fc_event before we start using that. After that, we
just assume fc_event is well formed. However we could check that

offsetof(struct fc_nl_event, event_data) + fc_event->event_data_len <= plen

just to make sure that we really read enough space for all the event
data.

> 161     		memcpy(els_mrg->payload, &(fc_event->event_data), fc_event->event_datalen);
> 162     		list_add_tail(&els_mrg->node, &els_marginal_list_head);
> 163     		pthread_cond_signal(&fpin_li_cond);
> 164     	} else
> 165     		ret = -ENOMEM;
> 166     	pthread_cleanup_pop(1);
> 
> ** CID 375095:  Program hangs  (LOCK)
> /multipathd/fpin_handlers.c: 429 in fpin_els_li_consumer()
> 
> 
> ________________________________________________________________________________________________________
> *** CID 375095:  Program hangs  (LOCK)
> /multipathd/fpin_handlers.c: 429 in fpin_els_li_consumer()
> 423     	rcu_register_thread();
> 424     	pthread_cleanup_push(fpin_clean_marginal_dev_list, NULL);
> 425     	INIT_LIST_HEAD(&marginal_list_head);
> 426     	pthread_cleanup_push(fpin_clean_els_marginal_list,
> 427     				(void *)&marginal_list_head);
> 428     	for ( ; ; ) {
> >>>     CID 375095:  Program hangs  (LOCK)
> >>>     "pthread_mutex_lock" locks "fpin_li_mutex" while it is locked.
> 429     		pthread_mutex_lock(&fpin_li_mutex);
> 430     		pthread_cleanup_push(cleanup_mutex, &fpin_li_mutex);
> 431     		pthread_testcancel();
> 432     		while (list_empty(&els_marginal_list_head))
> 433     			pthread_cond_wait(&fpin_li_cond, &fpin_li_mutex);
> 434     
> 
> ** CID 375094:  Memory - corruptions  (OVERRUN)
> /multipathd/fpin_handlers.c: 339 in fpin_handle_els_frame()

I can't see how we could double lock fpin_li_mutex here.  This looks to me
like coverity isn't understanding that the pthread_mutex_pop(1) that we
must do before we loop is unlocking the mutex.

> 
> 
> ________________________________________________________________________________________________________
> *** CID 375094:  Memory - corruptions  (OVERRUN)
> /multipathd/fpin_handlers.c: 339 in fpin_handle_els_frame()
> 333     	struct fc_els_fpin *fpin = (struct fc_els_fpin *)&fc_event->event_data;
> 334     	struct fc_tlv_desc *tlv;
> 335     	uint32_t dtag;
> 336     
> 337     	els_cmd = (uint32_t)fc_event->event_data;
> 338     	tlv = (struct fc_tlv_desc *)&fpin->fpin_desc[0];
> >>>     CID 375094:  Memory - corruptions  (OVERRUN)
> >>>     "tlv" evaluates to an address that is at byte offset 0 of an array of -4 bytes.
> 339     	dtag = be32_to_cpu(tlv->desc_tag);
> 340     	condlog(4, "Got CMD in add as 0x%x fpin_cmd 0x%x dtag 0x%x\n",
> 341     			els_cmd, fpin->fpin_cmd, dtag);
> 342     
> 343     	if ((fc_event->event_code == FCH_EVT_LINK_FPIN) ||
> 344     			(fc_event->event_code == FCH_EVT_LINKUP) ||


Um.. I don't think the array size is really -4 bytes. It's a zero-legth
array, and that seems to be tripping up coverity. This looks fine,
assuming a well formed fc_event structure. Otherwise we need some checking
like

offsetof(struct fc_els_fpin, fpin_desc) + sizeof(struct fc_tlv_desc) <= fc_event->event_data_len

to guarantee that the space actually exists for this.

-Ben

> 
> 
> ________________________________________________________________________________________________________
> To view the defects in Coverity Scan visit, https://u15810271.ct.sendgrid.net/ls/click?upn=HRESupC-2F2Czv4BOaCWWCy7my0P0qcxCbhZ31OYv50yrlXjF1MXVk7PoaBOP4azsLepCe1Mn8gwfBXDBrelSIoRMU8O0U7o5n1FSIQj14Dq4St65JUh9ZnyC-2Fg157qes-2Ft9bX_PKeZaaewXacQHsuZ3T6aIqwwc4cZvX5RuFKlZH-2B-2F-2FW3e6H-2BXHVqahp7aWZNvTEgZriF6MZKau2Bf0lzbvkaTbX4e4aRrLiV588LPwISv-2Baiuvm-2BG4Up9iV7VtAl7qS-2B0T3-2Fqqv361QJbg5iOmqOQvmACpZbC7bxySCtES2vULs1HDMmm0iEnBDbGCNYF1xpA27h3e8fIXqCGYvqwYb-2B3OQ-3D-3D
> 
>   To manage Coverity Scan email notifications for "mwilck@suse.com", click https://u15810271.ct.sendgrid.net/ls/click?upn=HRESupC-2F2Czv4BOaCWWCy7my0P0qcxCbhZ31OYv50yped04pjJnmXOsUBtKYNIXxFPY5t1N6AzTJMa-2BnAWi0npABKE4tMGq7bchotHs-2B2MqcQoJY2TJBjK3IaZ-2BUkHe2wCTAqHQyQFhpCFLiEJ5yDOXcRNksjcYeVNM9nq6-2Fe1c-3DJZ6i_PKeZaaewXacQHsuZ3T6aIqwwc4cZvX5RuFKlZH-2B-2F-2FW3e6H-2BXHVqahp7aWZNvTEgZ8ESLNy-2BD7eSZoQJj9Azw80YJzcErYNLrKcxKMYgGbPxYRwvkDgeGxz4WRfn-2B-2BuPaXZTSYImuaAoKoYTe4RaUajUfXcURMKMcXzDOS6kanowCj0jE9AfLqwwWVbaP-2BgeCbRXyI-2FvgEy6HVXWmfdW8qg-3D-3D
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

