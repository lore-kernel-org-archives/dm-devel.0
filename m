Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF49813BAFA
	for <dm-devel@lists.linux.dev>; Mon, 24 Jun 2024 13:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719234093; cv=fail; b=Dyg+6KIcwX2smgd8NUDVkN3xSVI+8Kq8nmw9+wZ9T9gocx4/13p7YTyq5bMA/xQgDLoOEurwvLxIvtZJoPZAkBqd1i+z2pWa8IThSLuc7uSV7qCfpIj8BoCnLq6EGi/Dn8tztWnk3zRYq98VzVLGpIhmDnye/yBTCLz7fGPNnjw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719234093; c=relaxed/simple;
	bh=8UPUCJUaQKWXMtXjurm/s/kKeKx0hJygOdKMlGk9G9Y=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=SHoO6VW8fJFXDzJAwh+V+a4eB2jIXKQLACYFVg7kaAwfbJRDaa0roOCA0ilmwXAvbJuGdh82QjsWRsu+w8VohL3XuTxhKxPUvZ9bFM39o86rbFfT66JjpXK8nHAmOlIo7eWdhr10iMe+rV1YlVh7MwvZk6Joy6w7/eb1gzeVwyc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=QbCHXTy8; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=RahgHZoq; arc=fail smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="QbCHXTy8";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="RahgHZoq"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1719234091; x=1750770091;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=8UPUCJUaQKWXMtXjurm/s/kKeKx0hJygOdKMlGk9G9Y=;
  b=QbCHXTy8hHgjwNt+7z2vk1y1f9M83I7ehlLakEDsCeIszIXToA6QT8X7
   xvGqpKrA0/w0+HgGpUZXC6j49QBhlHFKHdh4nN2KESAKIlWw49eyKSJPk
   h0Tg9iMNbglJ3tUdhF5Zi5VfGfFSDIUe6ySm2U6fNOuv4XUdaxN9g51Ph
   2YrmOr1gno6wMkxsNjZ5A5iv8pvwGsNJOae0GclhVdYJEupPszgyPZjxE
   lGHcseWRd7iElas9NTNW3eDMkWed8OMauMI36WwiHdiXodA3xhJTOZDcx
   inwRGFv2JlOY476Xjj/Dbj3siwk8zwlbj7bqOLQoPlNAXVx/bbTY46Yjj
   Q==;
X-CSE-ConnectionGUID: Xa49Y4NoQP2Ro4BIobiOvw==
X-CSE-MsgGUID: wKdrWlBnQg2HJ7aW1Xw3Zg==
X-IronPort-AV: E=Sophos;i="6.08,262,1712592000"; 
   d="scan'208";a="19853976"
Received: from mail-bn8nam12lp2174.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.174])
  by ob1.hgst.iphmx.com with ESMTP; 24 Jun 2024 21:01:28 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fjCE2FKbS4YYll3g1V4gFpiiW4EjX6wzXTfMLsbNAhiWXN41LuUF879+Xato3gOOXE5HB/N1lk6rtc1VPRI47o+u1CBs6i74C+vjUojijmV4GLO0/bs+tATDaOmDKw3bMNKKZuGHgwVAU5XpS53Nc/5bBjYApl/AYMmg0fo8MDsY2QyXv1iQJhlcvlDDAicw1xinTj4CA7cEFVZjwDXXmhy2FaDTe3xpaNoY/xtu5P2/6/YYi74hXRjogViOh7Pug5oHBQ8WU7FOk5fTxwHyChL1RvQXGJQSbL9sIvgejZJq79tbPrlRrhRx9jDMJTkGtqMWpfNmMzDvO6B0pibhhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GYO9cIScqw7yUuNrq3hSf7oUJEDaVI1hWM05mp6wukI=;
 b=dis16ojaaq10J1NaY3tpJtt4no6ix7ggrklncJa4wTkf+7pkPUL6lJ+86cLER1zVJiRVg90m0nibSUIpPnxrnsnTCLgMfGdrDKKzpkC6eDKVRVhSNoK8IZkSc3jeHjzuthLwmSkeHaNwo6Tqrs2nJutYE0u38MInc/l04oEabLa4KaZwLqqymfttZI7K9L07g23XjbdXRHOLdVAQjmvcmRXVCZpJJ6CoCfICD/HV+gDVXrVHhQBc8vfJ/VTi7ekkiAN7KokrBA0YhHLCIwxRzIUDz0iYzYZFt40+zRczixnoM9pArhN6tLGVHxMmTwJhBY7iBZU1IfieTw7knM2QEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GYO9cIScqw7yUuNrq3hSf7oUJEDaVI1hWM05mp6wukI=;
 b=RahgHZoqEgXfJLTA0Kri3s8a+L9SbbtmAS5qqrl3UdapxQjoyprHvM3guAogaGKcQU3TWvsftsaVqM1egu6uVOMnWY9orv8F0mZWWIweUXSSUzsAbVpaSEGUZwxeh9Xj6y9CxgyMfNpiqJ61Blbu5+efIyVpa1HmuBDypzwmHHY=
