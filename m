From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH 2/7] libmultipath: add detect_checker option
Date: Mon, 13 Feb 2017 08:40:02 -0600
Message-ID: <20170213144002.GN22981@octiron.msp.redhat.com>
References: <1486790932-30917-1-git-send-email-bmarzins@redhat.com>
	<1486790932-30917-3-git-send-email-bmarzins@redhat.com>
	<d1da38c9-4665-3c35-517f-9c3aab3eb538@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <d1da38c9-4665-3c35-517f-9c3aab3eb538@suse.de>
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
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Mon, Feb 13, 2017 at 07:51:21AM +0100, Hannes Reinecke wrote:
> On 02/11/2017 06:28 AM, Benjamin Marzinski wrote:
> > This patch adds a detect_checker option that works just like the
> > detect_prio option.  It currently only detects ALUA devices, and
> > if it finds ALUA support, it sets the priortizier to TUR. This is
> > useful for devices like the VNX2, where it should be using the
> > TUR checker when in ALUA mode (or so I have been told). It is set on by
> > default just like detect_prio and retain_attached_hw_handler.
> > =

> Isn't it about time to move the ALUA detection into the path detection
> proper, and make it an additional attribute to struct path?
> =

> More and more things start to look for it, and it really feel stupid to
> do the ALUA detection over and over again.

Sure. I can change that.

-Ben

> =

> Cheers,
> =

> Hannes
> -- =

> Dr. Hannes Reinecke		   Teamlead Storage & Networking
> hare@suse.de			               +49 911 74053 688
> SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
> GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
> HRB 21284 (AG N=FCrnberg)
