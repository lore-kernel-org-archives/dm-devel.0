From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH 1/6] dm cache: cache shrinking support
Date: Mon, 11 Nov 2013 23:17:33 +0000
Message-ID: <20131111231733.GG24324@agk-dp.fab.redhat.com>
References: <1384190448-3861-1-git-send-email-snitzer@redhat.com>
	<1384190448-3861-2-git-send-email-snitzer@redhat.com>
	<20131111211934.GB24324@agk-dp.fab.redhat.com>
	<20131111213232.GA5099@redhat.com>
	<20131111215009.GA17903@redhat.com>
	<20131111220920.GD24324@agk-dp.fab.redhat.com>
	<20131111221527.GE24324@agk-dp.fab.redhat.com>
	<CAMM=eLdsE7_MsKoZUZkRa0S83NkcN6esYL8AEF+PpV17tvMqbw@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CAMM=eLdsE7_MsKoZUZkRa0S83NkcN6esYL8AEF+PpV17tvMqbw@mail.gmail.com>
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

On Mon, Nov 11, 2013 at 06:06:26PM -0500, Mike Snitzer wrote:
> This really isn't even an "interface".  

It is an extension to the existing userspace-kernel interface: a size
reduction of an underlying device is detected on reload and triggers the
removal of metadata relating to the removed portion of the device.

Another interface might for example require a message to be sent to set
a threshold above which the device is 'cleaned' until there is no
metadata pointing beyond that point.  A subsequent reload using the
smaller underlying device would not then need to trigger any metadata
removal: it would already have been removed.

Alasdair