Received: from DM8PR04MB8037.namprd04.prod.outlook.com (2603:10b6:8:f::6) by
 DM6PR04MB6745.namprd04.prod.outlook.com (2603:10b6:5:22a::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7698.25; Mon, 24 Jun 2024 13:01:27 +0000
Received: from DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::b27f:cdfa:851:e89a]) by DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::b27f:cdfa:851:e89a%3]) with mapi id 15.20.7698.025; Mon, 24 Jun 2024
 13:01:27 +0000
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: "hch@infradead.org" <hch@infradead.org>
CC: Bryan Gurney <bgurney@redhat.com>, "linux-block@vger.kernel.org"
	<linux-block@vger.kernel.org>, "dm-devel@lists.linux.dev"
	<dm-devel@lists.linux.dev>
Subject: Re: blktests dm/002 always fails for me
Thread-Topic: blktests dm/002 always fails for me
Thread-Index:
 AQHavWqPXCpPMpKn4ECcCs6HQBvzjLHGxlmAgAAB4wCAD6M9gIAAPsiAgAAsPgCAAAcWAIAAFNQA
Date: Mon, 24 Jun 2024 13:01:27 +0000
Message-ID: <lkgvrxzyxf5gpxzdb5yq5epbhhxdz72rfqnjbzg4qyi6npndsw@g6wkv5jh37wj>
References: <ZmqrzUyLcUORPdOe@infradead.org>
 <pysa5z7udtu2rotezahzhkxjif7kc4nutl3b2f74n3qi2sp7wr@nt5morq6exph>
 <ZmvezI1KcsyE3Unl@infradead.org>
 <42ecobcsduvlqh77iavjj2p3ewdh7u4opdz4xruauz4u5ddljz@yr7ye4fq72tr>
 <Znkxn7LymUjD3Wac@infradead.org>
 <i4skne2yegneuyuw7nqt2mziuywjwo2p54emgba3fjcg5rflhe@dvqy65je7boc>
 <ZnlcrgxYvqqy5uoK@infradead.org>
