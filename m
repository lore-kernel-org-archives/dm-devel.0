From: Jens Axboe <axboe@kernel.dk>
Subject: Re: dm-crypt: fix warning in shutdown path
Date: Sat, 2 Jun 2018 14:10:23 -0600
Message-ID: <eeea0f12-45d4-d90c-e07e-3f02cdc9994f@kernel.dk>
References: <20180602174504.1847-1-kent.overstreet@gmail.com>
 <974665e7-fa4a-230b-99d8-e773489cc6bc@kernel.dk>
 <20180602200723.GA23980@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180602200723.GA23980@redhat.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>, Krzysztof Kozlowski <krzk@kernel.org>
Cc: Kent Overstreet <kent.overstreet@gmail.com>, dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On 6/2/18 2:07 PM, Mike Snitzer wrote:
> On Sat, Jun 02 2018 at  4:03pm -0400,
> Jens Axboe <axboe@kernel.dk> wrote:
> 
>> On 6/2/18 11:45 AM, Kent Overstreet wrote:
>>> The counter for the number of allocated pages includes pages in the
>>> mempool's reserve, so checking that the number of allocated pages is 0
>>> needs to happen after we exit the mempool.
>>
>> Looks good, but needs a fixes line. I'll add one.
> 
> Also needs the subject and header updated to reflect that it fixes the
> crash (Krzysztof please verify):
> 
> Reported-by: Krzysztof Kozlowski <krzk@kernel.org>
> Acked-by: Mike Snitzer <snitzer@redhat.com>

Indeed, I have added that. Thanks Mike.

-- 
Jens Axboe
