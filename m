From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 4/5] dm: implement REQ_FLUSH/FUA support for request-based
 dm
Date: Tue, 31 Aug 2010 15:14:42 +0200
Message-ID: <4C7D0042.3000607@kernel.org>
References: <1283162296-13650-1-git-send-email-tj@kernel.org> <1283162296-13650-5-git-send-email-tj@kernel.org> <20100830132836.GB5283@redhat.com> <4C7BB932.1070405@kernel.org> <4C7BC942.7070703@kernel.org> <20100830190835.GA8458@redhat.com> <20100830212819.GA12522@redhat.com> <4C7CD9A7.4030901@kernel.org> <20100831130242.GB17505@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100831130242.GB17505@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: jaxboe@fusionio.com, k-ueda@ct.jp.nec.com, j-nomura@ce.jp.nec.com, jamie@shareable.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-raid@vger.kernel.org, hch@lst.de, dm-devel@redhat.com
List-Id: dm-devel.ids

Hello,

On 08/31/2010 03:02 PM, Mike Snitzer wrote:
> On Tue, Aug 31 2010 at  6:29am -0400,
> Tejun Heo <tj@kernel.org> wrote:
> 
>> On 08/30/2010 11:28 PM, Mike Snitzer wrote:
>>> Hmm, but unfortunately I was too quick to say the patch fixed the hang.
>>>
>>> It is much more rare, but I can still get a hang.  I just got the
>>> following running vgcreate against an DM mpath (rq-based) device:
>>
>> Can you please try this one instead?
> 
> Still hit the hang on the 5th iteration of my test:
> while true ; do ./test_dm_discard_mpath.sh && sleep 1 ; done
> 
> Would you like me to (re)send my test script offlist?

Yes, please.  Thanks.

-- 
tejun