In-Reply-To: <ZnlcrgxYvqqy5uoK@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR04MB8037:EE_|DM6PR04MB6745:EE_
x-ms-office365-filtering-correlation-id: dc89c744-121f-40f1-6ebf-08dc944dc23b
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230037|366013|376011|1800799021|38070700015;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?mtuOgIukx+sgp70mYfyaU9sX7xHv9BZKShirP6LN8h1ZW3eNFWoQSIj7biLH?=
 =?us-ascii?Q?aj3qhVC8RUDKEFErSW4gyn/sdFKGIGupe75Xl1NMDPSUa6uP0/DwWxvQDVST?=
 =?us-ascii?Q?b83LA1/HwTDvpK7xyyPSnYAhOVuYYPowR9+7ZSC0aUFPzs0b0IQ6JUDE9HFR?=
 =?us-ascii?Q?YY0VWww0WAveGexpHKHtYoKPEOdsDK6F2nn9+uL3GmxSmcEG0fX5MHfRSRF1?=
 =?us-ascii?Q?bJfvc7ePkPDa4aZV0IHUKBW2cfwdQPNumA/HuZeDUYNOVqL40g6gVcTPXf+N?=
 =?us-ascii?Q?N72WGugKWNeJ5YbRPxiiYRMG50qyxj0C3awEugv3BkbyqPj/ftkQ9ajoZl+/?=
 =?us-ascii?Q?2NydcEWFxxngInP5kn0tVNg2cUP2PzZidNupw/8uDzMKWW74u/6g1ptTDI5z?=
 =?us-ascii?Q?2uM4jsZjRLthWZLCIINhuAf7G+UQgBRzIzIk3aK7kKwcvKuUDZqiDKzy+jjG?=
 =?us-ascii?Q?oZRr6Y+o4ZD+O+3gnOF2msW3Tt4Lk8CAl6VLRVBV6pQ0SMUsBiVjsf54BENa?=
 =?us-ascii?Q?WVQ2bxcz3PUHe8BlirRim1kH4gCmohbzOw6a1N8lxn2KJPAXmrInQRaGtDBl?=
 =?us-ascii?Q?GCGqzUNdW2l2YcaC7R5Kn6XP4fPvCREKGVhjyegSCw0goy6h5kP/XwXSQDeH?=
 =?us-ascii?Q?WIoEOIghEamAobYeprdiLn9wchYiEb/wfLfnKkUxGkM59B16Nkttqu4WZ9fw?=
 =?us-ascii?Q?FWyTiua/8nVNFRUWScnHGMbw43JxEvOXsBsmS+KhHSIJQ5ykax8yDu8xdpng?=
 =?us-ascii?Q?QEngB8ExEfslBnPl7+CwoBDg6P+tuCkzxPfo2Ptx7dNTBl5poylOwUHjLg08?=
 =?us-ascii?Q?RPY5ZSVWMAFZC8lfNvcpvxNRoSA2nYo6naAWKy7kbVy/ECoYPQAuGzXpTr1I?=
 =?us-ascii?Q?IDcjAN9RK6qfXVi5DAmF7lhe2vyJKmmATBJo+zbntBjjgfqw3NMQ6iUYtMYS?=
 =?us-ascii?Q?WL8v0Lbhd0W7lkBUaVRBIcq0DYmaPI2vYDgM4kCBgUHdcNRgtgH4b8N+TPHW?=
 =?us-ascii?Q?y3DVO6B6OniiIwUKWSXqA8c0an0sIr42SzXML0EA7suom0O5TX5pgz/v0kIJ?=
 =?us-ascii?Q?/ltP3I8BuEtRa0/0rY3N13EhackoJEGWnenDaCEWtyHq+7WfvnYhYAIubJS6?=
 =?us-ascii?Q?VCkg46kuPbyoEK30TQpf1SIr+KNbGqbZ9nKNumtCZesFtXo8OMhGyiknn3ST?=
 =?us-ascii?Q?JDRWdyUQ8XcajrMwotzhAZaHySATgmSmY43EmvwPVA61qBhHg5qKgC1fhnrg?=
 =?us-ascii?Q?KoFS4CAJ8D3X6Pj/UIElkjpgyYVrKT9EloBBN/8bhK7m2pte7wAt1FoUS4qt?=
 =?us-ascii?Q?Lme1WaYS5R6BIGrgs+cfAv8boMDHl/DX7EAYsQZkGoNKrdWm+MJwaF7fUo0M?=
 =?us-ascii?Q?P+WdvYQ=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR04MB8037.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(366013)(376011)(1800799021)(38070700015);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?EjaL7GKgZC7EPddokNCM5fa3ZCw8ER/kPEIHBNNTgW+/t18NOejhLWbQjJrc?=
 =?us-ascii?Q?iWryQ4UTmTKOKA7cp+/8xE82OKm2Dms+nZ5FqgwTXsU4O9eZzt7VuOSe2L7R?=
 =?us-ascii?Q?YHH1+Z5OQGKdsXuWP2iTVsNpk19JPBdqc0VO33bjaIK88Rnb3FmixvOfQu7L?=
 =?us-ascii?Q?Do3fCb5aTODqzyKIPnCm4POyK9BMs3a9uV9g85opdCj2nlOPIJxO/tiNjZNg?=
 =?us-ascii?Q?hHzYqgLgBsSItF343Ty7IMNt4TZrclYnA4X+nRxTIyjD5239jNfT0gFYX6O2?=
 =?us-ascii?Q?wcLeG7TRfbDQc0fZBYNiB8MpwntFYFk/qlQMeA8PLjnfVQsljU0Gjo/hhTFJ?=
 =?us-ascii?Q?osATmfBGIzTLL0067hM5Fq9UVnWMXfowjkjBUSgevNMsBnzEiJ0cVgBJ0ibO?=
 =?us-ascii?Q?IMk/d+SWV2/8IhB93NwXXMpwggeGr7lHlp+0JWVdLnZa4K0IYlI85m+71lWS?=
 =?us-ascii?Q?DMZUm3mGxrR+e+cr6Sv76CkwzwJ4ibgmn+r99OuLhjP9otLcDPFkLk2iNaRh?=
 =?us-ascii?Q?2vgTU0qnuo3KLFeeLA0x0FDN6ps5jtoYxzJhevJPC9jQ4NMuU7pKHO/lGpmv?=
 =?us-ascii?Q?5RlmHUsz56G7XGlai8VYA6ni1czS0YavoB+pOfcCEQ1hg2ZZD4kKFxRx6Adt?=
 =?us-ascii?Q?PFwcW0bFJ7QZOW2nCrNI+3hKQpN33DFtU+gf9NWc7t86Q6KVsjee7Ts6J42R?=
 =?us-ascii?Q?k/xjVdZBSYN/zyvxwTcwOw7GDxiEUDzlHqzWbgpS5evrRp/MvJjbyx50P1FP?=
 =?us-ascii?Q?IcWJq1d8/l/yYxgCCFDplhBnB9rlZSHXBtugqXyJXswn2GtOTD1Gs6A6dw97?=
 =?us-ascii?Q?x+K8oJ/pzqwdpjDQQPUPCYtEHyfF87BKFhN/6bIvv4Ssga164gbdBkAdL/FZ?=
 =?us-ascii?Q?ga3/H7gCU/SIkpWhYqGI+orT31n6Sb6vKCFt2pMyNYWlfHUQHCo/r8KUIUSM?=
 =?us-ascii?Q?SPYFTwz8zk+mocamIXYNaXnfZO7jUs00wYHcaOTt4OfN6DcIfg4rx5lf9XJq?=
 =?us-ascii?Q?Gs6N3uH1H0hGr251kXe4CVOSmGy3Kf6gxwsTK8KdXb/ho33Fppk2hp1Civr+?=
 =?us-ascii?Q?aQM7qwX+lYFMTNN3plC3s5yorqdxdGkyIfiT+9KzR/JSxgygRsOK/Rnfwumh?=
 =?us-ascii?Q?GzipKeM8magtu8xLG6TDYSe5Gu4t6XYbcqkSyQSo8a9wAPDN7ykzx8pnt9TX?=
 =?us-ascii?Q?A+lfIhHVBq1rai7bueJdA0tWEMyxFy2VWs5mVS6jyJAwPbYnCXmi5N+k5lQt?=
 =?us-ascii?Q?pnuPnim8KDpCjSj4KngN2LS4ariHX1MW2fE/BczkNwnNfxuLoI1VHA/yJ2ld?=
 =?us-ascii?Q?7RbygJXjGak69c5LfVIrHIApekxmT2zpAsRnZRedWyjYq/Jb2sOZnGVyrHg6?=
 =?us-ascii?Q?SkJk4p89yCTb1NNsbnILHdyNMjo/yVex8/w/OPO5FrG5whSW5EFBe0CIdNe6?=
 =?us-ascii?Q?Elu71PWsdKwyoZCdvSV4bjVGN1+WyjPCQkjRHa7IiL/Lt9QKlsUYXy9q84/h?=
 =?us-ascii?Q?UzuLNRPEYu9W0KM667pqlFW3aGmJQs9zLwhiQv/iAls97FX0kHUprlVbrNH7?=
 =?us-ascii?Q?O+TqfZf4waUuP0TlJHuaMfeCwOjHjS3TOdUlASV1O69tMS+0GWK0+lEhC317?=
 =?us-ascii?Q?sKbvifAnB+4jmLX+9GqQEds=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <F7B55FA2132BBF42A13E33774F5DFFE4@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	LFeTZbifjgYk7Apvge8cN2ZLt6CMJVXoyZAnVmllJKMXMCQFc/KFgWFauYN3T8pbef9h7IOQ4kl2aIL2vFXn4ARKacOciZNG3NKLujst3txrJRhijj5ahbU3ShUXseSfkN0rpET5g9HDxPv4FfThBb0SCWUm4xbIRxxMyLfko1bxwDdJbZnQeWs8NXsfdzj3EX2QZSvM+zw3xbi7X/ObDAuO0DXBGa3OFO/u1+koKYg7nJ/eru4wMf2gGTaCYGqrk0uEb+uLz0AQtRtna7TUp7kPFk0yc+SR4HArFbpmjydOH2ZWPVzJOGflHvvIlJHOjWBAA2QFg0L5HjTCn8kvLrBP7LWaKLzV0M2EeLnme/UHKeJAadNpSBrYwRE6fO+nUAKQH/9NwPwoyT35yx+9/g7r1F54OANJP3kUK7hsBdbA1ZUCIp/HUAv0+NuqdHz8QduA76QpoZkqXJIL3aSWpTj/mNMBmAJZvdJF5Td/va/7nyRZlsfmMK/bmBofU/y/0KC/5lt30FQ6Y1JKVfZ/udXBoP5Zr3RJE1jGEt/dYqEV6tH7p+L+6TKL3qc6qaZX+Sep9blrf/xNm4+rmERtIyqQE3rGBOU+4LW4lNcT6P8fUf07m9sRQItLFh3Ibhul
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR04MB8037.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc89c744-121f-40f1-6ebf-08dc944dc23b
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jun 2024 13:01:27.1317
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4BoLQti3yKnc7a6qan8y6v/oWX6CeWiFc/diFsKHtSO6cX8ciszG9k1wDsngCsVPn6iacpHVf/ofrArWIjkuZixwk7nt/GwAqTRZGPtA8QM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6745

