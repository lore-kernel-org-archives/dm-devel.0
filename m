From: Miquel Raynal <miquel.raynal@bootlin.com>
Subject: Re: [trivial PATCH] treewide: Convert switch/case fallthrough; to
 break;
Date: Tue, 15 Sep 2020 11:19:25 +0200
Message-ID: <20200915111925.475dd3f1__42476.090409194$1600162217$gmane$org@xps13>
References: <e6387578c75736d61b2fe70d9783d91329a97eb4.camel@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linuxppc-dev-bounces+glppd-linuxppc64-dev=m.gmane-mx.org@lists.ozlabs.org>
In-Reply-To: <e6387578c75736d61b2fe70d9783d91329a97eb4.camel@perches.com>
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev/>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Errors-To: linuxppc-dev-bounces+glppd-linuxppc64-dev=m.gmane-mx.org@lists.ozlabs.org
Sender: "Linuxppc-dev"
 <linuxppc-dev-bounces+glppd-linuxppc64-dev=m.gmane-mx.org@lists.ozlabs.org>
To: Joe Perches <joe@perches.com>
Cc: linux-fbdev@vger.kernel.org, oss-drivers@netronome.com, nouveau@lists.freedesktop.org, alsa-devel <alsa-devel@alsa-project.org>, dri-devel@lists.freedesktop.org, linux-mips@vger.kernel.org, linux-ide@vger.kernel.org, dm-devel@redhat.com, linux-mtd@lists.infradead.org, linux-i2c@vger.kernel.org, sparclinux@vger.kernel.org, linux-afs@lists.infradead.org, linux-rtc@vger.kernel.org, linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, dccp@vger.kernel.org, linux-rdma@vger.kernel.org, linux-atm-general@lists.sourceforge.net, iommu@lists.linux-foundation.org, kvmarm@lists.cs.columbia.edu, coreteam@netfilter.org, intel-wired-lan@lists.osuosl.org, linux-serial@vger.kernel.org, linux-input@vger.kernel.org, linux-mmc@vger.kernel.org, Kees Cook <kees.cook@canonical.com>, linux-media@vger.kernel.org, linux-pm@vger.kernel.org, intel-gfx@lists.freedesktop.org, linux-mediatek@lists.
List-Id: dm-devel.ids

Hi Joe,

For MTD:

>  drivers/mtd/nand/raw/nandsim.c                            |  2 +-

Reviewed-by: Miquel Raynal <miquel.raynal@bootlin.com>


Thanks,
Miqu=C3=A8l
