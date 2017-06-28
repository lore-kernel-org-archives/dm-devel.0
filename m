From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] dm-raid: Do not call BUG() in
	__rdev_sectors()
Date: Wed, 28 Jun 2017 10:01:18 +0200
Message-ID: <20170628080118.GB4185@linux-x5ow.site>
References: <1498636503-22484-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1498636503-22484-1-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: dm-devel@redhat.com, Hannes Reinecke <hare@suse.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

On Wed, Jun 28, 2017 at 09:55:03AM +0200, Hannes Reinecke wrote:
> __rdev_sectors() might be called for an invalid/non-existing
> RAID set during raid_ctr(), which is perfectly fine and no
> reason to panic.
> =

> Signed-off-by: Hannes Reinecke <hare@suse.com>
> ---
>  drivers/md/dm-raid.c          | 3 ++-
>  drivers/scsi/pmcraid.c        | 2 +-
>  drivers/scsi/qla4xxx/ql4_os.c | 2 +-

Ahm, accidential git commit -a?

-- =

Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=FCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
