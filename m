Return-Path: <SRS0=VWZ+=IN=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FDB6C433DB
	for <dm-devel@archiver.kernel.org>; Mon, 15 Mar 2021 08:56:06 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 9F44464E90
	for <dm-devel@archiver.kernel.org>; Mon, 15 Mar 2021 08:56:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9F44464E90
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=samsung.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-193-IuzkhgN1NsGWaXYQlwpzzw-1; Mon, 15 Mar 2021 04:56:01 -0400
X-MC-Unique: IuzkhgN1NsGWaXYQlwpzzw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8A5D68189CD;
	Mon, 15 Mar 2021 08:55:56 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6CE5C5D9DC;
	Mon, 15 Mar 2021 08:55:56 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 3E6821800B72;
	Mon, 15 Mar 2021 08:55:56 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12F3dRrx001096 for <dm-devel@listman.util.phx.redhat.com>;
	Sun, 14 Mar 2021 23:39:28 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id A90761111A41; Mon, 15 Mar 2021 03:39:27 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A40AC1111A40
	for <dm-devel@redhat.com>; Mon, 15 Mar 2021 03:39:25 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1806D800B28
	for <dm-devel@redhat.com>; Mon, 15 Mar 2021 03:39:25 +0000 (UTC)
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-600-rNTzQfHuO366hrVNWLsoqA-1; Sun, 14 Mar 2021 23:39:22 -0400
X-MC-Unique: rNTzQfHuO366hrVNWLsoqA-1
Received: from epcas1p1.samsung.com (unknown [182.195.41.45])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id
	20210315033919epoutp02a96f5e1e01d05b9020c968cc8614fe47~sZvLRaiG-1365913659epoutp02Q
	for <dm-devel@redhat.com>; Mon, 15 Mar 2021 03:39:19 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com
	20210315033919epoutp02a96f5e1e01d05b9020c968cc8614fe47~sZvLRaiG-1365913659epoutp02Q
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
	epcas1p4.samsung.com (KnoxPortal) with ESMTP id
	20210315033919epcas1p4a2015de13a4d1ec33c9e48ed8a626e70~sZvLFDfnB1168711687epcas1p48;
	Mon, 15 Mar 2021 03:39:19 +0000 (GMT)
Received: from epsmges1p1.samsung.com (unknown [182.195.40.161]) by
	epsnrtp1.localdomain (Postfix) with ESMTP id 4DzMbp1grlz4x9QJ;
	Mon, 15 Mar 2021 03:39:18 +0000 (GMT)
Received: from epcas1p1.samsung.com ( [182.195.41.45]) by
	epsmges1p1.samsung.com (Symantec Messaging Gateway) with SMTP id
	2B.6F.02418.6E6DE406; Mon, 15 Mar 2021 12:39:18 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas1p3.samsung.com (KnoxPortal) with ESMTPA id
	20210315033917epcas1p39ee45fb36b097aae1fb4cac32464e8dc~sZvJsakAi0336603366epcas1p32;
	Mon, 15 Mar 2021 03:39:17 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20210315033917epsmtrp175811e8eeb0f7d06bc617eb9b14969c5~sZvJrxqn21319713197epsmtrp1B;
	Mon, 15 Mar 2021 03:39:17 +0000 (GMT)
X-AuditID: b6c32a35-c23ff70000010972-4a-604ed6e66b11
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
	23.C0.08745.5E6DE406; Mon, 15 Mar 2021 12:39:17 +0900 (KST)
