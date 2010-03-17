From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] multipath: display average priority as group
	priority
Date: Wed, 17 Mar 2010 08:26:18 +0100
Message-ID: <4BA0841A.9060504@suse.de>
References: <201003171244.25957.knikanth@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <201003171244.25957.knikanth@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Nikanth Karthikesan <knikanth@suse.de>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Nikanth Karthikesan wrote:
> Display avg priority as group priority
> =

> Now average priority is used as path group priority, instead of sum of
> priorities of the paths. But while displaying group priority, sum is
> being displayed. Change it to print the average priority.
> =

> When there are no enabled paths, print 0 as priority.
> =

> Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>
Acked-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
