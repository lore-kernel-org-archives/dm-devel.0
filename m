From: Tejun Heo <tj@kernel.org>
Subject: Re: HPA unlock during partition scan of RAID components
Date: Fri, 4 Nov 2011 18:43:27 -0700
Message-ID: <CAOS58YNVoghyAxfj-MnTGNmRSt_4Mff2s9adq78UnzxsUv_Eug@mail.gmail.com>
References: <74AAB12B538EC94087A0D16AFDFC24F4045674@IRSMSX102.ger.corp.intel.com>
	<20111103153835.GF4417@google.com> <4EB2E4B7.7000103@cfl.rr.com>
	<CAOS58YNMOYDjuok5DDVF+CcgmP5Z4pdscv6boUC9gUqd7DiUpw@mail.gmail.com>
	<4EB407DC.8070307@cfl.rr.com> <20111104155228.GY4417@google.com>
	<4EB4121A.1060102@cfl.rr.com> <20111104163207.GA4417@google.com>
	<4EB45467.4060605@cfl.rr.com> <20111104215025.GB4417@google.com>
	<4EB49191.6060609@cfl.rr.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4EB49191.6060609@cfl.rr.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Phillip Susi <psusi@cfl.rr.com>
Cc: device-mapper development <dm-devel@redhat.com>, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, "Hawrylewicz Czarnowski,
	Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>
List-Id: dm-devel.ids

Hello,

On Fri, Nov 4, 2011 at 6:29 PM, Phillip Susi <psusi@cfl.rr.com> wrote:
> That would also break a Windows drive. =A0Are there any such biosen in
> the wild? =A0They should only add an HPA to a drive that is unformatted.

Yes, it would break under windows and it does.  Get a motherboard
which always locks HPA, do hotplug, create filesystem filling the full
disk and reboot. BIOS doesn't have a reliable way of determining
whether the disk is "unformatted" or not. Some try to scan dos
partition table but filesystem may be created on the whole device or
software raid could be using the whole drive. There is no reliable way
to tell. Some BIOSen may try to do HPA locking after hotplug using
ACPI _GTF which in theory can work but in practice many motherboards
either don't implement them or are horridly broken. So, yeah, it isn't
too difficult to break whether the os is windows or linux.

The only argument against unlocking by default and providing both
sizes is that some BIOSen may act incorrectly after soft reset, which
seems acceptable provided there's an override to disable the automatic
unlocking.

Maybe we should just add yet another param to suppress the block layer
heuristics and be done with it. I don't know.

Thanks.

-- =

tejun
