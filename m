Return-Path: <SRS0=HPtm=IV=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,HTML_MESSAGE,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E8D8C433C1
	for <dm-devel@archiver.kernel.org>; Tue, 23 Mar 2021 03:47:06 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 636A16196F
	for <dm-devel@archiver.kernel.org>; Tue, 23 Mar 2021 03:47:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 636A16196F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=erwinvanlonden.net
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-45-Z7mv1b_zOka2eTjESQW9pg-1; Mon, 22 Mar 2021 23:47:01 -0400
X-MC-Unique: Z7mv1b_zOka2eTjESQW9pg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 679D51084C8C;
	Tue, 23 Mar 2021 03:46:56 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id ED97D5C1A3;
	Tue, 23 Mar 2021 03:46:55 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id F1BA71809C83;
	Tue, 23 Mar 2021 03:46:54 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12N3kqJR015188 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 22 Mar 2021 23:46:53 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id D5BF3621BF; Tue, 23 Mar 2021 03:46:52 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CF89A621B9
	for <dm-devel@redhat.com>; Tue, 23 Mar 2021 03:46:49 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5EAD01021E08
	for <dm-devel@redhat.com>; Tue, 23 Mar 2021 03:46:49 +0000 (UTC)
Received: from gateway21.websitewelcome.com (gateway21.websitewelcome.com
	[192.185.45.228]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-578-eh9oqHWCM4KcYeY0K7DSLA-1; Mon, 22 Mar 2021 23:46:46 -0400
X-MC-Unique: eh9oqHWCM4KcYeY0K7DSLA-1
Received: from cm11.websitewelcome.com (cm11.websitewelcome.com [100.42.49.5])
	by gateway21.websitewelcome.com (Postfix) with ESMTP id 45A0D400D7576
	for <dm-devel@redhat.com>; Mon, 22 Mar 2021 22:22:25 -0500 (CDT)
Received: from just2098.justhost.com ([173.254.31.45]) by cmsmtp with SMTP
	id OXcel6snyPkftOXcflitgn; Mon, 22 Mar 2021 22:22:25 -0500
X-Authority-Reason: nr=8
Received: from 116-240-66-4.sta.dodo.net.au ([116.240.66.4]:49732
	helo=[192.168.1.104])
	by just2098.justhost.com with esmtpsa (TLS1.2) tls
	TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.93)
	(envelope-from <erwin@erwinvanlonden.net>) id 1lOXce-001E6c-9T
	for dm-devel@redhat.com; Mon, 22 Mar 2021 21:22:24 -0600
Message-ID: <7ad132c147e9df2673f99a693fafc3508dd384ef.camel@erwinvanlonden.net>
From: Erwin van Londen <erwin@erwinvanlonden.net>
To: dm-devel@redhat.com
Date: Tue, 23 Mar 2021 13:17:13 +1000
MIME-Version: 1.0
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33)
X-AntiAbuse: This header was added to track abuse,
	please include it with any abuse report
X-AntiAbuse: Primary Hostname - just2098.justhost.com
X-AntiAbuse: Original Domain - redhat.com
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - erwinvanlonden.net
X-BWhitelist: no
X-Source-IP: 116.240.66.4
X-Source-L: No
X-Exim-ID: 1lOXce-001E6c-9T
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 116-240-66-4.sta.dodo.net.au ([192.168.1.104])
	[116.240.66.4]:49732
X-Source-Auth: erwin@erwinvanlonden.net
X-Email-Count: 1
X-Source-Cap: aGl0YWNoaTE7aGl0YWNoaTE7anVzdDIwOTguanVzdGhvc3QuY29t
X-Local-Domain: yes
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
Subject: [dm-devel] dm-multipath "shaky SAN detection" is insufficient for
 intermittent errors.
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
Content-Type: multipart/mixed; boundary="===============4761278170030358623=="

--===============4761278170030358623==
Content-Type: multipart/alternative; boundary="=-xyyBEspKUzDNqRkr5csY"

--=-xyyBEspKUzDNqRkr5csY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello All,

This topic may have been discussed before although I've not been able
to find it in this d-list.

The "shaky SAN" detection method seems to be currently based on
availability of the remote target ports and how often they
disappear/reappear as per HBA state change on that remote target.

What we seen in SAN troubleshooting is that the majority of issues are
related to frame-corruption, missing frames and therefore incomplete FC
sequences/exchanges and hence just IO errors. I've been doing some test
with a FC jammer/analyser doing all sorts of weird things from changing
a scsi data-payload or crc therefore corrupting the frame to almost
persistently killing of cmnds or status frames based on normal IO's. As
long as I do nothing on a TUR and that checker keeps getting correct
statuses back it's then just left to the FC stack and or arrays to
chuck and HBA offline forcing multipath to halt IO's to that path.

My request is would it be possible to, instead (or in addition) of
checking on disappearing/re-appearing targets, to monitor for actual IO
errors on data-transfer where cmnd's timeout or cmnd's end up in any
check condition and utilise that to either halt IO's entirely or to
also use the marginal_path_err logic and have that path moved into a
holding queue and in the background check for subsequent errors where
the marginal_err_sample_time, err_rate_threshold and gap_time then
determine if that path can be used again or to have it permanently
failed.

I've been doing SAN troubleshooting for 20 years and the majority of
the problems is related to these intermittent issues of frame
corruption and/or discards. Actual flipping paths where a target goes
into and offline/online state is far less common.=C2=A0

Your feedback is appreciated.

Thank you

Erwin van Londen

--=-xyyBEspKUzDNqRkr5csY
Content-Type: text/html; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

<html><head></head><body><div>Hello All,</div><div><br></div><div>This topi=
c may have been discussed before although I've not been able to find it in =
this d-list.</div><div><br></div><div>The "shaky SAN" detection method seem=
s to be currently based on availability of the remote target ports and how =
often they disappear/reappear as per HBA state change on that remote target=
.</div><div><br></div><div>What we seen in SAN troubleshooting is that the =
majority of issues are related to frame-corruption, missing frames and ther=
efore incomplete FC sequences/exchanges and hence just IO errors. I've been=
 doing some test with a FC jammer/analyser doing all sorts of weird things =
from changing a scsi data-payload or crc therefore corrupting the frame to =
almost persistently killing of cmnds or status frames based on normal IO's.=
 As long as I do nothing on a TUR and that checker keeps getting correct st=
atuses back it's then just left to the FC stack and or arrays to chuck and =
HBA offline forcing multipath to halt IO's to that path.</div><div><br></di=
v><div>My request is would it be possible to, instead (or in addition) of c=
hecking on disappearing/re-appearing targets, to monitor for actual IO erro=
rs on data-transfer where cmnd's timeout or cmnd's end up in any check cond=
ition and utilise that to either halt IO's entirely or to also use the marg=
inal_path_err logic and have that path moved into a holding queue and in th=
e background check for subsequent errors where the marginal_err_sample_time=
, err_rate_threshold and gap_time then determine if that path can be used a=
gain or to have it permanently failed.</div><div><br></div><div>I've been d=
oing SAN troubleshooting for 20 years and the majority of the problems is r=
elated to these intermittent issues of frame corruption and/or discards. Ac=
tual flipping paths where a target goes into and offline/online state is fa=
r less common.&nbsp;</div><div><br></div><div>Your feedback is appreciated.=
</div><div><br></div><div>Thank you</div><div><br></div><div>Erwin van Lond=
en</div><div><span></span></div></body></html>

--=-xyyBEspKUzDNqRkr5csY--

--===============4761278170030358623==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel
--===============4761278170030358623==--

