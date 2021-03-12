Return-Path: <SRS0=VWZ+=IN=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4F66C433DB
	for <dm-devel@archiver.kernel.org>; Mon, 15 Mar 2021 08:55:59 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E590364E3F
	for <dm-devel@archiver.kernel.org>; Mon, 15 Mar 2021 08:55:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E590364E3F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=samsung.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-446-eTy5sah1NYWWRlWUXljuJw-1; Mon, 15 Mar 2021 04:55:55 -0400
X-MC-Unique: eTy5sah1NYWWRlWUXljuJw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 92A658030D7;
	Mon, 15 Mar 2021 08:55:51 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 741FB5D9DC;
	Mon, 15 Mar 2021 08:55:51 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 3A8611800848;
	Mon, 15 Mar 2021 08:55:51 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12C74KUr031395 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 12 Mar 2021 02:04:21 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id C42562026D6B; Fri, 12 Mar 2021 07:04:20 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BE3EE2026D60
	for <dm-devel@redhat.com>; Fri, 12 Mar 2021 07:04:18 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 81280800883
	for <dm-devel@redhat.com>; Fri, 12 Mar 2021 07:04:18 +0000 (UTC)
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-432-5ADJOWL7PJ6KB6DF6ljMhg-1; Fri, 12 Mar 2021 02:04:15 -0500
X-MC-Unique: 5ADJOWL7PJ6KB6DF6ljMhg-1
Received: from epcas1p2.samsung.com (unknown [182.195.41.46])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id
	20210312070412epoutp04051317d3d905d64cf439b47ce765fd1b~rhmNxFtgS1553115531epoutp04u
	for <dm-devel@redhat.com>; Fri, 12 Mar 2021 07:04:12 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com
	20210312070412epoutp04051317d3d905d64cf439b47ce765fd1b~rhmNxFtgS1553115531epoutp04u
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
	epcas1p2.samsung.com (KnoxPortal) with ESMTP id
	20210312070412epcas1p220db33dbd7e90c9e72df6733d1ee8af2~rhmNkxCTi2276122761epcas1p2-;
	Fri, 12 Mar 2021 07:04:12 +0000 (GMT)
Received: from epsmges1p5.samsung.com (unknown [182.195.40.160]) by
	epsnrtp3.localdomain (Postfix) with ESMTP id 4DxcHb5gDSz4x9QK;
	Fri, 12 Mar 2021 07:04:11 +0000 (GMT)
Received: from epcas1p1.samsung.com ( [182.195.41.45]) by
	epsmges1p5.samsung.com (Symantec Messaging Gateway) with SMTP id
	57.A7.11962.8621B406; Fri, 12 Mar 2021 16:04:08 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas1p3.samsung.com (KnoxPortal) with ESMTPA id
	20210312070408epcas1p356f1421f0af1d29d3ca7abd37f73bd4c~rhmJkma7t1738017380epcas1p3H;
	Fri, 12 Mar 2021 07:04:08 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20210312070408epsmtrp2049685e0484be4ca80067eefd2a3995f~rhmJj6ucQ1539915399epsmtrp2d;
	Fri, 12 Mar 2021 07:04:08 +0000 (GMT)
X-AuditID: b6c32a39-b5d34a8000002eba-76-604b1268512e
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
	98.ED.08745.8621B406; Fri, 12 Mar 2021 16:04:08 +0900 (KST)
Received: from jhs2lee03 (unknown [10.253.102.101]) by epsmtip2.samsung.com
	(KnoxPortal) with ESMTPA id
	20210312070408epsmtip2f8d0ec93a4a62a13d6da9166d726a940~rhmJaD79u1964919649epsmtip2I;
	Fri, 12 Mar 2021 07:04:08 +0000 (GMT)
