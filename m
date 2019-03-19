From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH v2 11/12] libmultipath: add get_uid fallback
 code for NVMe devices
Date: Tue, 19 Mar 2019 12:15:18 -0500
Message-ID: <20190319171518.GI13295@octiron.msp.redhat.com>
References: <1552086725-18476-1-git-send-email-bmarzins@redhat.com>
	<1552086725-18476-12-git-send-email-bmarzins@redhat.com>
	<074156cffd37513971e337ef941256a6f7ed7504.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <074156cffd37513971e337ef941256a6f7ed7504.camel@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Wilck <mwilck@suse.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Fri, Mar 15, 2019 at 12:49:41PM +0100, Martin Wilck wrote:
> On Fri, 2019-03-08 at 17:12 -0600, Benjamin Marzinski wrote:
> > If multipath can't get the uid for NVMe devices from udev, it can get
> > it
> > directly from sysfs.
> > =

> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > ---
> >  libmultipath/discovery.c | 49 ++++++++++++++++++++++++++++--------
> > ----
> >  1 file changed, 34 insertions(+), 15 deletions(-)
> =

> Aside the nit over the "old_len" variable name that I remarked on
> 07/12:

Sure, assuming that we come to some agreement that keeps the fallback
code.

-Ben

> Reviewed-by: Martin Wilck <mwilck@suse.com>
> =

> -- =

> Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
> SUSE Linux GmbH, GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
> HRB 21284 (AG N=FCrnberg)
> =
