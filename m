Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0BC9C64EC3
	for <dm-devel@archiver.kernel.org>; Mon,  6 Feb 2023 07:38:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1675669122;
	h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=5e7a8zMvXO8T7G5RZmA/2JDRVAZ/jn4ly+m9OVkdu1k=;
	b=e0zUVDVLHggFGbOko9jbKLOzw3hc1+4VRHhel0X9iVhM5vmK4oXllqhov3bx8zkjh9lHqP
	AsfRavbMyxr17OSbKNAlKqxzEIDCyyXZsN/X3puYmQYjG0uKIJys+bgm4VCU03g1DvATIy
	+bg41I/VaZnKpquMyHQ5O1XME9xW57g=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-44-p6BUdiQyP3ODgSTuZej4mA-1; Mon, 06 Feb 2023 02:38:37 -0500
X-MC-Unique: p6BUdiQyP3ODgSTuZej4mA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2C912100F913;
	Mon,  6 Feb 2023 07:38:36 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id EC35340398A3;
	Mon,  6 Feb 2023 07:38:34 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id A4E9B1946A46;
	Mon,  6 Feb 2023 07:38:33 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 008B41946586
 for <dm-devel@listman.corp.redhat.com>; Thu,  2 Feb 2023 18:55:56 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D5549C15BA0; Thu,  2 Feb 2023 18:55:56 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id CD753C15BAE
 for <dm-devel@redhat.com>; Thu,  2 Feb 2023 18:55:56 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A4E1E88F477
 for <dm-devel@redhat.com>; Thu,  2 Feb 2023 18:55:39 +0000 (UTC)
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com
 [148.163.158.5]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-601-tAT1-dKzOny730AFUMHjuw-1; Thu, 02 Feb 2023 13:55:34 -0500
X-MC-Unique: tAT1-dKzOny730AFUMHjuw-1
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
 by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id
 312HIHJG002547; Thu, 2 Feb 2023 18:55:14 GMT
Received: from pps.reinject (localhost [127.0.0.1])
 by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ngeuff378-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
 Thu, 02 Feb 2023 18:55:14 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
 by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 312InxkJ010732;
 Thu, 2 Feb 2023 18:55:14 GMT
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com
 [169.63.121.186])
 by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ngeuff36u-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
 Thu, 02 Feb 2023 18:55:14 +0000
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
 by ppma03wdc.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 312IQsak007753;
 Thu, 2 Feb 2023 18:55:12 GMT
Received: from smtprelay04.dal12v.mail.ibm.com ([9.208.130.102])
 by ppma03wdc.us.ibm.com (PPS) with ESMTPS id 3ncvtf51nu-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
 Thu, 02 Feb 2023 18:55:12 +0000