From: =?utf-8?B?7J207KCV7ZiE?= <jhs2.lee@samsung.com>
To: "'Sami Tolvanen'" <samitolvanen@google.com>
In-Reply-To: <CABCJKucMyQbtt-LACCRSk6bxAqmS05eVhv-5ou3_XZ1Nz+XYug@mail.gmail.com>
Date: Fri, 12 Mar 2021 16:04:08 +0900
Message-ID: <009001d7170d$e584d360$b08e7a20$@samsung.com>
MIME-Version: 1.0
Thread-Index: AQJywKbl46ZRzKPvCQNOoTqt3A/c2AF7PY8mAhqlor8B7jzycakcb2ag
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkk+LIzCtJLcpLzFFi42LZdlhTVzdDyDvBYEeHjcX6U8eYLfa+m81q
	cXnXHDaLpSveslq0bfzK6MDqsWBTqcf7fVfZPD5vkgtgjsqxyUhNTEktUkjNS85PycxLt1Xy
	Do53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAHaqKRQlphTChQKSCwuVtK3synKLy1JVcjI
	Ly6xVUotSMkpMDQo0CtOzC0uzUvXS87PtTI0MDAyBapMyMn429/LWNCvUrF61zemBsYPkl2M
	nBwSAiYS1zdPYuxi5OIQEtjBKHHo41M2COcTo8SxVUehMp8ZJd7sucYI03J/QR9UYhejxOe9
	W8ESQgIvGCUW3eMAsdkETCUOLlkCFhcR0Jf4e/UxmM0ssJFRorWdB8TmFAiUuHn8OXsXIweH
	sICdxIIv6SBhFgFVifZNL9hBbF4BS4kbH26xQNiCEidnPmGBGKMtsWzha2aIexQkdn86ygoy
	RkTATeLSA3eIEhGJ2Z1tzCBnSgj8ZJf49nUTC0S9i8TBxstQvwhLvDq+hR3ClpL4/G4vG0RD
	N6PE/fOv2SASExglenuYQBZICNhLvL9kAWIyC2hKrN+lD1GhKLHz91yoD/kk3n3tYYWo5pXo
	aBOCKFGSWPHvGtQFEhIbDnezTWBUmoXksVlIHpuF5INZCMsWMLKsYhRLLSjOTU8tNiwwRY7q
	TYzgtKhluYNx+tsPeocYmTgYDzFKcDArifBeeOmVIMSbklhZlVqUH19UmpNafIjRFBjUE5ml
	RJPzgYk5ryTe0NTI2NjYwsTM3MzUWEmcN8ngQbyQQHpiSWp2ampBahFMHxMHp1QDE9tTQR5z
	oXqDdtPNZYIuWR/SHRVS9Bgu39XyE9Gds/D5JcW/mw5ffTrpWMqGj+2yT1bIOIuKNT2wc6j7
	wJ+894qah4r+hDDr3jD2YzYlp/ZnpF8zXOT1O/m4Ydvf1W4vd9vtcny6meGa0OxVmt3Lfu34
	bzHnX/li5c44bSP9b5/T2GzeeV/vX3Vzy9X+4iaRH09e55+o32exIvez6uotDt7Rxz7cnX3q
	2vLb840+eQasWaS4saQwo/5g8dPGsmvrJ9tHPjRK5TpXLNWTtnCG8uKKo8cUeJ5++XFF4PtT
	d7GcpjjfUx1NC16emr9xpkSzvEoMexaf6reqlttbHrMYzNr4wNt9xgmJjZ4M+b/ZmpRYijMS
	DbWYi4oTAYalL7UUBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrLLMWRmVeSWpSXmKPExsWy7bCSvG6GkHeCwaR5khbrTx1jttj7bjar
	xeVdc9gslq54y2rRtvErowOrx4JNpR7v911l8/i8SS6AOYrLJiU1J7MstUjfLoEr49mLjewF
	h5Urfu9ex9LAOEOyi5GTQ0LAROL+gj7GLkYuDiGBHYwSzz7+ZYNISEhs2LSWvYuRA8gWljh8
	uBii5hmjxJ2OnSwgNWwCphIHlyxhBLFFBPQl/l59DDaIWWAzo0THurcsEB1TmCQWTzjDDlLF
	KRAocfP4c7CpwgJ2Egu+pIOEWQRUJdo3vQAr4RWwlLjx4RYLhC0ocXLmEzCbWUBb4unNp3D2
	soWvmSEOVZDY/ekoK8hIEQE3iUsP3CFKRCRmd7YxT2AUnoVk0iwkk2YhmTQLScsCRpZVjJKp
	BcW56bnFhgVGeanlesWJucWleel6yfm5mxjBMaKltYNxz6oPeocYmTgYDzFKcDArifBeeOmV
	IMSbklhZlVqUH19UmpNafIhRmoNFSZz3QtfJeCGB9MSS1OzU1ILUIpgsEwenVAMTL/OdiKr/
	O55bhXJOti34e2MLr19u+53Z7/6oyN80tpuXvXVtJu+92PDrPhqvG1nWdsxWrjv1xpJ593Hr
	jJ7MVUz2s9sc+EUfCEfUzZBTYvkpO91IU5oxzMBiT+IU7wevb5365R7Xdtvm0nLxBRuufxXc
	cN3mx9LoOI6/Vj+jFs3lPru8OGjehxlNRo3593aKSj/tivy5uNXiJh8fz+/zPzmVfHPj4rKu
	xMi6Mf4IeZy7QPXH7ZgGuz9vz9ye33UlRHiu6j2Z9MnXQn/xbxDnW39r9cYI88IjdrLTb6y+
	s3u9deOGK7sFUttX3qmKm3Pi0sTYTatdlTO+7na4qv7mg3Ox/+SLp5Pn8Bk4/X59U4mlOCPR
	UIu5qDgRAGlsocAAAwAA
