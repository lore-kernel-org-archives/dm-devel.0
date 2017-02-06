From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH v3] dm: don't allow ioctls to targets that don't map to
 whole devices
Date: Mon, 6 Feb 2017 08:29:10 +0100
Message-ID: <c36b1ecd-1647-d88d-e1d5-9114b23522e2@suse.de>
References: <20170203163708.13943-1-hch@lst.de>
 <20170203163921.GA823@redhat.com> <20170203164129.GA4755@lst.de>
 <4435311b-80e1-8764-fa12-140203e9231f@suse.de>
 <1486158062.2553.12.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1486158062.2553.12.camel@sandisk.com>
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>, "hch@lst.de" <hch@lst.de>, "snitzer@redhat.com" <snitzer@redhat.com>
Cc: "agk@redhat.com" <agk@redhat.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>, "axboe@kernel.dk" <axboe@kernel.dk>
List-Id: dm-devel.ids

On 02/03/2017 10:41 PM, Bart Van Assche wrote:
> On Fri, 2017-02-03 at 19:17 +0100, Johannes Thumshirn wrote:
>> Forgotten git add? git commit --amend without git add is such a classic
>> mistake on my side as well :-/
> Are you familiar with the -a option of git commit? Just run
>
> git commit -a --amend
Yes I try to train my muscle memory to do so. But this has drawbacks as 
well,
like adding unrelated files you've edited and then amend them.

Byte,
     Johannes

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
