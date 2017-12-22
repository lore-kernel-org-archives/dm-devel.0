From: Christian Borntraeger <borntraeger@de.ibm.com>
Subject: Re: regression 4.15-rc: kernel oops in dm-multipath
Date: Fri, 22 Dec 2017 21:10:28 +0100
Message-ID: <e2340502-a5f3-355a-008a-d15dc5e2b7a3@de.ibm.com>
References: <7dc463af-554f-1778-7e24-757de143d6b7@de.ibm.com>
 <1513958435.2579.1.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1513958435.2579.1.camel@wdc.com>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>, "agk@redhat.com" <agk@redhat.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "snitzer@redhat.com" <snitzer@redhat.com>
List-Id: dm-devel.ids

I will give that commit a try. Thanks.

On 12/22/2017 05:00 PM, Bart Van Assche wrote:
> On Fri, 2017-12-22 at 10:53 +0100, Christian Borntraeger wrote:
>> any quick ideas?
> 
> Hello Christian,
> 
> Was commit afc567a4977b ("dm table: fix regression from improper dm_dev_internal.count
> refcount_t conversion") included in your test kernel?
> 
> Bart.
> 
