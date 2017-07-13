From: Milan Broz <gmazyland@gmail.com>
Subject: Re: dm-integrity
Date: Thu, 13 Jul 2017 12:35:54 +0200
Message-ID: <6b5bb9c8-b005-76d0-052f-f634e5f8912c@gmail.com>
References: <bbf2a91d-2eac-5b10-903d-50939acfb57a@yandex.ru>
	<4d2e0176-071a-1cb4-3eaa-3c3552a2ce09@gmail.com>
	<0d01c698-211e-a969-8c4a-e6bb4ab2cf9b@yandex.ru>
	<96314674-1b66-ce91-732e-17901d1f3236@yandex.ru>
	<ce9f9bdb-cb04-097d-5628-4f4ea0155195@gmail.com>
	<b9024848-2505-7ce5-6927-a4cf3ae144e2@yandex.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <b9024848-2505-7ce5-6927-a4cf3ae144e2@yandex.ru>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Renesanso <renesanso@yandex.ru>, mpatocka@redhat.com, dm-devel@redhat.com, dmitry.kasatkin@huawei.com
List-Id: dm-devel.ids

On 07/12/2017 08:36 PM, Renesanso wrote:
> I have other question: why you dont use AEAD idea from redhad for 
> dm-crypt (cryptsetup, that works, as they present), that realise AES-GCM 
> (as, example ZFS use)? Why do you want to merge dm-integrity and 
> dm-crypt? 
> https://mbroz.fedorapeople.org/talks/DevConf2017/devconf2017-aead.pdf

Sorry? You mean my own talk? That exactly describes how it is implemented now.

We use AEAD when used together with encryption (dm-crypt) but this requires
LUKS2 userspace branch and this is not something I would like to use until
it is more stable.

As said in the slides you linked, dm-integrity can operate in two modes:

 - standalone [parity only] (configured through integritysetup) and

 - in cooperation with dm-crypt [for AEAD - authenticated encryption)
  (will be configured through cryptsetup, but it is not yet in master branch)

Milan
