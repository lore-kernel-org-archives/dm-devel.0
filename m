From: Zdenek Kabelac <zkabelac@redhat.com>
Subject: Re: Ideas to reuse filesystem's checksum to enhance dm-raid1/10/5/6?
Date: Thu, 16 Nov 2017 10:43:37 +0100
Message-ID: <6e0f8a37-c3f8-61f0-d51d-01b72c3c65b7@redhat.com>
References: <477d2d2b-3893-50c1-5946-076670a03f2d@gmx.com>
 <7ed134fc-1616-a1ab-6701-a917af0522da@suse.com>
 <5357fd4a-51b1-ebfb-27de-4d022d9749c0@gmx.com>
 <4df8d248-5def-9d29-89eb-7d9b977f089e@suse.com>
 <354402cd-587d-72d8-aaa1-87a1b5c9f03c@gmx.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <354402cd-587d-72d8-aaa1-87a1b5c9f03c@gmx.com>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, Nikolay Borisov <nborisov@suse.com>, linux-block@vger.kernel.org, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
List-Id: dm-devel.ids

Dne 16.11.2017 v 09:08 Qu Wenruo napsal(a):
> 
> 
>>>>>>
>>>>> [What we have]
>>>>> The nearest infrastructure I found in kernel is bio_integrity_payload.
>>>>>

Hi

We already have  dm-integrity target upstream.
What's missing in this target ?

Regards

Zdenek
