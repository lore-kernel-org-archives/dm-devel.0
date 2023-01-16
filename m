Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 546A8C54EBE
	for <dm-devel@archiver.kernel.org>; Mon, 16 Jan 2023 17:40:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1673890800;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=LZi8U+uJ5PE1p8EQ2L8aCmRaM7kpLGBfvb6EaMQVO/Y=;
	b=aM5VvgiB3zrwGdrJX1ow8eHbbAOIljT6CTc8w+kboCAVHo5IlwVt3ZSNhbylb7zk8H1K8u
	BsdtnA5mVze+HnX15YXejE+BkxWcc6yW8WPPqaljnj2PVCF50hhM4jGbyGaTzjfLy3m7FD
	9h1JTlsjY6kg/wvLsRnDzY7FeToYuE4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-157-U8IqbCb5PeqZk7eYPvECXg-1; Mon, 16 Jan 2023 12:39:56 -0500
X-MC-Unique: U8IqbCb5PeqZk7eYPvECXg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 09A8487A381;
	Mon, 16 Jan 2023 17:39:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A8BCBC15BA0;
	Mon, 16 Jan 2023 17:39:52 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 7722F194658C;
	Mon, 16 Jan 2023 17:39:52 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 1D2461946589
 for <dm-devel@listman.corp.redhat.com>; Mon, 16 Jan 2023 17:39:44 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 7651F2166B2A; Mon, 16 Jan 2023 17:39:44 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 5423C2166B26;
 Mon, 16 Jan 2023 17:39:44 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 30GHdhCp002511;
 Mon, 16 Jan 2023 11:39:43 -0600
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 30GHdgsZ002510;
 Mon, 16 Jan 2023 11:39:42 -0600
Date: Mon, 16 Jan 2023 11:39:42 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Nitin Yewale <nyewale@redhat.com>
Message-ID: <20230116173942.GC17327@octiron.msp.redhat.com>
References: <1673555329-9850-1-git-send-email-bmarzins@redhat.com>
 <1673555329-9850-2-git-send-email-bmarzins@redhat.com>
 <0ce9d087cc48ed97f2cee1a5c48c0149d5728332.camel@suse.com>
 <CACgRdraG3XRpmJB7L=kRce3eYOMWeWfUQ63pD0g1Bt0O5sA4LA@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CACgRdraG3XRpmJB7L=kRce3eYOMWeWfUQ63pD0g1Bt0O5sA4LA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: Re: [dm-devel] [PATCH 1/2] multipathd: Add format options to
 multipathd man page
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
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Jan 13, 2023 at 06:16:37PM +0530, Nitin Yewale wrote:
> Hello Ben,
> 
> I can try to explain the $format options. Will update bz with the new patch.

Sure. You're welcome to post patches directly to dm-devel as well.  But
if it's more convinient for you to post them to the bugzilla, I can
forward them for you.

-Ben

> 
> Thank you,
> Nitin Yewale
> 
> On Fri, Jan 13, 2023 at 2:22 PM Martin Wilck <martin.wilck@suse.com> wrote:
> 
> > On Thu, 2023-01-12 at 14:28 -0600, Benjamin Marzinski wrote:
> > > From: Nitin Yewale <nyewale@redhat.com>
> > >
> > > Move "multipathd show wildcards" command above the $format commands
> > > and
> > > also add $format options for "map" and "path" commands to the
> > > multipathd
> > > man page.
> > >
> > > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > > ---
> > >  multipathd/multipathd.8 | 16 ++++++++++++----
> > >  1 file changed, 12 insertions(+), 4 deletions(-)
> > >
> > > diff --git a/multipathd/multipathd.8 b/multipathd/multipathd.8
> > > index bdf102eb..95d475da 100644
> > > --- a/multipathd/multipathd.8
> > > +++ b/multipathd/multipathd.8
> > > @@ -113,9 +113,17 @@ The following commands can be used in
> > > interactive mode:
> > >  Show the paths that multipathd is monitoring, and their state.
> > >  .
> > >  .TP
> > > +.B list|show wildcards
> > > +Show the format wildcards used in interactive commands taking
> > > $format.
> > > +.
> > > +.TP
> > >  .B list|show paths format $format
> > >  Show the paths that multipathd is monitoring, using a format string
> > > with path
> > >  format wildcards.
> > > +
> > > +path format wildcards:
> > > +
> > > +%w (uuid), %i (hcil), %d (dev), %D (dev_t), %t (dm_st), %o (dev_st),
> > > %T (chk_st), %s (vend/prod/rev), %c (checker), %C (next_check), %p
> > > (pri), %S (size), %z (serial), %M (marginal_st), %m (multipath), %N
> > > (host WWNN), %n (target WWNN), %R (host WWPN), %r (target WWPN), %a
> > > (host adapter), %G (foreign), %g (vpd page data), %0 (failures), %P
> > > (protocol)
> > >  .
> >
> > If we do this in the first place, we should explain it better. Terms
> > like "dm_st" need explanation. The explanation would grow into a longer
> > paragraph, which should be moved to the bottom of the man page with a
> > cross reference here.
> >
> > >  .TP
> > >  .B list|show maps|multipaths
> > > @@ -125,6 +133,10 @@ Show the multipath devices that the multipathd
> > > is monitoring.
> > >  .B list|show maps|multipaths format $format
> > >  Show the status of all multipath devices that the multipathd is
> > > monitoring,
> > >  using a format string with multipath format wildcards.
> > > +
> > > +multipath format wildcards:
> > > +
> > > +%n (name), %w (uuid), %d (sysfs), %F (failback), %Q (queueing), %N
> > > (no. of paths), %r (write_prot), %t (dm-st), %S (size), %f
> > > (features), %x (failures), %h (hwhandler), %A (action), %0
> > > (path_faults), %1 (switch_grp), %2 (map_loads), %3 (total_q_time), %4
> > > (q_timeouts), %s (vend/prod/rev), %v (vend), %p (prod), %e (rev), %G
> > > (foreign), %g (vpd page data)
> >
> > Same comment as above.
> >
> > Martin
> >
> > >  .
> > >  .TP
> > >  .B list|show maps|multipaths status
> > > @@ -148,10 +160,6 @@ Show topology of a single multipath device
> > > specified by $map, for example
> > >  36005076303ffc56200000000000010aa. This map could be obtained from
> > > '\fIlist maps\fR'.
> > >  .
> > >  .TP
> > > -.B list|show wildcards
> > > -Show the format wildcards used in interactive commands taking
> > > $format.
> > > -.
> > > -.TP
> > >  .B list|show config
> > >  Show the currently used configuration, derived from default values
> > > and values
> > >  specified within the configuration file \fI/etc/multipath.conf\fR.
> >
> >
> 
> -- 
> Regards,
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

