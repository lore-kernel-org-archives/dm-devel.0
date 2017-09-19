From: Andy Grover <agrover@redhat.com>
Subject: Re: [PATCH 3/3] dm-ioctl: report event number in
 DM_LIST_DEVICES
Date: Tue, 19 Sep 2017 09:47:13 -0700
Message-ID: <25fc48c9-90d1-44a8-5a3f-417687ed8be3@redhat.com>
References: <20170917023849.GA4094@asgard.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170917023849.GA4094@asgard.redhat.com>
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

On 09/16/2017 07:41 PM, Eugene Syromiatnikov wrote:
>> +			event_nr = align_ptr(((void *) (nl + 1)) + strlen(hc->name) + 1);
> If my understanding is correct, (nl + 1) differs between 32-bit and
> 64-bit kernels (as the structure contains of one 8-byte and one 4-byte field),
> so this logic is probably broken for compat.

I don't understand.. how does this change the result from the 
calculation depending on the platform arch? 4 + 8 = 12.

Thanks -- Andy
