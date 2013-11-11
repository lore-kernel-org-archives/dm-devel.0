From: Mike Snitzer <snitzer@gmail.com>
Subject: Re: [PATCH 1/6] dm cache: cache shrinking support
Date: Mon, 11 Nov 2013 18:08:40 -0500
Message-ID: <CAMM=eLfiBSvgcfy1dK8=gy2+C-2ofJsH3KdPLFeVmJmMv7+sOA@mail.gmail.com>
References: <1384190448-3861-1-git-send-email-snitzer@redhat.com>
	<1384190448-3861-2-git-send-email-snitzer@redhat.com>
	<20131111211934.GB24324@agk-dp.fab.redhat.com>
	<20131111213232.GA5099@redhat.com>
	<20131111230349.GF24324@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20131111230349.GF24324@agk-dp.fab.redhat.com>
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

On Mon, Nov 11, 2013 at 6:03 PM, Alasdair G Kergon <agk@redhat.com> wrote:
>> DMERR("unable to shrink cache due to dirty blocks");
>
> Also, what is the process to recover from this error, given that you have
> already lost the end of the device and you cannot now resume the device
> without a preresume failure?
>
> Do the tools support retrieval of the dirty blocks from the portion of the
> device that you do still have?

Whatever the user used to resize the fast device would need to be
reversed.  The metadata hasn't changed, and provided the user can
actually get the original data back (possible with linear volume
anyway) then they can easily recover.  More sophisticated volumes may
not make this possible....

It hurts when one shoots one's self in the foot.