X-CMS-MailID: 20210312070408epcas1p356f1421f0af1d29d3ca7abd37f73bd4c
X-Msg-Generator: CA
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210311121850epcas1p493c255a586998916febfebaf994bc5dc
References: <CGME20210311121850epcas1p493c255a586998916febfebaf994bc5dc@epcas1p4.samsung.com>
	<1615464651-23675-1-git-send-email-jhs2.lee@samsung.com>
	<1615464651-23675-2-git-send-email-jhs2.lee@samsung.com>
	<CABCJKucMyQbtt-LACCRSk6bxAqmS05eVhv-5ou3_XZ1Nz+XYug@mail.gmail.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 12C74KUr031395
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 15 Mar 2021 04:55:29 -0400
Cc: 'device-mapper development' <dm-devel@redhat.com>,
	'Alasdair Kergon' <agk@redhat.com>, 'Mike Snitzer' <snitzer@redhat.com>,
	'LKML' <linux-kernel@vger.kernel.org>
Subject: Re: [dm-devel] [PATCH 2/2] dm verity: allow only one verify mode
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: ko
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hello, Dear Sami Tolvanen.
Thank you for reply.

> I agree that we shouldn't allow this, at least not without a warning, but
> out of curiosity, do you actually have a situation where this could happen?
> One ideally shouldn't be passing untrusted parameters to dm-verity.

Of course, I don't think this will happen because they are dm-verity experts.
But since we are humans, I think this case could happen accidentally.
So it would be a good at preventing these cases.

> I don't have a strong opinion about this, but the documentation doesn't
> talk about verity modes, so perhaps this could be reworded to something
> like "Conflicting error handling parameters"?

Yes of course. That looks better.

I also had some ambiguous about how to express it. 
This is because I couldn't find it in document. 
The code says verity mode, so I wrote it down. never mind it :) 

like this)
    case DM_VERITY_MODE_LOGGING:
    case DM_VERITY_MODE_RESTART:
    case DM_VERITY_MODE_PANIC:


> On Thu, Mar 11, 2021 at 4:19 AM JeongHyeon Lee <jhs2.lee@samsung.com>
> wrote:
> >
> > If there are multiple verity mode when parsing the verity mode of dm
> > verity table, it will be set as the last one.
> > So set to 'allow only once' to prevent it.
> 
> I agree that we shouldn't allow this, at least not without a warning, but
> out of curiosity, do you actually have a situation where this could happen?
> One ideally shouldn't be passing untrusted parameters to dm-verity.
> 
> >
> > Signed-off-by: JeongHyeon Lee <jhs2.lee@samsung.com>
> > ---
> >  drivers/md/dm-verity-target.c | 38
> > ++++++++++++++++++++++++++---------
> >  1 file changed, 28 insertions(+), 10 deletions(-)
> >
> > diff --git a/drivers/md/dm-verity-target.c
> > b/drivers/md/dm-verity-target.c index 808a98ef624c..b76431dc7721
> > 100644
> > --- a/drivers/md/dm-verity-target.c
> > +++ b/drivers/md/dm-verity-target.c
> > @@ -893,6 +893,28 @@ static int verity_alloc_zero_digest(struct
> dm_verity *v)
> >         return r;
> >  }
> >
> > +static inline bool verity_is_verity_mode(const char *arg_name) {
> > +       return (!strcasecmp(arg_name, DM_VERITY_OPT_LOGGING) ||
> > +               !strcasecmp(arg_name, DM_VERITY_OPT_RESTART) ||
> > +               !strcasecmp(arg_name, DM_VERITY_OPT_PANIC)); }
> > +
> > +static int verity_parse_verity_mode(struct dm_verity *v, const char
> > +*arg_name) {
> > +       if (v->mode)
> > +               return -EINVAL;
> > +
> > +       if (!strcasecmp(arg_name, DM_VERITY_OPT_LOGGING))
> > +               v->mode = DM_VERITY_MODE_LOGGING;
> > +       else if (!strcasecmp(arg_name, DM_VERITY_OPT_RESTART))
> > +               v->mode = DM_VERITY_MODE_RESTART;
> > +       else if (!strcasecmp(arg_name, DM_VERITY_OPT_PANIC))
> > +               v->mode = DM_VERITY_MODE_PANIC;
> > +
> > +       return 0;
> > +}
> > +
> >  static int verity_parse_opt_args(struct dm_arg_set *as, struct
> dm_verity *v,
> >                                  struct dm_verity_sig_opts
> > *verify_args)  { @@ -916,16 +938,12 @@ static int
> > verity_parse_opt_args(struct dm_arg_set *as, struct dm_verity *v,
> >                 arg_name = dm_shift_arg(as);
> >                 argc--;
> >
> > -               if (!strcasecmp(arg_name, DM_VERITY_OPT_LOGGING)) {
> > -                       v->mode = DM_VERITY_MODE_LOGGING;
> > -                       continue;
> > -
> > -               } else if (!strcasecmp(arg_name, DM_VERITY_OPT_RESTART)) {
> > -                       v->mode = DM_VERITY_MODE_RESTART;
> > -                       continue;
> > -
> > -               } else if (!strcasecmp(arg_name, DM_VERITY_OPT_PANIC)) {
> > -                       v->mode = DM_VERITY_MODE_PANIC;
> > +               if (verity_is_verity_mode(arg_name)) {
> > +                       r = verity_parse_verity_mode(v, arg_name);
> > +                       if (r) {
> > +                               ti->error = "Already verity mode set";
> 
> I don't have a strong opinion about this, but the documentation doesn't
> talk about verity modes, so perhaps this could be reworded to something
> like "Conflicting error handling parameters"?
> 
> > +                               return r;
> > +                       }
> >                         continue;
> >
> >                 } else if (!strcasecmp(arg_name,
> > DM_VERITY_OPT_IGN_ZEROES)) {
> > --
> > 2.17.1
> >
> 
> Sami


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

