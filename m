From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH V3 01/18] multipath: default fast_io_fail to
 5 seconds
Date: Mon, 14 Jan 2013 08:03:12 +0100
Message-ID: <50F3ADB0.5090105@suse.de>
References: <1357970695-3396-1-git-send-email-bmarzins@redhat.com>
	<1357996610.4263.17.camel@lapoo.opensvc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"; Format="flowed"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1357996610.4263.17.camel@lapoo.opensvc.com>
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

On 01/12/2013 02:16 PM, Christophe Varoqui wrote:
> On sam., 2013-01-12 at 00:04 -0600, Benjamin Marzinski wrote:
>> This patch sets fast_io_fail to 5 seconds in the defaults section.
>>
> Merged 1-18.
> Thanks.
>
> I also imported the log_thread_flush() and log_reset() missing
> functions from Hannes tree. Which makes the tree buildable again.
>
Yikes. Sorry.

I got sidetracked and forgot to check for that patch.

Thanks for fixing it up.

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
