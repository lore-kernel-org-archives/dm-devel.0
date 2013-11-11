From: Mike Snitzer <snitzer@gmail.com>
Subject: Re: [PATCH 1/6] dm cache: cache shrinking support
Date: Mon, 11 Nov 2013 18:34:59 -0500
Message-ID: <CAMM=eLcFoW7WBeBcoM70UQ7q6b8Ztg+BOTiS0j-RaoR3Ccwgzg@mail.gmail.com>
References: <1384190448-3861-1-git-send-email-snitzer@redhat.com>
	<1384190448-3861-2-git-send-email-snitzer@redhat.com>
	<20131111211934.GB24324@agk-dp.fab.redhat.com>
	<20131111213232.GA5099@redhat.com> <20131111215009.GA17903@redhat.com>
	<20131111220920.GD24324@agk-dp.fab.redhat.com>
	<20131111221527.GE24324@agk-dp.fab.redhat.com>
	<CAMM=eLdsE7_MsKoZUZkRa0S83NkcN6esYL8AEF+PpV17tvMqbw@mail.gmail.com>
	<20131111231733.GG24324@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20131111231733.GG24324@agk-dp.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Mon, Nov 11, 2013 at 6:17 PM, Alasdair G Kergon <agk@redhat.com> wrote:
> On Mon, Nov 11, 2013 at 06:06:26PM -0500, Mike Snitzer wrote:
>> This really isn't even an "interface".
>
> It is an extension to the existing userspace-kernel interface: a size
> reduction of an underlying device is detected on reload and triggers the
> removal of metadata relating to the removed portion of the device.
>
> Another interface might for example require a message to be sent to set
> a threshold above which the device is 'cleaned' until there is no
> metadata pointing beyond that point.  A subsequent reload using the
> smaller underlying device would not then need to trigger any metadata
> removal: it would already have been removed.

There is no reason to make them mutually exclusive.  Or to _only_ have
the later behavior you suggested where metadata is automatically
resized once clean below the specified threshold.

Even without this patch the user is already screwed if they resize
away a dirty portion of the fast device while it is actively in use by
dm-cache.

relative to your concerns: All this patch changes is detecting the
shrink when still dirty and tells the user they have shot themselves
in the foot.  So if anything this patch offers an improvement.
