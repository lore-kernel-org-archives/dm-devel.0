From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH 3/3] dm-crypt: Adds support for wiping key
	when doing suspend/hibernation
Date: Tue, 7 Apr 2015 14:55:52 +0100
Message-ID: <20150407135552.GA32694@agk-dp.fab.redhat.com>
References: <1428254419-7334-1-git-send-email-pali.rohar@gmail.com> <1428254419-7334-4-git-send-email-pali.rohar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-pm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1428254419-7334-4-git-send-email-pali.rohar@gmail.com>
Sender: linux-pm-owner@vger.kernel.org
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Neil Brown <neilb@suse.de>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, linux-raid@vger.kernel.org, dm-devel@redhat.com, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
List-Id: dm-devel.ids

On Sun, Apr 05, 2015 at 07:20:19PM +0200, Pali Roh=E1r wrote:
> This patch adds dm message commands and option strings to optionally =
wipe key
> from dm-crypt device before entering suspend or hibernate state.
=20
Try to avoid 0/1 - use descriptive options instead.=20
E.g. key wipe_on_hibernation / key retain_on_hibernation  (message)
     wipe_key_on_hiberation ('dmsetup table' - don't forget the reporti=
ng interface!)

Have you tested against every state the driver might be in at the time =
of
suspend/hibernation?

> +static void crypt_suspend_and_wipe_key(struct crypt_config *cc)
> +{
> +	dm_suspend_md(dm_table_get_md(cc->ti->table));

I'm not particularly keen on this - silently ignoring expected error st=
ates
like -EINVAL rather than checking first and not calling the function at=
 all
when it's known not to be needed.

Alasdair

