From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: [PATCH 1/2] multipath-tools: change default failback
 from manual to immediate
Date: Mon, 1 Aug 2016 03:58:08 +0200
Message-ID: <4cb41b6b-13c8-d145-c4f4-65cfc22c1c62@gmail.com>
References: <1468271522-3052-1-git-send-email-xose.vazquez@gmail.com>
	<c3922f2d-d524-4700-e890-902a22c89491@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <c3922f2d-d524-4700-e890-902a22c89491@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>, Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 07/28/2016 04:03 PM, Hannes Reinecke wrote:

> On 07/11/2016 11:12 PM, Xose Vazquez Perez wrote:
>> Default value is: manual
>>       1                 .pgfailback    = 15,
>>       2                 .pgfailback    = 30,
>>      24                 .pgfailback    = FAILBACK_UNDEF,
>>      50                 .pgfailback    = -FAILBACK_IMMEDIATE,
>>
>> manual is not used by any device.
>>
>> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
>> Cc: device-mapper development <dm-devel@redhat.com>
>> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
>> ---
>>  libmultipath/defaults.h    |  2 +-
>>  libmultipath/hwtable.c     | 50 ----------------------------------------------
>>  multipath/multipath.conf.5 |  2 +-
>>  3 files changed, 2 insertions(+), 52 deletions(-)
>>

> 'immediate' fallback only makes sense if the device has a working
> prioritizer _and_ supports a 'preferred path'.

Then there are, at least, seven misconfigured devices.


What devices have support for referred_path?

Based on:		guess???
PRIO_ALUA		- YES
PRIO_CONST		-  NO
PRIO_EMC		- YES
PRIO_HDS		- YES
PRIO_HP_SW		-  NO
PRIO_ONTAP		- YES
PRIO_RDAC		- YES

Is there a hint anywhere?

> None of which can be assumed for an unknown device, so this patch
> will break automatic configuration.

As I said in my previous e-mail I don't believe in magic.
But this is up to you(plural: Christophe, Hannes, Benjamin, ...)
