Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06318C433F5
	for <dm-devel@archiver.kernel.org>; Sun, 13 Mar 2022 10:30:04 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-403--Oa8zjHXPnSLqMzrUs_C7A-1; Sun, 13 Mar 2022 06:30:00 -0400
X-MC-Unique: -Oa8zjHXPnSLqMzrUs_C7A-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C3E7538041E3;
	Sun, 13 Mar 2022 10:29:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6ACEA56D2A9;
	Sun, 13 Mar 2022 10:29:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 10EE61940370;
	Sun, 13 Mar 2022 10:29:53 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 4EB59194035B
 for <dm-devel@listman.corp.redhat.com>; Sun, 13 Mar 2022 10:29:51 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 036D7422E3; Sun, 13 Mar 2022 10:29:51 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id F363F422DF
 for <dm-devel@redhat.com>; Sun, 13 Mar 2022 10:29:48 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F14F7101AA48
 for <dm-devel@redhat.com>; Sun, 13 Mar 2022 10:29:47 +0000 (UTC)
Received: from mout.gmx.net (mout.gmx.net [212.227.17.22]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-601-OTlMrhPqMw2KChj_xQu6mg-1; Sun, 13 Mar 2022 06:29:46 -0400
X-MC-Unique: OTlMrhPqMw2KChj_xQu6mg-1
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.net (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1M4axq-1nSmu5238Q-001fD4; Sun, 13
 Mar 2022 11:24:36 +0100
Message-ID: <88a5d138-68b0-da5f-8b08-5ddf02fff244@gmx.com>
Date: Sun, 13 Mar 2022 18:24:32 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
To: Linux FS Devel <linux-fsdevel@vger.kernel.org>,
 "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
X-Provags-ID: V03:K1:eDbfbmB7YpEKXAqDHWfkxATH4FVeK7qmSSfBVYbpbU+WyG8C/N4
 FGk1JI8mNe7rIKyJEs0z9hoRNOSgwNZsT6HetEApaaUzpDl5ODQnRBlRUKD0Hnn9YhcdO/u
 pEkUY0IvhVs4x3qdwKmynNl5Tetn1FFlrxv0yr8WqUAyGHypi/tFuJqS+EsQ5tDk8GiUNTB
 RdfFaJ0pS7pcE/oulY52A==
X-UI-Out-Filterresults: notjunk:1;V03:K0:h0/chrg8tRc=:vM63xkRC8VcUqWFX3BEsSt
 Ou0ulBbibumiyJDcdTjI3AIYoy0xwJyLx3Bv7YNZaiciOG7NXKa1PG49qmBnIJrBD1wUdPZjb
 aQ64/3v0xqCRsjYqGXY8jvXNqe0I44PfViA06z7nfOjnsvgDj8fTa+bhfMuA3WsAJK6Gd4XJl
 QxTWx6GxzjZS/a4DXX/3SpauUXSwvu7V+YCtCc/SAZgyvf7bMSfTmHCPOlgSbnRa9ZDtI/4Pu
 6ekXGvz4KI3G+G6Iq5dlagXCnXgIq9y/mqkNuSjziF51BZxQG62PEVBKfsXrK3gnf0456Ctle
 6dRYdanUBXe69ABJexfq5zoideulUnhum5rMvTRK8Z/y2WsbUXeMvbOL74FnOZTJ7Mes1PYM8
 nyljSwExduNd8zavWsjNs1HVT0c4lYgaMteef564i9/qj+Pyg1YB8BdCNsd1f05DqMDdgfWpg
 Al/JWTb0EzoSvqRM3x/jj62Z2i2Amm/FiEMJxya3fx7gBkzZBt4goujyxkAOBiXgdfbS5nRUu
 wwrSZ7oMnTZFrA19q/VD5lqP5UykwN9V9FQBHEZ9l1qxBbpTLpFf9diJxopC0DBMcBRGJKDtY
 ci+/gJpd8FINzptCGx/xnKpz/zXjk9NVA8tGszqOXckqc+PGSlAcRXPDldRrvN67hsM5sFHdI
 d4HQPgjBwfS0ERZaQDj25HuRxHl9hlKY4j0MnFRgYM1j4Le9HgYisJ3W6dEzoV/9KE6UB5JUl
 2cg0aZxVHkKgcLSNWczzzIuoXdrhKcmwkvm1KZcdiw0QpZeFlah0bH7iXFV5RCY//U69u7xN6
 4yTxW2Tdm+AoSsMK7+A5Y/nPEVLmgscmgUVdwrngWeyGTm2GNVQe5c9q48ZJGD2YSq13UU0R+
 eesroigpUYDu5hWIXDZUksbR889m4N2o+lKRi600n0wDDsUFvPekNFz0K2O0hR4DI8+x4c2sQ
 SA/CzLv2rGqQnsOadyIZUK6m0d3rIyIswZ3q9dUqK0y8zpCUsvD96pe90REjaJ60RPLL0iiMh
 GUV7KR+8aBMAswv2RYrtoiSnc2//aymjr/g7wjdpAsM+QR7BWfXQc99Uh2yaDIN70iwog0jCd
 T0CU0Z/co2LtvE=
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Subject: [dm-devel] Better read bio error granularity?
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
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

Hi,

Since if any of the split bio got an error, the whole bio will have
bi_status set to some error number.

This is completely fine for write bio, but I'm wondering can we get a
better granularity by introducing per-bvec bi_status or using page status?


One situation is, for fs like btrfs or dm device like dm-verify, if a
large bio is submitted, say a 128K one, and one of the page failed to
pass checksum/hmac verification.

Then the whole 128K will be marked error, while in fact the rest 124K
are completely fine.


Can this be solved by something like per-vec bi_status, or using page
error status to indicate where exactly the error is?

Or is such usage case too niche (only makes sense for read, only makes
sense for fs with verification)?

Thanks,
Qu

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

