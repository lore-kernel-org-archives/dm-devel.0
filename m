From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH RESEND] dm-raid: Do not call BUG() in
 __rdev_sectors()
Date: Fri, 30 Jun 2017 09:33:11 +0200
Message-ID: <20170630073310.GD5236@linux-x5ow.site>
References: <1498637057-23221-1-git-send-email-hare@suse.de>
	<17f4e017-f3f8-01dd-d305-dae30f93ae06@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <17f4e017-f3f8-01dd-d305-dae30f93ae06@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Heinz Mauelshagen <heinzm@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Thu, Jun 29, 2017 at 04:09:38PM +0200, Heinz Mauelshagen wrote:
> =

> Hi Hannes,
> =

> thanks for your patch.
> =

> BUG() is intentional there to catch what I've already fixed with patch
> =

> "[dm-devel] [PATCH] dm raid: fix oops on upgrading to extended superblock
> format"
> =

> on 06/23/2017.
> =

> IOW: returning 0 is never right and would hide bugs like that one fixed.

OTOH panicing systems to catch errors which could've been mitigted is
never right as well. Not a single time. Never. BUG() and BUG_ON() are not
for error handling.

-- =

Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=FCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