On Jun 24, 2024 / 04:46, hch@infradead.org wrote:
> On Mon, Jun 24, 2024 at 11:21:33AM +0000, Shinichiro Kawasaki wrote:
> > I took a look in the test script and dm-dust code again, and now I thin=
k the dd
> > command is expected to success. The added bad blocks have default wr_fa=
il_cnt
> > value 0, then write error should not happen for the dd command. (Bryan,=
 if this
> > understanding is wrong, please let me know.)
> >=20
> > So the error log that Christoph observes indicates that the dd command =
failed,
> > and this failure is unexpected. I can not think of any cause of the fai=
lure.
>=20
> Yes, it does indeed fail, this is 002.full with your patch:
>=20
> dd: error writing '/dev/mapper/dust1': Invalid argument
> 1+0 records in
> 0+0 records out
> 0 bytes copied, 0.000373943 s, 0.0 kB/s

Thank you for sharing the logs. The dd failed at the very first block.

>=20
> >=20
> > Christoph, may I ask you to share the kernel messages during the test r=
un?
> > Also, I would like to check the dd command output. The one liner patch =
below
> > to the blktests will create resutls/vdb/dm/002.full with the dd output.
>=20
> the relevant lines of dmesg output below:
>=20
> [   57.773967] run blktests dm/002 at 2024-06-24 11:43:53
> [   57.791251] I/O error, dev vdb, sector 774 op 0x0:(READ) flags 0x80700=
 phys_seg 250 prio class 0
> [   57.791849] I/O error, dev vdb, sector 520 op 0x0:(READ) flags 0x84700=
 phys_seg 254 prio class 0
> [   57.792420] I/O error, dev vdb, sector 520 op 0x0:(READ) flags 0x0 phy=
s_seg 1 prio class 0
> [   57.792805] I/O error, dev vdb, sector 521 op 0x0:(READ) flags 0x0 phy=
s_seg 1 prio class 0
> [   57.793190] I/O error, dev vdb, sector 522 op 0x0:(READ) flags 0x0 phy=
s_seg 1 prio class 0
> [   57.793578] I/O error, dev vdb, sector 523 op 0x0:(READ) flags 0x0 phy=
s_seg 1 prio class 0
> [   57.793955] I/O error, dev vdb, sector 524 op 0x0:(READ) flags 0x0 phy=
s_seg 1 prio class 0
> [   57.794318] I/O error, dev vdb, sector 525 op 0x0:(READ) flags 0x0 phy=
s_seg 1 prio class 0
> [   57.794700] I/O error, dev vdb, sector 526 op 0x0:(READ) flags 0x0 phy=
s_seg 1 prio class 0
> [   57.795130] I/O error, dev vdb, sector 527 op 0x0:(READ) flags 0x0 phy=
s_seg 1 prio class 0
> [   57.795516] Buffer I/O error on dev dm-0, logical block 65, async page=
 read
