From: "Guilherme G. Piccoli" <gpiccoli@canonical.com>
Subject: Re: [PATCH 1/2] md/raid0: Introduce new array state
 'broken' for raid0
Date: Wed, 31 Jul 2019 10:04:23 -0300
Message-ID: <9dd836f8-7358-834f-8d29-cd0db717d01b@canonical.com>
References: <20190729203135.12934-1-gpiccoli@canonical.com>
	<20190729203135.12934-2-gpiccoli@canonical.com>
	<d730c417-a328-3df3-1e31-32b6df48b6ad@oracle.com>
	<87ftmnkpxi.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <87ftmnkpxi.fsf@notabene.neil.brown.name>
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
To: NeilBrown <neilb@suse.com>, Bob Liu <bob.liu@oracle.com>, linux-raid@vger.kernel.org
Cc: linux-block@vger.kernel.org, jay.vosburgh@canonical.com, songliubraving@fb.com, dm-devel@redhat.com, Neil F Brown <nfbrown@suse.com>
List-Id: dm-devel.ids

On 30/07/2019 21:28, NeilBrown wrote:
> On Tue, Jul 30 2019, Bob Liu wrote:
>>
>>
>> Curious why only raid0 has this issue? 
> 
> Actually, it isn't only raid0.  'linear' has the same issue.
> Probably the fix for raid0 should be applied to linear too.
> 
> NeilBrown
> 

Thanks Neil, it makes sense! I didn't considered "linear" and indeed,
after some testing, it reacts exactly as raid0/stripping.

In case this patch gets good acceptance I can certainly include
md/linear in that!
Cheers,


Guilherme
