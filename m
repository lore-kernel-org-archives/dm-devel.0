From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm: Get devices using name_to_dev_t
Date: Wed, 14 Jan 2015 21:26:36 -0500
Message-ID: <20150115022636.GA7967@redhat.com>
References: <1421280960-23984-1-git-send-email-dehrenberg@chromium.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1421280960-23984-1-git-send-email-dehrenberg@chromium.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Dan Ehrenberg <dehrenberg@chromium.org>
Cc: grundler@chromium.org, drewry@chromium.org, dm-devel@redhat.com, gwendal@chromium.org
List-Id: dm-devel.ids

On Wed, Jan 14 2015 at  7:16pm -0500,
Dan Ehrenberg <dehrenberg@chromium.org> wrote:

> If a device is used as the root filesystem, it can't be built
> off of devices which are within the root filesystem (just like
> command line arguments to root=). For this reason, Linux has a
> pseudo-filesystem for root= and md initialization based on the
> function name_to_dev_t, which handles different ways of specifying
> devices including PARTUUID and major:minor.
> 
> This patch applies name_to_dev_t to dm initialization. Rather
> than assuming that all things which are not major:minor are paths
> in an already-mounted filesystem, this patch first attempts
> name_to_dev_t and tries the filesystem as a fallback.

What is all this talk of an already-mounted filesystem?

dm_get_device() currently assumes either a major:minor or path to the
block device is provided.  Please be specific about what functionality
this change enables that you cannot do without.
