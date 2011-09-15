From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 3/2] block: refactor generic_make_request
Date: Thu, 15 Sep 2011 13:56:53 +0200
Message-ID: <4E71E805.807@kernel.dk>
References: <20110911145053.GA28996@infradead.org> <20110912134202.GA22953@infradead.org> <20110912150935.GA27453@redhat.com> <20110912151310.GA7188@infradead.org> <20110915115534.GA14819@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110915115534.GA14819@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Vivek Goyal <vgoyal@redhat.com>, linux-raid@vger.kernel.org, dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On 2011-09-15 13:55, Christoph Hellwig wrote:
> On Mon, Sep 12, 2011 at 11:13:10AM -0400, Christoph Hellwig wrote:
>>>> @@ -1557,16 +1561,15 @@ void generic_make_request(struct bio *bi
>>>>  	 * from the top.  In this case we really did just take the bio
>>>>  	 * of the top of the list (no pretending) and so remove it from
>>>>  	 * bio_list, and call into __generic_make_request again.
>>>                                    ^^^^^^^^^^
>>> You got rid of __generic_make_request(). Now above comment has stale
>>> reference to it.
>>
>> Yeah, this should be ->make_request now.
> 
> Jens, do you want me to resend with that fix or can you fix it up when
> applying?

I'll just fix it up, applying it now.

-- 
Jens Axboe
