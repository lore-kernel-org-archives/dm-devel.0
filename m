From: Ankit Jain <jankit@suse.de>
Subject: Re: [PATCH 1/2] dm-kcopyd: introduce per-module throttle
 structure
Date: Wed, 01 Jun 2011 12:43:36 +0530
Message-ID: <4DE5E6A0.9010806@suse.de>
References: <Pine.LNX.4.64.1105311802330.9322@hs20-bc2-1.build.redhat.com>
	<4DE5D9C6.1050504@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4DE5D9C6.1050504@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

On 06/01/2011 11:48 AM, Ankit Jain wrote:
>> +
>> +#define dm_kcopyd_throttle_declare(name, description)	\
>> +static struct dm_kcopyd_throttle dm_kcopyd_throttle = { 100, 0, 0, 0, 0 }; \
>> +module_param_named(name, dm_kcopyd_throttle.throttle, uint, 0644); \
>> +MODULE_PARM_DESC(name, description)
>> +
> 
> I'm just trying to understand, how is it determined, when to use macros
> with UPPER_CASE_LETTERS and when otherwise. To me, UPPER_CASE_LETTERS
> makes it very clear that I'm using a macro, and since this seems to be
> doing declaration etc also, that would seem helpful. But I don't know
> the general style or reasoning followed in the kernel, hence the question.
> 

According to Documentation/CodingStyle, a macro can be named in lower
case, if it resembles a function, which it doesn't in this case. Um and
maybe name it like DECLARE_.. ?

Thanks,
-- 
Ankit Jain
SUSE Labs
