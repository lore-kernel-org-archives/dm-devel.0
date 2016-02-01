From: Todd Gill <tgill@redhat.com>
Subject: Re: [PATCH] Introducing multipath C API
 <libdmmp/libdmmp.h>
Date: Mon, 1 Feb 2016 08:13:53 -0500
Message-ID: <56AF5A11.70000@redhat.com>
References: <1453953120-7023-1-git-send-email-fge@redhat.com>
	<56A9DC24.3050507@suse.de>
Reply-To: tgill@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <56A9DC24.3050507@suse.de>
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

On 01/28/2016 04:15 AM, Hannes Reinecke wrote:
> 
> I would very much advocate to use the IPC interface into multipathd;
> we can easily define a stable ABI for that.

Do you have a preference for the format of the API?

Are you thinking JSON, JSON-RPC, YAML, XML, XML-RPC?

The user of the API would write a command to the netlink socket that
multiapthd already listens? the command would be something like:

multipathd show map topology JSON

Just looking to confirm I understand.

> ATM it's just being use for the userland CLI, and hence it'll return
> human-readable output. But I don't have any issues to define a
> machine-readable output, too, so that it can be easily parsed from
> other programs.

I've abandoned the approach of putting a d-bus thread in multipathd.
But, I'm still hoping to help higher level tools understand the
multipath picture (and help users manage/monitor it).

Thanks for any help,
Todd