Received: from b03ledav001.gho.boulder.ibm.com ([9.17.130.232])
 by smtprelay04.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id
 312ItBP011600580
 (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Thu, 2 Feb 2023 18:55:12 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
 by IMSVA (Postfix) with ESMTP id 90C1C6E050;
 Thu,  2 Feb 2023 18:57:22 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
 by IMSVA (Postfix) with ESMTP id A3D826E04E;
 Thu,  2 Feb 2023 18:57:16 +0000 (GMT)
Received: from lingrow.int.hansenpartnership.com (unknown [9.211.110.248])
 by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
 Thu,  2 Feb 2023 18:57:15 +0000 (GMT)
Message-ID: <ac6270fe1dba1b3398dc2b830cf9bda5c89a7a3d.camel@linux.ibm.com>
From: James Bottomley <jejb@linux.ibm.com>
To: Jonathan Corbet <corbet@lwn.net>, Bart Van Assche <bvanassche@acm.org>,
 Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org
Date: Thu, 02 Feb 2023 13:54:33 -0500
In-Reply-To: <87o7qbvra9.fsf@meer.lwn.net>
References: <20230129231053.20863-1-rdunlap@infradead.org>
 <875yckvt1b.fsf@meer.lwn.net>
 <a2c560bb-3b5c-ca56-c5c2-93081999281d@infradead.org>
 <8540c721-6bb9-3542-d9bd-940b59d3a7a4@acm.org>
 <87o7qbvra9.fsf@meer.lwn.net>
User-Agent: Evolution 3.42.4
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: kpy74EhUO0uEMlXQ9KTqHLip0-xHCshx
X-Proofpoint-ORIG-GUID: eZPeQqFlkdhx5p58topJeC6q8R4gRCuD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-02_12,2023-02-02_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0
 mlxlogscore=980 mlxscore=0 malwarescore=0 priorityscore=1501
 impostorscore=0 bulkscore=0 phishscore=0 spamscore=0 clxscore=1011
 suspectscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2212070000 definitions=main-2302020166
X-MIME-Autoconverted: from 8bit to quoted-printable by
 mx0a-001b2d01.pphosted.com id 312HIHJG002547
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mailman-Approved-At: Mon, 06 Feb 2023 07:38:31 +0000
Subject: Re: [dm-devel] [PATCH 0/9] Documentation: correct lots of spelling
 errors (series 2)
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
Reply-To: jejb@linux.ibm.com
Cc: nvdimm@lists.linux.dev, linux-doc@vger.kernel.org,
 Song Liu <song@kernel.org>, dm-devel@redhat.com,
 Zefan Li <lizefan.x@bytedance.com>, sparclinux@vger.kernel.org,
 Neeraj Upadhyay <quic_neeraju@quicinc.com>, Alasdair Kergon <agk@redhat.com>,
 Dave Jiang <dave.jiang@intel.com>, linux-scsi@vger.kernel.org,
 Vishal Verma <vishal.l.verma@intel.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Guenter Roeck <linux@roeck-us.net>,
 linux-media@vger.kernel.org, Jean Delvare <jdelvare@suse.com>, "Paul E.
 McKenney" <paulmck@kernel.org>, Frederic Weisbecker <frederic@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Mike Snitzer <snitzer@kernel.org>,
 Josh Triplett <josh@joshtriplett.org>, linux-raid@vger.kernel.org,
 dmaengine@vger.kernel.org, Jiri Pirko <jiri@nvidia.com>,
 cgroups@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>,
 Mauro Carvalho Chehab <mchehab@kernel.org>, linux-hwmon@vger.kernel.org,
 rcu@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>,
 linux-mm@kvack.org, netdev@vger.kernel.org, linux-usb@vger.kernel.org,
 Eric Dumazet <edumazet@google.com>, Vinod Koul <vkoul@kernel.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Tejun Heo <tj@kernel.org>,
 "David S. Miller" <davem@davemloft.net>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gVGh1LCAyMDIzLTAyLTAyIGF0IDExOjQ2IC0wNzAwLCBKb25hdGhhbiBDb3JiZXQgd3JvdGU6
Cj4gQmFydCBWYW4gQXNzY2hlIDxidmFuYXNzY2hlQGFjbS5vcmc+IHdyaXRlczoKPiAKPiA+IE9u
IDIvMi8yMyAxMDozMywgUmFuZHkgRHVubGFwIHdyb3RlOgo+ID4gPiBPbiAyLzIvMjMgMTA6MDks
IEpvbmF0aGFuIENvcmJldCB3cm90ZToKPiA+ID4gPiBSYW5keSBEdW5sYXAgPHJkdW5sYXBAaW5m
cmFkZWFkLm9yZz4gd3JpdGVzOgo+ID4gPiA+ID4gwqAgW1BBVENIIDYvOV0gRG9jdW1lbnRhdGlv
bjogc2NzaS9DaGFuZ2VMb2cqOiBjb3JyZWN0Cj4gPiA+ID4gPiBzcGVsbGluZwo+ID4gPiA+ID4g
wqAgW1BBVENIIDcvOV0gRG9jdW1lbnRhdGlvbjogc2NzaTogY29ycmVjdCBzcGVsbGluZwo+ID4g
PiA+IAo+ID4gPiA+IEkndmUgbGVmdCB0aGVzZSBmb3IgdGhlIFNDU0kgZm9sa3MgZm9yIG5vdy7C
oCBEbyB3ZSAqcmVhbGx5Kgo+ID4gPiA+IHdhbnQgdG8gYmUKPiA+ID4gPiBmaXhpbmcgc3BlbGxp
bmcgaW4gQ2hhbmdlTG9nIGZpbGVzIGZyb20gYWxtb3N0IDIwIHllYXJzIGFnbz8KPiA+ID4gCj4g
PiA+IFRoYXQncyB3aHkgSSBtYWRlIGl0IGEgc2VwYXJhdGUgcGF0Y2ggLS0gc28gdGhlIFNDU0kg
Zm9sa3MgY2FuCj4gPiA+IGRlY2lkZSB0aGF0Li4uCj4gPiAKPiA+IEhvdyBhYm91dCByZW1vdmlu
ZyB0aGUgRG9jdW1lbnRhdGlvbi9zY3NpL0NoYW5nZUxvZy4qIGZpbGVzPyBJJ20KPiA+IG5vdCBz
dXJlIHRoZXNlIGNoYW5nZWxvZ3MgYXJlIHN0aWxsIHVzZWZ1bCBzaW5jZSB0aGVzZSBkdXBsaWNh
dGUKPiA+IGluZm9ybWF0aW9uIHRoYXQgaXMgYWxyZWFkeSBhdmFpbGFibGUgaW4gdGhlIG91dHB1
dCBvZiBnaXQgbG9nCj4gPiAke2RyaXZlcl9kaXJlY3Rvcnl9Lgo+IAo+IEFjdHVhbGx5LCB0aGUg
aW5mb3JtYXRpb24gaW4gdGhvc2UgZmlsZXMgbW9zdGx5IHByZWRhdGVzIHRoZSBnaXQgZXJhLAo+
IHNvIHlvdSB3b24ndCBmaW5kIGl0IHRoYXQgd2F5LsKgIEkgKnN0aWxsKiBxdWVzdGlvbiB0aGVp
ciB2YWx1ZSwKPiB0aG91Z2guLi4KCkluIHRoZSBwcmUtc291cmNlIGNvbnRyb2wgZGF5cyB0aGV5
IHdlcmUgdGhlIGFuc3dlciB0byB0aGUgR1BMdjIKU2VjdGlvbiAyIHJlcXVpcmVtZW50IHRvICIg
Y2FycnkgcHJvbWluZW50IG5vdGljZXMgc3RhdGluZyB0aGF0IHlvdQpjaGFuZ2VkIHRoZSBmaWxl
cyBhbmQgdGhlIGRhdGUgb2YgYW55IGNoYW5nZS4iIAoKSWYgeW91IHJlbW92ZSB0aGUgZmlsZXMg
eW91IG1heSBydW4gYWZvdWwgb2YgdGhlIEdQTHYyIFNlY3Rpb24gMQpyZXF1aXJlbWVudCB0byAi
a2VlcCBpbnRhY3QgYWxsIHRoZSBub3RpY2VzIHRoYXQgcmVmZXIgdG8gdGhpcwpMaWNlbnNlIi4g
IE9mIGNvdXJzZSwgbm93YWRheXMgd2UgYXNzdW1lIHRoZSBzb3VyY2UgY29udHJvbCBkb2VzIHRo
aXMKZm9yIHVzLCBzbyBwZW9wbGUgcmFyZWx5IHRoaW5rIG9mIHRoZXNlIHJlcXVpcmVtZW50cywg
YnV0IGZvciBmaWxlcwp0aGF0IHByZWRhdGUgc291cmNlIGNvbnRyb2wgSSB0aGluayB5b3UgbmVl
ZCB0byBjb25zaWRlciB0aGUgbGljZW5jZQppbXBsaWNhdGlvbnMuCgpKYW1lcwoKCi0tCmRtLWRl
dmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vbGlzdG1hbi5yZWRo
YXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWwK

