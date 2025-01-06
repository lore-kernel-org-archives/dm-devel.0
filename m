Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2125.outbound.protection.outlook.com [40.107.95.125])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7E591DF983
	for <dm-devel@lists.linux.dev>; Mon,  6 Jan 2025 21:27:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.125
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736198838; cv=fail; b=IbzH309RKk0fF5Ux0Jvn6I8Ni3A+Ll7sM3keZzI3wb105Rg4hlUk9auoZXtJgnoKygSYR/YhdBk3mz9owb1/rEkebqmGJ7AnbsUFxUUw4NJzZZbXpSX4Xht3dLlhyJwEnsnRMrEsSTk6M4Dyf1WGEQusyk01s73KQJIrnKxUUJc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736198838; c=relaxed/simple;
	bh=ans5TKHIOReh/6bEn1dHcoyFBQPXce51nWjLchp10WU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Ttd7CdTv11J6vBZjtRlWzUqBdlHilg1Rp/1ZW3wefjual5uXb5ehGh3IOA53cNruM3y3I8uXbEHhO7m0QeOKVT1AjLL6Pklz6lWMGnAJq6hp/p3kGhDUcVKeCVW6Qrp16l/Nb9M6nS5XVloRuIIof1U3HLW7g2SeUdYPMMM2+eM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hammerspace.com; spf=pass smtp.mailfrom=hammerspace.com; dkim=fail (1024-bit key) header.d=hammerspace.com header.i=@hammerspace.com header.b=N2cEUetr reason="signature verification failed"; arc=fail smtp.client-ip=40.107.95.125
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hammerspace.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hammerspace.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=hammerspace.com header.i=@hammerspace.com header.b="N2cEUetr"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kfhgxQ6h/Btp+4PE751i18f0lddbhXCc8k5qEveiF+tKLSba2/vKohk9b6bqVYVa6i2T5rvjWqaQn7LIQTj8oFDUo8d/UW81uiZuhJKcPSc+vIOdb2M8GWwh5SYLecOOdxFyG2K9J0aQecG0iJ09s80e1hCdOzFd82TUtK/QrHT/CpIgVZIPSlA62uDo+UY1Un/LF0ZTTRExrguiPj9qCjnu7ULHnYFIixsFm63sNSgWjcqrd99AStdUjSU+eKqAcuWYSlyHWNmWWjmpjRPkx4n87rPDEuBVt/O5N18gScsTbk4B0f3TcQduKSYYjsXbbBLzBTOj0BbEmYIn8VLDmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ADAux4hBv9nua/DnNrCBcqVmGhEqwQr/YiDJ7P6MOcE=;
 b=mxFcS1F4nNjY7K7iqsKxDc+99LAnTO0Y/shGbVIKyrZpJSHXlt+/Dr8gkVyfI4wyv+Bz8lUaBqNj0kL4KekIgXIKMNbDihi3aE2Gq4GE8ahqcgyxfcEhyjz43kxdZrDcVdD42JrBG371MydViBVOSHchUeENp96JMbm/U5PHSsPORtFUUEsY/yYSYlH915fxDSf/bN0B3yGT3jSh3DUoqDwwLCi4dYa5WumpPSsHyLv77zwm07qz81QILJdHXfpFiH2fH8HETZbbMOsINlI1EGdeG7d4g14QHHIn9OnVqMTQMGJcnZ+81KZXj2/u3GyzbP9TPvZC9cLTJJgl4HUCrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hammerspace.com; dmarc=pass action=none
 header.from=hammerspace.com; dkim=pass header.d=hammerspace.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hammerspace.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ADAux4hBv9nua/DnNrCBcqVmGhEqwQr/YiDJ7P6MOcE=;
 b=N2cEUetrv2zbhYe9psQ/w7EgK+r9Yelh6MHwmKky0hTZb/Skr8/rC77WKSEy3QfXKPDuuIkj2Bhx0jysI4SDKsr6LWSgvsmsdIWqr8OzHq5EMa3P5w575cZKG7Vm2+xBYbb5mxyKPo9UK+POiVfN/sDuZuatTJH+WWwNFCpBG48=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=hammerspace.com;
Received: from DM6PR13MB4036.namprd13.prod.outlook.com (2603:10b6:5:2a7::14)
 by BY3PR13MB4961.namprd13.prod.outlook.com (2603:10b6:a03:36d::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.17; Mon, 6 Jan
 2025 21:27:08 +0000
Received: from DM6PR13MB4036.namprd13.prod.outlook.com
 ([fe80::2a78:7a0:a33:cecd]) by DM6PR13MB4036.namprd13.prod.outlook.com
 ([fe80::2a78:7a0:a33:cecd%7]) with mapi id 15.20.8314.018; Mon, 6 Jan 2025
 21:27:08 +0000
Date: Mon, 6 Jan 2025 16:27:07 -0500
From: Mike Snitzer <snitzer@hammerspace.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Mohammed Anees <pvmohammedanees2003@gmail.com>, agk@redhat.com,
	dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
	zkabelac@redhat.com
Subject: Re: dm: Allow the use of escaped characters in str_field_delimit()
Message-ID: <Z3xKkYyNCQaRqzjZ@hammerspace.com>
References: <Z1hrfMRedzEJb26O@kernel.org>
 <20241215101336.1456-1-pvmohammedanees2003@gmail.com>
 <034eaa34-1737-6f75-2227-4e0dfbc753cf@redhat.com>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <034eaa34-1737-6f75-2227-4e0dfbc753cf@redhat.com>
X-ClientProxiedBy: BN9PR03CA0067.namprd03.prod.outlook.com
 (2603:10b6:408:fc::12) To DM6PR13MB4036.namprd13.prod.outlook.com
 (2603:10b6:5:2a7::14)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR13MB4036:EE_|BY3PR13MB4961:EE_
X-MS-Office365-Filtering-Correlation-Id: 875a3555-6844-4b63-afca-08dd2e98dffb
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?wqWThJuYrhPDJc+JdkkTV5+sxbkJIxfZJCBhHA7b942Cu2RapN/GuwUqA0?=
 =?iso-8859-1?Q?yuN2YyL3pPBRVc7OxxR9GBSc7gl9h38pDa5Z+/CSD8QYWUEJZNY9b17BLz?=
 =?iso-8859-1?Q?o37iYMMqNOf3AmRrD4nvPDjxunSqTVzept5MZLqtED0/d+fcpMsumxE5tA?=
 =?iso-8859-1?Q?aXSKA7662T6p4+mzrShOCe+Y6ZMVxycTsdg8Xh7o8iOVy0oT2naZIX/ryK?=
 =?iso-8859-1?Q?txzH6UPmSkROsHtU3C1GC3AbSefbPzvWi8mrogsGR4zgCB+4bTgDb+br+R?=
 =?iso-8859-1?Q?7goeJtUc5N5GwfZdq2u7WUsu8NkJvuHEUzn+FsK5ZUYtCgr6ZyRaI+qCJt?=
 =?iso-8859-1?Q?RGZsRHxZxWPNfCdM18l6diLRZS/94xi/eub3lcw8zW+cN3zbA4hFbcbk3+?=
 =?iso-8859-1?Q?KvlYiWXnUQEm5zVdwVVkxMA9mV2g36hMscII7fUrrChyvoRCvksc16pq20?=
 =?iso-8859-1?Q?IZmRj5mbjGVgtg8gwgxY855lN+tdePsAK85sEROEV94mUeAp8j3s/rsQjS?=
 =?iso-8859-1?Q?fCCQhmQYFPGnCBDOPsBP+CM7AkTHwoW4+9bz5bm0rGTC+Dsw0+cS8Ebvsa?=
 =?iso-8859-1?Q?E1PP8n0e5H5KnK4Ds3IfJZJ+LVXpSbUGy6e7Fp3b82Ru6ao1vEBSObs6wq?=
 =?iso-8859-1?Q?lbqjO34go7PmMH3ynDlQ6MaHdLBcwe4DxNYUA+JFL21boNCtGIhwHCcWV7?=
 =?iso-8859-1?Q?GRa60RVUZ5bNLoF5hkPrI7REfHsGY69Mjfg9b9O7K8J4CMSM9EAbQ64iYb?=
 =?iso-8859-1?Q?c/uhPBmyYFgRJwtEp8ZDYyoKuE+tpI9JOGCGaEO7fpKQGePBr/bwyltdaq?=
 =?iso-8859-1?Q?RFHAg58XtuexZ4YF8CQf/0iUoVCiVl/58OvesxVmrNF+pI7e6zF5SHfhRG?=
 =?iso-8859-1?Q?tkw+Y7lOk9Ah9j+uyrfb8f8pXwXbF7Xs1Fl6oNvuv1xGMgRPJ7BgC5kRU8?=
 =?iso-8859-1?Q?dgDq4H91z2jNaUDdQdlgnxXA4RlYefXgV/k9i6cPx5ewM10hNWjmEoJwU5?=
 =?iso-8859-1?Q?J2PCAl3WXq7srIm6BfU+35wxnBgk2NSfLbGqcrM42n8JMeUzweuWr+2bcV?=
 =?iso-8859-1?Q?CfEuQfN6OTT0/BHNHJAofo7YEKUE76QkXHZ0xJbcv/aNUHekWh7hDiaBfw?=
 =?iso-8859-1?Q?rP1UCVn2vB3FgSUmkm9+vmKFCJD7Dj3rTeQD/hhkwQ8xcYO071K0pti515?=
 =?iso-8859-1?Q?1EDxMHRdq5Hr9mhr/CduiqYQRedl3dYmKKIt0GpO3D/a+MpyTU9coNdBE+?=
 =?iso-8859-1?Q?mnLt+AbMUs6DzqdkJM52sM2f7IDHxPpvAxgxXsT0Y/ixjQkCD4hchaWC2g?=
 =?iso-8859-1?Q?+KV2Tc7tIAEDU3izp2zmA1utlt3+2BCZqOpF5C9WV4Zb9wWaShcp4QHiH5?=
 =?iso-8859-1?Q?dUumnG2hBPs90s2B9Waj7Xn6pa2MLXisNSuNpKCANUiamo9rm5mcvTquEE?=
 =?iso-8859-1?Q?wbXByqDLS+lCwO1k?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR13MB4036.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?iso-8859-1?Q?st6nN5tQUb5O2A8/HbdQcZdDqjnUDBq9GIxJ9NzZaQDgktBhhc4U48oBgz?=
 =?iso-8859-1?Q?/Npq3K0ASR8xMHhDh3hlp1zlaruAPvoc8EMXZeKmDD2OFWVluTHB5sVMtA?=
 =?iso-8859-1?Q?gZm/Y9FZJGqiySJVrAZl2YcODHtRFYsH6Kkw5V2udwik/Pl65RYPcyGgZu?=
 =?iso-8859-1?Q?iPJDUFOyiPhEefhdh6Vt//EyTZgQKzHlENWzXD+1xy6d7caIyFHFvlWa03?=
 =?iso-8859-1?Q?wGUMPjQINmSQBg9QNfK3ZDdQiTaB6X8iEF/aTVfu+TmV2RtA3nakStQaGB?=
 =?iso-8859-1?Q?AvnOEyAxBEnqBKZNBsvTscy1NplF2qhsn/Xe72DG5DtySdjkm4LM7IaDWu?=
 =?iso-8859-1?Q?eeFYXaV2yBfzJY3ncqhlQbfUTuZvZqntilXGAQDqamC0zDwebBHvGPUbwa?=
 =?iso-8859-1?Q?Cphdp8TZkC3eVrxr8DYR7aOn8w+3IYDrcT/ejY11IWVA7FQyhL4MsndtFp?=
 =?iso-8859-1?Q?tvjykfVuBN4D1Z2iOzxA3PFk6prPBIQZEb74XKU2TuZbUYdAbKhSQlyIE8?=
 =?iso-8859-1?Q?TyW1EzI5tu3eyp1awvCm7tBkCRmIWSIzw2U36IB+mCarTYMGEd4m/FmYHC?=
 =?iso-8859-1?Q?woJxz9CRh5TXvq2qh91/jQh4RnZAlmJJGhr6REvHc9gtn3cOzTbFPe2O3O?=
 =?iso-8859-1?Q?1G8z6/8o/VFW/hO2Ohj3Phn9X4eh/w9Bq2eNy/nsqHgqZD5Y/zF8wfb6Gc?=
 =?iso-8859-1?Q?PcdWgkJH3urKZeeB73jM5FMXEm7lWFIGUm6G99J+mnfAlcsVX061zT3fCh?=
 =?iso-8859-1?Q?CedB5LqvQD4AnesyC87la5F1WxOVJa7tm9ZXo3mAGRPFFTtsfH8DYVYv0l?=
 =?iso-8859-1?Q?F5ekFz3i+X5s8qpNUv7vj3mRAvVIo8IuZ4pS8EZgTMQjZy4A8WWNC3/20a?=
 =?iso-8859-1?Q?LlEIm+XElHievqt7fUpFCuY5EF1v8Sn78gKFg2vzv42GUmKPRabhJ+ECJ0?=
 =?iso-8859-1?Q?ebI0FoN2r6y9QSZP3AqCyPweuZ/KYGg+M8/7l31stSQ9F/X0/sjzwBTFvQ?=
 =?iso-8859-1?Q?1UC+TRskw5UNa280ezCNQHPk1C88O4/aB2MB+H67Q5cAPX6PZ1mSwgfmRq?=
 =?iso-8859-1?Q?pwp9abYofDi0DwwvCbPOl2xmLdRiQlm6nQi4SQI92ixd/cRjyyU1TzztkR?=
 =?iso-8859-1?Q?JkeTGY3snP3SB8G1mAt1HZj6mTkHadfyNOtgf/aIkLhiaB61k0vrNnIQx1?=
 =?iso-8859-1?Q?PwY8JmxDwwZqPK8YWEE41RVRFTzilYP2388FpcSQuI66NhuJQt+Niqrdln?=
 =?iso-8859-1?Q?GjJEh2Eus0kihsuZNX+Ro8YnBBCamm1JLdZ6KeWND4VzSg/QdYhdeMtWkI?=
 =?iso-8859-1?Q?s3WzjpzCNJ7ON5rqdFzGE7/cmTcTZT2fFlGaFaUsIwCEYscAFU3SPCVFmr?=
 =?iso-8859-1?Q?Zen8voR6VD8vNei+EITYmfsynmcFzz5vmU3OQLYfwyRBdiwrqOda2FynU0?=
 =?iso-8859-1?Q?Nisv6vQWf/GYo+turdYc1Fx8byRUJjdzS4XK21fdT+/yEmszw4aGpq9hUG?=
 =?iso-8859-1?Q?YT+17vO03sKEzA+5s+OIaDceliPynzR7yR25dYCgniako4ekZotG8wb0V0?=
 =?iso-8859-1?Q?eapI1HMIyd3OCzVmYogbHkix9vaFGYxNP/vZZHrHkWAAkJEYFdTlyJthy4?=
 =?iso-8859-1?Q?/bXDK0xrXDaYE0+CmQjOQp20iUU0zQV9JqkQAAwWvOc0DUtG4vVt0hjg?=
 =?iso-8859-1?Q?=3D=3D?=
X-OriginatorOrg: hammerspace.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 875a3555-6844-4b63-afca-08dd2e98dffb
X-MS-Exchange-CrossTenant-AuthSource: DM6PR13MB4036.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2025 21:27:08.6055
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0d4fed5c-3a70-46fe-9430-ece41741f59e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4OCnt23RH7JbGXDTeKMLGkqbEl8hOgX3v2OmBCv6ewu0LbWuGpB/HY5ea+LuYFr5eNJlrR2fPh4Z1OHOaVfmpVKmB+EGPnn4hSR2yI+BM0w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY3PR13MB4961

On Fri, Jan 03, 2025 at 05:21:13PM +0100, Mikulas Patocka wrote:
> 
> 
> On Sun, 15 Dec 2024, Mohammed Anees wrote:
> 
> > > It would seem Mohammed cared enough to write the patch, but not reply
> > > to you with further clarification on why it needed...
> > 
> > I thought I had already replied to the concern, but it seems 
> > the message didn´t get sent, apologies for that oversight!
> > College academics kept me tied up, and I lost track of this,
> > apologies once again.
> > 
> > > BUT, in this instance it follows that: if lvm2 is allowing weird names
> > > which require escacped characters _and_ dm-init is used then dm-init
> > > needs to support handling them (dm-init is all about _not_ using
> > > normal initramfs with lvm2 in all its glory).
> > 
> > I completely agree with your point and am more than happy to 
> > provide further details or make any additional updates to 
> > the patch if needed, please let me know if anything else if needed. 
> > Thank you for your time.
> > 
> > Regards
> > Mohammed Anees
> 
> Hi
> 
> I don't want to bloat the code with the logic that no one uses. I would 
> only accept the patch if there were some real scenario where you need to 
> use escaped characters in device names or table parameters.

Please read my reply in this thread (which you quoted above).  The
real scenario was already answered.

Either:

1) remove dm-init entirely

or

2) fix it so that it works with naming that requires escaped
   characters 
or

3) say: "sorry, dm-init doesn't support escaped characters."
