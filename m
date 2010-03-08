From: Peter Rajnoha <prajnoha@redhat.com>
Subject: Re: [PATCH] dm_ioctl: Introduce DM_UEVENT_GENERATED_FLAG
Date: Mon, 08 Mar 2010 08:10:45 +0100
Message-ID: <4B94A2F5.8080000@redhat.com>
References: <4B8B7A65.3020301@redhat.com>
	<20100305193819.GS27852@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20100305193819.GS27852@agk-dp.fab.redhat.com>
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
Cc: agk@redhat.com
List-Id: dm-devel.ids

On 03/05/2010 08:38 PM, Alasdair G Kergon wrote:
> On Mon, Mar 01, 2010 at 09:27:17AM +0100, Peter Rajnoha wrote:
>> +	if (!dm_kobject_uevent(hc->md, KOBJ_CHANGE, cookie))
>> +		*flags |= DM_UEVENT_GENERATED_FLAG;
>   
> If userspace set this flag before the call, where is it cleared?
> It needs to have a defined state on *every* call.
> I'll add this to the top of validate_params.

Yes, you're right, we shouldn't rely on userspace to do this.
Indeed, it needs to be cleared directly. Thanks!

Peter