> [   57.800743] device-mapper: dust: dust_add_block: badblock added at blo=
ck 60 with write fail count 0
> [   57.802587] device-mapper: dust: dust_add_block: badblock added at blo=
ck 67 with write fail count 0
> [   57.804359] device-mapper: dust: dust_add_block: badblock added at blo=
ck 72 with write fail count 0
> [   57.811253] device-mapper: dust: dust_add_block: badblock added at blo=
ck 60 with write fail count 0
> [   57.813065] device-mapper: dust: dust_add_block: badblock added at blo=
ck 67 with write fail count 0
> [   57.814786] device-mapper: dust: dust_add_block: badblock added at blo=
ck 72 with write fail count 0
> [   57.818023] device-mapper: dust: enabling read failures on bad sectors
> [   57.826500] Buffer I/O error on dev dm-0, logical block 8, async page =
read

Hmm, there are many I/O errors for /dev/vdb and /dev/mapper/dust1. When the=
 test
case succeeds, no I/O error is reported [2]. So, the next question is "why =
the
I/O errors happen?" My mere guess is that the TEST_DEV might have non-512 b=
lock
size, probably 4096. The test case dm/002 specifies 512 byte as the block s=
ize
for the /dev/mapper/dust1, then 4096 block size will cause I/O errors due t=
o the
unaligned block sizes. I ran dm/002 with a null_blk with 4096 block size, a=
nd
observed very similar symptom as what Christoph observed.

Christoph, what is the output of "blockdev --getbsz /dev/vdb" on your syste=
m?
If it is not 512, could you try blktests side fix patch candidate [3]?


[2] Kernel message on success case:

[17024.868423] [ T160674] run blktests dm/002 at 2024-06-24 20:07:17
[17024.983252] [ T160697] device-mapper: dust: dust_add_block: badblock add=
ed at block 60 with write fail c
ount 0
[17024.992010] [ T160698] device-mapper: dust: dust_add_block: badblock add=
ed at block 67 with write fail c
ount 0
[17024.999706] [ T160699] device-mapper: dust: dust_add_block: badblock add=
ed at block 72 with write fail c
ount 0
[17025.029553] [ T160704] device-mapper: dust: dust_add_block: badblock add=
ed at block 60 with write fail c
ount 0
[17025.036658] [ T160705] device-mapper: dust: dust_add_block: badblock add=
ed at block 67 with write fail c
ount 0
[17025.044143] [ T160706] device-mapper: dust: dust_add_block: badblock add=
ed at block 72 with write fail c
ount 0
[17025.058206] [ T160708] device-mapper: dust: enabling read failures on ba=
d sectors
[17025.067598] [ T160709] device-mapper: dust: block 60 removed from badblo=
cklist by write
[17025.069738] [ T160709] device-mapper: dust: block 67 removed from badblo=
cklist by write
[17025.071753] [ T160709] device-mapper: dust: block 72 removed from badblo=
cklist by write


[3]

diff --git a/tests/dm/002 b/tests/dm/002
index 6635c43..f60e3bf 100755
--- a/tests/dm/002
+++ b/tests/dm/002
@@ -14,10 +14,12 @@ requires() {
=20
=20
 test_device() {
+	local sz bsz
 	echo "Running ${TEST_NAME}"
=20
-	TEST_DEV_SZ=3D$(blockdev --getsz "$TEST_DEV")
-	dmsetup create dust1 --table "0 $TEST_DEV_SZ dust $TEST_DEV 0 512"
+	sz=3D$(blockdev --getsz "$TEST_DEV")
+	bsz=3D$(blockdev --getbsz "$TEST_DEV")
+	dmsetup create dust1 --table "0 $sz dust $TEST_DEV 0 $bsz"
 	dmsetup message dust1 0 addbadblock 60
 	dmsetup message dust1 0 addbadblock 67
 	dmsetup message dust1 0 addbadblock 72
@@ -30,7 +32,7 @@ test_device() {
 	dmsetup message dust1 0 addbadblock 72
 	dmsetup message dust1 0 countbadblocks
 	dmsetup message dust1 0 enable
-	dd if=3D/dev/zero of=3D/dev/mapper/dust1 bs=3D512 count=3D128 oflag=3Ddir=
ect >/dev/null 2>&1 || return $?
+	dd if=3D/dev/zero of=3D/dev/mapper/dust1 bs=3D$bsz count=3D128 oflag=3Ddi=
rect >$FULL 2>&1 || return $?
 	sync
 	dmsetup message dust1 0 countbadblocks
 	sync=
