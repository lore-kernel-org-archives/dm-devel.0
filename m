From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 12/18] add raw format multipathd commands
Date: Mon, 12 Oct 2015 09:06:48 +0200
Message-ID: <561B5C08.5040507@suse.de>
References: <1444333491-16265-1-git-send-email-bmarzins@redhat.com>
	<1444333491-16265-13-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1444333491-16265-13-git-send-email-bmarzins@redhat.com>
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
> This patch adds the following multipathd interactive commands
> =

> show paths raw format $fmt
> show maps raw format $fmt
> =

> These commands work just like the regular "show ... format"
> commands, except that they don't print a header, and don't add
> any extra padding that isn't in the format string.  This should
> make it easier for programs wanting to parse the output from
> these commands.
> =

> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
