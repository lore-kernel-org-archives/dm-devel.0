From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: RE: [PATCH 1/3][RESUBMIT] scsi_dh_rdac: changes to collect
	the	debug information during rdac_activate
Date: Fri, 28 Aug 2009 18:06:04 -0700
Message-ID: <1251507964.26079.6.camel@chandra-ubuntu>
References: <E463DF2B2E584B4A82673F53D62C2EF474C65F3D@cosmail01.lsi.com>
	 <1251482228.20333.9.camel@chandra-ubuntu>
	 <E463DF2B2E584B4A82673F53D62C2EF474C66194@cosmail01.lsi.com>
Reply-To: sekharan@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <E463DF2B2E584B4A82673F53D62C2EF474C66194@cosmail01.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
To: "Moger, Babu" <Babu.Moger@lsi.com>
Cc: Linux SCSI Mailing list <linux-scsi@vger.kernel.org>, 'device mapper development' <dm-devel@redhat.com>, "Chauhan, Vijay" <Vijay.Chauhan@lsi.com>, "Stankey, Robert" <Robert.Stankey@lsi.com>, "Dachepalli, Sudhir" <Sudhir.Dachepalli@lsi.com>
List-Id: dm-devel.ids

Looks good, except for this one line
> +		h->ctlr->array_name[ARRAY_LABEL_LEN-1] = '\0';

should be array_name instead.

Thanks

chandra
<snip>

