From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH 2/9] dm: Rename a function argument
Date: Thu, 1 Sep 2016 14:17:11 +0000
Message-ID: <BLUPR02MB16834200AA81D28C19E10C3981E20@BLUPR02MB1683.namprd02.prod.outlook.com>
References: <18db2396-cd4f-1d52-1ffa-21b9b512eaf4@sandisk.com>
	<0753eed4-ba3a-a747-648d-cd5520916134@sandisk.com>
	<20160901032952.GC4741@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
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
To: Mike Snitzer <snitzer@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 08/31/16 20:29, Mike Snitzer wrote:
> On Wed, Aug 31 2016 at  6:16pm -0400,
> Bart Van Assche <bart.vanassche@sandisk.com> wrote:
>
>> Rename 'interruptible' into 'sleep_state' to make it clear that this
>> argument is a task state instead of a boolean.
>
> Shouldn't the type also be changed from int to long (to match 'state'
> member from 'struct task_struct')?

Hello Mike,

Today TASK_STATE_MAX equals 2048. So I think an int is big enough even 
on 32-bit platforms. Please let me know if you really want me to change 
the type from int to long.

Bart.
