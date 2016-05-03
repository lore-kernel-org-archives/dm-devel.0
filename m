From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 36/57] libmultipath: pass in 'cookie' as
 argument for dm_addmap()
Date: Tue, 3 May 2016 08:24:43 +0200
Message-ID: <5728442B.7000903@suse.de>
References: <1461755458-29225-1-git-send-email-hare@suse.de>
	<1461755458-29225-37-git-send-email-hare@suse.de>
	<20160502222313.GU26117@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20160502222313.GU26117@octiron.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>, Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

On 05/03/2016 12:23 AM, Benjamin Marzinski wrote:
> On Wed, Apr 27, 2016 at 01:10:37PM +0200, Hannes Reinecke wrote:
>> Instead of generating the cookie internally we should be
>> passing in the cookie to dm_addmap().
> =

> These look like they could actually cause problems. With
> dm_addmap_create and dm_addmap_reload, you could be in a situation where
> you get a cookie back on your first call to dm_task_set_cookie, wait on
> it, so that cookie is no longer in use, and then use that same cookie
> id again. It's possible that after you first waited on the cookie,
> someone else could have been given that cookie id (without looking into
> the dm cookie code more, I'm not sure how likely this is). If that is
> so, the second call to dm_addmap would be adding its command to the list
> of other commands for that cookie (since you are allowed to use a cookie
> for multiple dm commands). Calling dm_udev_wait would make it wait of
> all the commands.
> =

> We can use a cookie multiple times and then wait on it once. But we
> can't keep reusing the cookie after we've waited on it, because someone
> else could be using the same cookie.
> =

Ah. Thanks for the clarification. I'll be looking into it.

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
