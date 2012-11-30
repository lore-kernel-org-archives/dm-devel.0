From: Lars Marowsky-Bree <lmb@suse.com>
Subject: Re: [dm-devel] [PATCH 2/3] dm raid1: add interface to set resync
 speed
Date: Fri, 30 Nov 2012 12:39:28 +0100
Message-ID: <20121130113928.GO29064@suse.de>
References: <1353565673-4233-1-git-send-email-gzhao@suse.com>
 <1353565673-4233-3-git-send-email-gzhao@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1353565673-4233-3-git-send-email-gzhao@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On 2012-11-22T14:27:52, Guangliang Zhao <gzhao@suse.com> wrote:

Hi Guangliang,

thanks for adding this. I think this approach is a good direction to
take, just one feedback:

> Add ioctl to control resync speed, userspace tool
> is dmsetup message, message format is:
> 	dmsetup message $device 0 "set $speed"
> e.g.
> 	dmsetup message /dev/dm-2 "set 12345"

I think this should be "set-max-resync-rate" or something; "set" is ver=
y
generic and not very extensible going forward, should the need arise.

Regards,
    Lars

--=20
Architect Storage/HA
SUSE LINUX Products GmbH, GF: Jeff Hawn, Jennifer Guild, Felix Imend=F6=
rffer, HRB 21284 (AG N=FCrnberg)
"Experience is the name everyone gives to their mistakes." -- Oscar Wil=
de
