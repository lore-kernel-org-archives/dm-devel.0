From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] Introducing multipath C API
 <libdmmp/libdmmp.h>
Date: Mon, 1 Feb 2016 14:36:24 +0100
Message-ID: <56AF5F58.6030302@suse.de>
References: <1453953120-7023-1-git-send-email-fge@redhat.com>
	<56A9DC24.3050507@suse.de> <56AF5A11.70000@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; Format="flowed"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <56AF5A11.70000@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: tgill@redhat.com, dm-devel@redhat.com
List-Id: dm-devel.ids

On 02/01/2016 02:13 PM, Todd Gill wrote:
> On 01/28/2016 04:15 AM, Hannes Reinecke wrote:
>>
>> I would very much advocate to use the IPC interface into multipathd;
>> we can easily define a stable ABI for that.
>
> Do you have a preference for the format of the API?
>
> Are you thinking JSON, JSON-RPC, YAML, XML, XML-RPC?
>
> The user of the API would write a command to the netlink socket that
> multiapthd already listens? the command would be something like:
>
> multipathd show map topology JSON
>
> Just looking to confirm I understand.
>
Yes, something like that should work.

>> ATM it's just being use for the userland CLI, and hence it'll return
>> human-readable output. But I don't have any issues to define a
>> machine-readable output, too, so that it can be easily parsed from
>> other programs.
>
> I've abandoned the approach of putting a d-bus thread in multipathd.
> But, I'm still hoping to help higher level tools understand the
> multipath picture (and help users manage/monitor it).
>
Oh, I'm not doubting that some sort of multipathd interaction with other =

processes is useful.

The point I'm advocating is that we should centralize the information
on the existing multipath daemon, as this is the instance which is =

ultimatively responsible for correct multipath operation.
As the daemon carries quite some dynamic information it doesn't help if =

this information is constructed outside of the daemon; it might be
(and occasionally is) different from the information the daemon is using =

internally.

So yes, we do need some sort of query mechanism, but that should
be done by using the multipath daemon IPC mechanism.

Adding a 'format' specifier is a good starting point for that.
Plus you can add several format options if required.

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
