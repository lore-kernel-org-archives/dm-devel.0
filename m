From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 11/18] Add libmpathcmd library and use it
	internally
Date: Mon, 12 Oct 2015 09:06:20 +0200
Message-ID: <561B5BEC.2080909@suse.de>
References: <1444333491-16265-1-git-send-email-bmarzins@redhat.com>
	<1444333491-16265-12-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1444333491-16265-12-git-send-email-bmarzins@redhat.com>
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

On 10/08/2015 09:44 PM, Benjamin Marzinski wrote:
> Other programs would like to communicate with multipathd to issue
> command or check status.  Instead of having them exec multipathd,
> I've pulled the code that sends commands and receives replies from
> multipathd into its own library.  I've made the multipath tools use
> this library internally as well.
> =

> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---

Good idea.

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