Received: from jjungs-linux (unknown [10.253.101.104]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20210315033917epsmtip115028f0ce1f6615e595f32b01a9540cd~sZvJfIEPT0180001800epsmtip1d;
	Mon, 15 Mar 2021 03:39:17 +0000 (GMT)
Date: Mon, 15 Mar 2021 12:33:42 +0900
From: JeongHyeon Lee <jhs2.lee@samsung.com>
To: samitolvanen@google.com
Message-ID: <20210315033342.GB13408@jjungs-linux>
MIME-Version: 1.0
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMKsWRmVeSWpSXmKPExsWy7bCmru6za34JBv9nclqsP3WM2WLvu9ms
	Fpd3zWGzWLriLatF28avjA6sHgs2lXq833eVzePzJrkA5qgcm4zUxJTUIoXUvOT8lMy8dFsl
	7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zBygjUoKZYk5pUChgMTiYiV9O5ui/NKSVIWM
	/OISW6XUgpScAkODAr3ixNzi0rx0veT8XCtDAwMjU6DKhJyM3t6DTAUT1SruTl7D2MB4VrqL
	kZNDQsBE4tqc5+xdjFwcQgI7GCXuPV3IBOF8YpS4e3U9O0iVkMBnRonH27NhOh5cnccKEd/F
	KHHroxhEw2tGidbnG9hAEiwCqhKTn+xiBLHZBLQlbrdsAhskIiAtcWnWDCYQm1kgWmLb5mNA
	NgeHsICdxIIv6SBhXgFDiU+LWhghbEGJkzOfsICUiAqoSLw6WA+ySkJgH7vEkv6LjCBxCQEX
	iTmbCyBOE5Z4dXwLO4QtJfGyv40dor6bUeL++ddsEIkJjBK9PUwQvfYS7y9ZQFyTKfFv6wyo
	XkWJnb/nMkLE+STefe1hhSjnlehoE4IoUZJY8e8aC4QtIbHhcDfUdA+JhvM3oaEWK3Hpxm2m
	CYxys5A8MwvJNghbR2LB7k9ss4A2MAPDZ/k/DghTU2L9Lv0FjKyrGMVSC4pz01OLDQsMkSN3
	EyM49WmZ7mCc+PaD3iFGJg7GQ4wSHMxKIryfdXwThHhTEiurUovy44tKc1KLDzGaAiNmIrOU
	aHI+MPnmlcQbmhoZGxtbmJiZm5kaK4nzJhk8iBcSSE8sSc1OTS1ILYLpY+LglGpgMm//bBgZ
	vbPhwYYp/gmlm5ruaxpea1r9lE/5NlOY8DXBLQf7uQoED3JwW3sc3PH6WreLb072x7sliesa
	mPR2Zha6xHj8iXxnEjlPU+jk9htVDV/VDIMTyhad2SY6ac78oCXrDizYHWXUwnrq1p4XD4LE
	mENVHmftbTa5udj4n153nN/BBxalngtmPxZn3pBdvnV1+hEjj7u5C0IDs6UZpW19Nljuu/Bm
	lcCK9q5bH4r1S238Crg/pG7+cUOauaiszzQvcp/OqdQ/P+J7Xs56YfZUoIl9m8Nd0aUmLkuL
	vf7zmc2+u/NhKiNv4tqdV5TN5C74nwv+KnnRruLPmTtPD9soOCqx3BGS0ds5+bi/EktxRqKh
	FnNRcSIA/jlfjQYEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDLMWRmVeSWpSXmKPExsWy7bCSnO7Ta34JBmeeKlmsP3WM2WLvu9ms
	Fpd3zWGzWLriLatF28avjA6sHgs2lXq833eVzePzJrkA5igum5TUnMyy1CJ9uwSujJXtL9kK
	zilXbHpo1sC4WLKLkZNDQsBE4sHVeaxdjFwcQgI7GCVufrrFDpGQkNiwaS2QzQFkC0scPlwM
	UfOSUeL+6RWsIDUsAqoSk5/sYgSx2QS0JW63bALrFRGQlrg0awYTiM0sEC2xbfMxJpA5wgJ2
	Egu+pIOEeQUMJT4tamGEsAUlTs58wgJRriVx499LsHJmoDHL/3GAmKICKhKvDtZPYOSfhaRh
	FpKGWQgNCxiZVzFKphYU56bnFhsWGOWllusVJ+YWl+al6yXn525iBAeoltYOxj2rPugdYmTi
	YDzEKMHBrCTC+1nHN0GINyWxsiq1KD++qDQntfgQozQHi5I474Wuk/FCAumJJanZqakFqUUw
	WSYOTqkGJldWn7zs7xFM/R69vhfue7wuCj5vVfCyZwKz5W/3coZCk8KN4onXot7tNf9wZWfw
	i8lcFuwfFzw2bC7tya/MvvZv3/HatMe6274uU96u9H7zrgt77p2dJv5PcU/o053cezh49xzL
	vHZP5LXS0fP2T+xcHgbxy55QbShY+eeensHkWSUqKy7zLNSMjKrM/CUsfkxmnbvYvXmiCayB
	x1he7WiuNBec/ibKtnKKxtNpj9+lVCVlbQibNrHrqUjOuYTt0YzLROu0bQXPyb/03p5tt0zw
	7+UCzr0Kcx90e8858rLZS6HD+8xmtUoXdptqSUudgwxcefPfyUTNnHlm5oOWst9rz3ww3qid
	tdA7S3jfMSWW4oxEQy3mouJEACN+hRy/AgAA
X-CMS-MailID: 20210315033917epcas1p39ee45fb36b097aae1fb4cac32464e8dc
X-Msg-Generator: CA
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210315033917epcas1p39ee45fb36b097aae1fb4cac32464e8dc
References: <CGME20210315033917epcas1p39ee45fb36b097aae1fb4cac32464e8dc@epcas1p3.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 15 Mar 2021 04:55:29 -0400
Cc: dm-devel@redhat.com, agk@redhat.com, snitzer@redhat.com,
	linux-kernel@vger.kernel.org
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
Content-Type: multipart/mixed;
	boundary="----V1oBYrHh8kVlH0vl1DhTBnbYZqliemR8pfKkIoDTIwboyIJz=_300463_"

------V1oBYrHh8kVlH0vl1DhTBnbYZqliemR8pfKkIoDTIwboyIJz=_300463_
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline

Hello, Dear Sami Tolvanen.
Thank you for reply. Sorry, I send it again because my setting is wrong.

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

Thank you,
JeongHyeon Lee.

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


------V1oBYrHh8kVlH0vl1DhTBnbYZqliemR8pfKkIoDTIwboyIJz=_300463_
Content-Type: text/plain; charset="utf-8"


------V1oBYrHh8kVlH0vl1DhTBnbYZqliemR8pfKkIoDTIwboyIJz=_300463_
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel
------V1oBYrHh8kVlH0vl1DhTBnbYZqliemR8pfKkIoDTIwboyIJz=_300463_--

